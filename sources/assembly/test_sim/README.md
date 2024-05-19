# Test Code

包含 10 个 .asm 和对应的 .coe，为初步测试 CPU 正确性的文件



| 测试  | 内容                                           | 结果 |
| ----- | ---------------------------------------------- | ---- |
| test1 | 测试 `lb` 和 `sb`，拨动拨码开关对应 Led 灯亮起 | :white_check_mark: |
| test2 | 测试前递单元                                   | :white_check_mark: |
| test3 | 测试数据冒险停顿                               | :white_check_mark: |
| test4 | 测试分支跳转                                   | :white_check_mark: |
| test5 | 使用循环测试分支预测                           | :white_check_mark: |
| test6 | 测试叶子方法的调用                             | :white_check_mark: |
| test7 | 通过递归测试非叶子方法的调用(fib)                | :white_check_mark: |
| test8 | 通过 ecall 测试异常                            | :white_check_mark: |
| test9 | 测试 DCache 写回功能 |:white_check_mark:|
| test10| 测试 ld 后接 beq 时的数据冒险                   | :white_check_mark: |
