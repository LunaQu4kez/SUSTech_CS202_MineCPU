#include "pacdefs.h"
#include <err.h>
#include <errno.h>
#include <signal.h>
#include <fcntl.h>
#include <pwd.h>
#include <stdlib.h>
#include <termios.h>
#include <time.h>
#include <unistd.h>
#include <curses.h>

extern int
	delay,
	game,
	wmonst,
	boardcount,
	rounds,
	monsthere,
	potintvl,
	treascnt,
	bcount,
	showcount,
	goldcnt;

extern struct pac
	*pacptr;

extern struct pac
	monst[];

extern char monst_names[];
extern char *full_names[];

/*
 * initbrd is used to re-initialize the display
 * array once a new game is started.
 */
char	initbrd[BRDY][BRDX] =
{
"#######################################",
"# . . . * . . . . ### . . . . * . . . #",
"# O ### . ##### . ### . ##### . ### O #",
"# * . . * . * . * . . * . * . * . . * #",
"# . ### . # . ########### . # . ### . #",
"# . . . * # . . . ### . . . # * . . . #",
"####### . ##### . ### . ##### . #######",
"      # . # . . * . . * . . # . #      ",
"      # . # . ### - - ### . # . #      ",
"####### . # . #         # . # . #######",
"        * . * #         # * . *        ",
"####### . # . #         # . # . #######",
"      # . # . ########### . # . #      ",
"      # . # * . . . . . . * # . #      ",
"####### . # . ########### . # . #######",
"# . . . * . * . . ### . . * . * . . . #",
"# O ### . ##### . ### . ##### . ### O #",
"# . . # * . * . * . . * . * . * # . . #",
"### . # . # . ########### . # . # . ###",
"# . * . . # . . . ### . . . # . . * . #",
"# . ########### . ### . ########### . #",
"# . . . . . . . * . . * . . . . . . . #",
"#######################################",
};

/*
 * brd is kept for historical reasons.
 * It should only be used in the routine "which"
 * to determine the next move for a monster or
 * in the routine "monster" to determine if it
 * was a valid move. Admittedly this is redundant
 * and could be replaced by initbrd, but it is kept
 * so that someday additional intelligence or
 * optimization could be added to the choice of
 * the monster's next move. Hence, note the symbol
 * CHOICE at most points that a move decision
 * logically HAS to be made.
 */
char	brd[BRDY][BRDX] =
{
"#######################################",
"# . . . * . . . . ### . . . . * . . . #",
"# O ### . ##### . ### . ##### . ### O #",
"# * . . * . * . * . . * . * . * . . * #",
"# . ### . # . ########### . # . ### . #",
"# . . . * # . . . ### . . . # * . . . #",
"####### . ##### . ### . ##### . #######",
"      # . # . . * . . * . . # . #      ",
"      # . # . ### - - ### . # . #      ",
"####### . # . #         # . # . #######",
"        * . * #         # * . *        ",
"####### . # . #         # . # . #######",
"      # . # . ########### . # . #      ",
"      # . # * . . . . . . * # . #      ",
"####### . # . ########### . # . #######",
"# . . . * . * . . ### . . * . * . . . #",
"# O ### . ##### . ### . ##### . ### O #",
"# . . # * . * . * . . * . * . * # . . #",
"### . # . # . ########### . # . # . ###",
"# . * . . # . . . ### . . . # . . * . #",
"# . ########### . ### . ########### . #",
"# . . . . . . . * . . * . . . . . . . #",
"#######################################",
};

/*
 * display reflects the screen on the player's
 * terminal at any point in time.
 */
