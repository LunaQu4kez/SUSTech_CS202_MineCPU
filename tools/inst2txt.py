import io
import os

filename = 'testcase1'

with io.open(filename, 'r', encoding='utf-8') as file1:
    lines = file1.readlines()

if os.path.exists(filename + '.txt'):
    os.remove(filename + '.txt')

with open(filename + '.txt', 'a', encoding='utf-8') as file2:
    cnt = 1
    file2.write('00000000')
    for i in range(len(lines)):
        cnt += 1
        line = lines[i]
        file2.write(line[6:8])
        file2.write(line[4:6])
        file2.write(line[2:4])
        file2.write(line[0:2])
    while cnt < 8096:
        cnt += 1
        file2.write('00000000')
