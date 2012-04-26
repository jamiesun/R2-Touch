#include "utils.h"
#include <QFSFileEngine>
#include <QDir>
#include <QFile>
#include <QTextStream>
#include <QDataStream>
#include <QDateTime>
#include <QDebug>
Utils::Utils(QObject *parent) :
    QObject(parent)
{
    settings = new QSettings(getPath()+"settings.conf",QSettings::IniFormat);
    if(!settings->contains("std_font"))
    {
        settings->setValue("std_font",QVariant::fromValue(8));
        settings->sync();
    }

    if(!settings->contains("tiny_font"))
    {
        settings->setValue("tiny_font",QVariant::fromValue(7));
        settings->sync();
    }
}


QString Utils::decrypt(const QString &txt)
{
    QString result = txt;

    int len = result.length();
    for(int i=0;i<len;++i)
    {
       result[i] = QChar::fromAscii(result[i].toAscii() + 1);
    }
    return result;

}

QString Utils::encrypt(const QString &txt)
{
    QString dest = txt;
    int len = dest.length();
    for(int i=0;i<len;++i)
    {
       dest[i] = QChar::fromAscii(dest[i].toAscii() - 1);
    }
    return dest;
}



QString Utils::getCache(const QString &name)
{
    QString path = getPath()+name;
    if(!QFile::exists(path))
        return "";

    QString cache;
    QFile file(path);
    file.open(QIODevice::ReadOnly);
    QDataStream in(&file);
    in.setVersion(QDataStream::Qt_4_7);
    in>>cache;
    file.close();
    return cache;
}


void Utils::setCache(const QString &name,const QString &value)
{
    QString path = getPath()+name;
    QFile file(path);
    file.open(QIODevice::WriteOnly);
    QDataStream out(&file);
    out.setVersion(QDataStream::Qt_4_7);
    out<<value;
    file.flush();
    file.close();
}


QString Utils::getPath()
{
    QString path;
#if defined(Q_OS_SYMBIAN)
    path = QString("E:/.R2/");
#else
    path = QFSFileEngine::homePath()+"/.R2/";
#endif
    QDir dir(path);
    if(!dir.exists(path))
    {
        dir.mkdir(path);
    }
    return path;
}

void Utils::setConfig(const QString &k, const QVariant &v)
{
    settings->setValue(k,v);
}

QVariant Utils::getConfig(const QString &k)
{
    return settings->value(k);
}

void Utils::syncConfig()
{
    settings->sync();
}

QString Utils::uuid()
{
    return QUuid::createUuid().toString();
}

QString Utils::base64Encode(const QString &value)
{
    return value.toLocal8Bit().toBase64();
}

Utils::~Utils()
{
    delete settings;
}
