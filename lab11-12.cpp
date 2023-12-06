/******************************************************************************
Lab - 11-12

*******************************************************************************/

#include <iostream>
#include <ctime>
using namespace std;

void cout_massive(int a[], int size){
    for (int i =0; i < size; i++){
        cout << "[" << i << "] - " << a[i]<<endl;
    }
}
void swap_min_max(int* a, int size){
    int indMin = 0, indMax = 0, min = a[0], max = a[0];
	for (int i = 1; i < size; i++){
		if (a[i] < min){
			min = a[i];
			indMin = i;
		} if (a[i] > max){
		    max = a[i];
			indMax = i;
		}
	}
	swap(a[indMin], a[indMax]);
}

int* remove_ind(int* arr, int& size, int index){
	size--;
	int* arrNew = new int[size];
	for (size_t i = 0; i < size; i++){
		if (i < index){arrNew[i] = arr[i];}
		else if (i >= index){arrNew[i] = arr[i + 1];}
	}
	delete[] arr;
	return arrNew;
}

int* generate_mas(int size) {
    int* a = new int[size];
    for (int i = 0; i < size; i++) {
        a[i] = rand() % 100;
    }
    return a;
}

int main()
{
	srand(time(0));
	//task1
	/*int sizeA = 9, a[sizeA] = {1};
	for(int i = 0; i < sizeA; i++){ // Заповнюємо масив
        a[i] = a[i-1] + rand() % 10 + 1;
    }
    cout << "Generate num: \n";
    cout_massive(a,9);
    cout << "Swap: \n";
    swap_min_max(a,9);
    cout_massive(a,9);*/
    //task2
    /*int sizeA = 10;
    int* a = new int[sizeA] {6, 5, 3, 4, 5, 6, 7, 7, 9, 1};
    for (int i = 0; i < sizeA - 1; i++) {
        for (int ii = i + 1; ii < sizeA;) {
            if (a[i] == a[ii]) {
                a = remove_ind(a, sizeA, ii);
            } else {ii++;}
        }
    }
    cout_massive(a, sizeA);
    delete[] a;*/
    //task3
    /*cout << "Enter size: ";
    int sizeA;
    cin >> sizeA;
    int* a = generate_mas(sizeA);
    cout_massive(a, sizeA);
    int tmpMax = a[0], indMax = 0;
    for (int i = 1; i < sizeA; i++) {
        if(a[i] > tmpMax) {tmpMax = a[i], indMax = i;}
    }
    cout << "\nMAX" << a[indMax];*/
    //task 4
    /*int* a = new int[15] {1, 1, 2, 4, 5, 9, 14, 22, 37, 54, 87, 90, 111, 243, 345};
    for (int i = 1; i < 15; i++) {
        if(a[i] > 5) {cout << "[" << i << "] - " << a[i]<<endl;}
    }
    int tmp;
    cout << "Enter min number: ";
    cin >> tmp;
    for (int i = 1; i < 15; i++) {
        if(a[i] < tmp) {cout << "[" << i << "] - " << a[i]<<endl;}
    }*/
    return 0;
}

