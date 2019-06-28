#include"MySpace.h"
#include <QFile>
#include <QTextStream>
#include <QString>
//通用函数
double ExDis(Pos a, Pos b) {
	double aX = (double)a.x, aY = (double)a.y, bX = (double)b.x, bY = (double)b.y;
	return sqrt((aX - bX)*(aX - bX) + (aY - bY)*(aY - bY));
}

double ExTime(Pos a, Pos b) {
	return (abs(a.x - b.x) + abs(a.y - b.y)) / 2.0 + 1;
}

Pos ExchangePos(Pos p) {
	return { p.x * 2, p.y * 2 };
}
//废弃，由于输入信息中坐标不需要转换
int Rider::LengthTo(Pos P) { return abs(P.x - CurrentPos.x) + abs(P.y - CurrentPos.y); }
//简易距离获取
////////////
//检测地点是否顺路(nullptr_)
int GetDistance(Pos Det1, Pos Det2) {
	return (abs(Det1.x - Det2.x) + abs(Det1.y - Det2.y));
}
//返回两个地点之间的距离
int FindIndex(vector<Pos> Posvector, Pos element) {
	for (int i = 0; i < (int)Posvector.size(); i++) {
		if (Posvector.at(i).x == element.x && Posvector.at(i).y == element.y)
			return i;
	}
	return 0;
}
//在vector中找到对应Pos元素下标

