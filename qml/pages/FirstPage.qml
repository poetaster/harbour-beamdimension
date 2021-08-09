import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    // variables
    property var profileType : "I-Profile"

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.Portrait


    // all basic list elements for main page, with link to each page
    ListModel {
        id: idListSituations
        ListElement {
            page: "1_SingleSpanBeam.qml"
            title: qsTr("single span beam")
            subtitle: qsTr("between 2 supports")
            section: qsTr("calculate dimensions")
            icon: "../img/icon_SingleSpanBeam.png"
        }
        ListElement {
            page: "2_SingleSpanBeamCantilever.qml"
            title: qsTr("beam with cantilever")
            subtitle: qsTr("2 supports and 1 extension")
            section: qsTr("calculate dimensions")
            icon: "../img/icon_SingleSpanBeamCantilever.png"
        }
        ListElement {
            page: "3_MultiSpanBeam1.qml"
            title: qsTr("multi span beam")
            subtitle: qsTr("beam with multiple supports")
            section: qsTr("calculate dimensions")
            icon: "../img/icon_MultiSpanBeam.png"
        }
        ListElement {
            page: "4_ClampedBeam.qml"
            title: qsTr("clamped beam")
            subtitle: qsTr("wedged arm, e.g in a wall")
            section: qsTr("calculate dimensions")
            icon: "../img/icon_ClampedBeam.png"
        }
        ListElement {
            page: "5_PillarButtress.qml"
            title: qsTr("pillar / buttress")
            subtitle: qsTr("load in longitudinal direction")
            section: qsTr("calculate dimensions")
            icon: "../img/icon_Pillar.png"
        }
    }




    SilicaListView {
        id: idListView
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: { pageStack.push(Qt.resolvedUrl("About.qml"), {
                    profileType : profileType,
                } ) }
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: { pageStack.push(Qt.resolvedUrl("SettingsPage.qml"), {
                    profileType : profileType,
                } ) }
            }

        }
        VerticalScrollDecorator {}

        header: PageHeader {
            title: qsTr("BeamCalc")
        }


        // line content data from model above
        model: idListSituations

        // put all elements of one kind together, display it as common text like a SectionHeader
        section {
            property: "section"
            delegate: SectionHeader {
                text: section // info from model above
            }
        }

        // make a nice layout for each line with model data
        delegate: ListItem {
            contentHeight: 2 * Theme.fontSizeHuge
            Label {
                anchors.verticalCenter: parent.verticalCenter
                x: Theme.paddingLarge
                textFormat: Text.RichText // ToDo: add subtitles in smaller font to the label
                //text: model.title // model.subtitle
                text: "<font size=3>" + model.title + "</font>" + "<br>" + "<font size=1>" +model.subtitle + "</font>"
                color: highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            Image {
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingLarge
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
                source: model.icon
                height: Theme.iconSizeExtraLarge //150 //mainapp.mediumScreen || mainapp.largeScreen ? 128 : 64
                width: height
                layer.effect: ShaderEffect {
                    property color color: Theme.primaryColor

                    fragmentShader: "
                    varying mediump vec2 qt_TexCoord0;
                    uniform highp float qt_Opacity;
                    uniform lowp sampler2D source;
                    uniform highp vec4 color;
                    void main() {
                        highp vec4 pixelColor = texture2D(source, qt_TexCoord0);
                        gl_FragColor = vec4(mix(pixelColor.rgb/max(pixelColor.a, 0.00390625), color.rgb/max(color.a, 0.00390625), color.a) * pixelColor.a, pixelColor.a) * qt_Opacity;
                    }
                    "
                }
                layer.enabled: true
                layer.samplerName: "source"
            }

            onClicked: pageStack.push(Qt.resolvedUrl(model.page))

        }





    } // End SilicaListView

} // End page


