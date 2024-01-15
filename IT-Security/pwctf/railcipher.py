def decode(n, cipher):
    if (n == 1): return cipher
    l = len(cipher)
    zig_len = n+n-2
    top = (int) (l/zig_len+1)
    bot = (int) (l/zig_len)
    output = ""
    offsets = [""]*n
    offsets[0] = cipher[:top]#+1
    for i in range(1, n-1):
        offsets[i] = cipher[top:i*2*bot]#Lav et array med cipher skåret op i tracks
    offsets[n-1] = cipher[bot:]
    for i in range(l):
        if(i%2 <> 0):
            output += cipher[offsets[]]
#    if(i%2 <> 0):


    print(offsets)

decode(3, "PF_pb}wT{3cyt_0sCwr0i")

#https://en.wikipedia.org/wiki/Rail_fence_cipher