//Rider组函数
Pos Rider::WhereToRun(){
	Pos Tar;
	int XDeC, XDe2, YDeC, YDe2;

	XDeC = Det1.x - CurrentPos.x;
	XDe2 = Det1.x - Det2.x;
	YDeC = Det1.y - CurrentPos.y;
	YDe2 = Det1.y - Det2.y;

	if (XDeC * XDe2 > 0) {
		if (XDeC > 0) {
			//走到Det1的左侧；
			Tar.x = Det1.x - 1;
			Tar.y = Det1.y;
		}
		else {
			//走到Det1的右侧；
			Tar.x = Det1.x + 1;
			Tar.y = Det1.y;
		}
	}
	else if (YDeC * YDe2 > 0) {
		if (YDeC > 0) {
			//走到Det1的下面；
			Tar.x = Det1.x;
			Tar.y = Det1.y - 1;
		}
		else {
			//走到Det1的上面；
			Tar.x = Det1.x;
			Tar.y = Det1.y + 1;
		}
	}
	else if (XDeC == 0) {
		if (XDe2 > 0) {
			//走到Det1的左侧；
			Tar.x = Det1.x - 1;
			Tar.y = Det1.y;
		}
		if (XDe2 < 0) {
			//走到Det1的右侧；
			Tar.x = Det1.x + 1;
			Tar.y = Det1.y;
		}
		if (XDe2 == 0) {
			Tar.y = Det1.y;
			//走到不为边界的一侧；
			if (Det1.x - 1 > 0) {
				Tar.x = Det1.x - 1;
			}
			else {
				Tar.x = Det1.x + 1;
			}
		}
	}
	else if (XDe2 == 0) {
		if (XDeC > 0) {
			//走到Det1的左侧；
			Tar.x = Det1.x - 1;
			Tar.y = Det1.y;
		}
		if (XDeC < 0) {
			//走到Det1的右侧；
			Tar.x = Det1.x + 1;
			Tar.y = Det1.y;
		}
		if (XDeC == 0) {
			Tar.y = Det1.y;
			//走到不为边界的一侧；
			if (Det1.x - 1 > 0) {
				Tar.x = Det1.x - 1;
			}
			else {
				Tar.x = Det1.x + 1;
			}
		}
	}
	else if (YDeC == 0) {
		if (YDe2 > 0) {
			//走到Det1的下面；
			Tar.x = Det1.x;
			Tar.y = Det1.y - 1;
		}
		if (YDe2 < 0) {
			//走到Det1的上面；
			Tar.x = Det1.x;
			Tar.y = Det1.y + 1;
		}
		if (YDe2 == 0) {
			Tar.x = Det1.x;
			//走到不为边界的一侧；
			if (Det1.y - 1 > 0) {
				Tar.y = Det1.y - 1;
			}
			else {
				Tar.y = Det1.y + 1;
			}
		}
	}
	else if (YDe2 == 0) {
		if (YDeC > 0) {
			//走到Det1的下面；
			Tar.x = Det1.x;
			Tar.y = Det1.y - 1;
		}
		if (YDeC < 0) {
			//走到Det1的上面；
			Tar.x = Det1.x;
			Tar.y = Det1.y + 1;
		}
		if (YDeC == 0) {
			Tar.x = Det1.x;
			//走到不为边界的一侧；
			if (Det1.y - 1 > 0) {
				Tar.y = Det1.y - 1;
			}
			else {
				Tar.y = Det1.y + 1;
			}
		}
	}
	else {
		Tar.x = Det1.x;
		//走到不为边界的一侧；
		if (Det1.y - 1 > 0) {
			Tar.y = Det1.y - 1;
		}
		else {
			Tar.y = Det1.y + 1;
		}
	}
	
	return Tar;
}
//获取最优单步目的地
void Rider::AutoRun(Pos TarCoor)
{
	X = TarCoor.x - CurrentPos.x;
	Y = TarCoor.y - CurrentPos.y;

	if (TarCoor.x % 2 != 0 && CurrentPos.x % 2 != 0) {
		if (X < 0 && Y < 0)
			Run(GO_LUP);
		if (X > 0 && Y < 0)
			Run(GO_RUP);
		if (X == 0 && Y < 0)
			Run(GO_UP);
		if (X < 0 && Y > 0)
			Run(GO_LDOWN);
		if (X > 0 && Y > 0)
			Run(GO_RDOWN);
		if (X == 0 && Y > 0)
			Run(GO_DOWN);
		if (X < 0 && Y == 0) {
			if (CurrentPos.y - 1 > 0)
				Run(GO_LUP);
			else
				Run(GO_LDOWN);
		}
		if (X > 0 && Y == 0) {
			if (CurrentPos.y - 1 > 0)
				Run(GO_RUP);
			else
				Run(GO_RDOWN);
		}
	}
	else if (TarCoor.x % 2 != 0 && CurrentPos.x % 2 == 0) {
		if (X == -1 && Y < 0)
			Run(GO_LUP);
		if (X == 1 && Y < 0)
			Run(GO_RUP);
		if (X == -1 && Y > 0)
			Run(GO_LDOWN);
		if (X == 1 && Y > 0)
			Run(GO_RDOWN);
		if (abs(X) != 1 && X < 0)
			Run(GO_LEFT);
		if (abs(X) != 1 && X > 0)
			Run(GO_RIGHT);
	}
	else if (TarCoor.x % 2 == 0 && CurrentPos.x % 2 != 0) {
		if (abs(X) == 1 && Y < -1)
			Run(GO_UP);
		if (abs(X) == 1 && Y > 1)
			Run(GO_DOWN);
		if (X == -1 && Y == -1)
			Run(GO_LUP);
		if (X == 1 && Y == -1)
			Run(GO_RUP);
		if (X == -1 && Y == 1)
			Run(GO_LDOWN);
		if (X == 1 && Y == 1)
			Run(GO_RDOWN);
		if (abs(X) != 1 && X < 0 && Y < 0)
			Run(GO_LUP);
		if (abs(X) != 1 && X > 0 && Y < 0)
			Run(GO_RUP);
		if (abs(X) != 1 && X < 0 && Y > 0)
			Run(GO_LDOWN);
		if (abs(X) != 1 && X > 0 && Y > 0)
			Run(GO_RDOWN);
	}
	else if (TarCoor.x % 2 == 0 && CurrentPos.x % 2 == 0) {
		if (X == 0 && Y < 0) {
			if (CurrentPos.x - 1 > 0)
				Run(GO_LUP);
			else
				Run(GO_RUP);
		}
		if (X == 0 && Y > 0) {
			if (CurrentPos.x - 1 > 0)
				Run(GO_LDOWN);
			else
				Run(GO_RDOWN);
		}
		if (X == -2 && Y < 0)
			Run(GO_LUP);
		if (X == 2 && Y < 0)
			Run(GO_RUP);
		if (X == -2 && Y > 0)
			Run(GO_LDOWN);
		if (X == 2 && Y > 0)
			Run(GO_RDOWN);
		if (X == -2 && Y == 0)
			Run(GO_LEFT);
		if (X == 2 && Y == 0)
			Run(GO_RIGHT);
		if (X < -2)
			Run(GO_LEFT);
		if (X > 2)
			Run(GO_RIGHT);
	}
}
//有参照的运动
void Rider::Run(const int Operation) {
	//如果妹有其他在这个位置的骑手 改成在PrintMap之前
	Map[CurrentPos.y][CurrentPos.x] = 1;
	switch (Operation) {

	case GO_LUP:
		if (CurrentPos.x > 0 && CurrentPos.y > 0) {
			CurrentPos.x--;
			CurrentPos.y--;
		}
		break;
	case GO_UP:
		if (CurrentPos.x % 2 != 0) {
			CurrentPos.y -= 2;
		}
		break;
	case GO_RUP:
		if (CurrentPos.x < 16 && CurrentPos.y > 0) {
			CurrentPos.x++;
			CurrentPos.y--;
		}
		break;
	case GO_LEFT:
		if (CurrentPos.y % 2 != 0) {
			CurrentPos.x -= 2;
		}
		break;
	case GO_RIGHT:
		if (CurrentPos.y % 2 != 0) {
			CurrentPos.x += 2;
		}
		break;
	case GO_LDOWN:
		if (CurrentPos.x > 0 && CurrentPos.y < 16) {
			CurrentPos.x--;
			CurrentPos.y++;
		}
		break;
	case GO_DOWN:
		if (CurrentPos.x % 2 != 0) {
			CurrentPos.y += 2;
		}
		break;
	case GO_RDOWN:
		if (CurrentPos.x < 16 && CurrentPos.y < 16) {
			CurrentPos.x++;
			CurrentPos.y++;
		}
		break;
	default: break;//此处留空，我要加一个set函数
	}
	//Map[CurrentPos.y][CurrentPos.x] = 3;
	return;
}
//运动
void Rider::ProcessOrder(Order Oqs) {
	Urd.push(Oqs);
	tempUrd.push(Oqs);
	CacheTime = 3;
}
//处理接订单，改变成员变量
void Rider::ProcessDet(){
	Pos temppos;
	
	Det1 = AllPos.at(0);
	if (AllPos.size() < 2) {
		Det2 = AllPos.at(0);
	}
	else {
		Det2 = AllPos.at(1);
	}

	for (unsigned int i = 0; i < AllResPos.size(); i++) {
		if (IsPosCon(Det1, AllResPos.at(i)) && GetDistance(Det1, AllResPos.at(i))) {
			temppos = AllResPos.at(i);
			AllResPos.erase(AllResPos.begin() + FindIndex(AllResPos, temppos));
			AllResPos.insert(AllResPos.begin(), temppos);
			AllPos.erase(AllPos.begin() + FindIndex(AllPos, temppos));
			AllPos.insert(AllPos.begin(), temppos);
			Det2 = Det1;
			Det1 = temppos;
			i = 1;
		}
	}

	if (Status == OnTheWay && GetDistance(Det1, Urd.front().Det))
		Status = ToRes;
}
//处理目的地
void Rider::Init(Pos prim) {
	CurrentPos = prim; Map[prim.y][prim.x] = 3;
	Status = ToRes;
	X = 0; Y = 0;
	strcpy_s(RiDataOut, "");
}

