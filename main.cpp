#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QDebug>
#include <thread>
#include "MySpace.h"
using namespace std;

void Run(WorkingSystem* sys){
    while(sys->GetStatus()) {
		sys->PollEvents();
		sys->OneStepRun();
        emit sys->curTP(sys->getCurTime());
        //system("pause");
        Sleep(2040);
        sys->CurTimePP();
	}
}

int main(int argc, char *argv[]){
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    WorkingSystem sys;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("sys",&sys);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    
    if (engine.rootObjects().isEmpty())
        return -1;
    
    sys.emitInit();
	thread MainTask(Run, &sys);
    MainTask.detach();
    return app.exec();
}
