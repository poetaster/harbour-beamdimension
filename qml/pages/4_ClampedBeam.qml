import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page
    allowedOrientations: Orientation.Portrait

    // zero to all pre-sets
    property real zeroingIt
    property real oneIt : 1
    property real lastEntryAreaLoads : 0.0
    property real lastEntryAreaIntakeWidth : 0
    property real lastEntryLinearLoads : 0
    property real lastEntryPointLoad : 0
    property real lastDistanceToF : 0

    property real clampLaengeA_real : 0
    property real clampPointF_A_real : 0
    property real clampQ : 0
    property real clampMmax : 0
    property real clampBeamHeight : 0
    property real clampSupportS1 : 0
    property real clampSupportS2 : 0




    SilicaFlickable {
        anchors.fill: parent
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






        // Main Page o display
        Column {
            id: column
            //width: page.width
            spacing: Theme.paddingSmall
            PageHeader {
                title: qsTr("CLAMPED BEAM")
            }




            Label {
                text: " "
            }
            // Load principal image
            Image {
                id: idImageBeamTwoSupports
                x: Theme.paddingSmall
                width: page.width-2*Theme.paddingSmall
                height: sourceSize.height+ 2*Theme.paddingLarge
                source: "../img/clamped/clamped_basic.png"
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
                    id: idTextfieldBeamLength
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/2
                    inputMethodHints: Qt.ImhFormattedNumbersOnly //use "Qt.ImhDigitsOnly" for INT
                    validator: DoubleValidator { bottom: 0.01; decimals: 2; top: 9999 }
                    label: qsTr("beam length [m]")
                    labelVisible: true
                    text: zeroingIt
                    EnterKey.onClicked: idTextfieldBeamLength.focus = false
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
                    //(Math.round(clampMmax * 1000)/1000).toFixed(3)
                }
            } // End Grid material infos


            Label {
                text: " "
            }
            Label {
                text: " "
            }





            SectionHeader {
                text: qsTr("APPLY AREA LOAD")
            }


            Label {
                text: " "
            }


            // Load images
            Image {
                id: idImageQ
                x: Theme.paddingLarge
                width: page.width-Theme.paddingLarge-Theme.paddingMedium
                source: "../img/clamped/clamped_basicQ.png"
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


                Label { // ToDo: paddingLeft does not fit in light ambiances + textColor for description too strong
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





            SectionHeader {
                text: qsTr("APPLY LINEAR LOAD")
            }


            Label {
                text: " "
            }


            Image {
                id: idImageq
                x: Theme.paddingLarge
                width: page.width-Theme.paddingLarge-Theme.paddingMedium
                source: "../img/clamped/clamped_basicq.png"
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
                text: qsTr("APPLY POINT LOAD")
            }





            Label {
                text: " "
            }
            Image {
                id: idImageF
                x: Theme.paddingLarge
                width: page.width-Theme.paddingLarge-Theme.paddingMedium
                source: "../img/clamped/clamped_basicF.png"
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





            // Grid 3 Load F
            Grid {
                signal editingFinished()

                columns: 2
                rows: 4
                spacing: Theme.paddingSmall

                TextSwitch {
                    id: idTextSwitchPointLoad
                    width: page.width/2
                    text: qsTr("point load F")
                    description: qsTr("single force applied to beam")
                    onCheckedChanged: {
                        checked ? idTextfieldPointLoad.text = lastEntryPointLoad : idTextfieldPointLoad.text = 0
                        checked ? idTextfieldPointLoad.readOnly=false : idTextfieldPointLoad.readOnly=true

                        checked ? idTextfieldDistanceToF.text = lastEntryPointLoad : idTextfieldDistanceToF.text = 0
                        checked ? idTextfieldDistanceToF.readOnly=false : idTextfieldDistanceToF.readOnly=true
                    }
                }

                TextField {
                    id: idTextfieldPointLoad
                    readOnly: true
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/2
                    inputMethodHints: Qt.ImhFormattedNumbersOnly //use "Qt.ImhDigitsOnly" for INT
                    validator: DoubleValidator { bottom: -9999999; decimals: 2; top: 9999999 }
                    label: qsTr("point load F [kN]")
                    //EnterKey.enabled: text.length >= 0
                    text: lastEntryPointLoad
                    EnterKey.onClicked: { // ToDo: replace by "onEditingFinished" from QtQuick.Controls not yet available in Sailfish
                        lastEntryPointLoad = Number((idTextfieldPointLoad.text).replace(',', '.'))
                        //console.log(lastEntryPointLoad)
                        idTextfieldPointLoad.focus = false
                    }
                }

                Label { // empty
                    leftPadding: 3*Theme.paddingLarge
                    textFormat: Text.RichText
                    text: " "
                }

                TextField {
                    id: idTextfieldDistanceToF
                    readOnly: true
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/2
                    inputMethodHints: Qt.ImhFormattedNumbersOnly //use "Qt.ImhDigitsOnly" for INT
                    validator: DoubleValidator { bottom: 0; decimals: 2; top: 9999999 }
                    label: qsTr("distance to F [m]")
                    EnterKey.enabled: text.length >= 0
                    text: lastDistanceToF
                    EnterKey.onClicked: {
                        lastDistanceToF = Number((idTextfieldDistanceToF.text).replace(',', '.'))
                        //console.log(lastDistanceToF)
                        idTextfieldDistanceToF.focus = false
                    }
                }

            } // End Grid F

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
                source: "../img/clamped/clamped_basicResults.png"
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
                label: qsTr("maximum moment M(max) at clamp [kNm]")
                value: clampMmax
                // value: (Math.round(clampMmax * 1000)/1000).toFixed(3) //rounding to 3 digits after comma
            }
            DetailItem {
                label: qsTr("Vertical force F1 on support S1 [kN]")
                value:clampSupportS1
                //value: (Math.round(clampSupportS1 * 1000)/1000).toFixed(3)
            }

            Label {
                text: " "
            }





            SectionHeader {
                text: qsTr("MINIMUM BEAM HEIGHT")
            }


            DetailItem {
                label: qsTr("minimum height h of a suitable BEAM [mm]")
                value: clampBeamHeight
                // value: (Math.round(clampBeamHeight * 10)/10).toFixed(1)
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
        //str = str.replace(',', '.')
        var BeamLength = Number((idTextfieldBeamLength.text).replace(',', '.'))
        var BeamAngle = Number((idTextfieldBeamAngle.text).replace(',', '.'))
        var AreaLoad = Number((idTextfieldAreaLoads.text).replace(',', '.'))
        var IntakeWidth = Number((idTextfieldAreaIntakeWidth.text).replace(',', '.'))
        var LinearLoads = Number((idTextfieldLinearLoads.text).replace(',', '.'))
        var PointLoad = Number((idTextfieldPointLoad.text).replace(',', '.'))
        var BeamWidth = Number((idTextfieldBeamWidth.text).replace(',', '.'))
        var DesignTension = Number((idTextfieldDesignTension.text).replace(',', '.'))
        var DistanceToF = Number((idTextfieldDistanceToF.text).replace(',', '.'))


        //var clampLaengeA_pojected with regard to inclination
        clampLaengeA_real = BeamLength * (Math.cos(BeamAngle * (2 * Math.PI / 360))) // angle adjusted projected length
        //console.log("visible lenght from above: " + clampLaengeA_real)

        //var clampPointF_A_real with regard to inclination
        clampPointF_A_real = DistanceToF * (Math.cos(BeamAngle * (2 * Math.PI / 360))) // angle adjusted projected length
        //console.log("visible distance to F from above: " + clampPointF_A_real)

        //var clampQ
        clampQ = (AreaLoad * IntakeWidth) + LinearLoads
        //console.log("Q&q: " + clampQ)

        //var clampMmax
        clampMmax = (((clampQ * (clampLaengeA_real * clampLaengeA_real)) / 2) + ((PointLoad * clampPointF_A_real)))
        //Be_Mmax = (((Be_Q * (Be_LaengeA_real * Be_LaengeA_real)) / 2) + ((Be_Punktlast * Be_Punktlast_Abstand_real)))
        //console.log("M_max: " + clampMmax)

        //var clampBeamHeight
        clampBeamHeight = Math.sqrt((6 * clampMmax * 1000000) / (BeamWidth * DesignTension))
        //console.log("beam height: " + clampBeamHeight)

        //var clampSupportS1
        clampSupportS1 = ((clampQ * BeamLength) + PointLoad )
        //console.log("SupportS1: " + clampSupportS1)




        // Rounding to 3 places after comma
        clampMmax = (Math.round(clampMmax * 1000)/1000).toFixed(3) //rounding to 3 digits after comma
        clampSupportS1 = (Math.round(clampSupportS1 * 1000)/1000).toFixed(3)
        clampBeamHeight = (Math.round(clampBeamHeight * 10)/10).toFixed(1)


    }







} // End of whole Page








