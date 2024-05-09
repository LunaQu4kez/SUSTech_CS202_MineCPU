import io

filename = '../sources/assembly/ecall'

def pad(n: int):
    return hex(n * 4)[2::].zfill(4)

with io.open(filename + '.coe', 'r', encoding='utf-8') as file1:
    lines = file1.readlines()

with open(filename + '.txt', 'a', encoding='utf-8') as file2:
    for i in range(2, 100):
        line = f"            32'h1c09{pad(i - 2)}: edataa = 32'h{lines[i].strip(',\n')};\n"
        file2.write(line)