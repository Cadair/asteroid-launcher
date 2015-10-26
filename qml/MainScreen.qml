/****************************************************************************************
**
** Copyright (C) 2014 Aleksi Suomalainen <suomalainen.aleksi@gmail.com>
** All rights reserved.
**
** You may use this file under the terms of BSD license as follows:
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are met:
**     * Redistributions of source code must retain the above copyright
**       notice, this list of conditions and the following disclaimer.
**     * Redistributions in binary form must reproduce the above copyright
**       notice, this list of conditions and the following disclaimer in the
**       documentation and/or other materials provided with the distribution.
**     * Neither the name of the author nor the
**       names of its contributors may be used to endorse or promote products
**       derived from this software without specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
** ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
** WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
** DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
** ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
** ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
** SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
****************************************************************************************/

import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0
import QtQuick.Window 2.1
import org.nemomobile.time 1.0
import org.nemomobile.configuration 1.0
import org.nemomobile.lipstick 0.1
import "scripts/desktop.js" as Desktop

Page {
    WallClock {
        id: wallClock
        enabled: true /* XXX: Disable when display is off */
        updateFrequency: WallClock.Minute
    }

    id: desktop
    property alias switcher: switcher
    // Implements back key navigation

    Keys.onReleased: {
        if (event.key === Qt.Key_Back) {
            if (pageStack.depth > 1) {
                pageStack.pop();
                event.accepted = true;
            } else { Qt.quit(); }
        }
    }

    LauncherRotation {
        id: launcherRotation
        rotationParent: desktop.parent
    }

    orientation: Lipstick.compositor.screenOrientation

    onParentChanged: {
        launcherRotation.rotateRotationParent(nativeOrientation)
    }

    Component.onCompleted: {
        Desktop.instance = desktop
        Lipstick.compositor.screenOrientation = nativeOrientation
        LipstickSettings.lockScreen(true)
    }

    Pager {
        id: pager
        anchors.fill: parent

        model: VisualItemModel {
            ClockPage {
                id: clock
                width: pager.width
                height: pager.height
            }
            FeedsPage {
                id: feeds
                width: pager.width
                height: pager.height
            }
            AppLauncher {
                id: launcher
                height: pager.height
                switcher: switcher
            }
            AppSwitcher {
                id: switcher
                width: pager.width
                height: pager.height
                visibleInHome: x > -width && x < desktop.width
                launcher: launcher
            }
        }

        currentIndex: 0
    }

// Wallpaper
    ConfigurationValue {
        id: wallpaperSource
        key: desktop.isPortrait ? "/desktop/meego/background/portrait/picture_filename" : "/desktop/meego/background/landscape/picture_filename"
        defaultValue: "qrc:/qml/images/graphics-wallpaper-home.jpg"
    }

    Image {
        id:wallpaper
        source: wallpaperSource.value
        anchors.fill: parent
        z: -100
    }
}
