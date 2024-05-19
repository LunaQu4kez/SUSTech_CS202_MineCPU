# CS202 课程项目 CPU 报告

本报告为 2024 年春季南方科技大学计算机系课程 CS202 计算机组成原理的课程项目报告



## 团队分工

| 学号     | 姓名    | 分工                 | 贡献比 |
| -------- | ------ | ------------------- | ------ |
| 12211655 | 于斯瑶  | IO 模块、汇编软件 | 33.33% |
| 12110120 | 赵钊   | 架构设计、上板调试 | 33.33% |
| 12212231 | 陈贲   | 核心开发、仿真测试       | 33.33% |



## 计划日程安排和实施情况

| 时间          | 任务                                          |
| ------------- | -------------------------------------------- |
| 2024-3-18 | MineCPU 项目启动 |
| 2024-3-18 | 设计初始基本架构 (Stage 和 Stage 间 Regs) |
| 2024-3-18 | 完成寄存器模块、立即数生成模块 |
| 2024-3-29 | 完成 ALU 模块 |
| 2024-3-30 | 完成数据冒险前递模块 |
| 2024-3-30 | 完成 7 段数码管模块 |
| 2024-4-6 | 完成分支预测模块初版 |
| 2024-4-7 | 完成 Memory 模块初版 |
| 2024-4-9 | 完成分支预测模块 |
| 2024-4-9 | 顶层模块接线 |
| 2024-4-15 | 优化 MineCPU 架构 |
| 2024-4-18 | 实现异常中断 (`ecall` 指令实现) |
| 2024-4-19 | 完成 UART 模块 |
| 2024-4-21 | 优化分支预测: 添加返回地址栈 (RAS) |
| 2024-4-23 | 增加对 RV32M 指令的支持 |
| 2024-4-29     |  Project 发布                                |
| 2024-5-1 | 完成指令缓存 (ICache) |
| 2024-5-3 | 完成 Pacman 初版 |
| 2024-5-4 | 完成数据缓存 (DCache) |
| 2024-5-7 | 完成 UART 上板测试 |
| 2024-5-9 | 完成 MineCPU 上板测试 |
| 2024-5-11 | 完成场景测试 1 汇编 |
| 2024-5-11 | 完成 VGA 模块 |
| 2024-5-13 | 完成 VGA 上板测试 |
| 2024-5-14 | 完成场景测试 2 汇编 |
| 2024-5-17 | 完成 Pacman 上板测试 |
|  | 完成报告 |

**以上计划均顺利按时完成** 

#### 版本修改记录 (Git Commit Log)

