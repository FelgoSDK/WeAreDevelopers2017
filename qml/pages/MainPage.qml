import VPlayApps 1.0
import QtQuick 2.0
import "../common"

Page {
  title: "Main"
  backgroundColor: Theme.tintColor

  // set up navigation bar
  titleItem: Item {
    width: dp(150)
    implicitWidth: dp(150)
    height: dp(Theme.navigationBar.height)

    Image {
      id: img
      source: Theme.isAndroid ? "../../assets/WAD2017_logo_android.png" : "../../assets/WAD2017_logo_ios.png"
      width: dp(150)
      height: parent.height
      fillMode: Image.PreserveAspectFit
      y: Theme.isAndroid ? dp(Theme.navigationBar.titleBottomMargin) : 0
    }
  }

  AppFlickable {
    anchors.fill: parent
    anchors.centerIn: parent
    contentWidth: width
    contentHeight: content.height

    Rectangle {
      width: parent.width
      height: content.height + 3000
      color: Theme.backgroundColor
    }

    // page content
    Column {
      id: content
      width: parent.width
      spacing: dp(10)

      // General V-Play Description
      Column {
        width: parent.width

        Rectangle {
          id: vplayWrapper
          height: vplayBlockColumn.height + 2 * dp(Theme.navigationBar.defaultBarItemPadding)
          width: parent.width
          color: Theme.isIos ? Theme.secondaryBackgroundColor : "#09102b"

          Column {
            id: vplayBlockColumn
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            spacing: dp(Theme.navigationBar.defaultBarItemPadding)

            AppText {
              width: parent.width - dp(Theme.navigationBar.defaultBarItemPadding) * 2
              anchors.horizontalCenter: parent.horizontalCenter
              font.pixelSize: sp(12)
              horizontalAlignment: Text.AlignHCenter
              wrapMode: Text.WordWrap
              color: Theme.isIos ? Theme.textColor : "#fff"
              text: "This app was made with <b>V-Play Engine</b>!"
            }

            AppText {
              width: parent.width - dp(Theme.navigationBar.defaultBarItemPadding) * 2
              anchors.horizontalCenter: parent.horizontalCenter
              font.pixelSize: sp(12)
              wrapMode: Text.WordWrap
              color: Theme.isIos ? Theme.textColor : "#fff"
              textFormat: AppText.RichText
              onLinkActivated: nativeUtils.openUrl(link)
              text: "<style>a:link { color: "+Theme.tintColor+";}</style>
<ul><li><b>Only ~2900 lines of code</b> - download the full project source on GitHub <a href=\"https://github.com/V-Play/WeAreDevelopers2017\">here</a></li>

<li><b>Build cross-platform native apps</b> for iOS, Android, Win Phone, Desktop & Embedded</li>

<li><b>Native UI & UX:</b> Native navigation, No platform-specific code, 100% same source code</li>

<li><b>V-Play is based on Qt</b> and offers a native performance, responsive layouts and fluid animations</li>

<li><b>Fast UI development</b> with QML and JavaScript, which is compiled to C++</li>"
            }

            Column {
              width: parent.width - dp(Theme.navigationBar.defaultBarItemPadding) * 2
              anchors.horizontalCenter: parent.horizontalCenter
              spacing: dp(Theme.navigationBar.defaultBarItemPadding) * 0.5

              AppText {
                text: "V-Play Engine is free to use:"
                color: Theme.isIos ? Theme.textColor : "#fff"
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: sp(12)
              }

              AppButton {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "More Info & Download"
                onClicked: confirmOpenUrl("https://v-play.net/wad-conference-in-app")
                verticalMargin: 0
              }
            }
          }

          Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            color: Theme.listItem.dividerColor
            height: px(1)
            visible: Theme.isIos
          }

          Rectangle {
            width: parent.width
            color: Theme.listItem.dividerColor
            height: px(1)
            visible: Theme.isIos
          }
        }
      }

      Item {
        width: parent.width
        height: 1
      }

      // Code Savings Description
      AppText {
        width: parent.width - dp(Theme.navigationBar.defaultBarItemPadding) * 2
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: sp(12)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        color: Theme.secondaryTextColor
        text: "V-Play boosts development speed compared to other engines like React Native, Titanium or Xamarin:"
      }

      AppImage {
        width: parent.width - dp(Theme.navigationBar.defaultBarItemPadding) * 2
        fillMode: AppImage.PreserveAspectFit
        source: "../../assets/code-savings.png"
        anchors.horizontalCenter: parent.horizontalCenter
        MouseArea {
          anchors.fill: parent
          onClicked: PictureViewer.show(getApplication(), parent.source)
        }
      }

      AppText {
        width: parent.width - dp(Theme.navigationBar.defaultBarItemPadding) * 2
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: sp(12)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        text: "Save up to 90% Source Code with V-Play!"
      }

      AppButton {
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Show Code Comparison in Detail"
        onClicked: confirmOpenUrl("https://v-play.net/code-comparison-in-app")
        verticalMargin: 0
      }

      AppText {
        width: parent.width - dp(Theme.navigationBar.defaultBarItemPadding) * 2
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: sp(12)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        color: Theme.secondaryTextColor
        text: "<b>How is this possible?</b> By using QML (Qt Markup Language) + JavaScript for rapid cross-platform development:"
      }

      // Code Example
      Rectangle {
        width: parent.width
        height: codeFlickable.height + dp(Theme.navigationBar.defaultBarItemPadding * 2)
        color: "#eeeeee"

        AppFlickable {
          id: codeFlickable
          width: parent.width
          height: codeSample.height
          contentWidth: codeSample.implicitWidth + codeSample.x * 2
          anchors.centerIn: parent
          flickableDirection: Flickable.HorizontalFlick

          AppText {
            id: codeSample
            x: dp(Theme.navigationBar.defaultBarItemPadding)
            font.family: 'Courier New'
            font.pixelSize: sp(12)
            textFormat: AppText.RichText
            text: "<style>span.comment { color: 'darkgreen'; } span.keyword { color: '#777700'; } span.property { color: 'darkred'; } span.type { color: 'purple'; } span.inlinecomment { color: '#555555'; } </style>
<span class='type'>Window</span> {<br/>
&nbsp; <span class='property'>visible</span>: true<br/>
&nbsp; <span class='comment'>// property (variable) with type integer</span><br/>
&nbsp; <span class='keyword'>property int</span> <span class='property'>count</span>: 0<br/>
<br/>
&nbsp; <span class='comment'>// pretty useful function</span><br/>
&nbsp; <span class='keyword'>function</span> iDoNothing() { }<br/>
<br/>
&nbsp; <span class='comment'>// background, changing color whenever the user presses the MouseArea</span><br/>
&nbsp; <span class='type'>Rectangle</span> {<br/>
&nbsp;&nbsp;&nbsp; <span class='property'>color</span>: mouseArea.pressed ? <span class='comment'>\"lightblue\"</span> : <span class='comment'>\"lightgrey\"</span> <span class='inlinecomment'>// property binding</span><br/>
&nbsp;&nbsp;&nbsp; <span class='property'>anchors.fill</span>: parent<br/>
&nbsp; }<br/>
<br/>
&nbsp; <span class='comment'>// text element displaying text and number of clicks</span><br/>
&nbsp; <span class='type'>Text</span> {<br/>
&nbsp;&nbsp;&nbsp; <span class='property'>text</span>: <span class='comment'>\"Hello V-Play! \"</span> + count <span class='inlinecomment'>// property binding</span><br/>
&nbsp;&nbsp;&nbsp; <span class='property'>anchors.centerIn</span>: parent<br/>
&nbsp;&nbsp;&nbsp; <span class='property'>font.pixelSize</span>: 18<br/>
&nbsp;&nbsp;&nbsp; <span class='property'>font.bold</span>: count > 5 <span class='inlinecomment'>// property binding</span><br/>
&nbsp; }<br/>
<br/>
&nbsp; <span class='comment'>// listen to mouse/touch interactions</span><br/>
&nbsp; <span class='type'>MouseArea</span> {<br/>
&nbsp;&nbsp;&nbsp; <span class='property'>id</span>: mouseArea<br/>
&nbsp;&nbsp;&nbsp; <span class='property'>anchors.fill</span>: parent<br/>
&nbsp;&nbsp;&nbsp; <span class='property'>onPressed</span>: {<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; count++<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; iDoNothing()<br/>
&nbsp;&nbsp;&nbsp; }<br/>
&nbsp; }<br/>
}
"
          } // Text
        } // Flickable
      } // Rectangle

      AppText {
        width: parent.width - dp(Theme.navigationBar.defaultBarItemPadding) * 2
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: sp(12)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        color: Theme.secondaryTextColor
        font.bold: true
        text: "This produces the following example:"
      }

      Rectangle {
        id: exampleRect
        width: parent.width - dp(Theme.navigationBar.defaultBarItemPadding) * 2
        color: mouseArea.pressed ? "lightblue" : "lightgrey"
        height: dp(75)
        anchors.horizontalCenter: parent.horizontalCenter

        property int count: 0

        Text {
          text: "Hello V-Play! " + parent.count
          anchors.centerIn: parent
          font.pixelSize: sp(14)
          font.bold: parent.count > 5
        }

        MouseArea {
          id : mouseArea
          anchors.fill: parent
          onPressed: {
            exampleRect.count++
          }
        }
      }

      // More V-Play Features
      AppText {
        width: parent.width - dp(Theme.navigationBar.defaultBarItemPadding) * 2
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: sp(12)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        color: Theme.secondaryTextColor
        font.bold: true
        text: "More V-Play benefits and features:"
      }

      AppText {
        width: parent.width - dp(Theme.navigationBar.defaultBarItemPadding) * 2
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: sp(12)
        wrapMode: Text.WordWrap
        color: Theme.secondaryTextColor
        textFormat: AppText.RichText
        text: "<style>li { margin-left: 0px; }</style><ul><li>60+ samples + demos, like this conference app</li>
<li>Quick access to native device features like dialogs or camera</li>
<li>Extensible with custom native code</li>
<li>Cross-platform plugins for monetization, analytics, social integration or push notifications</li>
<li>Powerful for feature-rich UIs + animations</li>
<li>Responsive Layout Support</li>
<li>Easy to learn in days</li>
<li>Support for 3D, sensors & more</li>
<li>You can even create games with V-Play!</li>
</ul>"
      }

      // Spacer
      Item {
        width: parent.width
        height: dp(Theme.navigationBar.defaultBarItemPadding)
      }

      // Bottom CTA
      Column {
        width: parent.width - dp(Theme.navigationBar.defaultBarItemPadding) * 4
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: dp(Theme.navigationBar.defaultBarItemPadding) * 0.5

        AppText {
          text: "Get the V-Play SDK for free and create awesome games or apps:"
          width: parent.width
          horizontalAlignment: Text.AlignHCenter
          font.pixelSize: sp(12)
        }

        AppButton {
          anchors.horizontalCenter: parent.horizontalCenter
          text: "More Info & Download"
          onClicked: confirmOpenUrl("https://v-play.net/wad-conference-in-app")
          verticalMargin: 0
        }
      }

      // Spacer
      Item {
        width: parent.width
        height: dp(Theme.navigationBar.defaultBarItemPadding)
      }

      // Link to Demos
      Rectangle {
        width: parent.width
        height: demosContent.height + 2 * dp(Theme.navigationBar.defaultBarItemPadding)
        color: "#eeeeee"

        Column {
          id: demosContent
          width: parent.width
          anchors.verticalCenter: parent.verticalCenter
          spacing: parent.parent.spacing

          AppText {
            id: demosText
            width: parent.width - dp(Theme.navigationBar.defaultBarItemPadding) * 2
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: sp(12)
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            color: Theme.secondaryTextColor
            text: "Try more of the 60 other open-source V-Play Apps like:"
          }

          // Demos Grid
          Item {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 2 * dp(Theme.navigationBar.defaultBarItemPadding)
            height: Math.max(unoCol.height, showcaseCol.height)

            // One Card Demo
            Column {
              id: unoCol
              width: (parent.width - dp(Theme.navigationBar.defaultBarItemPadding)) * 0.5
              spacing: dp(Theme.navigationBar.defaultBarItemPadding) * 0.5

              AppText {
                text: "One Card! - UNO Game"
                font.pixelSize: sp(12)
                anchors.horizontalCenter: parent.horizontalCenter
              }

              AppImage {
                width: parent.width * 0.5
                fillMode: AppImage.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
                source: "../../assets/logo-onecard.png"
              }

              AppText {
                width: parent.width
                font.pixelSize: sp(11)
                color: Theme.secondaryTextColor
                horizontalAlignment: AppText.AlignHCenter
                text: "Play UNO with your friends in this multiplayer card game!"
              }
            } // One Card Column

            MouseArea {
              anchors.fill: unoCol
              onClicked: {
                var url = Theme.isAndroid ? "https://play.google.com/store/apps/details?id=net.vplay.demos.ONECard" : "https://itunes.apple.com/at/app/id1112447141?mt=8"
                nativeUtils.openUrl(url)
              }
            }

            // Showcase Demo
            Column {
              id: showcaseCol
              width: unoCol.width
              anchors.left: unoCol.right
              anchors.leftMargin: spacing
              spacing: unoCol.spacing

              AppText {
                text: "V-Play Showcase App"
                font.pixelSize: sp(12)
                anchors.horizontalCenter: parent.horizontalCenter
              }

              AppImage {
                width: parent.width * 0.5
                fillMode: AppImage.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
                source: "../../assets/logo-showcase.png"
              }

              AppText {
                width: parent.width
                font.pixelSize: sp(11)
                color: Theme.secondaryTextColor
                horizontalAlignment: AppText.AlignHCenter
                text: "This app includes all open-source demo & example apps of V-Play!"
              }
            } // Showcase Column

            MouseArea {
              anchors.fill: showcaseCol
              onClicked: {
                var url = Theme.isAndroid ? "https://play.google.com/store/apps/details?id=net.vplay.demos.apps.showcaseapp" : "https://itunes.apple.com/at/app/id1040477271?mt=8"
                nativeUtils.openUrl(url)
              }
            }
          } // Demos Grid
        } // Demos Content
      } // Rectangle
    } // Column
  } // Flickable



  // confirmOpenUrl - display confirm dialog before opening v-play url
  function confirmOpenUrl(url) {
    NativeDialog.confirm("Leave the app?","This action opens your browser to visit "+url+".",function(ok) {
      if(ok)
        nativeUtils.openUrl(url)
    })
  }


}
