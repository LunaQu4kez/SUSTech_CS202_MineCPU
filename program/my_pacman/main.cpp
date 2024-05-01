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
void ghost_move(int, int, int);
int bfs(int, int, int);


int game[31][28]; // -1 wall, 0 road, 1 point, 2 pacman, 3 red ghost, 4 pink ghost, 5 blue ghost, 6 orange ghost
int ox, oy;       // pacman x y
int gx[4], gy[4]; // ghost x y: red, pink, blue, orange
int dir;  // direction: 0 up, 1 down, 2 left, 3 right
int st[4];  // step now
int step, score;  
int cnt;  // for time delay
int bx[300], by[300], bh[300], bxt[300], byt[300], bht[300];  // t: temp, x,y: x,y, h: head
int bmap[31][28];
int bi, bit;  // bfs index
int wx, wy;


int main() {
    //while (true) {
        init();
        print_map();
        // if bt1 is pushed, start game
        // while (true) {
        //     if (bt1 is pushed) break;
        // }

        while (true) {
            ///******  for test  ******
            int t;
            cin >> t;
            if (t == 8) dir = 0;
            if (t == 5) dir = 1;
            if (t == 4) dir = 2;
            if (t == 6) dir = 3;
            // ******  for test  ******/
            time_delay();
            stepO();
            stepA();
            stepB();
            stepC();
            stepD();
            print_map();
            if (checkover()) {
                printf("*******************\n");
                printf("*******CAUGHT******\n");
                printf("*******************\n");
                break;
            }
        }

        // if bt1 is pushed, end and start a new game
        // while (true) {
        //     if (bt1 is pushed) break;
        // }
    //}
}

void stepO() {
    step++;
    printf("ox oy: %d %d\n", ox, oy);
    if (dir == 0) {   // up
        if (game[ox - 1][oy] != -1) {
            game[ox][oy] = 0;
            ox--;
            if (game[ox][oy] == 1) score++;
            game[ox][oy] = 2;
        }
    }
    if (dir == 1) {   // down
        if (game[ox + 1][oy] != -1) {
            game[ox][oy] = 0;
            ox++;
            if (game[ox][oy] == 1) score++;
            game[ox][oy] = 2;
        }
    }
    if (dir == 2) {   // left
        if (game[ox][oy - 1] != -1) {
            game[ox][oy] = 0;
            oy--;
            if (game[ox][oy] == 1) score++;
            game[ox][oy] = 2;
        }
    }
    if (dir == 3) {   // right
        if (game[ox][oy + 1] != -1) {
            game[ox][oy] = 0;
            oy++;
            if (game[ox][oy] == 1) score++;
            game[ox][oy] = 2;
        }
    }
}

void ghost_move(int idx, int tx, int ty) {   // ghost index, target point x, target point y
    printf("%d target %d %d\n", idx, tx, ty);
    printf("%d pos %d %d\n", idx, gx[idx], gy[idx]);
    printf("wx wy: %d %d\n", wx, wy);

    if (gx[idx] == tx && gy[idx] == ty) {
        game[tx][ty] = idx + 3;
        return;
    }

    cnt = 0;
    while (cnt < 300) {
        bxt[cnt] = 0;
        byt[cnt] = 0;
        bht[cnt] = 0;
        cnt++;
    }
    cnt = 0;
    int x = gx[idx];
    int y = gy[idx];
    for (int i = 0; i < 31; i++) {
        for (int j = 0; j < 28; j++) {
            bmap[i][j] = 0;
        }
    }
    bmap[x][y] = 1;
    if (idx == 1 || idx == 2) {
        bmap[wx][wy] = 1;
    }
    
    bit = 0;
    if (game[x-1][y] != -1 && bmap[x-1][y] != 1) {  // up
        if (x - 1 == tx && y == ty) {
            gx[idx] = tx;
            gy[idx] = ty;
            game[x][y] = st[idx];
            return;
        }
        bxt[bit] = x - 1;
        byt[bit] = y;
        bht[bit] = 0;
        bmap[x-1][y] = 1;
        bit++;
    }
    if (game[x+1][y] != -1 && bmap[x+1][y] != 1) {  // down
        if (x + 1 == tx && y == ty) {
            gx[idx] = tx;
            gy[idx] = ty;
            game[x][y] = st[idx];
            return;
        }
        bxt[bit] = x + 1;
        byt[bit] = y;
        bht[bit] = 1;
        bmap[x+1][y] = 1;
        bit++;
    }
    if (game[x][y-1] != -1 && bmap[x][y-1] != 1) {  // left
        if (x == tx && y - 1 == ty) {
            gx[idx] = tx;
            gy[idx] = ty;
            game[x][y] = st[idx];
            return;
        }
        bxt[bit] = x;
        byt[bit] = y - 1;
        bht[bit] = 2;
        bmap[x][y-1] = 1;
        bit++;
    }
    if (game[x][y+1] != -1 && bmap[x][y+1] != 1) {  // right
        if (x == tx && y + 1 == ty) {
            gx[idx] = tx;
            gy[idx] = ty;
            game[x][y] = st[idx];
            return;
        }
        bxt[bit] = x;
        byt[bit] = y + 1;
        bht[bit] = 3;
        bmap[x][y+1] = 1;
        bit++;
    }
    bit = 0;
    int d = bfs(idx, tx, ty);

    game[x][y] = st[idx];
    if (d == 0) {   // move up
        printf("%d move up\n", idx);
        x--;
        gx[idx]--;
    }
    if (d == 1) {   // move down
        printf("%d move down\n", idx);
        x++;
        gx[idx]++;
    }
    if (d == 2) {   // move left
        printf("%d move left\n", idx);
        y--;
        gy[idx]--;
    }
    if (d == 3) {   // move right
        printf("%d move right\n", idx);
        y++;
        gy[idx]++;
    }
    st[idx] = game[x][y];
    if (st[idx] == 2) st[idx] = 0;
    if (st[idx] == 3) st[idx] = st[0];
    if (st[idx] == 4) st[idx] = st[1];
    if (st[idx] == 5) st[idx] = st[2];
    if (st[idx] == 6) st[idx] = st[3];
    // game[x][y] = idx + 3;
}

