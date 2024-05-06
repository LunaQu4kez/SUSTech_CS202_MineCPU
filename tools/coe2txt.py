import io

filename = 'example'

with io.open(filename + '.coe', 'r', encoding='utf-8') as file1:
    lines = file1.readlines()

with open(filename + '.txt', 'a', encoding='utf-8') as file2:
    for i in range(2, 16386):
        line = lines[i]
        file2.write(line[6:8])
        file2.write(line[4:6])
        file2.write(line[2:4])
        file2.write(line[0:2])
