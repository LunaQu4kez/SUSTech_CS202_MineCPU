main:
    lb a0, 0(gp)
    sb a0, 12(gp)
    lb a0, 4(gp)
    sb a0, 16(gp)
    lb a0, 8(gp)
    sb a0, 20(gp)
    j main