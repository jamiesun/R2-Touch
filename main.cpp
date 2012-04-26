#include <QtGui/QApplication>
#include <QDeclarativeEngine>
#include <QDeclarativeContext>
#include <QDeclarativeComponent>
#include <QWebSettings>
#include "qmlapplicationviewer.h"
#include "utils.h"
#include "networkaccessmanagerfactory.h"
#include <QAbstractNetworkCache>
#include <QUrl>
#include <QPixmap>
#include <QSplashScreen>
int main(int argc, char *argv[])
{
    QApplication::setAttribute(Qt::AA_S60DontConstructApplicationPanes);
    QApplication app(argc, argv);
    QPixmap pixmap(QLatin1String(":/screen.png"));
    QSplashScreen splash(pixmap);
    splash.showFullScreen();
    //splash.showMessage("Wait...");
    app.processEvents();

#if defined(Q_OS_LINUX)
    app.setFont(QFont("微软雅黑"));
#endif
    QWebSettings::globalSettings()->setObjectCacheCapacities(1024*1024, 1024*1024, 1024*1024);
    QWebSettings::globalSettings()->setMaximumPagesInCache(10);
    QWebSettings::globalSettings()->setUserStyleSheetUrl(QUrl::fromLocalFile("qml/R2-Touch/style.css"));
    QmlApplicationViewer viewer;
    NetworkAccessManagerFactory factory;
    Utils utils;
    //viewer.engine()->setOfflineStoragePath(utils.getPath());
    viewer.engine()->setNetworkAccessManagerFactory(&factory);
    viewer.rootContext()->setContextProperty("utils",&utils);
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/R2-Touch/main.qml"));
    viewer.showFullScreen();
    splash.finish(&viewer);
    return app.exec();
}
