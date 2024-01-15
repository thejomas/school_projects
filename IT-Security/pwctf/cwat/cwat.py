#!/usr/bin/env python
# CWAT - PwCtf 2020
import sys

# Rotates either small or capital letters
def caesar(original, base):
    letter = ord(original)

    # Ensures the base rotation does not exceed 26
    # If the base is 28, it exceeds 26, and ends up being 2 (after modulus)
    base = base%26

    # If the letter is a space, underscore or curly brackets, just return it without rotating
    if (letter == 32 or letter == 95 or letter == 123 or letter == 125):
        return letter

    # If capital letter
    if (ord("A") <= letter and letter <= ord("Z")):
        # If the base exceeds the alphabet
        if (ord("Z") < (letter+base)):
            return (letter + base)-26
        else:
            return letter+base

    # If non-capital letter
    if (ord("a") <= letter and letter <= ord("z")):
        # If the base exceeds the alphabet
        if (ord("z") < (letter+base)):
            return (letter + base)-26
        else:
            return letter+base

    # If a non-alphabet letter was given, exit
    else:
        print ("Error, non-alphabet letter given")
        exit(1)


def encrypt(originalString):

    # Result to be printed
    result = []

    # Length of original string
    length = len(originalString)

    # So what's the cipher/base used for each letter..? Wouldn't you like to know!!
    for (letter, cipher) in zip(originalString, range(1,len(originalString)+1)):
        result.append(caesar(letter,cipher*cipher))

    # Prints the now 'encrypted' word given
    return ("".join(map(chr,result)))

def main(argv):
    # with open(argv, 'r') as file:
    #     data = file.read().replace('\n', '')
    # Encrypt each argument given
    # for x in range(1,len(argv)):
    #     encrypt(argv[x])
    flag = "QaLJE{QtLo_wF_r_YqOI_bXrH_gpJw_WxPh_Sm_QraVmo_Se_IoSvvn_XyR_GeU_Ack_EDRDTIosscf_rj}"
    for x in range(25):
        flag = encrypt(flag)
        if (x==24): print(flag)
    # print(encrypt(flag))
# Main
if __name__ == '__main__':
    if not (sys.argv[1:]):
        print ("ERROR  : You need to give at least one argument...")
        print ("EXAMPLE: python cwat.py 'davs'")
    else:
        main(sys.argv)
