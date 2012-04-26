# Add more folders to ship with the application, here
folder_01.source = qml/R2-Touch
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01
QT +=  webkit network
# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# Avoid auto screen rotation
#DEFINES += ORIENTATIONLOCK

# Needs to be defined for Symbian
DEFINES += NETWORKACCESS ReadUserData WriteUserData

symbian:{
    TARGET.UID3 =   0xE6E84C35 #0x200389DF #
    VERSION = "1.0.1"
    TARGET.EPOCSTACKSIZE = 0x14000
    TARGET.EPOCHEAPSIZE = 0x200000 0x1800000
    ICON = R2-Touch.svg
    vendorinfo = \
                 "; Localised Vendor name"\
                 "%{\"jamiesun\"}" \
                 " " \
                 "; Unique Vendor name"\
                 ":\"jamiesun\""\
                 " "
    my_deployment.pkg_prerules = vendorinfo
    DEPLOYMENT += my_deployment
}


# Define QMLJSDEBUGGER to allow debugging of QML in debug builds
# (This might significantly increase build time)
# DEFINES += QMLJSDEBUGGER

# If your application uses the Qt Mobility libraries, uncomment
# the following lines and add the respective components to the 
# MOBILITY variable. 
# CONFIG += mobility
# MOBILITY +=

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    networkaccessmanagerfactory.cpp \
    utils.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

HEADERS += \
    networkaccessmanagerfactory.h \
    utils.h

RESOURCES += \
    res.qrc

OTHER_FILES += \
    R2-Touch.svg \
    R2.png \
    screen.png
