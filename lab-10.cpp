/******************************************************************************
Lab - 10
task1 - Напишіть програму, яка перевіряє, чи знаходиться введене з клавіатури число в масиві. Масив попередньо вводить користувач на початку виконання програми.

*******************************************************************************/

#include <iostream>
#include <ctime>
using namespace std;

int main()
{
    //task 1
    /*int lenght_a;
    cout << "Enter length:";
    cin >> lenght_a;
    double a[lenght_a] = {}; // Create masiv
    for(int i = 0; i < lenght_a; i++){ //Enter masiv
        cout << "Enter double[" << i+1 << "]: ";
        cin >> a[i];
    }
    while(true){ // Find masiv
        int tmp;
        cout << "Enter find num: ";
        cin >> tmp;
        for(int i = 0; i < lenght_a; i++){
            if(a[i] == tmp){
                cout << "FIND!!! [" << i+1 << "]" << endl;
            }
        }
    }*/
    //task2
    /*cout << "Enter number: ";
    int num, length = 0;
    cin >> num;
    int tmp3 = num;
    while ((num/=10) > 0) length++;
    int a[length] {};
    
    for (int i = length; i >= 0; i--) { //Enter masive
        a[i] = tmp3 % 10;
        tmp3 /= 10;
    }
    
    int start = 0, end = length;
    while (start < end) { // Revers masive
        swap(a[start], a[end]);
        start++;
        end--;
    }
	
	for(int i = 0; i < length+1; i++){ //cout masive
        cout << "Masive[" << i+1 << "]: " << a[i] << endl;
    }*/
    //task3
	/*srand(time(0));
	const int size = 10;
    int a[size], b[size], c[size*2];
    int tmp = 0, tmp2 = 1;
    for (int i = 0; i < size; ++i){ // create 2 masive
        tmp += rand() % 10;
        a[i] = tmp;
        tmp2 += rand() % 10;
        b[i] = tmp2;
        cout << a[i] << " - " << b[i] << endl;
    }
    for (int i = 0; i < size; ++i) { c[i] = a[i]; }           //Обєднання масивів
    for (int i = 0; i < size*2; ++i) { c[size + i] = b[i]; }
    
    for(int step = 0; step < (size*2)-1; ++step){ //Bubble sort
        for (int i = 0; i < (size*2)-1; i++){
    		    if (c[i] > c[i+1]){ // UP / DOWN 
                swap(c[i], c[i+1]);
            } 
        }
        //Output step
        //cout << "-------------------"  << endl;
        //for (int i = 0; i < size*2; ++i){
        //    cout << c[i] << endl;
        //}
    }
    
    for(int i = 0; i < (size*2); i++){ //cout masive
        cout << "Masive[" << i+1 << "]: " << c[i] << endl;
    }*/
    return 0;
}

