Jkr.StartUDP(6000)

local message = Jkr.ConvertToVChar(vec3(5.5678910, 6.5678910, 7.5678910))
Jkr.SetBufferSizeUDP(#message)

Jkr.SendUDPBlocking(message, "127.0.0.1", 6001)
