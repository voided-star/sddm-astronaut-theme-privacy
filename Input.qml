// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Column {
    id: inputContainer
    
    Layout.fillWidth: true

    property ComboBox exposeSession: sessionSelect.exposeSession
    property bool failed

    Item {
        id: errorMessageField

        // change also in selectSession
        height: root.font.pointSize * 2
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter

        Label {
            id: errorMessage

            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            
            text: failed ? config.TranslateLoginFailedWarning || textConstants.loginFailed + "!" : keyboard.capsLock ? config.TranslateCapslockWarning || textConstants.capslockWarning : null
            font.pointSize: root.font.pointSize * 0.8
            font.italic: true
            color: config.WarningColor
            opacity: 0
            
            states: [
                State {
                    name: "fail"
                    when: failed
                    PropertyChanges {
                        target: errorMessage
                        opacity: 1
                    }
                },
                State {
                    name: "capslock"
                    when: keyboard.capsLock
                    PropertyChanges {
                        target: errorMessage
                        opacity: 1
                    }
                }
            ]
            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "opacity"
                        duration: 100
                    }
                }
            ]
        }
    }

    Item {
        id: usernameField

        height: root.font.pointSize * 4.5
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter

        TextField {
            id: username

            anchors.centerIn: parent
            height: root.font.pointSize * 3
            width: parent.width
            horizontalAlignment: TextInput.AlignHCenter
            z: 1

            text: config.ForceLastUser == "true" ? selectUser.currentText : null
            color: config.LoginFieldTextColor
            font.bold: true
            font.capitalization: config.AllowUppercaseLettersInUsernames == "false" ? Font.AllLowercase : Font.MixedCase
            placeholderText: config.TranslatePlaceholderUsername || textConstants.userName
            placeholderTextColor: config.PlaceholderTextColor
            selectByMouse: true
            renderType: Text.QtRendering
            
            onFocusChanged:{
                if(focus)
                    selectAll()
            }

            background: Rectangle {
                color: config.LoginFieldBackgroundColor
                opacity: 0.2
                border.color: "transparent"
                border.width: parent.activeFocus ? 2 : 1
                radius: config.RoundCorners || 0
            }
            
            onAccepted: config.AllowUppercaseLettersInUsernames == "false" ? sddm.login(username.text.toLowerCase(), password.text, sessionSelect.selectedSession) : sddm.login(username.text, password.text, sessionSelect.selectedSession)
            KeyNavigation.down: passwordIcon

            states: [
                State {
                    name: "focused"
                    when: username.activeFocus
                    PropertyChanges {
                        target: username.background
                        border.color: config.HighlightBorderColor
                    }
                    PropertyChanges {
                        target: username
                        color: Qt.lighter(config.LoginFieldTextColor, 1.15)
                    }
                }
            ]
        }

    }
    

    
    Item {
        id: passwordField

        height: root.font.pointSize * 4.5
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter

        TextField {
            id: password

            height: root.font.pointSize * 3
            width: parent.width
            anchors.centerIn: parent
            horizontalAlignment: TextInput.AlignHCenter
            
            font.bold: true
            color: config.PasswordFieldTextColor
            focus: config.PasswordFocus == "true" ? true : false
            placeholderText: config.TranslatePlaceholderPassword || textConstants.password
            placeholderTextColor: config.PlaceholderTextColor
            echoMode: TextInput.Password
            passwordCharacter: " "
            passwordMaskDelay: config.HideCompletePassword == "true" ? undefined : 1000
            renderType: Text.QtRendering
            selectByMouse: true
            opacity: 0 
            
            background: Rectangle {
                color: config.PasswordFieldBackgroundColor
                border.color: config.PasswordFieldTextColor
                border.width: parent.activeFocus ? 2 : 1
                radius: config.RoundCorners || 0
            }
            onAccepted: config.AllowUppercaseLettersInUsernames == "false" ? sddm.login(username.text.toLowerCase(), password.text, sessionSelect.selectedSession) : sddm.login(username.text, password.text, sessionSelect.selectedSession)
            KeyNavigation.down: loginButton
        }

        states: [
            State {
                name: "focused"
                when: password.activeFocus
                PropertyChanges {
                    target: password.background
                    border.color: config.HighlightBorderColor
                }
                PropertyChanges {
                    target: password
                    color: Qt.lighter(config.LoginFieldTextColor, 1.15)
                }
            }
        ]
        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "color, border.color"
                    duration: 150
                }
            }
        ]        
    }

    Item {
        id: login

        // important
        // try 4 or 9 ...
        height: root.font.pointSize * 9
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter

        visible: config.HideLoginButton == "true" ? false : true
        
        Button {
            id: loginButton

            height: root.font.pointSize * 3
            implicitWidth: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            
            text: config.TranslateLogin || textConstants.login
            enabled: config.AllowEmptyPassword == "true" || username.text != "" && password.text != "" ? true : false
            hoverEnabled: true

            contentItem: Text {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font.bold: true
                font.pointSize: root.font.pointSize
                font.family: root.font.family
                color: config.LoginButtonTextColor
                text: parent.text
                opacity: 0.5
            }

            background: Rectangle {
                id: buttonBackground

                color: config.LoginButtonBackgroundColor
                opacity: 0.2
                radius: config.RoundCorners || 0
            }

            states: [
                State {
                    name: "pressed"
                    when: loginButton.down
                    PropertyChanges {
                        target: buttonBackground
                        color: Qt.darker(config.LoginButtonBackgroundColor, 1.1)
                        opacity: 1
                    }
                    PropertyChanges {
                        target: loginButton.contentItem
                    }
                },
                State {
                    name: "hovered"
                    when: loginButton.hovered
                    PropertyChanges {
                        target: buttonBackground
                        color: Qt.lighter(config.LoginButtonBackgroundColor, 1.15)
                        opacity: 1
                    }
                    PropertyChanges {
                        target: loginButton.contentItem
                        opacity: 1
                    }
                },
                State {
                    name: "focused"
                    when: loginButton.activeFocus
                    PropertyChanges {
                        target: buttonBackground
                        color: Qt.lighter(config.LoginButtonBackgroundColor, 1.2)
                        opacity: 1
                    }
                    PropertyChanges {
                        target: loginButton.contentItem
                        opacity: 1
                    }
                },
                State {
                    name: "enabled"
                    when: loginButton.enabled
                    PropertyChanges {
                        target: buttonBackground;
                        color: config.LoginButtonBackgroundColor;
                        opacity: 1
                    }
                    PropertyChanges {
                        target: loginButton.contentItem;
                        opacity: 1
                    }
                }
            ]
            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "opacity, color";
                        duration: 300
                    }
                }
            ]

            onClicked: config.AllowUppercaseLettersInUsernames == "false" ? sddm.login(username.text.toLowerCase(), password.text, sessionSelect.selectedSession) : sddm.login(username.text, password.text, sessionSelect.selectedSession)
            Keys.onReturnPressed: clicked()
            Keys.onEnterPressed: clicked()
            
            KeyNavigation.down: config.HideSystemButtons == "true" ? virtualKeyboard : systemButtons.children[0]
        }
    }

    Connections {
        target: sddm
        function onLoginSucceeded() {}
        function onLoginFailed() {
            failed = true
            resetError.running ? resetError.stop() && resetError.start() : resetError.start()
        }
    }

    Timer {
        id: resetError
        interval: 2000
        onTriggered: failed = false
        running: false
    }
}