char	display[BRDY][BRDX] =
{
"#######################################",
"# . . . . . . . . ### . . . . . . . . #",
"# O ### . ##### . ### . ##### . ### O #",
"# . . . . . . . . . . . . . . . . . . #",
"# . ### . # . ########### . # . ### . #",
"# . . . . # . . . ### . . . # . . . . #",
"####### . ##### . ### . ##### . #######",
"      # . # . . . . . . . . # . #      ",
"      # . # . ### - - ### . # . #      ",
"####### . # . #         # . # . #######",
"        . . . #         # . . .        ",
"####### . # . #         # . # . #######",
"      # . # . ########### . # . #      ",
"      # . # . . . . . . . . # . #      ",
"####### . # . ########### . # . #######",
"# . . . . . . . . ### . . . . . . . . #",
"# O ### . ##### . ### . ##### . ### O #",
"# . . # . . . . . . . . . . . . # . . #",
"### . # . # . ########### . # . # . ###",
"# . . . . # . . . ### . . . # . . . . #",
"# . ########### . ### . ########### . #",
"# . . . . . . . . . . . . . . . . . . #",
"#######################################",
};

int	incharbuf;
int	bufstat;
char	message[81],	/* temporary message buffer */
	inbuf[2];

int	ppid,
	cpid,
	killcnt = 0,
	vs_rows,
	vs_cols;

unsigned
	pscore;

long	timein;

struct uscore
{
	unsigned score;	/* same type as pscore */
	int uid;	/* uid of player */
};

struct scorebrd
{
	struct uscore entry[MSSAVE];
} scoresave[MGTYPE];

void leave(void);

void update(void)
{
	char	str[10];

	sprintf(str, "%6d", pscore);
	SPLOT(0, 52, str);
	sprintf(str, "%6d", goldcnt);
	SPLOT(21, 57, str);
}

void reinit(void)
{
	int locx, locy;
	char tmp;

	if (boardcount % 2 == 0)
		movie();
	for (locy = 0; locy < BRDY; locy++)
	{
		for (locx = 0; locx < BRDX; locx++)
		{
			tmp = initbrd[locy][locx];
			brd[locy][locx] = tmp;
			if ((display[locy][locx] = tmp) == CHOICE)
			{
				display[locy][locx] = GOLD;
			};
		};
	};
	goldcnt = GOLDCNT;
	delay = delay * 3 / 4;	/* hot it up */
	boardcount++;
}

void errgen(string)
char	*string;
{
	SPLOT(23,45,string);
}

int dokill(mnum)
	int mnum;
{
	struct pac *mptr;
	char msgbuf[50];
	int bscore;

	beep();
	if (monst[mnum].danger == FALSE)
	{
		if (++killcnt == MAXMONSTER)
		{
			if (display[TRYPOS][TRXPOS] == GOLD)
			{
				goldcnt--;
			};
			display[TRYPOS][TRXPOS] = TREASURE;
			PLOT(TRYPOS, TRXPOS, TREASURE);
			killcnt = 0;
			treascnt = potintvl;
		}
		SPLOT(5, 45, "MONSTERS KILLED: ");
		(void) sprintf(message, "%1d", killcnt);
		SPLOT(5, 62, message);
		mptr = (&monst[mnum]);
		mptr->ypos = MSTARTY;
		mptr->xpos = MSTARTX + (2 * mnum);
		mptr->danger = TRUE;
		mptr->stat = START;
		PLOT(mptr->ypos, mptr->xpos, monst_names[mnum] | COLOR_PAIR(mnum+1));
		monsthere++;
		rounds = 1;	/* force it to be a while before he comes out */
		switch (monsthere) {
		case 1: bscore =     KILLSCORE; break;
		case 2: bscore = 2 * KILLSCORE; break;
		case 3: bscore = 4 * KILLSCORE; break;
		case 4: bscore = 8 * KILLSCORE; break;
		}
		pscore += bscore;
		bcount = BINTVL;
		sprintf(msgbuf, "BONUS: %4d", bscore);
		SPLOT(7, 45, msgbuf);
		sprintf(msgbuf, "You got %s!\n", full_names[mnum]);
		SPLOT(4, 45, msgbuf);
		return(GOTONE);
	};
	wmonst = mnum;
	return(TURKEY);
}

/*
 * clr -- issues an escape sequence to clear the display
 */

void clr(void)
{
	clear();
}

/*
 *	display initial instructions
 */

