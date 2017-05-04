import VPlayApps 1.0
import QtQuick 2.0
import QtGraphicalEffects 1.0

Page {
  id: venuePage
  title: "Venue"

  AppFlickable {
    anchors.fill: parent
    contentWidth: parent.width
    contentHeight: contentCol.height

    Column {
      id: contentCol
      width: parent.width

      Item {
        width: parent.width
        height: landscape ? dp(300) : img.height * 0.75
        clip: true

        AppImage {
          id: img
          width: parent.width
          height: width / sourceSize.width * sourceSize.height
          fillMode: AppImage.PreserveAspectFit
          source: "../../assets/WAD2017_background.jpg"
          anchors.bottom: parent.bottom
        }

        AppImage {
          width: parent.width * 0.5
          source: "../../assets/WAD2017_logo_android.png"
          fillMode: AppImage.PreserveAspectFit
          anchors.centerIn: parent
          layer.enabled: true
          layer.effect: DropShadow {
            color: Qt.rgba(0,0,0,0.5)
            radius: 16
            samples: 16
          }
        }

      }

      Item {
        width: parent.width
        height: addressCol.height + dp(Theme.navigationBar.defaultBarItemPadding) * 2
        Column {
          id: addressCol
          width: parent.width - dp(Theme.navigationBar.defaultBarItemPadding) * 2
          anchors.centerIn: parent
          spacing: dp(Theme.navigationBar.defaultBarItemPadding)
          Item {
            width: parent.width
            height: 1
            visible: Theme.isIos
          }
          Column {
            width: parent.width
            AppText {
              width: parent.width
              wrapMode: AppText.WordWrap
              text: "MARX HALLE"
            }
            AppText {
              width: parent.width
              wrapMode: AppText.WordWrap
              color: Theme.secondaryTextColor
              font.pixelSize: sp(13)
              text: "Karl-Farkas-Gasse 19"
            }
            AppText {
              width: parent.width
              wrapMode: AppText.WordWrap
              color: Theme.secondaryTextColor
              font.pixelSize: sp(13)
              text: "1030 Vienna, Austria"
            }
          }

          AppButton {
            text: "Plan Route"
            minimumWidth: parent.width - dp(Theme.navigationBar.defaultBarItemPadding) * 2
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
              if (Theme.isIos){
                Qt.openUrlExternally("http://maps.apple.com/?q=Karl-Farkas-Gasse 19, 1030 Vienna, Austria")
              } else {
                Qt.openUrlExternally("geo:0,0?q=48.187899,16.4022873")
              }
            }
          }
        }
        Rectangle {
          anchors.top: parent.top
          width: parent.width
          color: Theme.listItem.dividerColor
          height: px(1)
        }
        Rectangle {
          anchors.bottom: parent.bottom
          width: parent.width
          color: Theme.listItem.dividerColor
          height: px(1)
        }
      }

      AppImage {
        width: parent.width
        fillMode: AppImage.PreserveAspectFit
        source: "../../assets/rooms/GENERAL.png"

        MouseArea {
          anchors.fill: parent
          onClicked: venuePage.navigationStack.push(Qt.resolvedUrl("RoomPage.qml"), { room: "GENERAL" })
        }
      }

      Item {
        width: parent.width
        height: dp(Theme.navigationBar.defaultBarItemPadding)
      }
    }
  }

}
