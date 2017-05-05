import VPlayApps 1.0
import QtQuick 2.0
import VPlay 2.0 // for game network
import VPlayPlugins 1.0
import "pages"
import "common"

Rectangle {
  id: loaderItem
  anchors.fill: parent
  color: Theme.backgroundColor

  // make navigation public (required for V-Play app demo launcher)
  property Navigation navigation: mainLoader.item && mainLoader.item.navigation

  property GameNetworkViewItem gameNetworkViewItem: mainLoader.item && mainLoader.item.gameNetworkViewItem || null
  property MultiplayerViewItem multiplayerViewItem: mainLoader.item && mainLoader.item.multiplayerViewItem || null



  // game network
  VPlayGameNetwork {
    id: gameNetwork
    gameId: 353
    secret: "wad2017github"
    gameNetworkView: gameNetworkViewItem && gameNetworkViewItem.gnView || null

    clearAllUserDataAtStartup: system.desktopPlatform // this can be enabled during development to simulate a first-time app start
    clearOfflineSendingQueueAtStartup: true // clear any stored requests in the offline queue at app start, to avoid starting errors
    user.deviceId: system.UDID

    property int addScoreWhenSynced: 0
    onUserScoresInitiallySyncedChanged: {
      if(userScoresInitiallySynced && !system.publishBuild) {
        console.log("Debug Build - reset current score of "+gameNetwork.userHighscoreForCurrentActiveLeaderboard+" to 0")
        var targetScore = 0
        if(DataModel.favorites) {
          for(var id in DataModel.favorites)
            targetScore++
        }
        gameNetwork.reportRelativeScore(targetScore - gameNetwork.userHighscoreForCurrentActiveLeaderboard)
      }
      else if(userScoresInitiallySynced && addScoreWhenSynced != 0)
        gameNetwork.reportRelativeScore(addScoreWhenSynced)
    }
  }

  // multiplayer
  VPlayMultiplayer {
    id: multiplayer
    gameNetworkItem: gameNetwork
    multiplayerView: multiplayerViewItem && multiplayerViewItem.mpView || null
    appKey: "<add your-appkey>"
    pushKey: "<add your pushkey>"
    notificationBar: appNotificationBar // notification bar that also takes statusBarHeight into account
  }

  AppNotificationBar {
    id: appNotificationBar
    tintColor: Theme.tintColor
  }

  Component.onCompleted: {
    loaderTimer.start()
  }

  // load main item dynamically
  Loader {
    id: mainLoader
    property bool finished: false
    asynchronous: true
    visible: false
    onLoaded:{
      finished = true
      mainLoader.item.parent = loaderItem
      visible = true
    }
  }

  Timer {
    id: loaderTimer
    interval: 500
    onTriggered: mainLoader.source = Qt.resolvedUrl("WADMainItem.qml")
  }

  // loading image column
  Column {
    anchors.centerIn: parent
    spacing: dp(30)
    visible: !mainLoader.finished

    AppImage {
      width: dp(100)
      fillMode: AppImage.PreserveAspectFit
      source: "../assets/vplay-logo.png"
      anchors.horizontalCenter: parent.horizontalCenter
      NumberAnimation on rotation {duration: 2000; from: 0; to: 360; loops: Animation.Infinite; running: true}
    }

    AppText {
      text: "fetching conference data"
      color: Theme.secondaryTextColor
      font.pixelSize: sp(18)
      anchors.horizontalCenter: parent.horizontalCenter
    }
  }

  Connections {
    target: getApplication()

    // load data if not available and device goes online
    onIsOnlineChanged: {
      if(!DataModel.loaded && isOnline)
        loadDataTimer.start() // use timer to delay load as immediate calls might not get through (network not ready yet)
    }
  }

  // timer to load data after 1 second delay when going online
  Timer {
    id: loadDataTimer
    interval: 1000
    onTriggered: DataModel.loadData()
  }

  // color to HSL conversion
  function colorToHsl(color) {
    var r = color.r /= 255
    var g = color.g /= 255
    var b = color.b /= 255
    var max = Math.max(r, g, b), min = Math.min(r, g, b);
    var h, s, l = (max + min) / 2;

    if(max == min) {
      h = s = 0; // achromatic
    }
    else {
      var d = max - min;
      s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
      switch(max) {
      case r: h = (g - b) / d + (g < b ? 6 : 0); break;
      case g: h = (b - r) / d + 2; break;
      case b: h = (r - g) / d + 4; break;
      }
      h /= 6;
    }
    return [h, s, l];
  }

  // scheduleNotificationsForFavorites
  function scheduleNotificationsForFavorites() {
    if(typeof notificationManager === 'undefined')
      return

    notificationManager.cancelAllNotifications()
    if(!DataModel.notificationsEnabled) // do not schedule notification if user disabled it
      return

    // skip notifications for talks if DataModel not ready
    if(DataModel.favorites && DataModel.talks) {
      for(var idx in DataModel.favorites) {
        var talkId = DataModel.favorites[idx]
        scheduleNotificationForTalk(talkId)
      }
    }

    // add notification before conference starts!
    var nowTime = new Date().getTime()
    var eveningBeforeConferenceTime = new Date("2017-05-10T21:00.000+0200").getTime()
    if(nowTime < eveningBeforeConferenceTime) {
      var text = "V-Play wishes all the best for WeAreDevelopers 2017!"
      var notification = {
        notificationId: -1,
        message: text,
        timestamp: Math.round(eveningBeforeConferenceTime / 1000) // utc seconds
      }
      notificationManager.schedule(notification)
    }
  }

  // scheduleNotificationForTalk
  function scheduleNotificationForTalk(talkId) {
    if(DataModel.loaded && DataModel.talks && DataModel.talks[talkId]) {
      var talk = DataModel.talks[talkId]
      var text = talk["title"]+" starts "+talk.start+" at "+talk["room"]+"."

      var nowTime = new Date().getTime()
      var utcDateStr = talk.day+"T"+talk.start+".000+0200"
      var notificationTime = new Date(utcDateStr).getTime()
      notificationTime = notificationTime - 10 * 60 * 1000 // 10 minutes before

      if(nowTime < notificationTime) {
        var notification = {
          notificationId: talkId,
          message: text,
          timestamp: Math.round(notificationTime / 1000) // utc seconds
        }
        notificationManager.schedule(notification)
      }
    }
  }
}
