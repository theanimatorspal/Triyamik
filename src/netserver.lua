Jkr.StartUDP(6001)

local message = Jkr.ConvertToVChar(vec3(5.5678910, 6.5678910, 7.5678910))
Jkr.SetBufferSizeUDP(#message)

while true do
          if not Jkr.IsMessagesBufferEmptyUDP() then
                    local poped = Jkr.PopFrontMessagesBufferUDP()
                    local v3 = Jkr.ConvertFromVChar(vec3(0), poped)
                    print("MESSAGE REC: ", v3.x, v3.y, v3.z)
          end
end
