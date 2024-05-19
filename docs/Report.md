

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
| 2024-5-20 | 完成报告 |

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
  + ecall: 外部设备驱动, 通过 MMIO 进行输入输出, API doc 见后续 Environment Call
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

```systemverilog
module Top (
    // clk -> cpuclk, memclk, vgaclk
    input                     clk, rst,
    // uart related
    input  logic              rx,
    // interact with devices
    input  logic [`SWCH_WID ] switches1, switches2, switches3,
    input  logic              bt1, bt2, bt3, bt4, bt5,
    input  logic [`KBPIN_WID] kp,
    output logic [`LED_WID  ] led1_out, led2_out, led3_out,
    output logic [`LED_WID  ] seg_en, seg_out,
    // vga interface
    output logic              hsync,              // line synchronization signal
    output logic              vsync,              // vertical synchronization signal
    output logic [`COLOR_WID] red,
    output logic [`COLOR_WID] green,
    output logic [`COLOR_WID] blue
);
```

MineCPU 的输入信号包含：

- 一个 100MHz 的晶振时钟
- 高电平复位信号 rst
- UART 通信串口 rx
- 3 组拨码开关
- 5 个按钮
- 4 × 4 小键盘信号

输出信号包含：

- 3 组 led 
- 7 段数码管的控制信号
- VGA 的控制信号



### CPU 内部结构

<div align="center">
    <img src="./pic/schematic1.png" alt="" height="200">
    <img src="./pic/schematic2.png" alt="" height="200">
</div>

<div align="center">
    <img src="./pic/schematic3.png" alt="" height="135">
    <img src="./pic/schematic4.png" alt="" height="135">
</div>

<div align="center">
    <img src="./pic/schematic5.png" alt="" height="160">
    <img src="./pic/schematic6.png" alt="" height="160">
</div>

<div align="center">
    <img src="./pic/schematic7.png" alt="" height="135">
    <img src="./pic/schematic8.png" alt="" height="135">
</div>

以上是 Vivado 生成的 Schematic 图，但并不能清晰的展现总体结构，下图清晰的展现了 MineCPU 的设计架构与模块间的关联

<div align="center">
    <img src="./pic/architecture.png" alt="" width="600">
</div>

下面将对主要模块端口及功能进行说明 **(不包含 5 个 Stage 模块和 Stage 间的 Regs，它们只起到封装和传输信号作用)** 

#### ALU

```systemverilog
module ALU (
    input  logic [`DATA_WID ] src1, src2,
    input  logic [`ALUOP_WID] ALU_op,
    output logic [`DATA_WID ] result
);
```

ALU 模块，起计算作用，输入 32 bit 数据 src1 和 src2 及控制信号 ALU_op，输出 32 bit 的结果 result.

#### Branch_Predictor *

见 Bonus 部分

#### BRU (Branch Unit)

```systemverilog
module BRU (
	input  logic [`DATA_WID ] src1, src2, pc, imm,
	input  logic [`BRUOP_WID] BRU_op,
	input  logic              Jalr,
	output logic [`DATA_WID ] old_pc,
	output logic              old_branch, result
);
```

用于处理分支指令的结果，可理解为分支指令的专属 ALU，同时处理下一条指令的真实 pc，并判断分支预测是否正确即是否需要停顿.

#### Const

用于储存所有常数的头文件 (.svh)

#### Control

```systemverilog
module Control (
    input  logic [`DATA_WID] inst, 
    output logic [`CTRL_WID] total_ctrl
);
```

控制单元，输入 32 bit 的指令，输出位宽为 17 bit 的控制总线，包含 EX 阶段、MEM 阶段和 WB 阶段的控制信号

#### CPU

```systemverilog
module CPU (
    input  logic               cpuclk, memclk, rst_n,
    // uart related
    input  logic [`DATA_WID  ] uart_data,
    input  logic [`DATA_WID  ] uart_addr,
    input  logic               uart_done,
    // interact with devices
    input  logic [`LED_WID   ] switches1, switches2, switches3,
    input  logic               bt1, bt2, bt3, bt4, bt5,
    input  logic [`KBCODE_WID] kb_idx,
    output logic [`LED_WID   ] led1_out, led2_out, led3_out,
    output logic [`DATA_WID  ] seg1_out,
    // vga interface
    input  logic [`VGA_ADDR  ] vga_addr,
    output logic [`INFO_WID  ] char_out,
    output logic [`INFO_WID  ] color_out,
    // debug port
    output logic [`DATA_WID  ] pc_t,
    output logic [`DATA_WID  ] inst_t
);
```

CPU 的顶层模块，仅包含 CPU，不包含 IO 处理如 7 段数码管和 VGA，也不包含 UART.

#### DCache *

见 Bonus 部分

#### Forward *

见 Bonus 部分

#### Hazard *

见 Bonus 部分

#### ICache *

见 Bonus 部分

#### ImmGen

```systemverilog
module ImmGen (
    input  logic [`DATA_WID] inst,
    output logic [`DATA_WID] imm
);
```

立即数生成模块，输入 32 bit 指令，根据指令类型生成符号扩展的 32 bit 立即数

#### Memory

```systemverilog
module Memory (
    input                      rst,
    input                      clka, clkb,
    input  logic [`DATA_WID  ] addra, addrb,
    input  logic [`DATA_WID  ] write_datab,
    input  logic               web, // port b write enable
    output logic [`DATA_WID  ] dataa, datab,
    // IO related
    input  logic [`SWCH_WID  ] switches1, switches2, switches3,
    input                      bt1, bt2, bt3, bt4, bt5,   // middle, up, down, left, right
    input  logic [`KBCODE_WID] kb_idx,                    // keyboard index: 0 1 2 3 4 5 6 7 8 9 A B C D * #
    output logic [`DATA_WID  ] seg1_out,
    output logic [`LED_WID   ] led1_out, led2_out,
    // vga related
    input  logic [`VGA_ADDR  ] vga_addr,
    output logic [`INFO_WID  ] char_out,
    output logic [`INFO_WID  ] color_out
);
```

内存模块，输入输出包含内存相关信号，IO 相关信号. IO 采用轮询的 MMIO 模式.

#### PC

```systemverilog
module PC (
    input                    clk, rst,
    input  logic             PC_Write,   // hazard stall 1: yes, 0: no
    input  logic             icache_stall,
    input  logic             dcache_stall,
    input  logic [`DATA_WID] new_pc,     // next pc
    output logic [`DATA_WID] pc_out
);
```

管理指令 pc 的模块，输入包含因与内存交互导致数据冒险的停顿信号，指令缓存和数据缓存未命中的停顿信号，输出包含新 pc.

#### RegisterFile

```systemverilog
module RegisterFile (
    input  logic             clk, rst,
    input  logic [`REGS_WID] read_reg_1, read_reg_2, write_reg,
    input  logic [`DATA_WID] write_data,
    input  logic             RegWrite,
    output logic [`DATA_WID] read_data_1, read_data_2
);
```

寄存器模块，输入包含时钟和复位信号，寄存器写入信号，和5 bit 位宽的读取寄存器的 rd1，rd2，写入寄存器的 write_reg. 输出包含 32 bit 的从寄存器读取到的数据.

#### CPU_Clk

```systemverilog
module CPU_Clk (
    input clk,
    output clk0
);
```

注意到 ip Clocking Wizard 能够生成的时钟范围仅为 6MHz 到 80MHz，因此如果需要生成更低频比如 1MHz 的时钟，需要分频器，而 CPU_Clk 模块的作用就是分频.

#### Keyboard

```systemverilog
module Keyboard (
    input  logic [`KBPIN_WID ] kp,
    output logic [`KBCODE_WID] kb_idx
);
```

小键盘的控制模块.

#### Queue *

见 Bonus 部分

#### Seg7Tube

```systemverilog
module Seg7Tube(
    input               clk, rst_n,                // clock, reset
    input        [31:0] data_in,                   // 7-segment display data
    output logic [7:0]  seg_en,                    // scan signal
    output logic [7:0]  seg_out                    // 7-segment display
);
```

七段数码管的控制模块，数据要显示的数据，输出七段数码管的扫描信号和使能信号.

#### UART *

见 Bonus 部分

#### VGA *

见 Bonus 部分



## 使用说明

下图为 Minisys 的使用说明图例

<div align="center">
    <img src="./pic/minisys.png" alt="" width="500">
</div>

#### 详细使用步骤如下：

 1. **创建 Vivado 项目**：通过 Vivado 创建一个 RTL Project，Project device 选择 **xc7a100tfgg484-1**，Target Language设置为 VHDL，设置完毕并创建项目后，将所有 System Verilog 文件作为设计文件导入，再将 constr.xdc 作为约束文件导入

 2. **创建 IP 核** 

    - 创建 Clocking Wizard

      - 将组件名称改为 VGAClkGen
      - 选择 PLL 时钟
      - 将 clk_in1 的 Source 修改为 Global buffer
      - 将 clk_out1 的频率设置为 40MHz 并取消 reset 信号和 locked 信号

      <div align="center">
          <img src="./pic/ip1.png" alt="" width="370">
          <img src="./pic/ip2.png" alt="" width="370">
      </div>

      <div align="center">
          <img src="./pic/ip3.png" alt="" width="370">
          <img src="./pic/ip4.png" alt="" width="370">
      </div>

    - 创建 Block Memory Generator

      - 将组件名称改为 Mem
      - Memory Type 选择 True Dual Port RAM
      - Port A 的 Write Width 修改为 32，Write Depth 修改为 16384 (Read Width, Read Depth 和 Port B 的相关参数会自动修改)

      <div align="center">
          <img src="./pic/ip5.png" alt="" width="370">
          <img src="./pic/ip6.png" alt="" width="370">
      </div>

 3. **在 Vivado 中依次 Synthesis -> Implementation -> Generate Bitstream (注: 可以在等待过程中先进行下面的第 4 和 5 步)，将生成比特流文件 (.bit) 烧写进 FPGA** 

 4. **获取执行代码的机器码文件**：使用 RARS 打开需要执行的汇编代码，点击运行，再点击左上角 File，选择 Dump Memory，Dump Format 选择 Hexadecimal Text，点击 Dump To File... 并输入文件名后保存 (**注: 不需要带后缀**)

    <div align="center">
        <img src="./pic/rars1.png" alt="" height="220">
        <img src="./pic/rars2.png" alt="" height="220">
    </div>

 5. **获取 UART 串口传输的文件**：将上一步得到的文件放在指令转换脚本 inst2txt.py 同一目录下，打开 inst2txt.py 将第 4 行的 `filename` 改为上一步所得的文件的名称，运行脚本，得到一个 .txt 文件 (如 test.txt)，这是要通过 UART 串口传输给 CPU 运行的指令

 6. **通过 UART 加载程序并运行**：打开串口工具 UARTAssist.exe，串口号选择 COM6 (一般来说直接选能选的最后一个)，波特率设置为 115200，打开连接，发送选项选择 “按十六进制发送” 并 “启用文件数据源...”，选择上一步得到的 .txt 文件并确定，然后点击发送，发送完毕后 CPU 将会自动开始运行

    <div align="center">
        <img src="./pic/uart1.png" alt="" width="400">
    </div>





## 测试说明









## 非 Bonus 部分的问题及解决方案

+ **[Memory/Solved]** 内存读取数据时传入地址会延迟一个周期读取到数据，且 `sh` 和 `sb` 无法直接对内存进行操作.
  - **原因**: 使用 ip RAM 生成的内存以 32 bit 为单位进行存或读取，而 `sh` 和 `sb` 只修改其中的 16 bit 或 8 bit
  - **解决方案**:
    1. :negative_squared_cross_mark: 加快内存时钟频率，先读取再修改最后存入
    2. :white_check_mark: 使用 Cache 进行管理



## Bonus 相关说明

### MineCPU 性能优化

MineCPU Project 主要采用了两个方向上的性能优化，第一个是采用**五级流水线**的结构，第二个是加入了指令缓存 (ICache) 和数据缓存 (DCache)，涉及的模块如下

- Forward、Hazard 为解决数据冒险的控制流水线前递和停顿的模块
- Branch_Predictor 为解决控制冒险的分支预测模块
- ICache、DCache 分别为指令和数据缓存，为提升与内存交互的效率的缓存模块

#### Forward





#### Hazard





#### Branch_Predictor

```systemverilog
module Branch_Predictor # (
    parameter BHT_SIZE = 4,
    parameter RAS_SIZE = 4
) (
    input  logic             clk, rst,
    input  logic             stall,
    // whether to branch and predict, excp is ecall
    input  logic             branch, predict, excp, sret,
    // calculate branch target
    input  logic [`REGS_WID] rs1, rd,
    input  logic [`DATA_WID] pc, imm,
    // update table, and predict fail
    input  logic [`DATA_WID] old_pc, old_branch_pc, old_predict_pc,
    input  logic             old_predict, old_actual, old_branch,
    // target pc is predicted pc, pass predict_result to EX, predict_fail to flush
    output logic [`DATA_WID] target_pc,
    output logic             predict_result, predict_fail
);
```

分支预测模块在 IF 阶段进行，由于在 IF 阶段并未将指令解码，而预测某指令是否为分支指令过于复杂，因此采取预解码的方式判断该指令是否为分支指令。分支预测的实现方式为状态机，有强不跳转、弱不跳转、弱跳转、强跳转这 4 种状态，`history_table` 中假设所有分支初始都是弱不跳转，预测时按照状态处于跳转或不跳转进行预测，若预测失败，流水线清空错误指令并执行正确指令，并在每次预测后更新 `history_table`.

此外，分支预测中还加入了返回地址栈 [Return Address Stack (RAS)]，用于解决方法调用结束后返回时 ra 寄存器可能存在的数据冒险. RAS 在遇到 `call` 或 `ret` 指令时将压入 / 弹出 ra 寄存器的内容，记录指令跳转目标地址，在 EX 阶段计算实际跳转，并判断是否预测错误，如错误则更新正确 pc 并清空错误指令.

#### ICache





#### DCache





### MineCPU 功能扩展





### UART 的实现

本项目的 UART 波特率为 115200，参数为 8 bit 数据配合 1 bit 停止位. 由于寻址单位为 32 bit，因此需要一个队列来实现接受并计数 4 byte 数据后统一存进内存.

#### Queue

```systemverilog
module Queue (
    input  logic        clk, rst,
    input  logic [7:0]  data_in,
    input  logic        ready_in,
    output logic [31:0] data_out,
    output logic [31:0] addr_out
);
```







### VGA 的实现





### Pacman (吃豆人) 小游戏的实现







### Bonus 部分的问题及解决方案

+ **[Instruction `auipc`/Solved]** 指令 `auipc` 的实现.
  - **原因**: 指令 `auipc` 需要进行 pc 相关的计算，而 ALU 没有相关数据的输入
  - **解决方案**:
    1. :white_check_mark: 在 ALU 输入 rs1 的端口前添加选择器，对 pc 和 rs1_data 进行选择，同时拓宽控制信号 ALUSrc
+ **[`jalr` Data Hazard/Solved]** `ret (jalr zero, ra, 0)` 指令必须在 `ld ra, 0(sp)` 4 条指令之后，或者函数指令数必须大于 4，否则会出现异常.
  - **原因**: ra 寄存器的更改发生在 4 个周期后，而 `ret` 指令在访问 ra 寄存器时导致数据冒险
  - **解决方案**:
    1. :negative_squared_cross_mark: 保证 `ret` 指令在 `ld ra, 0(sp)` 4 条指令后执行 (如在 `ret` 指令之前插入 nop 指令)
    2. :negative_squared_cross_mark: 进行停顿 / 改进转发单元。前者过于简单，后者工作量太大，且 `ld` 指令的冒险难以解决。~~考虑后续增加记分板~~
    3. :white_check_mark: 在分支预测中加入 RAS (Return Address Stack) 结构，在遇到 `call` 或 `ret` 指令时将压入 / 弹出 ra 寄存器的内容。记录指令跳转目标地址，在 EX 阶段计算实际跳转，并判断是否预测错误，如错误则更新正确 pc 并清空错误指令。由于 EX 阶段不存在 Data Hazard，故解决.
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
6. 尽可能在设计的时候考虑全面，尽管可能会花费更多的时间. MineCPU 在最初设计时采用的是在 ID 阶段进行分支预测，后面由于 ID 阶段的效率过低，改为在 IF 阶段预测，架构上进行了较大的修改，十分麻烦且易错

