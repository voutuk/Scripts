/******************************************************************************
Lab - 9

*******************************************************************************/

#include <iostream>
#include <ctime>
using namespace std;

int main()
{
	srand(time(0));
	const int randA = rand() % 10, randB = rand() % 10, randC = rand() % 10; // Generate rand number PC
	//cout << "Debug: " << randA<< randB << randC<<endl<<endl;
	int tmp = 0, score1 = 0, score2 = 0, count = 0; // Score1 Точне місце / Score2 вгадана цифра
    while (score1 < 3){
        score1 = 0, score2 = 0; // obnulaem rahunok
    	do{
    	cout << "\nEnter number(0-999): ";
    	cin >> tmp;
    	}while (tmp <= -1 || tmp >= 1000); // Perevirka vvedenogo number
    	
    	const int usrA = tmp / 100, usrB = (tmp / 10) % 10, usrC = tmp % 10; // Запис у змінні числа користувача
    	if (usrA == randA) {score1++;}
    	else if (usrA == randB || usrA == usrC) {score2++;}
    	if (usrB == randB) {score1++;}
    	else if (usrB == randA || usrB == usrC) {score2++;}
    	if (usrC == randC) {score1++;}
    	else if (usrC == randB || usrC == usrA) {score2++;}
    	
    	count++; // Плюсуємо спробу
    	cout << "Sproba: " << count << endl << "Corect position: " << score1 << "\nIncorect position: " << score2;
    }
    cout << "\nYou WIN!!! \nSprob: " << count << endl;
    return 0;
}