int bfs(int idx, int tx, int ty) {
    cnt = 0;
    while (cnt < 300) {
        bx[cnt] = bxt[cnt];
        by[cnt] = byt[cnt];
        bh[cnt] = bht[cnt];
        cnt++;
    }
    cnt = 0;
    while (cnt < 300) {
        bxt[cnt] = 0;
        byt[cnt] = 0;
        bht[cnt] = 0;
        cnt++;
    }
    cnt = 0;
    bi = 0;
    bit = 0;

    int x = bx[bi];
    int y = by[bi];
    int h = bh[bi];
    while (x != 0 || y != 0) {
        if (game[x-1][y] != -1 && bmap[x-1][y] == 0) {  // up
            if (x - 1 == tx && y == ty) {
                if (idx == 0) {
                    wx = x;
                    wy = y;
                }
                return h;
            }
            bxt[bit] = x - 1;
            byt[bit] = y;
            bht[bit] = h;
            bmap[x-1][y] = 1;
            bit++;
        }
        if (game[x+1][y] != -1 && bmap[x+1][y] == 0) {  // down
            if (x + 1 == tx && y == ty) {
                if (idx == 0) {
                    wx = x;
                    wy = y;
                }
                return h;
            }
            bxt[bit] = x + 1;
            byt[bit] = y;
            bht[bit] = h;
            bmap[x+1][y] = 1;
            bit++;
        }
        if (game[x][y-1] != -1 && bmap[x][y-1] == 0) {  // left
            if (x == tx && y - 1 == ty) {
                if (idx == 0) {
                    wx = x;
                    wy = y;
                }
                return h;
            }
            bxt[bit] = x;
            byt[bit] = y - 1;
            bht[bit] = h;
            bmap[x][y-1] = 1;
            bit++;
        }
        if (game[x][y+1] != -1 && bmap[x][y+1] == 0) {  // right
            if (x == tx && y + 1 == ty) {
                if (idx == 0) {
                    wx = x;
                    wy = y;
                }
                return h;
            }
            bxt[bit] = x;
            byt[bit] = y + 1;
            bht[bit] = h;
            bmap[x][y+1] = 1;
            bit++;
        }
        bi++;
        x = bx[bi];
        y = by[bi];
        h = bh[bi];
    }
    return bfs(idx, tx, ty);
}

void stepA() {
    ghost_move(0, ox, oy);
}

void stepB() {
    int bx = gx[1];
    int by = gy[1];
    if(abs(bx - ox) + abs(by - oy) <= 2 && (bx != wx || by != wy)) {
        ghost_move(1, ox, oy);
        return;
    }
    if (dir == 0) {
        cnt = 2;
        while (cnt >= 0) {
            if (ox - cnt >= 0 && game[ox-cnt][oy] != -1 && bmap[ox-cnt][oy] != 1) {
                ghost_move(1, ox-cnt, oy);
                cnt = 0;
                break;
            }
            cnt--;
        }
    } 
    if (dir == 1) {
        cnt = 2;
        while (cnt >= 0) {
            if (ox + cnt < 31 && game[ox+cnt][oy] != -1 && bmap[ox+cnt][oy] != 1) {
                ghost_move(1, ox+cnt, oy);
                cnt = 0;
                break;
            }
            cnt--;
        }
    } 
    if (dir == 2) {
        cnt = 2;
        while (cnt >= 0) {
            if (oy - cnt >= 0 && game[ox][oy-cnt] != -1 && bmap[ox][oy-cnt] != 1) {
                ghost_move(1, ox, oy-cnt);
                cnt = 0;
                break;
            }
            cnt--;
        }
    } 
    if (dir == 3) {
        cnt = 2;
        while (cnt >= 0) {
            if (oy + cnt < 28 && game[ox][oy+cnt] != -1 && bmap[ox][oy+cnt] != 1) {
                ghost_move(1, ox, oy+cnt);
                cnt = 0;
                break;
            }
            cnt--;
        }
    } 
}

