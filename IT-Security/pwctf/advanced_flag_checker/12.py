inp = "Dk7H:ob$hGc5Xj(bWYXq"
flag = ""
for i in range(len(inp)):
    flag += chr(ord(inp[i])+12)
print(flag)