void instruct(void)
{
	clr();
	POS(0, 0);
	printw("Attention: you are in a maze, being chased by monsters!\n\n");
	printw("There is food scattered uniformly in the maze, marked by \".\".\n");
	printw("One magic potion is available at each spot marked \"O\". Each potion will\n");
	printw("enable you to eat monsters for a limited duration. It will also\n");
	printw("scare them away. When you eat a monster it is regenerated, but this takes\n");
	printw("time. You can also regenerate yourself %d times. Eating all the monsters\n", MAXPAC);
	printw("results in further treasure appearing magically somewhere in the dungeon,\n");
	printw("marked by \"$\". There is a magic tunnel connecting the center left and\n");
	printw("center right parts of the dungeon. The monsters know about it!\n\n");
	printw("        Type:   h or s  to move left\n");
	printw("                l or f  to move right\n");
	printw("                k or e  to move up\n");
	printw("                j or c  to move down\n");
	printw("                <space> to halt \n");
	printw("                q       to quit\n\n");
	printw("        Type:   1       easy game\n");
	printw("                2       intelligent monsters\n");
	printw("                3       very intelligent monsters\n");
	refresh();
}

/*
 * over -- game over processing
 */

void over(int signo)
{
	struct passwd *p;
	int scorefile = 0;
	int line, col;
	int i;

	(void)signo;
	refresh();
	signal(SIGINT, SIG_IGN);
	/* high score to date processing */
	if (game != 0)
	{
		col = 45;
		line = 10;
		POS(line++, col);
		(void) printw(" ___________________________ ");
		POS(line++, col);
		(void) printw("| G A M E   O V E R         |");
		POS(line++, col);
		(void) printw("|                           |");
		POS(line++, col);
		(void) printw("| Game type: %6.6s         |",game==1?"easy":game==2?"medium":"smart");

		scorefile = open(MAXSCORE, 2);
		if (scorefile != -1)
		{
			int rc;

			rc = read(scorefile, (char *)scoresave, sizeof(scoresave));
			if (rc == -1)
				warn("Failed reading score file %s", MAXSCORE);

			for (i = MSSAVE - 1; i >= 0; i--) {
				if (scoresave[game - 1].entry[i].score < pscore)
				{
					if (i < MSSAVE - 1)
					{
						scoresave[game - 1].entry[i + 1].score =
							scoresave[game - 1].entry[i].score;
						scoresave[game - 1].entry[i + 1].uid =
							scoresave[game - 1].entry[i].uid;
					};
					scoresave[game - 1].entry[i].score = pscore;
					scoresave[game - 1].entry[i].uid = getuid();
				};
			};
			lseek(scorefile, 0l, 0);
			rc = write(scorefile, (char *)scoresave, sizeof(scoresave));
			if (rc == -1)
				warn("Failed writing score file %s", MAXSCORE);
			close(scorefile);
			POS(line++, col);
			(void) printw("| High Scores to date:      |");
			for (i = 0; i < MSSAVE; i++)
			{
				setpwent();
				p = getpwuid(scoresave[game - 1].entry[i].uid);
				POS(line++, col);
				(void) printw("| Player : %-8s  %5u  |", p->pw_name,
					scoresave[game - 1].entry[i].score);
			};
		}
		else
		{
			POS(line++, col);
			(void) printw("|                           |");
			POS(line++, col);
			(void) printw("| Please create a 'paclog'  |");
			POS(line++, col);
			(void) printw("| file. See 'MAXSCORE' in   |");
			POS(line++, col);
			(void) printw("| 'pacdefs.h'.              |");
		};
		POS(line, col);
		(void) printw("|___________________________|");
	};
	refresh();
	leave();
}

/*
 * leave -- flush buffers,kill the Child, reset tty, and delete tempfile
 */

void leave(void)
{
	leaveok(stdscr, FALSE);
	POS(23, 0);
	refresh();
	endwin();
	exit(0);
}

/*
 * init -- does global initialization and spawns a child process to read
 *      the input terminal.
 */