void stepC() {
    int px = 2*ox-gx[2];
    if (px < 0) px = 0;
    if (px >= 31) px = 30;
    int py = 2*oy-gy[2];
    if (py < 0) py = 0;
    if (py >= 28) py = 27;
    
    if (px > ox) {
        while (px >= ox) {
            if (game[px][py] != -1 && bmap[px][py] != 1) {
                ghost_move(2, px, py);
                return;
            }
            px--;
        }
    }
    if (px < ox) {
        while (px <= ox) {
            if (game[px][py] != -1 && bmap[px][py] != 1) {
                ghost_move(2, px, py);
                return;
            }
            px++;
        }
    }
    if (py > oy) {
        while (py >= oy) {
            if (game[px][py] != -1 && bmap[px][py] != 1) {
                ghost_move(2, px, py);
                return;
            }
            py--;
        }
    }
    if (py < oy) {
        while (py <= oy) {
            if (game[px][py] != -1 && bmap[px][py] != 1) {
                ghost_move(2, px, py);
                return;
            }
            py++;
        }
    }
}

void stepD() {
    int v = gx[3] - ox;
    int h = gy[3] - oy;
    if (abs(v) + abs(h) > 8) {
        ghost_move(3, ox, oy);
    } else {
        ghost_move(3, 29, 1);
    }
    game[ox][oy] = 2;
    game[gx[0]][gy[0]] = 3;
    game[gx[1]][gy[1]] = 4;
    game[gx[2]][gy[2]] = 5;
    game[gx[3]][gy[3]] = 6;
}


bool checkover() {
    if (score == 244) return true;
    if (ox == gx[0] && oy == gy[0]) return true;
    if (ox == gx[1] && oy == gy[1]) return true;
    if (ox == gx[2] && oy == gy[2]) return true;
    if (ox == gx[3] && oy == gy[3]) return true;
    return false;
}

void time_delay() {
    while (cnt < 10000000) {
        cnt++;
        // if (bt2 is pushed && dir != 1) dir = 0;
        // if (bt3 is pushed && dir != 0) dir = 1;
        // if (bt4 is pushed && dir != 3) dir = 2;
        // if (bt5 is pushed && dir != 2) dir = 3;
    }
    cnt = 0;
}

void print_map() {
    printf("   ");
    for (int j = 0; j < 28; j++) {
        if (j < 10) printf("%d ", j);
        else printf("%d", j);
    }
    printf("\n");
    for (int i = 0; i < 31; i++) {
        if (i < 10) printf("%d  ", i);
        else printf("%d ", i);
        for (int j = 0; j < 28; j++) {
            if (game[i][j] == -1) printf("X ");
            else if (game[i][j] == 0) printf("  ");
            else if (game[i][j] == 1) printf(". ");
            else if (game[i][j] == 2) printf("O ");
            else if (game[i][j] == 3) printf("A ");
            else if (game[i][j] == 4) printf("B ");
            else if (game[i][j] == 5) printf("C ");
            else if (game[i][j] == 6) printf("D ");
        }
        printf("\n");
    }
    printf("**********************************************************************************\n");
}

