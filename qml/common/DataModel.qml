pragma Singleton
import VPlayApps 1.0
import VPlay 2.0
import QtQuick 2.0

Item {
  id: dataModel

  property var schedule: undefined
  property var speakers: undefined
  property var favorites: undefined
  property var talks: undefined

  readonly property bool loading: _.loadingCount > 0
  readonly property bool loaded: !!schedule && !!speakers

  property bool notificationsEnabled: true
  onNotificationsEnabledChanged: storage.setValue("notificationsEnabled", notificationsEnabled)

  signal loadingFailed()
  signal favoriteAdded()
  signal favoriteRemoved()

  Component.onCompleted: loadData()

  // item for private members
  QtObject {
    id: _

    // wad 2017 conference data
    property string wadScheduleUrl: Qt.resolvedUrl("../../assets/data/schedule.json")
    property string wadSpeakersUrl: Qt.resolvedUrl("../../assets/data/speakers.json")

    property int loadingCount: 0

    // sendGetRequest - load data from url with success handler
    function sendGetRequest(url, success) {
      var xmlHttpReq = new XMLHttpRequest()
      xmlHttpReq.onreadystatechange = function() {
        if(xmlHttpReq.readyState == xmlHttpReq.DONE && xmlHttpReq.status == 200) {
          var fixedResponse = xmlHttpReq.responseText.replace(new RegExp("&amp;",'g'),"&")
          success(JSON.parse(fixedResponse))
          loadingCount--
        }
        else if(xmlHttpReq.readyState == xmlHttpReq.DONE && xmlHttpReq.status != 200) {
          console.error("Error: Failed to load data from "+url+", status = "+xmlHttpReq.status+", response = "+XMLHttpRequest.responseText)
          loadingCount--
          if(!loading)
            dataModel.loadingFailed()
        }
      }

      loadingCount++
      xmlHttpReq.open("GET", url, true)
      xmlHttpReq.send()
    }

    // loadSchedule - load Qt WS 2016 schedule from api
    function loadSchedule() {
      _.sendGetRequest(_.wadScheduleUrl, function(data) {
        _.processScheduleData(data)
        // load speakers after schedule is processed
        _.loadSpeakers()
      })
    }

    // loadSpeakers - load Qt WS 2016 speakers from api
    function loadSpeakers() {
      _.sendGetRequest(_.wadSpeakersUrl, function(data) {
        _.processSpeakersData(data)
      })
    }

    // processScheduleData - process schedule data for usage in UI
    function processScheduleData(data) {
      // retrieve talks and build model for talks and schedule
      var talks = {}

      // rewrite key of days to match "YYYY-MM-DD"
      var keys = Object.keys(data.conference.days)
      for(var dayIdx in keys) {
        var day = keys[dayIdx]
        var dayData = data.conference.days[day]
        delete data.conference.days[day]

        if(day === "may-11-day-1")
          day = "2017-05-11"
        else
          day = "2017-05-12"

        // re-add day with correct key
        data.conference.days[day] = dayData
      }

      // parse conference schedule
      for(day in data.conference.days) {
        for(var room in data.conference.days[day]["rooms"]) {
          for (var eventIdx in data.conference.days[day]["rooms"][room]) {
            var event = data.conference.days[day]["rooms"][room][eventIdx]

            // skip duplicates of general events for each room
            if(talks[event.id] !== undefined) {
              data.conference.days[day]["rooms"][room][eventIdx] = undefined // REMOVE EVENT
              continue
            }

            // format start and end time
            var start = event.start.split(":")
            var end = event.end.split(":")
            event.start = _.format2DigitTime(start[0]) + ":" + _.format2DigitTime(start[1])
            event.end = _.format2DigitTime(end[0]) + ":" + _.format2DigitTime(end[1])

            // clean-up false start time formatting (always 2 digits required)
            if(event.start.substring(1,2) == ':') {
              event.start = "0"+event.start
            }

            // add day of event (for favorites)
            event.day = day

            for(var speakerIdx in event.persons) {
              var speaker = event.persons[speakerIdx]

              // replace whitespace in speaker id (full name), "sebastian krumhausen" -> "sebastiankrumhausen"
              // "0" is id for speakers without speaker details, do nothing in that case
              var speakerId = speaker.id !== 0 ? speaker.id.replace(/ /g,'') : speaker.id
              speaker.id = speakerId

              // first name property of WAD data includes last name as well -> split up
              var separatorIdx = speaker.first_name.lastIndexOf(" ")
              speaker.last_name = speaker.first_name.substr(separatorIdx + 1)
              speaker.first_name = speaker.first_name.substr(0, separatorIdx)

              // replace speaker entry with changed speaker
              event.persons[speakerIdx] = speaker
            }

            // build talks model
            talks[event["id"]] = event

            // if first loading, add VPlay talk to favorites
            if(!dataModel.loaded && dataModel.isVPlayTalk(event) && !dataModel.isFavorite(event.id)) {
              dataModel.toggleFavorite(event)
            }

            // replace talks in schedule with talk-id
            data.conference.days[day]["rooms"][room][eventIdx] = event["id"]
          }
        }
      }

      // store data
      dataModel.talks = talks
      dataModel.schedule = data
      storage.setValue("talks", talks)
      storage.setValue("schedule", data)

      // force update of favorites as new data arrived
      var favorites = dataModel.favorites
      dataModel.favorites = undefined
      dataModel.favorites = favorites
    }

    // processSpeakersData - process schedule data for usage in UI
    function processSpeakersData(data) {
      // convert speaker data into model map with id as key
      var speakers = {}
      for(var i = 0; i < data.length; i++) {
        var speaker = data[i]

        // replace whitespace in speaker id (full name), "sebastian krumhausen" -> "sebastiankrumhausen"
        var speakerId = speaker.id.replace(/ /g,'')
        speaker.id = speakerId

        // first name property of WAD data includes last name as well -> split up
        var separatorIdx = speaker.first_name.lastIndexOf(" ")
        speaker.last_name = speaker.first_name.substr(separatorIdx + 1)
        speaker.first_name = speaker.first_name.substr(0, separatorIdx)

        // add to speakers model
        speakers[speakerId] = speaker

        var talks= []
        for (var j in Object.keys(dataModel.talks)) {
          var talkID = Object.keys(dataModel.talks)[j];
          var talk = dataModel.talks[parseInt(talkID)]
          var persons = talk.persons

          for(var k in persons) {
            if(persons[k].id === speakerId) {
              talks.push(talkID.toString())
            }
          }
        }
        speakers[speakerId]["talks"] = talks
      }
      // store data
      dataModel.speakers = speakers
      storage.setValue("speakers", speakers)
    }

    // format2DigitTime - adds leading zero to time (hour, minute) if required
    function format2DigitTime(time) {
      return (("" + time).length < 2) ? "0" + time : time
    }
  }

  // storage for caching data
  Storage {
    id: storage
    Component.onCompleted: {
      // load cached data at startup
      dataModel.schedule = storage.getValue("schedule")
      dataModel.speakers = storage.getValue("speakers")
      dataModel.favorites = storage.getValue("favorites")
      dataModel.talks = storage.getValue("talks")
      dataModel.notificationsEnabled = storage.getValue("notificationsEnabled") !== undefined ? storage.getValue("notificationsEnabled") : true
    }
  }

  // clearCache - clears locally stored data
  function clearCache() {
    var favorites = dataModel.favorites
    storage.clearAll()
    dataModel.schedule = undefined
    dataModel.speakers = undefined
    dataModel.favorites = favorites // keep favorites even when clearing cache
    dataModel.talks = undefined
    dataModel.notificationsEnabled = true
  }

  // getAll - loads all data from Qt WS 2016 api
  function loadData() {
    if(!loading) {
      _.loadSchedule() // loads both schedule and speakers
    }
  }

  // toggleFavorite - add or remove item from favorites
  function toggleFavorite(item) {
    if(dataModel.favorites === undefined)
      dataModel.favorites = { }

    if(dataModel.favorites[item.id]) {
      delete dataModel.favorites[item.id]
      dataModel.favoriteRemoved()
    }
    else {
      dataModel.favorites[item.id] = item.id
      dataModel.favoriteAdded()
    }

    storage.setValue("favorites", dataModel.favorites)
    signalFavoritesChanged.restart() // signal favorites changed with timer (to not block UI)
    return dataModel.isFavorite(item.id)
  }

  Timer {
    id: signalFavoritesChanged
    interval: 50
    onTriggered: dataModel.favoritesChanged()
  }

  // isFavorite - check if item is favorited
  function isFavorite(id) {
    return dataModel.favorites !== undefined && dataModel.favorites[id] !== undefined
  }

  // search - get talks with certain keyword in title or description
  function search(query) {
    if(!dataModel.talks)
      return []

    query = query.toLowerCase().split(" ")
    var result = []

    // check talks
    for(var id in talks) {
      var talk = talks[id]
      var contains = 0

      // check query
      for (var key in query) {
        var term = query[key].trim()
        if(talk.title.toLowerCase().indexOf(term) >= 0 ||
            talk.description.toLowerCase().indexOf(term) >= 0) {
          contains++
        }
        for(var key2 in talk.persons) {
          var speaker = talk.persons[key2]
          if(speaker.full_public_name.toLowerCase().indexOf(term) >= 0) {
            contains++
          }
        }
      }

      if(contains == query.length)
        result.push(talk)
    } // check talks

    return result
  }

  // isVPlayTalk - checks whether a talk is by V-Play
  function isVPlayTalk(talk) {
    return talk.title.toLowerCase().indexOf("multiple platforms and best practices") > 0
  }
}
