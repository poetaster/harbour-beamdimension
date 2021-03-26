import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: page
    allowedOrientations: Orientation.Portrait

    // values from former page
    property var profileType


    // UI values
    property var imageRatio : idBeamtypeImage.sourceSize.width / idBeamtypeImage.sourceSize.height

    // autostart functions
    Component.onCompleted: {
        //console.log(profileType)
    }


    SilicaFlickable {
        anchors.fill: parent
        contentHeight: idColumn.height

        Column {
            id: idColumn
            width: parent.width

            DialogHeader { }

            ComboBox {
                id: idComboBoxProfiles
                label: qsTr("Profile:")
                description: qsTr("beam shape")
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Rectangular")
                    }
                    MenuItem {
                        text: qsTr("Rectangular, hollow")
                    }
                    /*
                    MenuItem {
                        text: qsTr("I - Type")
                    }
                    MenuItem {
                        text: qsTr("C - Type")
                    }
                    MenuItem {
                        text: qsTr("T - Type")
                    }
                    MenuItem {
                        text: qsTr("Circular")
                    }
                    MenuItem {
                        text: qsTr("Circular, hollow")
                    }
                    MenuItem {
                        text: qsTr("Triangular")
                    }
                    */
                }
                onCurrentIndexChanged: {
                    getCurrentProfile()
                }
            }

            Image {
                id: idBeamtypeImage
                fillMode: Image.PreserveAspectFit
                x: Theme.paddingLarge + Theme.paddingSmall
                width: parent.width - 2*Theme.paddingLarge - 2*Theme.paddingSmall
                height: width / imageRatio
                source: "../img/profiles/Rechteck-Profil.png"
                Rectangle {
                    z: -1
                    anchors.fill: parent
                    color: "white"
                }
            }

            Item {
                width: parent.width
                height: Theme.paddingLarge
            }

            ComboBox {
                id: idComboBoxKnownValue
                label: qsTr("To check")
                description: qsTr("dimension in question")
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("height H")
                    }
                    MenuItem {
                        text: qsTr("width B")
                    }
                }
            }

            Column {
                id: idGridMeasuresRectangle
                visible: true
                width: parent.width

                Grid {
                    width: parent.width
                    columns: 4
                    TextField {
                        id: idInputRectangle_b
                        width: parent.width / 4
                        label: qsTr("B [mm]")
                        text: "0"
                        horizontalAlignment: Text.AlignRight
                        inputMethodHints: Qt.ImhFormattedNumbersOnly //use "Qt.ImhDigitsOnly" for INT
                        EnterKey.onClicked: {
                            if (text.length <= 0) {
                                text = "0"
                            }
                            focus = false
                        }
                    }
                    Item {
                        height: parent.height
                        width: parent.width / 4
                    }
                    Item {
                        height: parent.height
                        width: parent.width / 4
                    }
                    TextField {
                    id: idInputRectangle_h
                    width: parent.width / 4
                    label: qsTr("H [mm]")
                    text: "0"
                    horizontalAlignment: Text.AlignRight
                    inputMethodHints: Qt.ImhFormattedNumbersOnly //use "Qt.ImhDigitsOnly" for INT
                    EnterKey.onClicked: {
                        if (text.length <= 0) {
                            text = "0"
                        }
                        focus = false
                    }
                }
                }

                Item {
                    width: parent.width
                    height: Theme.paddingLarge
                }

                DetailItem {
                    id: idDetailRectangleArea
                    label: qsTr("Area A") + " [mm]"
                    value: idInputRectangle_b.text * idInputRectangle_h.text
                }
                DetailItem {
                    id: idDetailRectangleIy
                    label: qsTr("Areal Moment of Inertia Iy") + " [mm4]"
                    value: ( idInputRectangle_b.text * Math.pow(idInputRectangle_h.text, 3) ) / 12
                }
                DetailItem {
                    id: idDetailRectangleIz
                    label: qsTr("Areal Moment of Inertia Iz") + " [mm4]"
                    value: ( Math.pow(idInputRectangle_b.text, 3) * idInputRectangle_h.text ) / 12
                }
                DetailItem {
                    id: idDetailRectangleWy
                    label: qsTr("Resistance Moment Wy") + " [mm4]"
                    value: idInputRectangle_b.text * idInputRectangle_h.text
                }
                DetailItem {
                    id: idDetailRectangleWz
                    label: qsTr("Resistance Moment Wz") + " [mm4]"
                    value: idInputRectangle_b.text * idInputRectangle_h.text
                }

            }

            Column {
            id: idGridMeasuresRectangleHollow
            visible: false
            width: parent.width
            Grid {
                columns: 4
                width: parent.width
                TextField {
                    id: idInputRectangleHollow_B
                    width: parent.width / 4
                    label: qsTr("B [mm]")
                    text: "0"
                    horizontalAlignment: Text.AlignRight
                    inputMethodHints: Qt.ImhFormattedNumbersOnly //use "Qt.ImhDigitsOnly" for INT
                    EnterKey.onClicked: {
                        if (text.length <= 0) { text = "0" }
                        focus = false
                    }
                }
                TextField {
                    id: idInputRectangleHollow_b
                    width: parent.width / 4
                    label: qsTr("b [mm]")
                    text: "0"
                    horizontalAlignment: Text.AlignRight
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    EnterKey.onClicked: {
                        if (text.length <= 0) { text = "0" }
                        focus = false
                    }
                }
                TextField {
                    id: idInputRectangleHollow_h
                    width: parent.width / 4
                    label: qsTr("h [mm]")
                    text: "0"
                    horizontalAlignment: Text.AlignRight
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    EnterKey.onClicked: {
                        if (text.length <= 0) { text = "0" }
                        focus = false
                    }
                }
                TextField {
                    id: idInputRectangleHollow_H
                    width: parent.width / 4
                    label: qsTr("H [mm]")
                    text: "0"
                    horizontalAlignment: Text.AlignRight
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    EnterKey.onClicked: {
                        if (text.length <= 0) { text = "0" }
                        focus = false
                    }
                }
            }
        }
        }

    }
    onDone: {
        if (result == DialogResult.Accepted) {
            profileType = idTestLabel.text
        }
    }


    function getCurrentProfile() {
        idGridMeasuresRectangle.visible = false
        idGridMeasuresRectangleHollow.visible = false
        if (idComboBoxProfiles.currentIndex === 0) {
            idBeamtypeImage.source = "../img/profiles/Rechteck-Profil.png"
            idGridMeasuresRectangle.visible = true
        }
        else if (idComboBoxProfiles.currentIndex === 1) {
            idBeamtypeImage.source = "../img/profiles/Rechteckrohr-Profil.png"
            idGridMeasuresRectangleHollow.visible = true
        }
        else if (idComboBoxProfiles.currentIndex === 2) {
            idBeamtypeImage.source = "../img/profiles/I-Profil.png"
        }
        else if (idComboBoxProfiles.currentIndex === 3) {
            idBeamtypeImage.source = "../img/profiles/C-Profil.png"
        }
        else if (idComboBoxProfiles.currentIndex === 4) {
            idBeamtypeImage.source = "../img/profiles/T-Profil.png"
        }
        else if (idComboBoxProfiles.currentIndex === 5) {
            idBeamtypeImage.source = "../img/profiles/Kreis-Profil.png"
        }
        else if (idComboBoxProfiles.currentIndex === 6) {
            idBeamtypeImage.source = "../img/profiles/Kreisrohr-Profil.png"
        }
        else if (idComboBoxProfiles.currentIndex === 7) {
            idBeamtypeImage.source = "../img/profiles/Dreieck-Profil.png"
        }
    }
}