void init() {
    ox = 23;
    oy = 13;
    gx[0] = 17;
    gy[0] = 18;
    gx[1] = 11;
    gy[1] = 18;
    gx[2] = 17;
    gy[2] = 9;
    gx[3] = 11;
    gy[3] = 9;

    dir = 3;

    st[0] = 0;
    st[1] = 0;
    st[2] = 0;
    st[3] = 0;

    step = 0;
    score = 0;
    cnt = 0;
    bi = 0;
    bit = 0;

    game[0][0] = -1;
    game[0][1] = -1;
    game[0][2] = -1;
    game[0][3] = -1;
    game[0][4] = -1;
    game[0][5] = -1;
    game[0][6] = -1;
    game[0][7] = -1;
    game[0][8] = -1;
    game[0][9] = -1;
    game[0][10] = -1;
    game[0][11] = -1;
    game[0][12] = -1;
    game[0][13] = -1;
    game[0][14] = -1;
    game[0][15] = -1;
    game[0][16] = -1;
    game[0][17] = -1;
    game[0][18] = -1;
    game[0][19] = -1;
    game[0][20] = -1;
    game[0][21] = -1;
    game[0][22] = -1;
    game[0][23] = -1;
    game[0][24] = -1;
    game[0][25] = -1;
    game[0][26] = -1;
    game[0][27] = -1;

    game[1][0] = -1;
    game[1][1] = 1;
    game[1][2] = 1;
    game[1][3] = 1;
    game[1][4] = 1;
    game[1][5] = 1;
    game[1][6] = 1;
    game[1][7] = 1;
    game[1][8] = 1;
    game[1][9] = 1;
    game[1][10] = 1;
    game[1][11] = 1;
    game[1][12] = 1;
    game[1][13] = -1;
    game[1][14] = -1;
    game[1][15] = 1;
    game[1][16] = 1;
    game[1][17] = 1;
    game[1][18] = 1;
    game[1][19] = 1;
    game[1][20] = 1;
    game[1][21] = 1;
    game[1][22] = 1;
    game[1][23] = 1;
    game[1][24] = 1;
    game[1][25] = 1;
    game[1][26] = 1;
    game[1][27] = -1;

    game[2][0] = -1;
    game[2][1] = 1;
    game[2][2] = -1;
    game[2][3] = -1;
    game[2][4] = -1;
    game[2][5] = -1;
    game[2][6] = 1;
    game[2][7] = -1;
    game[2][8] = -1;
    game[2][9] = -1;
    game[2][10] = -1;
    game[2][11] = -1;
    game[2][12] = 1;
    game[2][13] = -1;
    game[2][14] = -1;
    game[2][15] = 1;
    game[2][16] = -1;
    game[2][17] = -1;
    game[2][18] = -1;
    game[2][19] = -1;
    game[2][20] = -1;
    game[2][21] = 1;
    game[2][22] = -1;
    game[2][23] = -1;
    game[2][24] = -1;
    game[2][25] = -1;
    game[2][26] = 1;
    game[2][27] = -1;

    game[3][0] = -1;
    game[3][1] = 1;
    game[3][2] = -1;
    game[3][3] = -1;
    game[3][4] = -1;
    game[3][5] = -1;
    game[3][6] = 1;
    game[3][7] = -1;
    game[3][8] = -1;
    game[3][9] = -1;
    game[3][10] = -1;
    game[3][11] = -1;
    game[3][12] = 1;
    game[3][13] = -1;
    game[3][14] = -1;
    game[3][15] = 1;
    game[3][16] = -1;
    game[3][17] = -1;
    game[3][18] = -1;
    game[3][19] = -1;
    game[3][20] = -1;
    game[3][21] = 1;
    game[3][22] = -1;
    game[3][23] = -1;
    game[3][24] = -1;
    game[3][25] = -1;
    game[3][26] = 1;
    game[3][27] = -1;

    game[4][0] = -1;
    game[4][1] = 1;
    game[4][2] = -1;
    game[4][3] = -1;
    game[4][4] = -1;
    game[4][5] = -1;
    game[4][6] = 1;
    game[4][7] = -1;
    game[4][8] = -1;
    game[4][9] = -1;
    game[4][10] = -1;
    game[4][11] = -1;
    game[4][12] = 1;
    game[4][13] = -1;
    game[4][14] = -1;
    game[4][15] = 1;
    game[4][16] = -1;
    game[4][17] = -1;
    game[4][18] = -1;
    game[4][19] = -1;
    game[4][20] = -1;
    game[4][21] = 1;
    game[4][22] = -1;
    game[4][23] = -1;
    game[4][24] = -1;
    game[4][25] = -1;
    game[4][26] = 1;
    game[4][27] = -1;

    game[5][0] = -1;
    game[5][1] = 1;
    game[5][2] = 1;
    game[5][3] = 1;
    game[5][4] = 1;
    game[5][5] = 1;
    game[5][6] = 1;
    game[5][7] = 1;
    game[5][8] = 1;
    game[5][9] = 1;
    game[5][10] = 1;
    game[5][11] = 1;
    game[5][12] = 1;
    game[5][13] = 1;
    game[5][14] = 1;
    game[5][15] = 1;
    game[5][16] = 1;
    game[5][17] = 1;
    game[5][18] = 1;
    game[5][19] = 1;
    game[5][20] = 1;
    game[5][21] = 1;
    game[5][22] = 1;
    game[5][23] = 1;
    game[5][24] = 1;
    game[5][25] = 1;
    game[5][26] = 1;
    game[5][27] = -1;

    game[6][0] = -1;
    game[6][1] = 1;
    game[6][2] = -1;
    game[6][3] = -1;
    game[6][4] = -1;
    game[6][5] = -1;
    game[6][6] = 1;
    game[6][7] = -1;
    game[6][8] = -1;
    game[6][9] = 1;
    game[6][10] = -1;
    game[6][11] = -1;
    game[6][12] = -1;
    game[6][13] = -1;
    game[6][14] = -1;
    game[6][15] = -1;
    game[6][16] = -1;
    game[6][17] = -1;
    game[6][18] = 1;
    game[6][19] = -1;
    game[6][20] = -1;
    game[6][21] = 1;
    game[6][22] = -1;
    game[6][23] = -1;
    game[6][24] = -1;
    game[6][25] = -1;
    game[6][26] = 1;
    game[6][27] = -1;

    game[7][0] = -1;
    game[7][1] = 1;
    game[7][2] = -1;
    game[7][3] = -1;
    game[7][4] = -1;
    game[7][5] = -1;
    game[7][6] = 1;
    game[7][7] = -1;
    game[7][8] = -1;
    game[7][9] = 1;
    game[7][10] = -1;
    game[7][11] = -1;
    game[7][12] = -1;
    game[7][13] = -1;
    game[7][14] = -1;
    game[7][15] = -1;
    game[7][16] = -1;
    game[7][17] = -1;
    game[7][18] = 1;
    game[7][19] = -1;
    game[7][20] = -1;
    game[7][21] = 1;
    game[7][22] = -1;
    game[7][23] = -1;
    game[7][24] = -1;
    game[7][25] = -1;
    game[7][26] = 1;
    game[7][27] = -1;

    game[8][0] = -1;
    game[8][1] = 1;
    game[8][2] = 1;
    game[8][3] = 1;
    game[8][4] = 1;
    game[8][5] = 1;
    game[8][6] = 1;
    game[8][7] = -1;
    game[8][8] = -1;
    game[8][9] = 1;
    game[8][10] = 1;
    game[8][11] = 1;
    game[8][12] = 1;
    game[8][13] = -1;
    game[8][14] = -1;
    game[8][15] = 1;
    game[8][16] = 1;
    game[8][17] = 1;
    game[8][18] = 1;
    game[8][19] = -1;
    game[8][20] = -1;
    game[8][21] = 1;
    game[8][22] = 1;
    game[8][23] = 1;
    game[8][24] = 1;
    game[8][25] = 1;
    game[8][26] = 1;
    game[8][27] = -1;

    game[9][0] = -1;
    game[9][1] = -1;
    game[9][2] = -1;
    game[9][3] = -1;
    game[9][4] = -1;
    game[9][5] = -1;
    game[9][6] = 1;
    game[9][7] = -1;
    game[9][8] = -1;
    game[9][9] = -1;
    game[9][10] = -1;
    game[9][11] = -1;
    game[9][12] = 0;
    game[9][13] = -1;
    game[9][14] = -1;
    game[9][15] = 0;
    game[9][16] = -1;
    game[9][17] = -1;
    game[9][18] = -1;
    game[9][19] = -1;
    game[9][20] = -1;
    game[9][21] = 1;
    game[9][22] = -1;
    game[9][23] = -1;
    game[9][24] = -1;
    game[9][25] = -1;
    game[9][26] = -1;
    game[9][27] = -1;

    game[10][0] = -1;
    game[10][1] = -1;
    game[10][2] = -1;
    game[10][3] = -1;
    game[10][4] = -1;
    game[10][5] = -1;
    game[10][6] = 1;
    game[10][7] = -1;
    game[10][8] = -1;
    game[10][9] = -1;
    game[10][10] = -1;
    game[10][11] = -1;
    game[10][12] = 0;
    game[10][13] = -1;
    game[10][14] = -1;
    game[10][15] = 0;
    game[10][16] = -1;
    game[10][17] = -1;
    game[10][18] = -1;
    game[10][19] = -1;
    game[10][20] = -1;
    game[10][21] = 1;
    game[10][22] = -1;
    game[10][23] = -1;
    game[10][24] = -1;
    game[10][25] = -1;
    game[10][26] = -1;
    game[10][27] = -1;

    game[11][0] = -1;
    game[11][1] = -1;
    game[11][2] = -1;
    game[11][3] = -1;
    game[11][4] = -1;
    game[11][5] = -1;
    game[11][6] = 1;
    game[11][7] = -1;
    game[11][8] = -1;
    game[11][9] = 0;
    game[11][10] = 0;
    game[11][11] = 0;
    game[11][12] = 0;
    game[11][13] = 0;
    game[11][14] = 0;
    game[11][15] = 0;
    game[11][16] = 0;
    game[11][17] = 0;
    game[11][18] = 0;
    game[11][19] = -1;
    game[11][20] = -1;
    game[11][21] = 1;
    game[11][22] = -1;
    game[11][23] = -1;
    game[11][24] = -1;
    game[11][25] = -1;
    game[11][26] = -1;
    game[11][27] = -1;

    game[12][0] = -1;
    game[12][1] = -1;
    game[12][2] = -1;
    game[12][3] = -1;
    game[12][4] = -1;
    game[12][5] = -1;
    game[12][6] = 1;
    game[12][7] = -1;
    game[12][8] = -1;
    game[12][9] = 0;
    game[12][10] = -1;
    game[12][11] = -1;
    game[12][12] = -1;
    game[12][13] = -1;
    game[12][14] = -1;
    game[12][15] = -1;
    game[12][16] = -1;
    game[12][17] = -1;
    game[12][18] = 0;
    game[12][19] = -1;
    game[12][20] = -1;
    game[12][21] = 1;
    game[12][22] = -1;
    game[12][23] = -1;
    game[12][24] = -1;
    game[12][25] = -1;
    game[12][26] = -1;
    game[12][27] = -1;

    game[13][0] = -1;
    game[13][1] = -1;
    game[13][2] = -1;
    game[13][3] = -1;
    game[13][4] = -1;
    game[13][5] = -1;
    game[13][6] = 1;
    game[13][7] = -1;
    game[13][8] = -1;
    game[13][9] = 0;
    game[13][10] = -1;
    game[13][11] = -1;
    game[13][12] = -1;
    game[13][13] = -1;
    game[13][14] = -1;
    game[13][15] = -1;
    game[13][16] = -1;
    game[13][17] = -1;
    game[13][18] = 0;
    game[13][19] = -1;
    game[13][20] = -1;
    game[13][21] = 1;
    game[13][22] = -1;
    game[13][23] = -1;
    game[13][24] = -1;
    game[13][25] = -1;
    game[13][26] = -1;
    game[13][27] = -1;

    game[14][0] = -1;
    game[14][1] = -1;
    game[14][2] = -1;
    game[14][3] = -1;
    game[14][4] = -1;
    game[14][5] = -1;
    game[14][6] = 1;
    game[14][7] = 0;
    game[14][8] = 0;
    game[14][9] = 0;
    game[14][10] = -1;
    game[14][11] = -1;
    game[14][12] = -1;
    game[14][13] = -1;
    game[14][14] = -1;
    game[14][15] = -1;
    game[14][16] = -1;
    game[14][17] = -1;
    game[14][18] = 0;
    game[14][19] = 0;
    game[14][20] = 0;
    game[14][21] = 1;
    game[14][22] = -1;
    game[14][23] = -1;
    game[14][24] = -1;
    game[14][25] = -1;
    game[14][26] = -1;
    game[14][27] = -1;

    game[15][0] = -1;
    game[15][1] = -1;
    game[15][2] = -1;
    game[15][3] = -1;
    game[15][4] = -1;
    game[15][5] = -1;
    game[15][6] = 1;
    game[15][7] = -1;
    game[15][8] = -1;
    game[15][9] = 0;
    game[15][10] = -1;
    game[15][11] = -1;
    game[15][12] = -1;
    game[15][13] = -1;
    game[15][14] = -1;
    game[15][15] = -1;
    game[15][16] = -1;
    game[15][17] = -1;
    game[15][18] = 0;
    game[15][19] = -1;
    game[15][20] = -1;
    game[15][21] = 1;
    game[15][22] = -1;
    game[15][23] = -1;
    game[15][24] = -1;
    game[15][25] = -1;
    game[15][26] = -1;
    game[15][27] = -1;

    game[16][0] = -1;
    game[16][1] = -1;
    game[16][2] = -1;
    game[16][3] = -1;
    game[16][4] = -1;
    game[16][5] = -1;
    game[16][6] = 1;
    game[16][7] = -1;
    game[16][8] = -1;
    game[16][9] = 0;
    game[16][10] = -1;
    game[16][11] = -1;
    game[16][12] = -1;
    game[16][13] = -1;
    game[16][14] = -1;
    game[16][15] = -1;
    game[16][16] = -1;
    game[16][17] = -1;
    game[16][18] = 0;
    game[16][19] = -1;
    game[16][20] = -1;
    game[16][21] = 1;
    game[16][22] = -1;
    game[16][23] = -1;
    game[16][24] = -1;
    game[16][25] = -1;
    game[16][26] = -1;
    game[16][27] = -1;

    game[17][0] = -1;
    game[17][1] = -1;
    game[17][2] = -1;
    game[17][3] = -1;
    game[17][4] = -1;
    game[17][5] = -1;
    game[17][6] = 1;
    game[17][7] = -1;
    game[17][8] = -1;
    game[17][9] = 0;
    game[17][10] = 0;
    game[17][11] = 0;
    game[17][12] = 0;
    game[17][13] = 0;
    game[17][14] = 0;
    game[17][15] = 0;
    game[17][16] = 0;
    game[17][17] = 0;
    game[17][18] = 0;
    game[17][19] = -1;
    game[17][20] = -1;
    game[17][21] = 1;
    game[17][22] = -1;
    game[17][23] = -1;
    game[17][24] = -1;
    game[17][25] = -1;
    game[17][26] = -1;
    game[17][27] = -1;

    game[18][0] = -1;
    game[18][1] = -1;
    game[18][2] = -1;
    game[18][3] = -1;
    game[18][4] = -1;
    game[18][5] = -1;
    game[18][6] = 1;
    game[18][7] = -1;
    game[18][8] = -1;
    game[18][9] = 0;
    game[18][10] = -1;
    game[18][11] = -1;
    game[18][12] = -1;
    game[18][13] = -1;
    game[18][14] = -1;
    game[18][15] = -1;
    game[18][16] = -1;
    game[18][17] = -1;
    game[18][18] = 0;
    game[18][19] = -1;
    game[18][20] = -1;
    game[18][21] = 1;
    game[18][22] = -1;
    game[18][23] = -1;
    game[18][24] = -1;
    game[18][25] = -1;
    game[18][26] = -1;
    game[18][27] = -1;

    game[19][0] = -1;
    game[19][1] = -1;
    game[19][2] = -1;
    game[19][3] = -1;
    game[19][4] = -1;
    game[19][5] = -1;
    game[19][6] = 1;
    game[19][7] = -1;
    game[19][8] = -1;
    game[19][9] = 0;
    game[19][10] = -1;
    game[19][11] = -1;
    game[19][12] = -1;
    game[19][13] = -1;
    game[19][14] = -1;
    game[19][15] = -1;
    game[19][16] = -1;
    game[19][17] = -1;
    game[19][18] = 0;
    game[19][19] = -1;
    game[19][20] = -1;
    game[19][21] = 1;
    game[19][22] = -1;
    game[19][23] = -1;
    game[19][24] = -1;
    game[19][25] = -1;
    game[19][26] = -1;
    game[19][27] = -1;

    game[20][0] = -1;
    game[20][1] = 1;
    game[20][2] = 1;
    game[20][3] = 1;
    game[20][4] = 1;
    game[20][5] = 1;
    game[20][6] = 1;
    game[20][7] = 1;
    game[20][8] = 1;
    game[20][9] = 1;
    game[20][10] = 1;
    game[20][11] = 1;
    game[20][12] = 1;
    game[20][13] = -1;
    game[20][14] = -1;
    game[20][15] = 1;
    game[20][16] = 1;
    game[20][17] = 1;
    game[20][18] = 1;
    game[20][19] = 1;
    game[20][20] = 1;
    game[20][21] = 1;
    game[20][22] = 1;
    game[20][23] = 1;
    game[20][24] = 1;
    game[20][25] = 1;
    game[20][26] = 1;
    game[20][27] = -1;

    game[21][0] = -1;
    game[21][1] = 1;
    game[21][2] = -1;
    game[21][3] = -1;
    game[21][4] = -1;
    game[21][5] = -1;
    game[21][6] = 1;
    game[21][7] = -1;
    game[21][8] = -1;
    game[21][9] = -1;
    game[21][10] = -1;
    game[21][11] = -1;
    game[21][12] = 1;
    game[21][13] = -1;
    game[21][14] = -1;
    game[21][15] = 1;
    game[21][16] = -1;
    game[21][17] = -1;
    game[21][18] = -1;
    game[21][19] = -1;
    game[21][20] = -1;
    game[21][21] = 1;
    game[21][22] = -1;
    game[21][23] = -1;
    game[21][24] = -1;
    game[21][25] = -1;
    game[21][26] = 1;
    game[21][27] = -1;

    game[22][0] = -1;
    game[22][1] = 1;
    game[22][2] = -1;
    game[22][3] = -1;
    game[22][4] = -1;
    game[22][5] = -1;
    game[22][6] = 1;
    game[22][7] = -1;
    game[22][8] = -1;
    game[22][9] = -1;
    game[22][10] = -1;
    game[22][11] = -1;
    game[22][12] = 1;
    game[22][13] = -1;
    game[22][14] = -1;
    game[22][15] = 1;
    game[22][16] = -1;
    game[22][17] = -1;
    game[22][18] = -1;
    game[22][19] = -1;
    game[22][20] = -1;
    game[22][21] = 1;
    game[22][22] = -1;
    game[22][23] = -1;
    game[22][24] = -1;
    game[22][25] = -1;
    game[22][26] = 1;
    game[22][27] = -1;

    game[23][0] = -1;
    game[23][1] = 1;
    game[23][2] = 1;
    game[23][3] = 1;
    game[23][4] = -1;
    game[23][5] = -1;
    game[23][6] = 1;
    game[23][7] = 1;
    game[23][8] = 1;
    game[23][9] = 1;
    game[23][10] = 1;
    game[23][11] = 1;
    game[23][12] = 1;
    game[23][13] = 0;
    game[23][14] = 0;
    game[23][15] = 1;
    game[23][16] = 1;
    game[23][17] = 1;
    game[23][18] = 1;
    game[23][19] = 1;
    game[23][20] = 1;
    game[23][21] = 1;
    game[23][22] = -1;
    game[23][23] = -1;
    game[23][24] = 1;
    game[23][25] = 1;
    game[23][26] = 1;
    game[23][27] = -1;

    game[24][0] = -1;
    game[24][1] = -1;
    game[24][2] = -1;
    game[24][3] = 1;
    game[24][4] = -1;
    game[24][5] = -1;
    game[24][6] = 1;
    game[24][7] = -1;
    game[24][8] = -1;
    game[24][9] = 1;
    game[24][10] = -1;
    game[24][11] = -1;
    game[24][12] = -1;
    game[24][13] = -1;
    game[24][14] = -1;
    game[24][15] = -1;
    game[24][16] = -1;
    game[24][17] = -1;
    game[24][18] = 1;
    game[24][19] = -1;
    game[24][20] = -1;
    game[24][21] = 1;
    game[24][22] = -1;
    game[24][23] = -1;
    game[24][24] = 1;
    game[24][25] = -1;
    game[24][26] = -1;
    game[24][27] = -1;

    game[25][0] = -1;
    game[25][1] = -1;
    game[25][2] = -1;
    game[25][3] = 1;
    game[25][4] = -1;
    game[25][5] = -1;
    game[25][6] = 1;
    game[25][7] = -1;
    game[25][8] = -1;
    game[25][9] = 1;
    game[25][10] = -1;
    game[25][11] = -1;
    game[25][12] = -1;
    game[25][13] = -1;
    game[25][14] = -1;
    game[25][15] = -1;
    game[25][16] = -1;
    game[25][17] = -1;
    game[25][18] = 1;
    game[25][19] = -1;
    game[25][20] = -1;
    game[25][21] = 1;
    game[25][22] = -1;
    game[25][23] = -1;
    game[25][24] = 1;
    game[25][25] = -1;
    game[25][26] = -1;
    game[25][27] = -1;

    game[26][0] = -1;
    game[26][1] = 1;
    game[26][2] = 1;
    game[26][3] = 1;
    game[26][4] = 1;
    game[26][5] = 1;
    game[26][6] = 1;
    game[26][7] = -1;
    game[26][8] = -1;
    game[26][9] = 1;
    game[26][10] = 1;
    game[26][11] = 1;
    game[26][12] = 1;
    game[26][13] = -1;
    game[26][14] = -1;
    game[26][15] = 1;
    game[26][16] = 1;
    game[26][17] = 1;
    game[26][18] = 1;
    game[26][19] = -1;
    game[26][20] = -1;
    game[26][21] = 1;
    game[26][22] = 1;
    game[26][23] = 1;
    game[26][24] = 1;
    game[26][25] = 1;
    game[26][26] = 1;
    game[26][27] = -1;

    game[27][0] = -1;
    game[27][1] = 1;
    game[27][2] = -1;
    game[27][3] = -1;
    game[27][4] = -1;
    game[27][5] = -1;
    game[27][6] = -1;
    game[27][7] = -1;
    game[27][8] = -1;
    game[27][9] = -1;
    game[27][10] = -1;
    game[27][11] = -1;
    game[27][12] = 1;
    game[27][13] = -1;
    game[27][14] = -1;
    game[27][15] = 1;
    game[27][16] = -1;
    game[27][17] = -1;
    game[27][18] = -1;
    game[27][19] = -1;
    game[27][20] = -1;
    game[27][21] = -1;
    game[27][22] = -1;
    game[27][23] = -1;
    game[27][24] = -1;
    game[27][25] = -1;
    game[27][26] = 1;
    game[27][27] = -1;

    game[28][0] = -1;
    game[28][1] = 1;
    game[28][2] = -1;
    game[28][3] = -1;
    game[28][4] = -1;
    game[28][5] = -1;
    game[28][6] = -1;
    game[28][7] = -1;
    game[28][8] = -1;
    game[28][9] = -1;
    game[28][10] = -1;
    game[28][11] = -1;
    game[28][12] = 1;
    game[28][13] = -1;
    game[28][14] = -1;
    game[28][15] = 1;
    game[28][16] = -1;
    game[28][17] = -1;
    game[28][18] = -1;
    game[28][19] = -1;
    game[28][20] = -1;
    game[28][21] = -1;
    game[28][22] = -1;
    game[28][23] = -1;
    game[28][24] = -1;
    game[28][25] = -1;
    game[28][26] = 1;
    game[28][27] = -1;

    game[29][0] = -1;
    game[29][1] = 1;
    game[29][2] = 1;
    game[29][3] = 1;
    game[29][4] = 1;
    game[29][5] = 1;
    game[29][6] = 1;
    game[29][7] = 1;
    game[29][8] = 1;
    game[29][9] = 1;
    game[29][10] = 1;
    game[29][11] = 1;
    game[29][12] = 1;
    game[29][13] = 1;
    game[29][14] = 1;
    game[29][15] = 1;
    game[29][16] = 1;
    game[29][17] = 1;
    game[29][18] = 1;
    game[29][19] = 1;
    game[29][20] = 1;
    game[29][21] = 1;
    game[29][22] = 1;
    game[29][23] = 1;
    game[29][24] = 1;
    game[29][25] = 1;
    game[29][26] = 1;
    game[29][27] = -1;

    game[30][0] = -1;
    game[30][1] = -1;
    game[30][2] = -1;
    game[30][3] = -1;
    game[30][4] = -1;
    game[30][5] = -1;
    game[30][6] = -1;
    game[30][7] = -1;
    game[30][8] = -1;
    game[30][9] = -1;
    game[30][10] = -1;
    game[30][11] = -1;
    game[30][12] = -1;
    game[30][13] = -1;
    game[30][14] = -1;
    game[30][15] = -1;
    game[30][16] = -1;
    game[30][17] = -1;
    game[30][18] = -1;
    game[30][19] = -1;
    game[30][20] = -1;
    game[30][21] = -1;
    game[30][22] = -1;
    game[30][23] = -1;
    game[30][24] = -1;
    game[30][25] = -1;
    game[30][26] = -1;
    game[30][27] = -1;

    game[ox][oy] = 2;
    game[gx[0]][gy[0]] = 3;
    game[gx[1]][gy[1]] = 4;
    game[gx[2]][gy[2]] = 5;
    game[gx[3]][gy[3]] = 6;
}