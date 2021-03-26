import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.Portrait
    property variant arrayMultiAllFactors
    property int indexMultiChosenSituation
    property variant arrayMultiChosenSituation
   property variant numberOfSupportsChosenSituation



    // 2 dimensional array for sectional factors depending on number of supports and loead situations
    Item {
        id: idArrayMomentFactors
        property variant arrayMultiAllFactors:
          [[ "A",      "B",      "C",      "D",      "E",     "M1",     "M2",     "M3",     "M4",     "MA",     "MB",     "MC",     "MD",     "ME"],
          [ 0.375,    1.250,    0.375,    0.000,    0.000,    0.070,    0.070,    0.000,    0.000,    0.000,   -0.125,    0.000,    0.000,    0.000],   //fields
          [ 0.438,    0.625,   -0.063,    0.000,    0.000,    0.096,    0.000,    0.000,    0.000,    0.000,   -0.063,    0.000,    0.000,    0.000],   //2
          [ 0.400,    1.100,    1.100,    0.400,    0.000,    0.080,    0.025,    0.080,    0.000,    0.000,   -0.100,   -0.100,    0.000,    0.000],   //3 fields
          [ 0.450,    0.550,    0.550,    0.450,    0.000,    0.101,   -0.050,    0.101,    0.000,    0.000,   -0.050,   -0.050,    0.000,    0.000],   //3
          [-0.050,    0.550,    0.550,   -0.050,    0.000,    0.000,    0.075,    0.000,    0.000,    0.000,   -0.050,   -0.050,    0.000,    0.000],   //3
          [ 0.400,    1.200,    0.400,    0.000,    0.000,    0.070,    0.070,    0.000,    0.000,    0.000,   -0.117,   -0.033,    0.000,    0.000],   //3
          [ 0.000,    0.000,    0.500,    0.500,    0.000,    0.000,   -0.063,    0.096,    0.000,    0.000,    0.017,   -0.067,    0.000,    0.000],   //3
          [ 0.393,    1.143,    0.929,    1.143,    0.393,    0.077,    0.036,    0.036,    0.077,    0.000,   -0.107,   -0.071,   -0.107,    0.000],   //4 fields
          [ 0.446,    0.554,    0.500,    0.446,   -0.054,    0.100,    0.000,    0.080,    0.000,    0.000,   -0.054,   -0.036,   -0.054,    0.000],   //4
          [-0.054,    0.446,    0.500,    0.554,    0.446,    0.000,    0.080,    0.000,   -0.100,    0.000,   -0.054,   -0.036,   -0.054,    0.000],   //4
          [ 0.766,    1.224,    0.766,    0.500,    0.500,    0.070,    0.070,    0.000,    0.096,    0.000,   -0.121,   -0.018,   -0.058,    0.000],   //4
          [ 0.000,   -0.080,    0.420,    0.550,   -0.050,    0.000,    0.000,    0.075,    0.000,    0.000,    0.013,   -0.054,   -0.049,    0.000],   //4
          [-0.050,    0.478,    1.144,    0.478,   -0.050,    0.000,    0.070,    0.070,    0.000,    0.000,   -0.036,   -0.107,   -0.036,    0.000],   //4
          [ 0.500,    0.607,   -0.214,    0.607,    0.500,    0.096,    0.000,    0.000,    0.096,    0.000,   -0.071,    0.036,   -0.071,    0.000],   //4
          [ 0.000,    0.000,    0.000,    0.000,    0.000,    0.000,    0.000,    0.000,    0.000,    0.000,    0.000,    0.000,    0.000,    0.000]] //4 if no load
    }



    // all basic list elements for main page, with link to each page
    ListModel {
        id: idListSituationsMultiBeam
        ListElement {
            index: 1
            numberOfSupports: 3
            page: "3_MultiSpanBeam2.qml"
            section: qsTr("choose fields and load")
            icon: "../img/multispan_icon/multi_icon1.png"
        }
        ListElement {
            index: 2
            numberOfSupports: 3
            page: "3_MultiSpanBeam2.qml"
            section: qsTr("choose fields and load")
            icon: "../img/multispan_icon/multi_icon2.png"
        }
        ListElement {
            index: 3
            numberOfSupports: 4
            page: "3_MultiSpanBeam2.qml"
            section: qsTr("choose fields and load")
            icon: "../img/multispan_icon/multi_icon3.png"
        }
        ListElement {
            index: 4
            numberOfSupports: 4
            page: "3_MultiSpanBeam2.qml"
            section: qsTr("choose fields and load")
            icon: "../img/multispan_icon/multi_icon4.png"
        }
        ListElement {
            index: 5
            numberOfSupports: 4
            page: "3_MultiSpanBeam2.qml"
            section: qsTr("choose fields and load")
            icon: "../img/multispan_icon/multi_icon5.png"
        }
        ListElement {
            index: 6
            numberOfSupports: 4
            page: "3_MultiSpanBeam2.qml"
            section: qsTr("choose fields and load")
            icon: "../img/multispan_icon/multi_icon6.png"
        }
        ListElement {
            index: 7
            numberOfSupports: 4
            page: "3_MultiSpanBeam2.qml"
            section: qsTr("choose fields and load")
            icon: "../img/multispan_icon/multi_icon7.png"
        }
        ListElement {
            index: 8
            numberOfSupports: 5
            page: "3_MultiSpanBeam2.qml"
            section: qsTr("choose fields and load")
            icon: "../img/multispan_icon/multi_icon8.png"
        }
        ListElement {
            index: 9
            numberOfSupports: 5
            page: "3_MultiSpanBeam2.qml"
            section: qsTr("choose fields and load")
            icon: "../img/multispan_icon/multi_icon9.png"
        }
        ListElement {
            index: 10
            numberOfSupports: 5
            page: "3_MultiSpanBeam2.qml"
            section: qsTr("choose fields and load")
            icon: "../img/multispan_icon/multi_icon10.png"
        }
        ListElement {
            index: 11
            numberOfSupports: 5
            page: "3_MultiSpanBeam2.qml"
            section: qsTr("choose fields and load")
            icon: "../img/multispan_icon/multi_icon11.png"
        }
        ListElement {
            index: 12
            numberOfSupports: 5
            page: "3_MultiSpanBeam2.qml"
            section: qsTr("choose fields and load")
            icon: "../img/multispan_icon/multi_icon12.png"
        }
        ListElement {
            index: 13
            numberOfSupports: 5
            page: "3_MultiSpanBeam2.qml"
            section: qsTr("choose fields and load")
            icon: "../img/multispan_icon/multi_icon13.png"
        }
        ListElement {
            index: 14
            numberOfSupports: 5
            page: "3_MultiSpanBeam2.qml"
            section: qsTr("choose fields and load")
            icon: "../img/multispan_icon/multi_icon14.png"
        }
    } // End List




    SilicaListView {
        id: idListView
        anchors.fill: parent
        VerticalScrollDecorator {}

        header: PageHeader {
            title: qsTr("MULTI SPAN BEAM")
        }


        // line content data from model above
        model: idListSituationsMultiBeam

        // put all elements of one kind together, display it as common text like a SectionHeader
        section {
            property: "section"
            delegate: SectionHeader {
                text: section // info from model above
            }
        }

        // make a nice layout for each line with model data
        delegate: ListItem {
            id: idListItemChoiceMulti
            contentHeight: 2*Theme.fontSizeHuge
            Image {
                anchors.centerIn: parent
                height: Theme.iconSizeMedium
                fillMode: Image.PreserveAspectFit
                source: model.icon
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


            // Take the index number to load correct follow-up pictures + take the corresponding line of the array as basic values
            onClicked: {
                // get important variables and transfer to next page
                indexMultiChosenSituation = model.index
                arrayMultiChosenSituation = idArrayMomentFactors.arrayMultiAllFactors[indexMultiChosenSituation]
                numberOfSupportsChosenSituation = model.numberOfSupports
                pageStack.push(Qt.resolvedUrl(model.page), {
                       indexMultiChosenSituation : indexMultiChosenSituation,
                       arrayMultiChosenSituation : arrayMultiChosenSituation,
                       numberOfSupportsChosenSituation : numberOfSupportsChosenSituation
                       })
            }

        } // End ListItem





    } // End SilicaListView

} // End page


