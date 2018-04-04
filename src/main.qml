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

            Image {
                id: image
                source: imagePath.text
            }
        }
    }

    FileDialog {
        id: fileDialog

        title: "Please choose an image"
        modality: Qt.WindowModal

        folder: shortcuts.home
        nameFilters: [ "Image files (*.jpg *.png)" ]

        onAccepted: imagePath.text = fileDialog.fileUrls[0]
    }
}
