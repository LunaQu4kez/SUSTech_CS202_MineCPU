<div align=center>

# SUSTech CS202 Course Project: MineCPU

南方科技大学 2024 年春季 `CS202 计算机组成原理` 的课程 Project RISC-V CPU（标准五级流水线版）

</div>



## 功能

能跑再说...



## 小组成员及分工

| 成员 | CPU核心 | IO & UART | 仿真 & 测试 | 汇编 | 报告 |
| --- | --- | --- | --- | --- | --- |
| [@wLUOw](https://github.com/wLUOw) |  |  |  |  |  |
| [@Yao1OoO](https://github.com/Yao1OoO) |  |  |  |  |  |
| [@chanbengz](https://github.com/chanbengz) |  |  |  |  |  |



## 项目结构

```
MineCPU
├── docs
│   ├── CPU.*                  # design draft
│   ├── Report.md              # report of this project
│   ├── cpu_design.pdf         # CPU design from textbook
│   └── riscv-card.pdf         # ISA reference
├── program
│   ├── lib                    # library of some API
│   └── list.md                # maybe useful
├── sources                                              
│   ├── assembly               # assembly program for test and fun
│   │   ├── *.asm              
│   │   └── *.coe             
│   ├── constrain
│   │   └── constr.xdc         # constrain file
│   ├── core
│   │   └── *.sv               # code of CPU core
│   ├── io
│   │   └── *.sv               # code related to IO
│   ├── sim
│   │   ├── *.cpp              # verilator simulation
│   │   └── *.sv               # vivado simulation
│   └── Top.v                  # top module of MineCPU
├── test
│   └── DiffTest.cpp           # differential test of CPU
├── .gitignore
├── LICENSE
└── README.md
```



## 完成列表

- [x] CPU 核心
  - [x] IF Stage
  - [x] ID Stage
    - [x] 立即数生成模块
    - [x] 寄存器模块
    - [x] 控制模块
    - [x] 数据冒险停顿模块
    - [x] 分支预测模块
  - [x] EX Stage
    - [x] ALU
      - [x] RV32I
      - [ ] RV32M *
    - [x] BRU
    - [x] 前递模块
  - [x] MEM Stage
  - [x] WB Stage
  - [x] Memory
  - [ ] 异常控制 *
- [ ] IO
  - [ ] Led & 7 段数码管
  - [ ] 拨码开关 & 按钮
  - [ ] VGA *
  - [ ] UART *
- [ ] 软件
  - [ ] 测试场景1
  - [ ] 测试场景2
  - [ ] Pac-Man *



## 使用方法

还是先略...



## 总结与注意事项

最后再写
