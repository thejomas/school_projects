import base64
import codecs

with open('challenge', 'r') as file:
    data = file.read().replace('\n', '')
# test = "0123456789"
# print(test.count(test))
# print('testing: ' + test[:2] + test[2:])
while True:
    # head, tail = tail.split(':', 1)
    if (data[:7] == 'base64:'):
        # input('Wanna use b64? ' + data[:10])
        data = str(base64.b64decode(data[7:]), "utf-8")
    elif (data[:8] == 'reverse:'):
        # input('Wanna use rev? ' + data[:10])
        data = data[8:][::-1]
    elif (data[:6] == 'rot13:'):
        # input('Wanna use rot? ' + data[:10])
        data = codecs.decode(data[6:], 'rot_13')
    elif (data[:4] == 'hex:'):
        data = bytes.fromhex(data[4:]).decode('utf-8')
    else:
        # print(len(data))
        print(data)
        # print(data[len(data)-10:])
        # data = base64.b64decode(data[:-1][:6])
        # print(data[:10])
        break

# print(data[:7])
# data = base64.b64decode(data[7:])
# data = base64.b64decode(data[7:])
# data = base64.b64decode(data[7:])
# print(data[:8])
