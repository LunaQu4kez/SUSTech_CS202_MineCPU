#ifndef __MINECPU_LIB_H__
#define __MINECPU_LIB_H__

#include "def.h"

int getled(void);
int getswitch(void);
void putchar(char c);
void printf(const char *fmt, ...);

#endif