void init(void)
{
	int tries = 0;

	errno = 0;
	(void) time(&timein);	/* get start time */
	srand((unsigned)timein);	/* start rand randomly */
	signal(SIGINT, over);
	signal(SIGQUIT, over);

	/* Curses init - could probably eliminate much of stuff below */
	initscr();
	if ((start_color()) == OK)
	{
	     init_pair (1, COLOR_YELLOW, COLOR_BLUE);
	     init_pair (2, COLOR_BLUE, COLOR_YELLOW);
	     init_pair (3, COLOR_YELLOW, COLOR_GREEN);
	     init_pair (4, COLOR_MAGENTA, COLOR_CYAN);
	     init_pair (5, COLOR_YELLOW, COLOR_RED);
	}
	noecho();
	crmode();
	nonl();
	leaveok(stdscr, TRUE);
	keypad(stdscr, TRUE);
	nodelay(stdscr, TRUE);
	vs_rows = LINES;
	vs_cols = COLS;

	if (delay == 0)
		delay = 500;	/* number of ticks per turn */

	/*
	 * New game starts here
	 */
	if (game == 0)
		instruct();
	while ((game == 0) && (tries++ < 300))
	{
		napms(100);
		pollch(1);
	};
	if (tries >= 300)
	{
		/* I give up. Let's call it quits. */
		leave();
	};
	goldcnt = GOLDCNT;
	pscore = 0;
	clr();
}

/*
 * poll -- read characters sent by input subprocess and set global flags
 */

void pollch(sltime)
int sltime;
{
	int stop;
	int c;

	(void)sltime;
	stop = 0;
readin:

	refresh();
	if (bufstat == EMPTY) {
		c = getch();
		if (c < 0) {
			bufstat = EMPTY;
		} else {
			bufstat = FULL;
			incharbuf = c;
		}
	}

	if (bufstat == EMPTY) 
	{
		if (stop)
		{
			goto readin;
		};
		return;
	};
	bufstat = EMPTY;

	switch(incharbuf)
	{
	case LEFT:
	case NLEFT:
	case KEY_LEFT:
		pacptr->dirn = DLEFT;
		break;

	case RIGHT:
	case NRIGHT:
	case KEY_RIGHT:
		pacptr->dirn = DRIGHT;
		break;

	case NORTH:
	case NNORTH:
	case KEY_UP:
		pacptr->dirn = DUP;
		break;

	case DOWN:
	case NDOWN:
	case KEY_DOWN:
		pacptr->dirn = DDOWN;
		break;

	case HALT:
	case KEY_HOME:
		pacptr->dirn = DNULL;
		break;

	case REDRAW:
		clearok(curscr, TRUE);
//		draino(0);
		tcdrain(STDOUT_FILENO);
		break;

	case ABORT:
	case DELETE:
	case QUIT:
		over(0);
		break;

	case 'S':
		stop = 1;
		goto readin;

	case 'G':
		stop = 0;
		goto readin;

	case GAME1:
		if (game == 0)
			game = 1;
		break;

	case GAME2:
		if (game == 0)
			game = 2;
		break;

	case GAME3:
		if (game == 0)
			game = 3;
		break;

	default:
		goto readin;
	}
}

unsigned int getrand(range)
	int range;
{
	unsigned int q;

	q = rand();
	return(q % range);
}

#define FIRSTMSGLINE	13
#define LASTMSGLINE	13
/*
 * This function is convenient for debugging pacman.  It isn't used elsewhere.
 * It's like printf and prints in a window on the right hand side of the screen.
 */
void msgf(fmt, arg1, arg2, arg3, arg4)
char *fmt;
int arg1, arg2, arg3, arg4;
{
	char msgbuf[100];
	static char msgline = FIRSTMSGLINE;

	sprintf(msgbuf, fmt, arg1, arg2, arg3, arg4);
	SPLOT(msgline, 45, msgbuf);
	if (++msgline > LASTMSGLINE)
		msgline = FIRSTMSGLINE;
}