int Rider::MissionCheck(int CurTime) {
	if (!Urd.empty()) {
		if (Status == OnTheWay) {
			Pos P = Urd.front().Det;
			if (CurTime - Urd.front().Time > 30)
				if (!Urd.front().Punished) {
					Urd.front().Punished = true; ExOrd++;
					for (int i = 0; i <= 9; i++) {
						if (failOrdA[i] == 0) {
							failOrdA[i] = Urd.front().Index;
							break;
						}
					}
					return -50;
				}
			if (CurTime - Urd.front().Time > 60) {
				fout << endl << endl << "致死订单编号：" << Urd.front().Index << endl;
				return -114514;
			}

			if (CurrentPos.x == TarCoor.x && CurrentPos.y == TarCoor.y) {
				Map[P.y][P.x] = 0;//到达食客
				if (strlen(RiDataOut) == 0) {
					char type[8] = "食客 ";
					char temp[11] = ""; char space[2] = " ";
					char posx[3] = ""; char posy[3] = "";

					_itoa_s(Urd.front().Det.x, posx, 10);
					_itoa_s(Urd.front().Det.y, posy, 10);
					strcat_s(temp, type); strcat_s(temp, posx);
					strcat_s(temp, space); strcat_s(temp, posy);
					strcpy_s(RiDataOut, temp);
				}
				for (int i = 0; i <= 9; i++) {
					if (fiOrdA[i] == 0) {
						fiOrdA[i] = Urd.front().Index;
						break;
					}
				}
				//Urd.front().Print();
				if (Urd.size() == tempUrd.size())
					tempUrd.pop();
				if (!GetDistance(Urd.front().Det, AllDetPos.at(0)))
					AllDetPos.erase(AllDetPos.begin());
				AllPos.erase(AllPos.begin());
                //emit ordPop(Urd.front().Index);
				Urd.pop();
				if (AllResPos.size() > 0 && !Urd.empty()) {
					if (!GetDistance(Urd.front().Det, AllResPos.at(0))) {
						Status = ToRes;
					}
				}
				FiOrd++;
				return 10;
			}
		}
		else {
			if (CurrentPos.x == TarCoor.x && CurrentPos.y == TarCoor.y) {
				Map[Det1.y][Det1.x] = 0;//到达餐厅
				AllResPos.erase(AllResPos.begin());
				Status = OnTheWay;
				if (strlen(RiDataOut) == 0) {
					char type[8] = "餐馆 ";
					char temp[11] = ""; char space[2] = " ";
					char posx[3] = ""; char posy[3] = "";

					_itoa_s(Urd.front().Res.x, posx, 10);
					_itoa_s(Urd.front().Res.y, posy, 10);
					strcat_s(temp, type); strcat_s(temp, posx);
					strcat_s(temp, space); strcat_s(temp, posy);
					strcpy_s(RiDataOut, temp);
				}
				if (!GetDistance(AllPos.at(0), Urd.front().Det)) {//////////////////////////////
					AllDetPos.erase(AllDetPos.begin());////////////////////////////
					AllPos.erase(AllPos.begin());////////////////////////////
					AllPos.erase(AllPos.begin() + FindIndex(AllPos, Urd.front().Det));///////////////////////
					if (Urd.size() == tempUrd.size())//////////////////////////////////////
						tempUrd.pop();/////////////////////////////
					char type[8] = "餐客 ";
					char temp[11] = ""; char space[2] = " ";
					char posx[3] = ""; char posy[3] = "";

					_itoa_s(Urd.front().Res.x, posx, 10);
					_itoa_s(Urd.front().Res.y, posy, 10);
					strcat_s(temp, type); strcat_s(temp, posx);
					strcat_s(temp, space); strcat_s(temp, posy);
					strcpy_s(RiDataOut, temp);
					Urd.pop();//////////////////
					FiOrd++;/////////////////
					return 10;////////////////
					
				}
				AllPos.erase(AllPos.begin());
                return 114;//到达餐馆
			}
		}
	}//处理骑手是否到达餐厅/是否按时送餐到达目的地
	return 0;
}
//检查任务完成情况

