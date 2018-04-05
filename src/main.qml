import QtQuick 2.10
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3

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
                    onClicked: fileDialog.open();
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
                            if (topLeftText.font.bold) {
                                topLeftText.text = mouseX + ", " + mouseY;
                                topLeftText.font.bold = false;
                                topRightText.font.bold = true;
                            }
                            else if (topRightText.font.bold) {
                                topRightText.text = mouseX + ", " + mouseY;
                                topRightText.font.bold = false;
                                bottomRightText.font.bold = true;
                            }
                            else if (bottomRightText.font.bold) {
                                bottomRightText.text = mouseX + ", " + mouseY;
                                bottomRightText.font.bold = false;
                                bottomLeftText.font.bold = true;
                            }
                            else if (bottomLeftText.font.bold) {
                                bottomLeftText.text = mouseX + ", " + mouseY;
                                bottomLeftText.font.bold = false;
                            }
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

                Text {
                    id: topLeftText
                    property int topLeft: 0
                    font.bold: true
                    text: qsTr("Choose top-left")
                }

                Text {
                    id: topRightText
                    property int topRight: 0
                    text: qsTr("Choose top-right")
                }

                Text {
                    id: bottomRightText
                    property int bottomRight: 0
                    text: qsTr("Choose bottom-right")
                }

                Text {
                    id: bottomLeftText
                    property int bottomLeft: 0
                    text: qsTr("Choose bottom-left")
                }

                Button {
                    text: "Undo"
                    // onClicked: fileDialog.open();
                }


                Button {
                    text: "Save..."
                    // onClicked: fileDialog.open();
                }
            }
        }
    }

    FileDialog {
        id: fileDialog

        title: "Please choose an image"
        modality: Qt.WindowModal

        nameFilters: [ "Image files (*.jpg *.png)" ]

        onAccepted: imagePath.text = fileDialog.fileUrls[0]
    }
}
