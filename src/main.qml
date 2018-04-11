import QtQuick 2.10
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3
import ch.epfl.chili.fileio 1.0

ApplicationWindow {
    visible: true
    property int margin: 11
    width: imageBox.implicitWidth + 2 * margin
    height: imageBox.implicitHeight + 2 * margin

    title: "Mark corners of cellulo paper"
    
    ColumnLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: margin

        GroupBox {
            id: rowBox
            Layout.fillWidth: true

            RowLayout {
                id: filePickerLayout
                anchors.fill: parent

                TextField {
                    id: imagePath
                    Layout.fillWidth: true

                    placeholderText: qsTr("No image selected")
                }

                Button {
                    text: "Open..."
                    onClicked: imageFileDialog.open();
                }
            }
        }

        GroupBox {
            id: imageBox
            title: "Image"            
            implicitWidth: 640
            implicitHeight: 480
            Layout.fillWidth: true
            Layout.fillHeight: true

            ScrollView {
                anchors.fill: parent

                Image {
                    id: image
                    source: imagePath.text
                    fillMode: Image.Pad

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onPositionChanged: {
                            coordText.xCoord = mouseX;
                            coordText.yCoord = mouseY;
                        }
                        onClicked: {
                            coordRepeater.itemAt(choiceLayout.currentStep).text = "[" + mouseX + ", " + mouseY + "]";
                            if (choiceLayout.currentStep < 3)
                                choiceLayout.currentStep += 1;
                            else choiceLayout.done = true;
                        }
                    }
                }
            }
        }

        GroupBox {
            id: coordBox
            Layout.fillWidth: true

            RowLayout {
                id: coordLayout
                anchors.fill: parent

                Text {
                    id: coordText
                    property int xCoord: 0
                    property int yCoord: 0

                    text: "(" + xCoord + ", " + yCoord + ")"
                }
            }
        }

        GroupBox {
            id: choiceBox
            Layout.fillWidth: true

            RowLayout {
                id: choiceLayout
                anchors.fill: parent

                property int currentStep: 0
                property bool done: false

                Repeater {
                    id: coordRepeater
                    model: ["Choose top-left", "Choose top-right", "Choose bottom-right", "Choose bottom-left"]

                    Text {
                        font.bold: choiceLayout.currentStep == index
                        text: modelData
                    }
                }

                Button {
                    text: "Undo"
                    onClicked: {
                        if (choiceLayout.currentStep == 0)
                            return;

                        if (choiceLayout.done)
                            choiceLayout.done = false
                        else
                            choiceLayout.currentStep -= 1;

                        coordRepeater.itemAt(choiceLayout.currentStep).text = coordRepeater.model[choiceLayout.currentStep];
                    }
                }


                Button {
                    text: "Save..."
                    enabled: choiceLayout.done
                    onClicked: outputFileDialog.open();
                }
            }
        }
    }

    FileDialog {
        id: imageFileDialog

        title: "Please choose an image"
        modality: Qt.WindowModal
        selectMultiple: false

        nameFilters: [ "Image files (*.jpg *.png)" ]

        onAccepted: imagePath.text = imageFileDialog.fileUrl
    }

    FileDialog {
        id: outputFileDialog

        title: "Please choose an output file"
        modality: Qt.WindowModal
        selectExisting: false
        selectMultiple: false

        nameFilters: [ "JSON files (*.json)" ]

        onAccepted: {
            console.log("Writing output to \"" + outputFileDialog.fileUrl + "\"");
            fileIo.setPath(outputFileDialog.fileUrl);
            fileIo.write("{\"coords\" : [" + 
                coordRepeater.itemAt(0).text + ", " + 
                coordRepeater.itemAt(1).text + ", " + 
                coordRepeater.itemAt(2).text + ", " + 
                coordRepeater.itemAt(0).text + "]}\n")
        }
    }

    FileIo {
        id: fileIo
        visible: false
    }
}
