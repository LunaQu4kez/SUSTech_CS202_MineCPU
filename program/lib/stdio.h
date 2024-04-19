#ifndef __MINECPU_LIB_H__
#define __MINECPU_LIB_H__

#include <def.h>

uint32_t getled(void);
uint32_t getswitch(void);
void putchar(char c);
void printf(const char *fmt, ...);

#endif