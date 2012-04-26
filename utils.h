#ifndef UTILS_H
#define UTILS_H

#include <QObject>
#include <QSettings>
#include <QtCore/QUuid>
class Utils : public QObject
{
    Q_OBJECT
public:
    explicit Utils(QObject *parent = 0);
    ~Utils();
    Q_INVOKABLE QString decrypt(const QString &txt);
    Q_INVOKABLE QString encrypt(const QString &txt);
    Q_INVOKABLE QString getCache(const QString &key);
    Q_INVOKABLE void setCache(const QString  &key,const QString &value);
    Q_INVOKABLE QString getPath();
    Q_INVOKABLE void setConfig(const QString &k,const QVariant &v);
    Q_INVOKABLE QVariant getConfig(const QString &k);
    Q_INVOKABLE void syncConfig();
    Q_INVOKABLE QString uuid();
    Q_INVOKABLE QString base64Encode(const QString &value);
signals:

public slots:

private:
    QSettings *settings;

};

#endif // UTILS_H
