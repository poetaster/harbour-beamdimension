import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page
    allowedOrientations: Orientation.Portrait

    // zero to all pre-sets
    property real zeroingIt
    property real oneIt : 1
    property real lastEntryPointLoad : 0
    property int eulerCase : 1  // Euler-case: apply load for this situation of clamped and loose supports
    property real eulerBeta : 2 // for eulerCase1

    property real pillar_LaengeA_real : 0
    property real pillar_Mmax : 0
    property real beamHeight_Ideal : 0
    property real beamWidth_Ideal : 0

    property real beam_FKy_Ideal : 0
    property real beam_FKz_Ideal : 0

    property real beam_Iy_Ideal : 0
    property real beam_Iz_Ideal : 0



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
                text: qsTr("check manual dimensions")
                onClicked: checkManualBeamDimensions()
            }
            MenuItem {
                text: qsTr("calculate minimum dimensions")
                onClicked: calculationIdealBeam()
            }
        }






        // Main Page
        Column {
            id: column
            //width: page.width
            spacing: Theme.paddingSmall
            PageHeader {
                title: qsTr("PILLAR / BUTTRESS")
            }




            Label {
                text: " "
            }
            // Load principal image
            Image {
                id: idImagePillar
                x: Theme.paddingSmall
                width: page.width-2*Theme.paddingSmall
                height: sourceSize.height+ 2*Theme.paddingLarge
                source: "../img/pillar/pillar_basic.png"
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






            ComboBox {
                id: idComboBoxEuler
                label: qsTr("principal situation") + "  "
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("E1 = Euler 1")
                        onClicked: {
                            eulerCase = 1
                            eulerBeta = 2
                        }
                    }
                    MenuItem {
                        text: qsTr("E2 = Euler 2")
                        onClicked: {
                            eulerCase = 2
                            eulerBeta = 1
                        }
                    }
                    MenuItem {
                        text: qsTr("E3 = Euler 3")
                        onClicked: {
                            eulerCase = 3
                            eulerBeta = 0.7 // = 1/2*sqrt(2)
                        }
                    }
                    MenuItem {
                        text: qsTr("E4 = Euler 4")
                        onClicked: {
                            eulerCase = 4
                            eulerBeta = 0.5
                        }
                    }
                }
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
                    label: qsTr("beam width y [mm]")
                    EnterKey.enabled: text.length >= 0
                    text: zeroingIt
                    EnterKey.onClicked: idTextfieldBeamWidth.focus = false
                }
                Label {
                    text: " "
                }

                TextField {
                    id: idTextfieldBeamHeight
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/2
                    inputMethodHints: Qt.ImhFormattedNumbersOnly //use "Qt.ImhDigitsOnly" for INT
                    validator: IntValidator { bottom: 1; top: 9999 }
                    label: qsTr("beam height z [mm]")
                    EnterKey.enabled: text.length >= 0
                    text: zeroingIt
                    EnterKey.onClicked: idTextfieldBeamHeight.focus = false
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
                    //(Math.round(pillar_Mmax * 1000)/1000).toFixed(3)
                }
            } // End Grid material infos






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
                    description: qsTr("single force in longitudinal direction")
                    onCheckedChanged: {
                        checked ? idTextfieldPointLoad.text = lastEntryPointLoad : idTextfieldPointLoad.text = 0
                        checked ? idTextfieldPointLoad.readOnly=false : idTextfieldPointLoad.readOnly=true
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
            } // End Grid F





            Label {
                text: " "
            }






            SectionHeader {
                text: qsTr("RESULTS - EULER") + " " + eulerCase
            }





            Image {
                id: idImageResults
                x: Theme.paddingSmall
                width: page.width-2*Theme.paddingSmall
                height: sourceSize.height+ 2*Theme.paddingLarge
                source: "../img/pillar/pillar_results" + eulerCase + ".png"
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
                id: idDetailItemBeamWidthIdeal
                visible: false
                label: qsTr("minimum WIDTH y of a suitable BEAM [mm] /ignore manual input")
                value: beamWidth_Ideal
            }
            DetailItem {
                id: idDetailItemBeamResitancemomentIy
                label: qsTr("surface moment of inertia Iy [mm4]")
                value: beam_Iy_Ideal
            }

            DetailItem {
                id: idForceFy
                label: qsTr("maximum force F [kN] before bending/braking in y-direction")
                value: beam_FKy_Ideal
            }
            DetailItem {
                id: idForceFyStrongEnough
                label: qsTr("beam strong enough to resist bending/braking in y-direction?")
                value: ""
            }
            Label {
                text: " "
            }





            DetailItem {
                id: idDetailItemBeamHeightIdeal
                visible: false
                label: qsTr("minimum HEIGHT z of a suitable BEAM [mm] /ignore manual input")
                value: beamHeight_Ideal
            }
            DetailItem {
                id: idDetailItemBeamResitancemomentIz
                label: qsTr("surface moment of inertia Iz [mm4]")
                value: beam_Iz_Ideal
            }
            DetailItem {
                id: idForceFz
                label: qsTr("maximum force F [kN] before bending/braking in z-direction")
                value: beam_FKz_Ideal
            }
            DetailItem {
                id: idForceFzStrongEnough
                label: qsTr("beam strong enough to resist bending/braking in z-direction?")
                value: ""
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
    function calculationIdealBeam() {

        // activate chosen items
        //idDetailItemBeamHeightIdeal.visible = true
        //idDetailItemBeamWidthIdeal.visible = true


        // Replace commas with dots in string - like from German to English
        // ... then make a number from that string
        var BeamLengthMM = 1000 * Number((idTextfieldBeamLength.text).replace(',', '.'))
        var PointLoad = Number((idTextfieldPointLoad.text).replace(',', '.'))
        var BeamWidth = Number((idTextfieldBeamWidth.text).replace(',', '.'))
        var DesignTension = Number((idTextfieldDesignTension.text).replace(',', '.'))
        var Emoduln = Number((idTextfieldEModuln.text).replace(',', '.'))


        // minimal ideal square beam dimensions, less will break, width and height of beam are the same (Y=Z)
        var beamHeight_Ideal = Math.pow( (12 * (PointLoad * 1000) * (Math.pow( (eulerBeta * BeamLengthMM), 2 ))  /  (3.1416 * 3.1416 * Emoduln ) )  , (1/4) ) // result in [mm]
        var beam_Iy_Ideal = ((beamHeight_Ideal * beamHeight_Ideal * beamHeight_Ideal * beamHeight_Ideal) / 12)
        var beam_Iz_Ideal = beam_Iy_Ideal

        var beam_FKy_Ideal = (((3.1416 * 3.1416) * Emoduln * beam_Iy_Ideal) / ((eulerBeta * BeamLengthMM) * (eulerBeta * BeamLengthMM)))/1000 // in kN
        var beam_FKz_Ideal = beam_FKy_Ideal

        // round to 3 digits after comma
        beamHeight_Ideal = (Math.round(beamHeight_Ideal * 1000)/1000).toFixed(3)
        var beamWidth_Ideal = beamHeight_Ideal
        beam_FKy_Ideal = (Math.round(beam_FKy_Ideal * 1000)/1000).toFixed(3)
        beam_FKz_Ideal = (Math.round(beam_FKz_Ideal * 1000)/1000).toFixed(3)
        beam_Iy_Ideal = (Math.round(beam_Iy_Ideal * 1000)/1000).toFixed(3)
        beam_Iz_Ideal = (Math.round(beam_Iz_Ideal * 1000)/1000).toFixed(3)

        // show calculated values
        idDetailItemBeamHeightIdeal.value = beamHeight_Ideal
        idDetailItemBeamWidthIdeal.value = beamWidth_Ideal
        idForceFy.value = beam_FKy_Ideal
        idForceFz.value = beam_FKz_Ideal
        idDetailItemBeamResitancemomentIy.value = beam_Iy_Ideal
        idDetailItemBeamResitancemomentIz.value = beam_Iy_Ideal


        // check if beam is strong enough or not in each direction
        if (beam_FKy_Ideal > PointLoad) {
            idForceFyStrongEnough.value = "YES, holding nicely"
        }
        if ( (Math.round(beam_FKy_Ideal* 1000/1000).toFixed(3) ) === ( Math.round(PointLoad * 1000/1000).toFixed(3) ) ) {
            idForceFyStrongEnough.value = "BARELY holding, but OK"
        }
        if (beam_FKy_Ideal < PointLoad) {
            idForceFyStrongEnough.value = "NO, bends and brakes through"
        }

        if (beam_FKz_Ideal > PointLoad) {
            idForceFzStrongEnough.value = "YES, holding nicely"
        }
        if ( (Math.round(beam_FKz_Ideal* 1000/1000).toFixed(3) ) === ( Math.round(PointLoad * 1000/1000).toFixed(3) ) ) {
            idForceFzStrongEnough.value = "BARELY holding, but OK"
        }
        if (beam_FKz_Ideal < PointLoad) {
            idForceFzStrongEnough.value = "NO, bends and brakes through"
        }




    }




    function checkManualBeamDimensions() {

        // dactivate chosen items from calculationIdealBeam()
        idDetailItemBeamHeightIdeal.visible = false
        idDetailItemBeamWidthIdeal.visible = false

        // Replace commas with dots in string - like from German to English
        // ... then make a number from that string
        var BeamLengthMM = 1000 * Number((idTextfieldBeamLength.text).replace(',', '.'))
        var PointLoad = Number((idTextfieldPointLoad.text).replace(',', '.'))
        var BeamWidth = Number((idTextfieldBeamWidth.text).replace(',', '.'))
        var BeamHeight = Number((idTextfieldBeamHeight.text).replace(',', '.'))
        var DesignTension = Number((idTextfieldDesignTension.text).replace(',', '.'))
        var Emoduln = Number((idTextfieldEModuln.text).replace(',', '.'))

        // check beam dimensions, if stable or breaks
        var beamHeight_Ideal = Math.pow( (12 * (PointLoad * 1000) * (Math.pow( (eulerBeta * BeamLengthMM), 2 ))  /  (3.1416 * 3.1416 * Emoduln ) )  , (1/4) ) // result in [mm]

        var beam_Iy_Ideal = (BeamWidth * (BeamHeight * BeamHeight * BeamHeight)) / 12
        var beam_Iz_Ideal = (BeamHeight * (BeamWidth * BeamWidth * BeamWidth)) / 12

        var beam_FKy_Ideal = (((3.1416 * 3.1416) * Emoduln * beam_Iy_Ideal) / ((eulerBeta * BeamLengthMM) * (eulerBeta * BeamLengthMM)))/1000 // in kN
        var beam_FKz_Ideal = (((3.1416 * 3.1416) * Emoduln * beam_Iz_Ideal) / ((eulerBeta * BeamLengthMM) * (eulerBeta * BeamLengthMM)))/1000 // in kN


        // round to 3 digits after comma
        beamHeight_Ideal = (Math.round(beamHeight_Ideal * 1000)/1000).toFixed(3)
        beam_FKy_Ideal = (Math.round(beam_FKy_Ideal * 1000)/1000).toFixed(3)
        beam_FKz_Ideal = (Math.round(beam_FKz_Ideal * 1000)/1000).toFixed(3)
        beam_Iy_Ideal = (Math.round(beam_Iy_Ideal * 1000)/1000).toFixed(3)
        beam_Iz_Ideal = (Math.round(beam_Iz_Ideal * 1000)/1000).toFixed(3)

        // show calculated values
        idDetailItemBeamHeightIdeal.value = beamHeight_Ideal
        idDetailItemBeamWidthIdeal.value = beamWidth_Ideal
        idForceFy.value = beam_FKy_Ideal
        idForceFz.value = beam_FKz_Ideal
        idDetailItemBeamResitancemomentIy.value = beam_Iy_Ideal
        idDetailItemBeamResitancemomentIz.value = beam_Iy_Ideal

        // check if beam is strong enough or not in each direction
        if (beam_FKy_Ideal > PointLoad) {
            idForceFyStrongEnough.value = "YES, holding nicely"
        }
        if (beam_FKy_Ideal === PointLoad) {
            idForceFyStrongEnough.value = "BARELY holding, but OK"
        }
        if (beam_FKy_Ideal < PointLoad) {
            idForceFyStrongEnough.value = "NO, bends and brakes through"
        }

        if (beam_FKz_Ideal > PointLoad) {
            idForceFzStrongEnough.value = "YES, holding nicely"
        }
        if (beam_FKz_Ideal === PointLoad) {
            idForceFzStrongEnough.value = "BARELY holding, but OK"
        }
        if (beam_FKz_Ideal < PointLoad) {
            idForceFzStrongEnough.value = "NO, bends and brakes through"
        }


    }




} // End of whole Page








