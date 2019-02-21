import Felgo 3.0
import QtQuick 2.0
import "../common"

ListPage {
  id: morePage
  title: "More"

  model: [
    { text: "Venue", section: "General", page: Qt.resolvedUrl("VenuePage.qml") },
    { text: "Settings", section: "General", page: Qt.resolvedUrl("SettingsPage.qml") },
    { text: "Leaderboard", section: "Social", state: "leaderboard" },
    { text: "Profile", section: "Social",  state: "profile" },
    { text: "Chat", section: "Social",  state: "inbox" },
    { text: "Friends", section: "Social", state: "friends" }
  ]

  section.property: "section"

  // open configured page when clicked
  onItemSelected: {
    if(item.text === "Venue" || item.text === "Settings")
      morePage.navigationStack.popAllExceptFirstAndPush(model[index].page)
    else {
      var properties = { targetState: model[index].state }
      if(item.text === "Leaderboard" || item.text === "Profile") {
        properties["targetItem"] = gameNetworkViewItem
      }
      else if(item.text === "Chat" || item.text === "Friends") {
        properties["targetItem"] = multiplayerViewItem
      }
      morePage.navigationStack.popAllExceptFirstAndPush(dummyPageComponent, properties)
    }
  }
}
