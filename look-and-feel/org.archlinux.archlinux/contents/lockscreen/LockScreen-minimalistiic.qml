/********************************************************************
 KSld - the KDE Screenlocker Daemon
 This file is part of the KDE project.

Copyright (C) 2011 Martin Gräßlin <mgraesslin@kde.org>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*********************************************************************/

import QtQuick 2.2
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
// import org.kde.qtextracomponents 2.0
import org.kde.kscreenlocker 1.0
import "../components"

Image {
    id: lockScreen
    signal unlockRequested()
    property alias capsLockOn: unlockUI.capsLockOn
    property bool locked: false
    source: "../components/artwork/background.png"
    fillMode: Image.PreserveAspectCrop

    Rectangle {
        id: dialog
//        width: 200
//        height: 200
        width: mainStack.currentPage.implicitWidth + mainStack.anchors.leftMargin + mainStack.anchors.rightMargin
        height: mainStack.currentPage.implicitHeight + mainStack.anchors.topMargin + mainStack.anchors.bottomMargin
        color: "#ffffff"
        visible: lockScreen.locked
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: 0
        anchors.verticalCenterOffset: parent.height / 4

        PlasmaComponents.PageStack {
            id: mainStack
            clip: true
            anchors {
                fill: parent
                leftMargin: 20
                topMargin: 20
                rightMargin: 20
                bottomMargin: 20
            }
            initialPage: unlockUI
        }
    }

    Greeter {
        id: unlockUI

        switchUserEnabled: sessions.switchUserSupported

        Sessions {
            id: sessions
        }

        Connections {
            onAccepted: lockScreen.unlockRequested()
            onSwitchUserClicked: { mainStack.push(userSessionsUIComponent); mainStack.currentPage.forceActiveFocus(); }
        }
    }

    function returnToLogin() {
        mainStack.pop();
        unlockUI.resetFocus();
    }

    Component {
        id: userSessionsUIComponent

        SessionSwitching {
            id: userSessionsUI
            visible: false

            Connections {
                onSwitchingCanceled: returnToLogin()
                onSessionActivated: returnToLogin()
                onNewSessionStarted: returnToLogin()
            }
        }
    }
}
