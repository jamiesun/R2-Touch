#include "networkaccessmanagerfactory.h"
#include <QtNetwork>
#include <QDesktopServices>
NetworkAccessManagerFactory::NetworkAccessManagerFactory()
{

}


QNetworkAccessManager* NetworkAccessManagerFactory::create(QObject* parent)
{
    QNetworkAccessManager* manager = new QNetworkAccessManager(parent);
    QNetworkDiskCache* diskCache = new QNetworkDiskCache(parent);
    QString dataPath;
#if defined(Q_OS_SYMBIAN)
    dataPath = QString("E:/.R2/netcache");
#else
    dataPath = QFSFileEngine::homePath()+"/.R2/netcache";
#endif
    QDir().mkpath(dataPath);
    diskCache->setCacheDirectory(dataPath);
    diskCache->setMaximumCacheSize(256*1024*1024);
    manager->setCache(diskCache);
    return manager;
}
