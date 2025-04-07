#include<iostream>

using namespace std;

int main(){
    unsigned int x =  0x87654321;

    unsigned short low = x & 0x0000FFFF;
    unsigned short high = (x & 0xFFFF0000) >> 16;

    cout << hex << low << endl;
    cout << hex << high << endl;
}