[Github Link](https://github.com/wLUOw/CS202_MineCPU) (仓库将会在 Project DDL 后公开)



## CPU架构设计说明

### CPU 特性

- **冯诺依曼架构**支持 **RISC-V** 指令集的**五级流水线** CPU，CPI 约为 4.7 (存在分支预测未命中和 Cache 未命中产生的停顿)
- 采用前递、分支预测的方式解决冒险
- 含 32 个 32 bit 的寄存器 (不含 pc 寄存器)
- 寻址单位为 32 bit (4 byte)
- 冯诺依曼架构不对指令空间和数据空间进行区分
- 栈空间基址为 0x7ffc
- **时钟频率:** 
  + CPU: 最高可支持 50MHz
  + MEM: 与 CPU 同频
  + VGA: 40MHz
- **分支预测**:
  + BHT: 32 entries, 2 bits
  + RAS: 32 entries, 32 bits
- **Cache**:
  + ICache: 直接映射, 1472 bits, 32 entries
  + DCache: 直接映射/写回, 1504 bits, 32 entries
- **异常控制**:
  + ecall: 外部设备驱动, 通过 MMIO 进行输入输出, API doc 见 [Environment Call](#environment-call)
  + 中断返回时使用 `sret` 指令

### ISA

参考 RISC-V 基本指令集 (RV32I) 及乘除法拓展 (RV32M)

| 指令                    | 指令类型 | 执行操作                                  |
| ----------------------- | -------- | ----------------------------------------- |
| `add rd, rs1, rs2`      | R        | rd = rs1 + rs2                            |
| `sub rd, rs1, rs2`      | R        | rd = rs1 - rs2                            |
| `xor rd, rs1, rs2`      | R        | rd = rs1 ^ rs2                            |
| `or rd, rs1, rs2`       | R        | rd = rs1 \| rs2                           |
| `and rd, rs1, rs2`      | R        | rd = rs1 & rs2                            |
| `sll rd, rs1, rs2`      | R        | rd = rs1 << rs2                           |
| `srl rd, rs1, rs2`      | R        | rd = rs1 >> rs2                           |
| `sra rd, rs1, rs2`      | R        | rd = rs1 >> rs2 (sign-extend)             |
| `slt rd, rs1, rs2`      | R        | rd = ( rs1 < rs2 ) ? 1 : 0                |
| `sltu rd, rs1, rs2`     | R        | rd = ( (u)rs1 < (u)rs2 ) ? 1 : 0          |
| `addi rd, rs1, rs2`     | I        | rd = rs1 + imm                            |
| `xori rd, rs1, rs2`     | I        | rd = rs1 ^ imm                            |
| `ori rd, rs1, rs2`      | I        | rd = rs1 \| imm                           |
| `andi rd, rs1, rs2`     | I        | rd = rs1 & imm                            |
| `slli rd, rs1, rs2`     | I        | rd = rs1 << imm[4:0]                      |
| `srli rd, rs1, rs2`     | I        | rd = rs1 >> imm[4:0]                      |
| `srai rd, rs1, rs2`     | I        | rd = rs1 >> imm[4:0] (sign-extend)        |
| `slti rd, rs1, rs2`     | I        | rd = (rs1 < imm) ? 1 : 0                  |
| `sltiu rd, rs1, rs2`    | I        | rd = ( (u)rs1 < (u)imm ) ? 1 : 0          |
| `lb rd, imm(rs1)`       | I        | 读取 1 byte 并做符号位扩展                |
| `lh rd, imm(rs1)`       | I        | 读取 1 half-word (2 bytes) 并做符号位扩展 |
| `lw rd, imm(rs1)`       | I        | 读取 1 word (4 bytes)                     |
| `lbu rd, imm(rs1)`      | I        | 读取 1 byte 并做 0 扩展                   |
| `lhu rd, imm(rs1)`      | I        | 读取 2 byte 并做 0 扩展                   |
| `sb rd, imm(rs1)`       | S        | 存入 1 byte                               |
| `sh rd, imm(rs1)`       | S        | 存入 1 half-word (2 bytes)                |
| `sw rd, imm(rs1)`       | S        | 存入 1 word (4 bytes)                     |
| `beq rs1, rs2, label`   | B        | if (rs1 == rs2)  PC += (imm << 1)         |
| `bne rs1, rs2, label`   | B        | if (rs1 != rs2)  PC += (imm << 1)         |
| `blt rs1, rs2, label`   | B        | if (rs1 < rs2)  PC += (imm << 1)          |
| `bge rs1, rs2, label`   | B        | if (rs1 >= rs2)  PC += (imm << 1)         |
| `bltu rs1, rs2, label`  | B        | if ( (u)rs1 < (u)rs2 )  PC += (imm << 1)  |
| `bgeu rs1, rs2, label`  | B        | if ( (u)rs1 >= (u)rs2 )  PC += (imm << 1) |
| `jal rd, label`         | J        | rd = PC + 4; PC += (imm << 1)             |
| `jalr rd, rs1, imm`     | I        | rd = PC + 4; PC = rs1 + imm               |
| `lui rd, imm`           | U        | rd = imm << 12                            |
| `auipc rd, imm`         | U        | rd = PC + (imm << 12)                     |
| `ecall`                 | I        | 控制权交给固件 (采用输入设备模拟)         |
| `sret` *                | I        | 控制权交还给程序                          |
| `mul rd, rs1, rs2` *    | R        | rd = (rs1 * rs2)[31:0]                    |
| `mulh rd, rs1, rs2` *   | R        | rd = (rs1 * rs2)[63:32]                   |
| `mulhsu rd, rs1, rs2` * | R        | rd = (rs1 * (u)rs2)[63:32]                |
| `mulhu rd, rs1, rs2` *  | R        | rd = ( (u)rs1 * (u)rs2 )[63:32]           |
| `div rd, rs1, rs2` *    | R        | rd = rs1 / rs2                            |
| `rem rd, rs1, rs2` *    | R        | rd = rs1 % rs2                            |

### Environment Call

| 调用 No. (a7) | 参数 | 功能                          | 返回值 |
| :------------ | ---- | ----------------------------- | ------ |
| 0x01          | a0   | 写入 1 Byte 到第一组 LED 显示 | N/A    |
| 0x02          | a0   | 写入 1 Byte 到第二组 LED 显示 | N/A    |
| 0x03          | a0   | 写入 4 Bytes 到七段数码管显示 | N/A    |
| 0x05          | N/A  | 从第一组拨码开关读入 1 Byte   | a0     |
| 0x06          | N/A  | 从第二组拨码开关读入 1 Byte   | a0     |
| 0x07          | N/A  | 从第三组拨码开关读入 1 Byte   | a0     |
| 0x0A          | N/A  | 结束程序 (死循环)             | N/A    |

### IO

- 使用 **MMIO** (Memory Mapping IO，内存映射) 进行 IO 操作并支持 UART
- UART
  - 支持通过软件而非重新烧写 FPGA 的方式进行程序与数据的加载
  - 规格：115200Hz 波特率, 8 data bits, 1 stop bits
  - 数据直接写入内存，在接收过数据后超过约 0.5 秒空闲会触发超时中断，启动 CPU
- 输入 (Input)
  - 24 个拨码开关
  - 5 个按钮
  - 4 × 4 小键盘
- 输出 (Output)
  - 支持 24 个 LED 灯, 其中 8 个用于显示 CPU 状态
  - 7 段数码管, 可显示 4 Bytes
  - VGA

**MMIO 对应地址** 

| 地址                 | 读/写 | 映射内容               | 取值范围 (省略前导0)    |
| :------------------- | ----- | ---------------------- | ----------------------- |
| 0xFFFFFF00           | R     | 第 1 组拨码开关 (8 个) | 0x00 - 0xFF             |
| 0xFFFFFF04           | R     | 第 2 组拨码开关 (8 个) | 0x00 - 0xFF             |
| 0xFFFFFF08           | R     | 第 3 组拨码开关 (8 个) | 0x00 - 0xFF             |
| 0xFFFFFF0C           | W     | 第 1 组 LED (8 个)     | 0x00 - 0xFF             |
| 0xFFFFFF10           | W     | 第 2 组 LED (8 个)     | 0x00 - 0xFF             |
| 0xFFFFFF14           | R     | 按钮 1 (中)            | 0x00 - 0x01             |
| 0xFFFFFF18           | R     | 按钮 2 (上)            | 0x00 - 0x01             |
| 0xFFFFFF1C           | R     | 按钮 3 (下)            | 0x00 - 0x01             |
| 0xFFFFFF20           | R     | 按钮 4 (左)            | 0x00 - 0x01             |
| 0xFFFFFF24           | R     | 按钮 5 (右)            | 0x00 - 0x01             |
| 0xFFFFFF28           | W     | 七段数码管             | 0x00000000 - 0xFFFFFFFF |
| 0xFFFFFF2C           | R     | 4*4 小键盘是否被按下   | 0x00 - 0x01             |
| 0xFFFFFF30           | R     | 4*4 小键盘按下位置     | 0x00 - 0x0F             |
| 0xFFFFE___ (000-BFF) | W     | VGA 字符               | 0x00 - 0xFF             |
| 0xFFFFD___ (000-BFF) | W     | VGA 颜色               | 0x00 - 0xFF             |

### CPU 接口

```
```







## 使用说明





## 测试说明





## 问题及解决方案

+ **[Memory/Solved]** 内存读取数据时传入地址会延迟一个周期读取到数据，且 `sh` 和 `sb` 无法直接对内存进行操作.
  - **原因**: 使用 ip RAM 生成的内存以 32 bit 为单位进行存或读取，而 `sh` 和 `sb` 只修改其中的 16 bit 或 8 bit
  - **解决方案**:
    1. :negative_squared_cross_mark: 加快内存时钟频率，先读取再修改最后存入
    2. :white_check_mark: 使用 Cache 进行管理
+ **[Instruction `auipc`/Solved]** 指令 `auipc` 的实现.
  - **原因**: 指令 `auipc` 需要进行 pc 相关的计算，而 ALU 没有相关数据的输入
  - **解决方案**:
    1. :white_check_mark: 在 ALU 输入 rs1 的端口前添加选择器，对 pc 和 rs1_data 进行选择，同时拓宽控制信号 ALUSrc
+ **[`jalr` Data Hazard/Solved]** `ret (jalr zero, ra, 0)` 指令必须在 `ld ra, 0(sp)` 4 条指令之后，或者函数指令数必须大于 4，否则会出现异常.
  - **原因**: ra 寄存器的更改发生在 4 个周期后，而 `ret` 指令在访问 ra 寄存器时导致数据冒险
  - **解决方案**:
    1. :negative_squared_cross_mark: 保证 `ret` 指令在 `ld ra, 0(sp)` 4 条指令后执行 (如在 `ret` 指令之前插入 nop 指令)
    2. :negative_squared_cross_mark: 进行停顿 / 改进转发单元。前者过于简单，后者工作量太大，且 `ld` 指令的冒险难以解决。~~考虑后续增加记分板~~
    3. :white_check_mark: 在分支预测中加入 RAS (Return Address Stack) 结构，在遇到 `call` 或 `ret` 指令时将压入 / 弹出 ra 寄存器的内容。~~那要 ld/sd ra, 4(sp) 有何用~~ 。记录指令跳转目标地址，在 EX 阶段计算实际跳转，并判断是否预测错误，如错误则更新正确 pc 并清空错误指令。由于 EX 阶段不存在 Data Hazard，故解决.
+ **[CPU Clock Rate/Solved]** CPU 时钟频率上限较低而影响 CPU 的性能.
  - **原因**: 分支预测速度较慢，且在 ID 阶段需等待寄存器的 rs1_data 才可开始执行
  - **解决方案**:
    1. :white_check_mark: 将分支预测移到 IF 阶段进行，但由于 IF 阶段获取指令后未进行解码，因此需要对指令进行预解码 (否则不仅需要预测是否跳转，同时也需要预测该指令是否为分支指令，较为复杂)
+ **[UART/Pending]** 第一个 Byte 接收会有概率出错 / 丢失.
  - **原因**: 未知 (但大概率是 UART 串口工具发送时的小问题)
  - **解决方案**:
    1. :white_check_mark: 在第 1 条指令预先插入 `nop` 或 0x00000000
    2. :negative_squared_cross_mark: 使用课程提供的 UART IP 核
+ **[Branch Instruction Data Hazard/Pending]** `lw` 后的分支指令若存在数据冒险，在 CPU 的时钟频率较高 (50MHz) 时可能执行错误，但频率较低 (1Hz) 时不会执行错误.
  - **可能原因**: 分支预测 (Branch Predictor) 和指令缓存 (ICache) 耗时较长
  - **解决方案**:
    1. :negative_squared_cross_mark: 降低时钟频率，但是会导致 CPU 性能整体全面下降
    2. :negative_squared_cross_mark: 在 `lw` 和紧接的分支指令之间插入 `nop` 
    3. :white_check_mark: 调整预测表和缓存的大小，减少访问时间



## 总结

1. 说在最前面，也是最重要的：**仿真对了上板也可能有各种奇奇怪怪的问题！！！** 可能硬件都是这样，写代码 5 分钟，上板调试 2 小时，应尽可能安排好时间
2. 如果上板发现寄了，可以考虑考虑以下问题
   - 顶层模块接线接错了
   - 模块中某个信号的 input，output 写反了，位宽写错了
   - 时钟频率过快（毕竟仿真会理想化的假设没有延迟）
   - 有隐性的 multi-driver 存在
   - 时序逻辑应该在时钟的上升沿还是下降沿更新没有想清楚
   - reset 信号是高电平还是低电平触发
3. 实现 CPU 的过程中有很多枚举性的工作，比如 ALU，控制模块等，**一定要很仔细并且写完之后仔细检查**，真出问题了不太好 debug
4. 团队合作非常重要，一定要多和队友沟通，从一开始的设计和架构，到细节实现，到测试，再到上板，**整个 Project 非常需要充分交流和沟通！**
5. Vivado 这个工具说实话不太好用，可以使用 Verilator 仿真器和用于 CPU 差分测试的 Unicorn



## Bonus 相关说明

