import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page
    allowedOrientations: Orientation.Portrait

    // values from multi-span-choice page before
    property variant arrayMultiChosenSituation
    property int indexMultiChosenSituation
    property int numberOfSupportsChosenSituation


    // zero to all pre-sets
    property real zeroingIt
    property real oneIt : 1
    property real lastEntryAreaLoads : 0.0
    property real lastEntryAreaIntakeWidth : 0
    property real lastEntryLinearLoads : 0

    property real multispan_LaengeA_real : 0
    property real multispan_LaengeB_real: 0
    property real multispan_Q : 0

    property real multispan_F1 : 0
    property real multispan_F2 : 0
    property real multispan_F3 : 0
    property real multispan_F4 : 0
    property real multispan_F5 : 0

    property real multispan_MA : 0
    property real multispan_MB : 0
    property real multispan_MC : 0
    property real multispan_MD : 0

    property real multispan_M1 : 0
    property real multispan_M2 : 0
    property real multispan_M3 : 0
    property real multispan_M4 : 0
    property real multispan_M5 : 0

    property real multispan_Mmax : 0
    property real multispan_BeamHeight : 0



    // only show those results, that match the current choice of supports (3 or 4 or 5)
    Component.onCompleted: {
        idLabelF1.visible = true
        idLabelF2.visible = true
        idLabelF3.visible = true
        idLabelMS1.visible = true
        idLabelMS2.visible = true
        idLabelMS3.visible = true
        idLabelMA.visible = true
        idLabelMB.visible = true
        if (numberOfSupportsChosenSituation == 4) {
            idLabelF4.visible = true
            idLabelMS4.visible = true
            idLabelMC.visible = true
        }
        if (numberOfSupportsChosenSituation == 5) {
            idLabelF4.visible = true
            idLabelF5.visible = true
            idLabelMS4.visible = true
            idLabelMS5.visible = true
            idLabelMC.visible = true
            idLabelMD.visible = true
        }
    }




    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent
        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        /*PullDownMenu {

            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }
        }*/

        // PullUp Menu to (re)calculate
        PushUpMenu {
            quickSelect: true
            MenuItem {
                text: qsTr("calculate")
                onClicked: calculationBeamBetweenTwoSupports()
            }
        }





        // Main Page
        Column {
            id: column
            //width: page.width
            spacing: Theme.paddingSmall
            PageHeader {
                title: (numberOfSupportsChosenSituation - 1) + qsTr(" - SPAN BEAM")
            }





            // Load principal image
            Image {
                id: idMultiSpanSituationImage
                x: Theme.paddingSmall
                width: page.width-2*Theme.paddingSmall
                height: sourceSize.height+ 2*Theme.paddingLarge

                //image according to chosen situation from first input
                source: "../img/multispan/multispan_basic" + indexMultiChosenSituation + ".png"
                fillMode: Image.PreserveAspectFit
                // change black/white according to light or dark theme
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
            Label {
                text: " "
            }
            Label {
                text: " "
            }






            SectionHeader { // Beam-Material Settings
                text: qsTr("KNOWN DIMENSIONS")
            }

            // Grid beam dimensions
            Grid {
                columns: 2
                rows: 2
                spacing: Theme.paddingSmall
                TextField {
                    id: idTextfieldSpanLength
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/2
                    inputMethodHints: Qt.ImhFormattedNumbersOnly //use "Qt.ImhDigitsOnly" for INT
                    validator: DoubleValidator { bottom: 0.01; decimals: 2; top: 9999 }
                    label: qsTr("span length [m]")
                    labelVisible: true
                    text: zeroingIt
                    EnterKey.onClicked: idTextfieldSpanLength.focus = false
                }
                TextField {
                    id: idTextfieldBeamWidth
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/2
                    inputMethodHints: Qt.ImhFormattedNumbersOnly //use "Qt.ImhDigitsOnly" for INT
                    validator: IntValidator { bottom: 1; top: 9999 }
                    label: qsTr("beam width [mm]")
                    EnterKey.enabled: text.length >= 0
                    text: zeroingIt
                    EnterKey.onClicked: idTextfieldBeamWidth.focus = false
                }
                Label{
                    text: " "
                }
                TextField {
                    id: idTextfieldBeamAngle
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/2
                    inputMethodHints: Qt.ImhFormattedNumbersOnly //use "Qt.ImhDigitsOnly" for INT
                    validator: DoubleValidator { bottom: -90; decimals: 2; top: 90 }
                    label: qsTr("inclination [°]")
                    EnterKey.enabled: text.length >= 0
                    text: zeroingIt
                    EnterKey.onClicked: idTextfieldBeamAngle.focus = false
                }
            } // End Grid beam dimensions





            Label {
                text: " "
            }
            Label {
                text: " "
            }
            SectionHeader { // Beam-Material Settings
                text: qsTr("MATERIAL AND SAFETY")
            }

            //Combobox material selector
            ComboBox {
                id: idComboBoxMaterial
                label: qsTr("material")
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("MANUAL INPUT")
                        onClicked: {
                            idTextfieldAllowTension.text = 0
                            idTextfieldEModuln.text = 0
                            idTextfieldDesignTensionSafetyFactor.text = 1
                        }
                    }
                    MenuItem {
                        text: qsTr("timber: spruce / pine")
                        onClicked:  {
                            idTextfieldAllowTension.text = 14 // around 11 is safer
                            idTextfieldEModuln.text = 11000  // around 8000 is safer
                            idTextfieldDesignTensionSafetyFactor.text = 1.7
                        }
                    }
                    MenuItem {
                        text: qsTr("timber: glued laminated timber")
                        onClicked:  {
                            idTextfieldAllowTension.text = 18
                            idTextfieldEModuln.text = 11000
                            idTextfieldDesignTensionSafetyFactor.text = 1.7
                        }
                    }
                    MenuItem {
                        text: qsTr("timber: beech")
                        onClicked:  {
                            idTextfieldAllowTension.text = 24
                            idTextfieldEModuln.text = 11000
                            idTextfieldDesignTensionSafetyFactor.text = 1.7
                        }
                    }
                    MenuItem {
                        text: qsTr("timber: oak")
                        onClicked:  {
                            idTextfieldAllowTension.text = 26
                            idTextfieldEModuln.text = 11000
                            idTextfieldDesignTensionSafetyFactor.text = 1.7
                        }
                    }
                    MenuItem {
                        text: qsTr("metal: aluminium")
                        onClicked: {
                            idTextfieldAllowTension.text = 160
                            idTextfieldEModuln.text = 70000
                            idTextfieldDesignTensionSafetyFactor.text = 1.05
                        }
                    }
                    MenuItem {
                        text: qsTr("metal: steel S235")
                        onClicked: {
                            idTextfieldAllowTension.text = 235
                            idTextfieldEModuln.text = 210000
                            idTextfieldDesignTensionSafetyFactor.text = 1.05
                        }
                    }
                    MenuItem {
                        text: qsTr("metal: steel S355")
                        onClicked: {
                            idTextfieldAllowTension.text = 355
                            idTextfieldEModuln.text = 210000
                            idTextfieldDesignTensionSafetyFactor.text = 1.05
                        }
                    }
                    MenuItem {
                        text: qsTr("concrete: C12/15 - no reinforcement")
                        onClicked: {
                            idTextfieldAllowTension.text = 1.1
                            idTextfieldEModuln.text = 28000
                            idTextfieldDesignTensionSafetyFactor.text = 1
                        }
                    }
                    MenuItem {
                        text: qsTr("concrete: C20/25 - no reinforcement")
                        onClicked: {
                            idTextfieldAllowTension.text = 1.5
                            idTextfieldEModuln.text = 30000
                            idTextfieldDesignTensionSafetyFactor.text = 1
                        }
                    }
                    MenuItem {
                        text: qsTr("concrete: C35/45 - no reinforcement")
                        onClicked: {
                            idTextfieldAllowTension.text = 2.2
                            idTextfieldEModuln.text = 34000
                            idTextfieldDesignTensionSafetyFactor.text = 1
                        }
                    }
                    MenuItem {
                        text: qsTr("concrete: C55/65 - no reinforcement")
                        onClicked: {
                            idTextfieldAllowTension.text = 2.2
                            idTextfieldEModuln.text = 34000
                            idTextfieldDesignTensionSafetyFactor.text = 1
                        }
                    }

                }
            } // End Combobox material selector

            // Grid material infos
            Grid {
                columns: 2
                rows: 2
                spacing: Theme.paddingSmall
                TextField {
                    id: idTextfieldAllowTension
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/2
                    inputMethodHints: Qt.ImhDigitsOnly // for INT, for DEC use Qt.ImhFormattedNumbersOnly
                    validator: DoubleValidator { bottom: 0.1; top: 99999 }
                    label: qsTr("Allowed Tensile") + "\n" + qsTr("Stress [N/mm²]")
                    EnterKey.enabled: text.length >= 0
                    text: zeroingIt
                    onActiveFocusChanged:   {
                        idComboBoxMaterial.currentIndex = 0 // if any manual input, select first item: manual
                    }
                    EnterKey.onClicked: idTextfieldAllowTension.focus = false
                }
                TextField {
                    id: idTextfieldEModuln
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/2
                    inputMethodHints: Qt.ImhDigitsOnly // for INT, for DEC use Qt.ImhFormattedNumbersOnly
                    validator: IntValidator { bottom: 1; top: 9999999 }
                    label: qsTr("E-Moduln") + "\n" + "[N/mm²]"
                    EnterKey.enabled: text.length >= 0
                    text: zeroingIt
                    onActiveFocusChanged:   {
                        idComboBoxMaterial.currentIndex = 0 // if any manual input, select first item: manual
                    }
                    EnterKey.onClicked: idTextfieldEModuln.focus = false
                }
                TextField {
                    id: idTextfieldDesignTensionSafetyFactor
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/2
                    inputMethodHints: Qt.ImhDigitsOnly // for INT, for DEC use Qt.ImhFormattedNumbersOnly
                    validator: DoubleValidator { bottom: 1; top: 99.9 }
                    label: qsTr("material safety") + "\n" + qsTr("factor")
                    EnterKey.enabled: text.length >= 0
                    text: oneIt
                    onActiveFocusChanged:   {
                        idComboBoxMaterial.currentIndex = 0 // if any manual input, select first item: manual
                    }
                    EnterKey.onClicked: idTextfieldDesignTensionSafetyFactor.focus = false
                }
                TextField {
                    id: idTextfieldDesignTension
                    readOnly: true
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/2
                    inputMethodHints: Qt.ImhDigitsOnly // for INT, for DEC use Qt.ImhFormattedNumbersOnly
                    validator: DoubleValidator { bottom: 0.01; top: 99999 }
                    label: qsTr("Design Tension") + "\n" + "SigmaE [N/mm²]"
                    EnterKey.enabled: text.length >= 0
                    // make sure there are only points instead of commas in the input
                    text: ( (idTextfieldAllowTension.text).replace(',', '.') / (idTextfieldDesignTensionSafetyFactor.text).replace(',', '.') ).toFixed(3)
                }
            } // End Grid material infos






            Label {
                text: " "
            }
            Label {
                text: " "
            }





            SectionHeader {
                text: qsTr("APPLY AREA LOAD WHERE AFFECTED")
            }




            Label {
                text: " "
            }
            // Load images
            Image {
                id: idImageQ
                x: Theme.paddingLarge
                width: page.width-Theme.paddingLarge-Theme.paddingMedium
                source: "../img/multispan/multispan_basicQ.png"
                fillMode: Image.PreserveAspectFit
                // change black/white according to light or dark theme
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
            Label {
                text: " "
            }





            // Grid 1 Load Q
            Grid {
                columns: 2
                rows: 4
                spacing: Theme.paddingSmall

                TextSwitch {
                    id: idTextSwitchAreaLoads
                    width: page.width/2
                    text: qsTr("area load Q")
                    description: qsTr("distributed load from an intake area, like snow")
                    onCheckedChanged: {
                        checked ? idTextfieldAreaLoads.text = lastEntryAreaLoads : idTextfieldAreaLoads.text = 0 // call before next line!!!
                        checked ? idTextfieldAreaLoads.readOnly=false : idTextfieldAreaLoads.readOnly=true

                        checked ? idTextfieldAreaIntakeWidth.text = lastEntryAreaIntakeWidth : idTextfieldAreaIntakeWidth.text = 0
                        checked ? idTextfieldAreaIntakeWidth.readOnly=false : idTextfieldAreaIntakeWidth.readOnly=true
                    }
                }

                TextField {
                    id: idTextfieldAreaLoads
                    readOnly: true
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/2
                    inputMethodHints: Qt.ImhFormattedNumbersOnly //use "Qt.ImhDigitsOnly" for INT
                    validator: DoubleValidator { bottom: -9999999; decimals: 2; top: 9999999 }
                    label: qsTr("area load Q [kN/m²]")
                    EnterKey.enabled: text.length >= 0
                    text: lastEntryAreaLoads
                    EnterKey.onClicked: {
                        lastEntryAreaLoads = Number((idTextfieldAreaLoads.text).replace(',', '.'))
                        //console.log(lastEntryAreaLoads)
                        idTextfieldAreaLoads.focus = false
                    }

               }


                Label { // empty
                    leftPadding: 3*Theme.paddingLarge
                    textFormat: Text.RichText
                    text: " "
                }

                TextField {
                    id: idTextfieldAreaIntakeWidth
                    readOnly: true
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/2
                    inputMethodHints: Qt.ImhFormattedNumbersOnly //use "Qt.ImhDigitsOnly" for INT
                    validator: DoubleValidator { bottom: -9999999; decimals: 2; top: 9999999 }
                    label: qsTr("intake width [m]")
                    EnterKey.enabled: text.length >= 0
                    text: lastEntryAreaIntakeWidth
                    EnterKey.onClicked: {
                        lastEntryAreaIntakeWidth = Number((idTextfieldAreaIntakeWidth.text).replace(',', '.'))
                        //console.log(lastEntryAreaIntakeWidth)
                        idTextfieldAreaIntakeWidth.focus = false
                    }
                }
            } // End Grid Q





            Label {
                text: " "
            }
            Label {
                text: " "
            }





            SectionHeader {
                text: qsTr("APPLY LINEAR LOAD WHERE AFFECTED")
            }





            Label {
                text: " "
            }
            Image {
                id: idImageq
                x: Theme.paddingLarge
                width: page.width-Theme.paddingLarge-Theme.paddingMedium
                source: "../img/multispan/multispan_basicq.png"
                fillMode: Image.PreserveAspectFit
                // change black/white according to light or dark theme
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
            Label {
                text: " "
            }





            // Grid 2 Load q
            Grid {
                columns: 2
                rows: 2
                spacing: Theme.paddingSmall

                TextSwitch {
                    id: idTextSwitchLinearLoads
                    width: page.width/2
                    text: qsTr("linear load q")
                    description: qsTr("load along the beam, e.g. a wall")
                    onCheckedChanged: {
                        checked ? idTextfieldLinearLoads.text = lastEntryLinearLoads : idTextfieldLinearLoads.text = 0
                        checked ? idTextfieldLinearLoads.readOnly=false : idTextfieldLinearLoads.readOnly=true
                    }
                }

                TextField {
                    id: idTextfieldLinearLoads
                    readOnly: true
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/2
                    inputMethodHints: Qt.ImhFormattedNumbersOnly //use "Qt.ImhDigitsOnly" for INT
                    validator: DoubleValidator { bottom: -9999999; decimals: 2; top: 9999999 }
                    label: qsTr("linear load q [kN/m]")
                    EnterKey.enabled: text.length >= 0
                    text: lastEntryLinearLoads
                    EnterKey.onClicked: {
                        lastEntryLinearLoads = Number((idTextfieldLinearLoads.text).replace(',', '.'))
                        //console.log(lastEntryLinearLoads)
                        idTextfieldLinearLoads.focus = false
                    }
                }
            } // End Grid q





            Label {
                text: " "
            }
            Label {
                text: " "
            }






            SectionHeader {
                text: qsTr("RESULTS")
            }





            Label {
                text: " "
            }
            Image {
                id: idImageResults
                x: Theme.paddingSmall
                width: page.width-2*Theme.paddingSmall
                height: sourceSize.height+ 2*Theme.paddingLarge
                source: "../img/multispan/multispan_results" + (numberOfSupportsChosenSituation-1) + "spans.png"
                fillMode: Image.PreserveAspectFit
                // change black/white according to light or dark theme
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
            Label {
                text: " "
            }






            DetailItem {
                id: idLabelMS1
                visible: false
                label: qsTr("M1 [kNm]")
                value: multispan_M1
            }
            DetailItem {
                id: idLabelMS2
                visible: false
                label: qsTr("M2 [kNm]")
                value: multispan_M2
            }
            DetailItem {
                id: idLabelMS3
                visible: false
                label: qsTr("M3 [kNm]")
                value: multispan_M3
            }
            DetailItem {
                id: idLabelMS4
                visible: false
                label: qsTr("M4 [kNm]")
                value: multispan_M4
            }
            DetailItem {
                id: idLabelMS5
                visible: false
                label: qsTr("M5 [kNm]")
                value: multispan_M5
            }



            DetailItem {
                id: idLabelMA
                visible: false
                label: qsTr("Ma [kNm]")
                value: multispan_MA
            }
            DetailItem {
                id: idLabelMB
                visible: false
                label: qsTr("Mb [kNm]")
                value: multispan_MB
            }
            DetailItem {
                id: idLabelMC
                visible: false
                label: qsTr("Mc [kNm]")
                value: multispan_MC
            }
            DetailItem {
                id: idLabelMD
                visible: false
                label: qsTr("Md [kNm]")
                value: multispan_MD
            }



            DetailItem {
                label: qsTr("highest absolute moment M(max) [kNm]")
                value: multispan_Mmax
            }



            DetailItem {
                id: idLabelF1
                visible: false
                label: qsTr("F1 on S1 [kN]")
                value:multispan_F1
            }
            DetailItem {
                id: idLabelF2
                visible: false
                label: qsTr("F2 on S2 [kN]")
                value: multispan_F2
            }
            DetailItem {
                id: idLabelF3
                visible: false
                label: qsTr("F3 on S3 [kN]")
                value: multispan_F3
            }
            DetailItem {
                id: idLabelF4
                visible: false
                label: qsTr("F4 on S4 [kN]")
                value: multispan_F4
            }
            DetailItem {
                id: idLabelF5
                visible: false
                label: qsTr("F5 on S5 [kN]")
                value: multispan_F5
            }




            Label {
                text: " "
            }





            SectionHeader {
                text: qsTr("MINIMUM BEAM HEIGHT")
            }

            DetailItem {
                label: qsTr("minimum height h of a suitable BEAM [mm]")
                value: multispan_BeamHeight
                // value: (Math.round(multispan_BeamHeight * 10)/10).toFixed(1)
            }





            Label {
                text: " "
            }
            Label {
                text: " "
            }





        } // End of full column
    } // End of Flickable











/// Part for Functions /////////////////////////////////////////////////////////////
    function calculationBeamBetweenTwoSupports() {


        // Replace commas with dots in string - like from German to English
        // ... then make a number from that string
        var BeamLengthA = Number((idTextfieldSpanLength.text).replace(',', '.'))
        var BeamAngle = Number((idTextfieldBeamAngle.text).replace(',', '.'))
        var AreaLoad = Number((idTextfieldAreaLoads.text).replace(',', '.'))
        var IntakeWidth = Number((idTextfieldAreaIntakeWidth.text).replace(',', '.'))
        var LinearLoads = Number((idTextfieldLinearLoads.text).replace(',', '.'))
        var BeamWidth = Number((idTextfieldBeamWidth.text).replace(',', '.'))
        var DesignTension = Number((idTextfieldDesignTension.text).replace(',', '.'))


        //var multispan_LaengeA_pojected with regard to inclination
        multispan_LaengeA_real = BeamLengthA * (Math.cos(BeamAngle * (2 * Math.PI / 360))) // angle adjusted projected length
        //var total multispan_Q
        multispan_Q = (AreaLoad * IntakeWidth) + LinearLoads


        //var multispan_Supports
        multispan_F1 = multispan_Q * multispan_LaengeA_real * arrayMultiChosenSituation[0]
        multispan_F2 = multispan_Q * multispan_LaengeA_real * arrayMultiChosenSituation[1]
        multispan_F3 = multispan_Q * multispan_LaengeA_real * arrayMultiChosenSituation[2]
        multispan_F4 = multispan_Q * multispan_LaengeA_real * arrayMultiChosenSituation[3]
        multispan_F5 = multispan_Q * multispan_LaengeA_real * arrayMultiChosenSituation[4]

        multispan_MA = multispan_Q * multispan_LaengeA_real * arrayMultiChosenSituation[5]
        multispan_MB = multispan_Q * multispan_LaengeA_real * arrayMultiChosenSituation[6]
        multispan_MC = multispan_Q * multispan_LaengeA_real * arrayMultiChosenSituation[7]
        multispan_MD = multispan_Q * multispan_LaengeA_real * arrayMultiChosenSituation[8]

        multispan_M1 = multispan_Q * multispan_LaengeA_real * arrayMultiChosenSituation[9]
        multispan_M2 = multispan_Q * multispan_LaengeA_real * arrayMultiChosenSituation[10]
        multispan_M3 = multispan_Q * multispan_LaengeA_real * arrayMultiChosenSituation[11]
        multispan_M4 = multispan_Q * multispan_LaengeA_real * arrayMultiChosenSituation[12]
        multispan_M5 = multispan_Q * multispan_LaengeA_real * arrayMultiChosenSituation[13]


        // get highest absolute Mmax for beam dimensioning
        multispan_Mmax = (Math.max((Math.abs(multispan_MA)),
                                   (Math.abs(multispan_MB)),
                                   (Math.abs(multispan_MC)),
                                   (Math.abs(multispan_MD)),
                                   (Math.abs(multispan_M1)),
                                   (Math.abs(multispan_M2)),
                                   (Math.abs(multispan_M3)),
                                   (Math.abs(multispan_M4)),
                                   (Math.abs(multispan_M5)) ) )


        //get necessary BeamHeight
        multispan_BeamHeight = Math.sqrt((6 * multispan_Mmax * 1000000) / (BeamWidth * DesignTension))



        // Rounding to 3 places after comma
        multispan_F1 = (Math.round(multispan_F1 * 1000)/1000).toFixed(3)
        multispan_F1 = (Math.round(multispan_F2 * 1000)/1000).toFixed(3)
        multispan_F1 = (Math.round(multispan_F3 * 1000)/1000).toFixed(3)
        multispan_F1 = (Math.round(multispan_F4 * 1000)/1000).toFixed(3)
        multispan_F1 = (Math.round(multispan_F5 * 1000)/1000).toFixed(3)

        multispan_MA = (Math.round(multispan_MA * 1000)/1000).toFixed(3)
        multispan_MB = (Math.round(multispan_MB * 1000)/1000).toFixed(3)
        multispan_MC = (Math.round(multispan_MC * 1000)/1000).toFixed(3)
        multispan_MD = (Math.round(multispan_MD * 1000)/1000).toFixed(3)
        multispan_M1 = (Math.round(multispan_M1 * 1000)/1000).toFixed(3)
        multispan_M2 = (Math.round(multispan_M2 * 1000)/1000).toFixed(3)
        multispan_M3 = (Math.round(multispan_M3 * 1000)/1000).toFixed(3)
        multispan_M4 = (Math.round(multispan_M4 * 1000)/1000).toFixed(3)
        multispan_M5 = (Math.round(multispan_M5 * 1000)/1000).toFixed(3)

        multispan_Mmax = (Math.round(multispan_Mmax * 1000)/1000).toFixed(3)
        multispan_BeamHeight = (Math.round(multispan_BeamHeight * 10)/10).toFixed(1)


    }







} // End of whole Page