bool Rider::IsPosCon(Pos Det1, Pos tempDet) {
	if ((tempDet.x - CurrentPos.x) * (tempDet.x - Det1.x) <= 0 && (tempDet.y - CurrentPos.y) * (tempDet.y - Det1.y) <= 0)
		return true;
	return false;
}
//Rider's Get系方法
int Rider::GetOrderCount() { return (int)Urd.size(); }
Pos Rider::GetPos() { return CurrentPos; }
int Rider::getStatus() { return Status; }
bool Rider::OrderEmpty() { return Urd.empty(); }
Order Rider::GetCurOrder() { /*if (!Urd.empty())*/ return Urd.front(); }
//Order Rider::GetLaOrder() {	return; } //Urd.back(); }

//WorkingSystem
void WorkingSystem::PrintMap() {
	system("cls");
	for (int i = 0; i <= 16; i++) {
		if (i % 2 == 0) {
			for (int n = 0; n <= 3; n++) {
				for (int j = 0; j <= 16; j++) {
					if (j % 2 == 0) {
						if (n == 0) {
							cout << "__________";
						}
						if (n == 1) {
							cout << "|        |";
						}
						if (n == 2) {
							cout << "|  ";
							if (Map[i][j] == 1) {
								cout << "    ";
							}
							if (Map[i][j] == 2) {
								cout << "餐厅";
							}
							if (Map[i][j] == 0) {
								cout << "    ";
							}
							if (Map[i][j] == 9) {
								cout << "住户";
							}
							cout << "  |";
						}
						if (n == 3) {
							cout << "|________|";
						}
					}
					else {
						if (n == 2) {
							if (Map[i][j] == 1) {
								cout << "    ";
							}
							if (Map[i][j] == 3) {
								cout << "骑手";
							}
						}
						else {
							cout << "    ";
						}
					}
				}
				cout << endl;
			}
		}
		else {
			for (int j = 0; j <= 16; j++) {
				if (j % 2 == 0) {
					cout << "   ";
					if (Map[i][j] == 1) {
						cout << "    ";
					}
					if (Map[i][j] == 3) {
						cout << "骑手";
					}
					cout << "   ";
				}
				else {
					cout << "    ";
				}
			}
			cout << "\n";
		}
	}
	//cout << "当前时间 T = " << CurTime + 1 << "   余额：" << balance << endl;
	//cout << "已接单数：" << PolledOrd << "	已完成订单数：" << FiOrd << "	超时的订单数：" << ExOrd << endl;
	cout << "当前时间：" << CurTime + 1 << endl << "余额：" << balance << endl;
	cout << "已接单数：" << PolledOrd << endl << "已完成订单数：" << FiOrd << "  结单：";
	fout << "当前时间：" << CurTime + 1 << endl << "余额：" << balance << endl;
	fout << "已接单数：" << PolledOrd << endl << "已完成订单数：" << FiOrd << "  结单：";
	for (unsigned int i = 0; i < Riders.size(); i++)
		if (fiOrdA[i] != 0) {
			fout << fiOrdA[i] << "  ";
			cout << fiOrdA[i] << "  ";
		}
	fout << endl << "超时单数：" << ExOrd << "  罚单：";
	cout << endl << "超时单数：" << ExOrd << "  罚单：";
	for (unsigned int i = 0; i < Riders.size(); i++)
		if (failOrdA[i] != 0) {
			fout << failOrdA[i] << "  ";
			cout << failOrdA[i] << "  ";
		}
	fout << endl;
	cout << endl;
	for (unsigned int i = 0; i < Riders.size(); i++) {
		fout << "骑手" << i << "位置：" << Riders.at(i).GetPos().x << " " << Riders.at(i).GetPos().y;
		fout << " 停靠：";
		cout << "骑手" << i << "位置：" << Riders.at(i).GetPos().x << " " << Riders.at(i).GetPos().y;
		cout << " 停靠：";
		char *str = Riders.at(i).GetOutput();
		if (str != nullptr) {
			fout << str << endl;
			cout << str << endl;
		}
		else {
			fout << endl;
			cout << endl;
		}
	}
	fout << endl;

	/*for (unsigned int i = 0; i < Riders.size(); i++) {
		//cout << "骑手" << i;
		if (Riders.at(i).getStatus() == OnTheWay)
			cout << "骑手" << i << " 送餐中.. ";
		else if (!Riders.at(i).OrderEmpty())
			cout << "骑手" << i << " 取餐中.. ";
		if (!Riders.at(i).OrderEmpty()) {
			Order ord = Riders.at(i).GetCurOrder();
			ord.Print();
		}
		else cout << "骑手" << i << " 当前无订单 ";
		Pos posR = Riders.at(i).GetPos();
		cout << " 当前位置: "; posR.Print(); cout << endl;
	}*/
	//system("pause");
	if (FiOrd == OrderList.size()) Running = false;
	//终止条件
	CurTime++;
	//Sleep(200);
}
//打印地图
WorkingSystem::WorkingSystem() {
	PolledOrd = 0;
	ExOrd = 0;
	FiOrd = 0;
	orderPing = true;
	balance = StartUp; //资金初始化
	PrimPos = { 8,9 }; //GetPrimPos(); //设定初始位置
	CurTime = 0;
	bool pd = true;
	for (int i = 0; i <= 16; i++) {
		pd = true;
		for (int j = 0; j <= 16; j++) {
			if (i % 2 != 0) Map[i][j] = 1;
			else {
				Map[i][j] = pd ? 0 : 1;
				pd = !pd;
			}
		}
	}//地图初始化，其中房屋为0，道路为1, 餐厅为2， 骑手为3
	//GetOrders(); //初始化地图后一次性读取订单
    //ordIt = OrderList.begin();
}
//初始化
void WorkingSystem::PollEvents() {

	//if (Riders.empty()) CreateNewRider();  //此为只创建一个骑手的版本
	//for each rider use MissionCheck()
	while (balance >= RiderCost) {
		CreateNewRider();
	}

	if (balance < 0) { Running = false; return; }
	return;
}
//状态检测
void WorkingSystem::OneStepRun() {
	int x, y;
	memset(fiOrdA, 0, 10);
	memset(failOrdA, 0, 10);
	//Arrange();
	for (unsigned int i = 0; i < Riders.size(); i++) {
		Riders.at(i).stringClear();
		if (!Riders.at(i).OrderEmpty()) {
			Riders.at(i).ProcessDet();
			Riders.at(i).TarCoor = Riders.at(i).WhereToRun();
			Riders.at(i).AutoRun(Riders.at(i).TarCoor);
            emit riderMoved(i, Riders.at(i).GetPos().x, Riders.at(i).GetPos().y);
		}
	}

	for (unsigned int i = 0; i < Riders.size(); i++) {
        if (!Riders.at(i).OrderEmpty()){ //如果此骑手的订单不为空
            int index_ = Riders.at(i).GetCurOrder().Index;//用来发送pop信号
			int val = Riders.at(i).MissionCheck(CurTime);//注意防止重复
            switch (val) {
            case 10: emit riderArrivedDet(i); balance += val; emit ordPP(); emit ordPop(index_, i); break;
            case -50: emit ordEx(i, Riders.at(i).GetCurOrder().Index); balance += val; break;
            case 114: emit riderArrivedRes(i); break;
            case -114514: balance += val; emit quit(); break;
            default: break;
            }
            emit balanceChange(balance);
        }
	}

	for (unsigned int i = 0; i < Riders.size(); i++) {
		Pos P = Riders.at(i).GetPos();
		Map[P.y][P.x] = 3;
		for (unsigned int j = 0; j < Riders.at(i).AllResPos.size(); j++) {
			x = Riders.at(i).AllResPos.at(j).x;
			y = Riders.at(i).AllResPos.at(j).y;
			Map[y][x] = 2;
		}
		for (unsigned int j = 0; j < Riders.at(i).AllDetPos.size(); j++) {
			x = Riders.at(i).AllDetPos.at(j).x;
			y = Riders.at(i).AllDetPos.at(j).y;
			Map[y][x] = 9;
		}
	}
	
    
    fout << "当前时间：" << CurTime + 1 << endl << "余额：" << balance << endl;
	fout << "已接单数：" << PolledOrd << endl << "已完成订单数：" << FiOrd << "  结单：";
	for (unsigned int i = 0; i < Riders.size(); i++)
		if (fiOrdA[i] != 0) {
			fout << fiOrdA[i] << "  ";
		}
	fout << endl << "超时单数：" << ExOrd << "  罚单：";
	for (unsigned int i = 0; i < Riders.size(); i++)
		if (failOrdA[i] != 0) {
			fout << failOrdA[i] << "  ";
		}
	fout << endl;
	for (unsigned int i = 0; i < Riders.size(); i++) {
		fout << "骑手" << i << "位置：" << Riders.at(i).GetPos().x << " " << Riders.at(i).GetPos().y;
		fout << " 停靠：";
		char *str = Riders.at(i).GetOutput();
		if (str != nullptr) {
			fout << str << endl;
		}
		else {
			fout << endl;
		}
	}
	fout << endl;
    
    return;
}
//单步运行改变状态，文件打印扔在这里和MissionCheck里
void WorkingSystem::CreateNewRider() {
	balance -= RiderCost;
	Rider NewRider;
	NewRider.Init(PrimPos);
	Riders.push_back(NewRider);
    emit newRider();
    emit balanceChange(balance);
	//要不要添加骑手类型？
	//delete  OR ~?
	return;
}
//创建新骑手

