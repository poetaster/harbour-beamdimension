# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-beamdimension

CONFIG += sailfishapp

SOURCES += src/harbour-beamdimension.cpp

DISTFILES += qml/harbour-beamdimension.qml \
    qml/cover/CoverPage.qml \
    qml/pages/About.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SettingsPage.qml \
    rpm/harbour-beamdimension.changes.in \
    rpm/harbour-beamdimension.changes.run.in \
    rpm/harbour-beamdimension.spec \
    translations/*.ts \
    harbour-beamdimension.desktop \
    qml/pages/1_SingleSpanBeam.qml \
    qml/pages/4_ClampedBeam.qml \
    qml/pages/2_SingleSpanBeamCantilever.qml \
    qml/pages/3_MultiSpanBeam2.qml \
    qml/pages/3_MultiSpanBeam1.qml \
    qml/pages/5_PillarButtress.qml

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-beamdimension-de.ts \
                translations/harbour-beamdimension-sv.ts \
