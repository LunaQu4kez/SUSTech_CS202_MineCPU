#include <bits/stdc++.h>
using namespace std;

void init();
void print_map();
void time_delay();
void stepO();
void stepA();
void stepB();
void stepC();
void stepD();
bool checkover();
void ghost_move();


int game[31][28]; // -1 wall, 0 road, 1 point, 2 pacman, 3 red ghost, 4 pink ghost, 5 blue ghost, 6 orange ghost
int ox, oy;       // pacman x y
int gx[4], gy[4]; // ghost x y: red, pink, blue, orange
int dir;  // direction: 0 up, 1 down, 2 left, 3 right
int st[4];  // step now
int step, score;  
int cnt;  // for time delay
int idx, tx, ty;


int main() {
    while (true) {
        init();
        print_map();

        // if bt1 is pushed, start game
        while (true) {
            if (bt1 is pushed) break;
        }

        while (true) {
            time_delay();
            stepO();
            stepA();
            stepB();
            stepC();
            stepD();
            print_map();
            if (checkover()) {
                break;
            }
        }

        // if bt1 is pushed, end and start a new game
        while (true) {
            if (bt1 is pushed) break;
        }
    }
}

void stepO() {
    // same as play_by_keyboard.cpp
}

void ghost_move() {   // ghost index, target point x, target point y
    // same as play_by_keyboard.cpp
}

void stepA() {
    // same as play_by_keyboard.cpp
}

void stepB() {
    // same as play_by_keyboard.cpp 
}

void stepC() {
    // same as play_by_keyboard.cpp
}

void stepD() {
    // same as play_by_keyboard.cpp
}


bool checkover() {
    // same as play_by_keyboard.cpp
}

void time_delay() {
    while (cnt < 10000000) {
        cnt++;
        if (bt2 is pushed && dir != 1) dir = 0;
        if (bt3 is pushed && dir != 0) dir = 1;
        if (bt4 is pushed && dir != 3) dir = 2;
        if (bt5 is pushed && dir != 2) dir = 3;
    }
    cnt = 0;
}

void print_map() {
    int adio1 = 0xffffe00f;
    int adio2 = 0xffffd00f;
    int adda = 0x10014000;
    for (int i = 0; i < 31; i++) {
        for (int j = 0; j < 28; j++) {
            int ch, co;
            int num = game[i][j];
            if (num == -1) {        // wall
                ch = 32;
                co = 6;
                // sw ch, 0(adio1)
                // sw co, 0(adio2)
                // nop
                // sw ch, 1(adio1)
                // sw co, 1(adio2)
                // nop
            } else if (num == 1) {  // point
                ch = 1;
                co = 7;
                // sw ch, 0(adio1)
                // sw co, 0(adio2)
                // nop
                ch = 2;
                // sw ch, 1(adio1)
                // sw co, 1(adio2)
                // nop
            } else if (num == 2) {  // pacman
                co = 1;
                if (dir == 0) ch = 7;
                else if (dir == 1) ch = 9;
                else if (dir == 2) ch = 6;
                else if (dir == 3) ch = 3;
                // sw ch, 0(adio1)
                // sw co, 0(adio2)
                // nop
                if (dir == 0) ch = 8;
                else if (dir == 1) ch = 10;
                else if (dir == 2) ch = 4;
                else if (dir == 3) ch = 5;
                // sw ch, 1(adio1)
                // sw co, 1(adio2)
                // nop
            } else if (num >= 3) {  // ghost
                ch = 11;
                if (num == 3) co = 2;
                else if (num == 4) co = 3;
                else if (num == 5) co = 5;
                else if (num == 6) co = 4;
                // sw ch, 0(adio1)
                // sw co, 0(adio2)
                // nop
                ch = 12;
                // sw ch, 1(adio1)
                // sw co, 1(adio2)
                // nop
            } else {                       // road
                ch = 32;
                co = 0;
                // sw ch, 0(adio1)
                // sw co, 0(adio2)
                // nop
                // sw ch, 1(adio1)
                // sw co, 1(adio2)
                // nop
            }
            adio1 += 2;
            adio2 += 2;
            adda += 4;
        }
        adio1 += 40;
        adio2 += 40;
    }
}

void init() {
    // same as play_by_keyboard.cpp
}