//取餐之后之后Status/TOdet，若有新订单判断可接后在改变为Tores状态
void WorkingSystem::Arrange() {
	int index;
	int min, tempmin;

	//while (orderPing && CurTime == OrderList.at(PolledOrd).Time) {//可添加记录推迟时间的成员变量！
		index = Riders.size() - 1;
		min = 0;
		tempmin = 0;
		Order Oqs = OrderList.at(PolledOrd);
		Rider tempRider;

		tempRider = Riders.at(index);
		if (tempRider.OrderEmpty()) {
			min = GetDistance(tempRider.GetPos(), Oqs.Res);
		}
		else {
			//正常配单
			
			min = GetDistance(tempRider.GetPos(), tempRider.AllPos.at(0));
			for (unsigned int i = 0; i < tempRider.AllPos.size() - 1; i++) {
				min += GetDistance(tempRider.AllPos.at(i), tempRider.AllPos.at(i + 1));
			}
			if (tempRider.IsPosCon(tempRider.Det1, Oqs.Res)) {
				min += GetDistance(tempRider.AllPos.at(tempRider.AllPos.size() - 1), Oqs.Det);
			}
			else {
				min += GetDistance(Oqs.Res, Oqs.Det);
			}
			
			
			//玄学配单
            /*
			if (tempRider.IsPosCon(tempRider.Det1, Oqs.Res)) {
				min = GetDistance(tempRider.GetPos(), Oqs.Res) + GetDistance(Oqs.Res, tempRider.AllPos.at(0));
				for (unsigned int i = 0; i < tempRider.AllPos.size() - 1; i++) {
					min += GetDistance(tempRider.AllPos.at(i), tempRider.AllPos.at(i + 1));
				}
				min += GetDistance(tempRider.AllPos.at(tempRider.AllPos.size() - 1), Oqs.Det);
			}
			else {
				min = GetDistance(Oqs.Res, tempRider.AllPos.at(0));
				for (unsigned int i = 0; i < tempRider.AllPos.size() - 1; i++) {
					min += GetDistance(tempRider.AllPos.at(i), tempRider.AllPos.at(i + 1));
				}
				min += GetDistance(tempRider.AllPos.at(tempRider.AllPos.size() - 1), Oqs.Res);
				min += GetDistance(Oqs.Res, Oqs.Det);
			}
			*/
		}

		for (int i = Riders.size() - 2; i >= 0; i--) {
			tempRider = Riders.at(i);
			if (tempRider.OrderEmpty()) {
				tempmin = GetDistance(tempRider.GetPos(), Oqs.Res);
			}
			else {

				//正常配单
				
				tempmin = GetDistance(tempRider.GetPos(), tempRider.AllPos.at(0));
				for (unsigned int j = 0; j < tempRider.AllPos.size() - 1; j++) {
					tempmin += GetDistance(tempRider.AllPos.at(j), tempRider.AllPos.at(j + 1));
				}
				if (tempRider.IsPosCon(tempRider.Det1, Oqs.Res)) {
					tempmin += GetDistance(tempRider.AllPos.at(tempRider.AllPos.size() - 1), Oqs.Det);
				}
				else {
					tempmin += GetDistance(Oqs.Res, Oqs.Det);
				}
				
				
				//玄学配单
                /*
				if (tempRider.IsPosCon(tempRider.Det1, Oqs.Res)) {
					tempmin = GetDistance(tempRider.GetPos(), Oqs.Res) + GetDistance(Oqs.Res, tempRider.AllPos.at(0));
					for (unsigned int j = 0; j < tempRider.AllPos.size() - 1; j++) {
						tempmin += GetDistance(tempRider.AllPos.at(j), tempRider.AllPos.at(j + 1));
					}
					tempmin += GetDistance(tempRider.AllPos.at(tempRider.AllPos.size() - 1), Oqs.Det);
				}
				else {
					tempmin = GetDistance(Oqs.Res, tempRider.AllPos.at(0));
					for (unsigned int j = 0; j < tempRider.AllPos.size() - 1; j++) {
						tempmin += GetDistance(tempRider.AllPos.at(j), tempRider.AllPos.at(j + 1));
					}
					tempmin += GetDistance(tempRider.AllPos.at(tempRider.AllPos.size() - 1), Oqs.Res);
					tempmin += GetDistance(Oqs.Res, Oqs.Det);
				}*/
				
			}
			if (tempmin < min) {
				min = tempmin;
				index = i;
			}
		}
		Riders.at(index).AllResPos.push_back(Oqs.Res);
		Riders.at(index).AllDetPos.push_back(Oqs.Det);
		Riders.at(index).AllPos.push_back(Oqs.Res);
		Riders.at(index).AllPos.push_back(Oqs.Det);
		Riders.at(index).ProcessOrder(OrderList.at(PolledOrd));
		emit orderAppend(Oqs.Index, Oqs.Time, Oqs.Res.x, Oqs.Res.y, Oqs.Det.x, Oqs.Det.y);
        emit ridGetOrd(index, OrderList.at(PolledOrd).Index);
		//if (PolledOrd == OrderList.size() - 1)
		//	orderPing = false;
		PolledOrd++;
	//}
	return;
}

