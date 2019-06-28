#pragma once

#include "MyUsing.h"
const int Punishment = -50, StartUp = 1000, RiderCost = 300; //程序用约定常量
const int OnTheWay = 10001;
const int ToRes = 10002;  //状态组
const int GO_LUP = 101, GO_UP = 102, GO_RUP = 103, GO_LEFT = 104, GO_RIGHT = 105,
GO_LDOWN = 106, GO_DOWN = 107, GO_RDOWN = 108;
//行走指令数据化，分为八个方向

static int Map[17][17]; //17*17地图
static int ExOrd;//超时订单数
static int FiOrd;//已完成订单数
static 	ofstream fout("output.txt", ios::out);//全局文件输出流
static int fiOrdA[10] = {0};//当前单位时间内结单容器
static int failOrdA[10] = {0};//当前单位时间超时订单序号容器

struct Pos {
	int x; int y;
	void Print() {
		cout << x << " " << y;
		return;
	}
};

struct Order {
	int Index, Time;
	Pos Res, Det;
	//订单编号 & 下单时间 & 餐馆XY & 目的地XY
	void Print() {
		cout << " 当前订单序号: " << Index << ",下单时间: " << Time << ",餐馆坐标: ";
		Res.Print(); cout << " 目的地坐标: "; Det.Print();
	}
	bool Punished;
	void punish() { Punished = !Punished; }
};

//骑手类
class Rider {
private:
	queue<Order> Urd; //订单队列
	queue<Order> tempUrd; //缓存队列
	Pos CurrentPos; //骑手当前位置
	int Status; //状态
	int CacheTime; //缓冲时间
	int X, Y; //运动控制辅助变量
	char RiDataOut[11];
public:
	//暴露参数
	Pos Det1, Det2; //第一目标地，第二目标地, 第三目的地
	Pos TarCoor; //目标坐标
	vector<Pos> AllResPos;
	vector<Pos> AllDetPos;
	vector<Pos> AllPos;
	//处理型方法
	Pos WhereToRun();
	int LengthTo(Pos P);
	int MissionCheck(int CurTime);
	void Init(Pos prim);
	void Run(const int Operation); //骑手移动Function
	void ProcessOrder(Order Oqs); //处理订单
	void ProcessDet();
	void stringClear() { strcpy_s(RiDataOut, ""); return; }
	void AutoRun(Pos TarCoor);
	bool IsPosCon(Pos Det1, Pos tempDet);

	//Get系方法
	int GetOrderCount();
	Pos GetPos();
	int getStatus();
	bool OrderEmpty();
	Order GetCurOrder();
	//Order GetLaOrder();
	char* GetOutput() { if (strlen(RiDataOut) != 0) return RiDataOut; return nullptr; }
};
//主进程类
class WorkingSystem :public QObject{
    Q_OBJECT
public:
	WorkingSystem(); //初始化
	void PollEvents(); //每隔一个时间单位检测一次状态
	void OneStepRun(); //每一次时间单位改变一次各成员状态
	void CreateNewRider(); //创建新骑手
	void Arrange(); //安排订单
	void PrintMap(); //打印当前地图（第二版，输出示意图+数组内容）
	bool GetStatus() { return Running; } //获取当前是否倒闭
	void GetOrders(); //输入订单 cin时用Ctrl+z
	//void Debug_PrintOrderList(); //订单测试
    void CurTimePP() { CurTime++; }
    void emitInit();
    int getCurTime(){return CurTime;}
signals:
    void newRider();
    void riderMoved(QVariant id, QVariant x, QVariant y);
    void changeToRes(QVariant x, QVariant y);
    void balanceChange(QVariant value);
    void quit();
    void orderAppend(QVariant index, QVariant time, QVariant rx, QVariant ry,
        QVariant dx, QVariant dy);//测试功能
    void ordLoad(QVariant cnt);
    void ordPop(QVariant ordIndex, QVariant id);
    void riderArrivedRes(QVariant id);
    void riderArrivedDet(QVariant id);
    void ridGetOrd(QVariant id, QVariant index_);
    void ordEx(QVariant id, QVariant index_);
    void curTP(QVariant cur);
    void ordPP();
public slots: void appendOrder(int rx, int ry, int dx, int dy){
        Order Oqs = {(int)OrderList.size() + 1, CurTime, {rx, ry}, {dx, dy}, false};
        OrderList.push_back(Oqs);
        emit ordLoad(OrderList.size());
        Arrange();
        return;
    }
    void ctPP() {CurTime++; return;}
private:
	int balance; //当前余额
	bool orderPing;
	Pos PrimPos; //骑手初始位置设定
	vector<Rider> Riders; //储存骑手的数组
	bool Running = true; //系统存活状态
	/*static*/ int CurTime; //当前时间单位
	vector<Order> OrderList; //订单检测列表，用在Pollevent中检测当前时间是否存在订单
	int PolledOrd;//已处理的订单数
};