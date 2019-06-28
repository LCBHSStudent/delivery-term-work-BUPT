#pragma once

#include<iostream>
#include<fstream>
#include<vector>
#include<queue>
#include<iomanip>
#include<iterator>
#include<windows.h>
//#include<unistd.h>
#include<QObject>
#include<QtQml>
using namespace std;
/*
#define SafeDelete(_x)		{ if (_x) { delete (_x); (_x) = NULL; } }
#define SafeDeleteArray(_x)	{ if (_x) { delete [] (_x); (_x) = NULL; } }

template <typename T>
class vector {
public:
	//默认构造函数
	vector() {
		this->length = 0;
		this->maxlength = 10;
		this->data = new T[this->maxlength];
		for (unsigned i = 0; i < this->maxlength; i++)
		{
			this->data[i] = NULL;
		}
	};
	//初始化长度
	vector(unsigned initLength) {
		if (initLength < 5)
		{
			printf("warning: vector init_length must more than 5.\n");
			initLength = 5;
		}
		this->length = 0;
		this->maxlength = initLength;
		this->data = new T[this->maxlength];
		for (unsigned i = 0; i < this->maxlength; i++)
		{
			this->data[i] = NULL;
		}
	};
	//拷贝构造函数
	vector(const vector& v) {
		this->length = v.length;
		this->maxlength = v.maxlength;
		this->data = new T[this->maxlength];
		for (unsigned i = 0; i < this->maxlength; i++)
		{
			this->data[i] = v.data[i];
		}
	};
	~vector() {
		this->length = 0;
		this->maxlength = 0;
		SafeDeleteArray(this->data);
	};
	//插入一个元素到最后
	void push_back(T element) {
		if (this->length >= this->maxlength)
		{
			unsigned i;
			T* dataTemp = new T[this->maxlength * 2];
			for (i = 0; i < this->maxlength; i++)
			{
				dataTemp[i] = this->data[i];
			}
			this->maxlength = this->maxlength * 2;
			for (; i < this->maxlength; i++)
			{
				dataTemp[i] = NULL;
			}
			SafeDeleteArray(this->data);
			this->data = dataTemp;
		}
		this->data[this->length] = element;
		this->length++;
	};
	//清空vector
	void clear() {
		SafeDeleteArray(this->data);
		this->length = 0;
		this->maxlength = 10;
		this->data = new T[this->maxlength];
		for (unsigned i = 0; i < this->maxlength; i++)
		{
			this->data[i] = NULL;
		}
	};
	//获得下标为i的对象
	T get(unsigned i) {
		if (i >= this->length)
		{
			return NULL;
		}
		return this->data[i];
	};
	//设置下标为i的对象，返回原来的对象
	T set(unsigned i, T element) {
		if (i >= this->maxlength)
		{
			unsigned j;
			T* dataTemp = new T[2 * i];
			for (j = 0; j < this->maxlength; j++)
			{
				dataTemp[j] = this->data[j];
			}
			this->maxlength = 2 * i;
			for (; j < this->maxlength; j++)
			{
				dataTemp[j] = NULL;
			}
			SafeDeleteArray(this->data);
			this->data = dataTemp;
		}
		T olddata = this->data[i];
		this->data[i] = element;
		if (this->length < i + 1)
		{
			this->length = i + 1;
		}
		return olddata;
	};
	//获得vector元素个数
	unsigned size() {
		return this->length;
	};
	//重载[]操作符
	T& operator[](unsigned i) {
		if (i >= this->length)
		{
			printf("error: vector is out of vector.\n");
			exit(1);
		}
		return this->data[i];
	};
	//重载=操作符
	vector& operator=(const vector & v) {
		this->length = v.length;
		this->maxlength = v.maxlength;
		SafeDeleteArray(this->data);
		this->data = new T[this->maxlength];
		for (unsigned i = 0; i < this->maxlength; i++)
		{
			this->data[i] = v.data[i];
		}
		return *this;
	};

	bool empty() {
		if (length == 0)
			return false;
		else
			return true;
	}

private:
	T* data;									//存储数据的数组
	unsigned length;							//数组元素
	unsigned maxlength;							//最大可存储空间
};
template<class T> class queue;
template<class T> class item
{
	friend class queue<T>;
private:
	item(const T& val) :value(val), next(0) {} //带有一个参数的构造函数
	item* next;
	T value;

};

template<class T> class queue
{
public:
	queue() :head(0), tail(0), cur_size(0) {}
	~queue()
	{
		destroy();
	}
	T front() { return head->value; }//将头部对象返回
	void push(const T& t);	//将对象加到尾部
	void pop();//将对象从头部移除
	bool empty() const { return head == 0; }
	unsigned int size() { return cur_size; }
private:
	item<T>* head;
	item<T>* tail;
	void destroy();
	unsigned cur_size;
};

template<class T> void queue<T>::push(const T& t){
	item<T>* tmp = new item<T>(t);
	if (empty()){
		head = tail = tmp;
	}
	else{
		tail->next = tmp;
		tail = tmp;
	}
	cur_size++;
}
template<class T> void queue<T>::destroy(){
	while (!empty())
		pop();
}
template<class T> void queue<T>::pop(){
	if (!empty()) {
		item<T>* tmp = head;
		head = head->next;
		//if (tmp != NULL)
		//	delete tmp;
		tmp = NULL;
		//free(tmp);
		cur_size--;
	}
}
*/