void WorkingSystem::GetOrders() {
    int Index = 0, Time = 0;
	Pos Res_Pos, Det_Pos;
	Order order;
    QFile file(":/Texts/sales.txt");
	if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        while(!file.atEnd()){
            QString line = file.readLine();
            QStringList sections = line.split(" "); 
            for(int i = 0; i <= 5; i++){
                switch(i){
                case 0: Index = sections.at(0).trimmed().toInt(); break;
                case 1: Time = sections.at(1).trimmed().toInt(); break;
                case 2: Res_Pos.x = sections.at(2).trimmed().toInt(); break;
                case 3: Res_Pos.y = sections.at(3).trimmed().toInt(); break;
                case 4: Det_Pos.x = sections.at(4).trimmed().toInt(); break;
                case 5: Det_Pos.y = sections.at(5).trimmed().toInt(); break;
                default: break;
                }
            }
            order = { Index, Time, Res_Pos, Det_Pos, false };
			OrderList.push_back(order);
        }
        cout<<endl<<"File Loaded."<<endl;
	}
	else {
		while (cin >> Index >> Time >> Res_Pos.x >> Res_Pos.y >> Det_Pos.x >> Det_Pos.y) {
			order = { Index, Time, Res_Pos, Det_Pos, false };
			Pos ItMap = Res_Pos;//ExchangePos(Res_Pos);
			Map[ItMap.y][ItMap.x] = 2;
			OrderList.push_back(order);
		}
	}
	return;
}

void WorkingSystem::emitInit(){
    emit ordLoad(OrderList.size());
    //for(int i = 0; i < OrderList.size(); i++){
    //    emit changeToRes(OrderList.at(i).Res.x, OrderList.at(i).Res.x);
    //}
}
//OneStepRun    GetOrders   