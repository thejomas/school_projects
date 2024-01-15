newmap = {
    2: "PostFail",
    4: "a",
    5: "b",
    6: "c",
    7: "d",
    8: "e",
    9: "f",
    10: "g",
    11: "h",
    12: "i",
    13: "j",
    14: "k",
    15: "l",
    16: "m",
    17: "n",
    18: "o",
    19: "p",
    20: "q",
    21: "r",
    22: "s",
    23: "t",
    24: "u",
    25: "v",
    26: "w",
    27: "x",
    28: "y",
    29: "z",
    30: "1",
    31: "2",
    32: "3",
    33: "4",
    34: "5",
    35: "6",
    36: "7",
    37: "8",
    38: "9",
    39: "0",
    40: "Enter",
    41: "esc",
    42: "del",
    43: "tab",
    44: "space",
    45: "-",
    47: "[",
    48: "]",
    56: "/",
    57: "CapsLock",
    79: "RightArrow",
    80: "LetfArrow"
}

myKeys = open('hexoutput.txt')
i = 1
flag = ""
for line in myKeys:
    bytesArray = bytearray.fromhex(line.strip())

    #print "Line Number: " + str(i)
    for byte in bytesArray:
        if byte != 0:
            keyVal = int(byte)
            # print("KeyVal:", keyVal)
            if keyVal in newmap and keyVal != 2:# and ((keyVal >= 4 and keyVal <= 39) or (keyVal >= 45 and keyVal <= 56))
                #print "Value map : " + str(keyVal) + " — -> " + newmap[keyVal]
                flag += newmap[keyVal]
            else:
                print ("No map found for this value: " + str(keyVal))

                #print format(byte, ‘02X’)
                i+=1
print(flag)
# pwctf7p4ck3t33//5p1tt1ng33//k3yb04rd0

# PwCTF{p4ck3t33_5p1tt1ng33_k3yb04rd}