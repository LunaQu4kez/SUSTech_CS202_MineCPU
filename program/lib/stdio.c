#include <stdio.h>
#include <defs.h>

uint32_t sbi_call(uint32_t sbi_type, uint32_t arg0, uint32_t arg1,
          uint32_t arg2)
{
    uint32_t ret_val;
    __asm__ volatile("mv x17, %[sbi_type]\n"
             "mv x10, %[arg0]\n"
             "mv x11, %[arg1]\n"
             "mv x12, %[arg2]\n"
             "ecall\n"
             "mv %[ret_val], x10"
             : [ret_val] "=r"(ret_val)
             : [sbi_type] "r"(sbi_type), [arg0] "r"(arg0),
               [arg1] "r"(arg1), [arg2] "r"(arg2)
             : "memory");
    return ret_val;
}
