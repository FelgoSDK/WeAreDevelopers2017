import Felgo 3.0
import QtQuick 2.0
import "pages"
import "common"

/*
  Note: This project is no longer compatible with the latest Felgo SDK. You can find a the latest Felgo Conference App Demo here: https://github.com/FelgoSDK/Qt-World-Summit-Conference-App
 */

App {
  id: app
  // add your license key with activated One Signal and Local Notifications plugins here
  // licenseKey: "<add your license key>"

  onInitTheme: {
    if(system.desktopPlatform)
      Theme.platform = "android"

    // default theme setup
    Theme.colors.tintColor = "#FF164C"
  }

  // local notifications (not within loader item to deactivate notifications within V-Play Demo Launcher app)
  NotificationManager {
    id: notificationManager
    // display alert for upcoming sessions
    onNotificationFired: {
      if(notificationId >= 0) {
        // session reminder
        if(DataModel.loaded && DataModel.talks && DataModel.talks[notificationId]) {
          var talk = DataModel.talks[notificationId]
          var text = talk["title"]+" starts "+talk.start+" at "+talk["room"]+"."
          var title = "Session Reminder"
          NativeDialog.confirm(title, text, function(){}, false)
        }
      }
      else {
        // default notification
        NativeDialog.confirm("The conference starts soon!", "Thanks for using our app, we wish you a great conference!", function(){}, false)
      }
    }
  }

  // loads and holds actual app content
  WADLoaderItem { id: loaderItem }
}
