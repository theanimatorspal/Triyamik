require "Present.Present"

CAndroid = function(inCAndroidTable)
          return { CAndroid = inCAndroidTable }
end
-- TODO C defer listen = false at last,
-- do this later in execution
gprocess.CAndroid = function(inPresentation, inValue, inFrameIndex, inElementName)
          Engine.net.Server() -- dont start the server but provide  the functions
          Engine.gate[1] = function()
                    Engine = mt:Get("Engine", StateId)
                    Engine:PrepareMultiThreadingAndNetworking()
                    local gate = Engine.gate
                    local net = Engine.net
                    Engine.net.Server()
                    gate.ip_addresses = net.Start()
                    gate.net = Engine.net
                    local listen = true

                    local function android_construct_next_previous_buttons()
                              local Next = function()
                                        SHOULD_SEND_TCP = true
                                        TCP_FILE_IN:WriteFunction("CTRL",
                                                  function()
                                                            gMoveForward()
                                                  end
                                        )
                              end
                              local Prev = function()
                                        SHOULD_SEND_TCP = true
                                        TCP_FILE_IN:WriteFunction("CTRL",
                                                  function()
                                                            gMoveBackward()
                                                  end
                                        )
                              end
                              GWR.AnimationPush(MainLayout,
                                        vec3(0, 0, 50),
                                        vec3(FrameD.x, FrameD.y * 2, 50),
                                        vec3(FrameD.x, FrameD.y, 1),
                                        vec3(0, 20, 1))
                              GBASE_DEPTH = 45
                              local UpButtonAction
                              local _c = vec4(1)
                              local dimension = vec3(FrameD.x, FrameD.y, 1)
                              local down_pos = vec3(0, FrameD.y / 3.3, GBASE_DEPTH)
                              local up_pos = vec3(0, -FrameD.y / 2, GBASE_DEPTH)
                              local OverMenu = V(
                                        {
                                                  U { e = true, bc = _c },
                                                  H(
                                                            {
                                                                      U { t = "Next", bc = _c, onclick = Next },
                                                                      U { t = "Prev", bc = _c, onclick = Prev },
                                                                      U { t = "^", bc = _c, en = "UPDOWN", onclick = function()
                                                                                UpButtonAction()
                                                                      end },
                                                            },
                                                            { 0.45, 0.45, 0.1 }
                                                  ),
                                                  U { c = vec4(1), bc = _c }
                                        },
                                        { 0.65, 0.05, 0.8 }
                              )

                              OverMenu:Update(down_pos, dimension)

                              local OverMenuState = "DOWN"
                              UpButtonAction = function()
                                        local el = ELEMENTS["UPDOWN"]
                                        if OverMenuState == "DOWN" then
                                                  el:Update(el.mPosition_3f, el.mDimension_3f, F, "<>")
                                                  GWR.AnimationPush(OverMenu, down_pos, up_pos, dimension,
                                                            dimension)
                                                  OverMenuState = "UP"
                                        elseif OverMenuState == "UP" then
                                                  el:Update(el.mPosition_3f, el.mDimension_3f, F, "<>")
                                                  GWR.AnimationPush(OverMenu, up_pos, down_pos, dimension,
                                                            dimension)
                                                  OverMenuState = "DOWN"
                                        end
                              end
                    end

                    Engine.net.UDP()
                    Engine.net.StartUDP(6523)
                    local vc = Jkr.ConvertToVChar(vec4(0))
                    Jkr.SetBufferSizeUDP(#vc)

                    local android_setup_udp = function()
                              Engine.net.UDP()
                              Engine.net.StartUDP(6525)
                              local vc = Jkr.ConvertToVChar(vec4(0))
                              Jkr.SetBufferSizeUDP(#vc)
                    end

                    while listen and (not gate.application_has_ended) and (not gate.android_device_connected_tcp) do
                              net.BroadCast(
                                        function()
                                                  Engine.net.SendToServer("Connection Established")
                                        end
                              )
                              Jkr.SleepForMiliSeconds(1000)
                              local msg = net.listenOnce()
                              if type(msg) == "string" and msg == "Connection Established" then
                                        listen = false
                                        gate.android_device_connected_tcp = true
                                        net.BroadCast(android_construct_next_previous_buttons)
                                        net.BroadCast(android_setup_udp)
                                        gate.android_device_connected_udp = true
                              end
                    end
          end

          local frames = 0
          IterateEachFrame(inPresentation, function(inEachFrame, _)
                    frames = frames + 1
                    gAddFrameKeyElement(inEachFrame, {
                              {
                                        "*FANDR*",
                                        handle = nil,
                                        value = inValue,
                                        name = "__common_android_listener"
                              }
                    })
          end)

          while not Engine.gate.ip_addresses do
          end

          local layout = {};
          for i = 1, #Engine.gate.ip_addresses do
                    layout[#layout + 1] = U({
                              t = Engine.gate.ip_addresses[i],
                              f = "Huge"
                    });
          end
          local vlayout = V():Add(layout, CR(layout))
          vlayout:Update(vec3(0, 0, gbaseDepth),
                    vec3(gFrameDimension.x, gFrameDimension.y, 1))

          for i = 1, #layout do
                    gprocess.CButton(inPresentation, CButton(layout[i]).CButton, 1,
                              "__common_ip_address_" .. i)
                    local out = Copy(CButton(layout[i]).CButton)
                    out.p = vec3(100 * gFrameDimension.x, 100 * gFrameDimension.y, 1)
                    if frames > 1 then
                              gprocess.CButton(inPresentation, out, 2,
                                        "__common_ip_address_" .. i)
                    end
          end

          -- for i = 1, #layout do
          --           gprocess.CButton(inPresentation, CButton(layout[i]).CButton, inFrameIndex,
          --                     "__common_ip_address_" .. i)
          -- end
end


TCP_FILE_IN = Jkr.FileJkr()

SHOULD_SEND_TCP = false
TCP_FILE_OUT = Jkr.FileJkr()
UDP_FILE_OUT = Jkr.FileJkr()

gFUNCTIONS_TO_BE_SEND_TO_ANDROID = {}
local CURRENT_ANDROID_CONTROL = 0
local sent = false
ExecuteFunctions["*FANDR*"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
          TCP_FILE_IN:Clear()
          local func = gFUNCTIONS_TO_BE_SEND_TO_ANDROID[inFrameIndex]
          if not Engine.net.listenOnce then
                    Engine.net.Server()
          end
          if Engine.gate.android_device_connected_tcp then
                    do
                              if not sent then
                                        Engine.net.BroadCast(function()
                                                  GWR.c:Push(Jkr.CreateUpdatable(
                                                            function()
                                                                      SHOULD_SEND_TCP = true
                                                                      TCP_FILE_IN:WriteVec4("ACC", vec4(3, 8, 2, 1))
                                                            end
                                                  ))
                                        end)
                                        sent = true
                              end
                              if func then
                                        -- local vchar = TCP_FILE_OUT:GetDataFromMemory()
                                        -- local msg = Jkr.Message()
                                        -- msg:InsertVChar(vchar)
                                        -- net.BroadCast(msg)
                                        -- SHOULD_SEND_TCP = false
                                        if CURRENT_ANDROID_CONTROL ~= inFrameIndex then
                                                  Engine.net.BroadCast(func)
                                                  CURRENT_ANDROID_CONTROL = inFrameIndex
                                        end
                                        -- TCP_FILE_OUT:Clear()
                              end
                    end
                    local Message = Engine.net.listenOnce()
                    if type(Message) == "function" then
                              Message()
                    elseif type(Message) == "userdata" then
                              local vchar = Message:GetVChar()
                              TCP_FILE_IN:PutDataFromMemory(vchar)
                              if (TCP_FILE_IN:HasEntry("ACC")) then
                                        local ac = TCP_FILE_IN:ReadVec4("ACC")
                              end
                              if (TCP_FILE_IN:HasEntry("CTRL")) then
                                        local f = load(TCP_FILE_IN:ReadFunction("CTRL"))
                                        f()
                              end
                    end
          end
          if Engine.gate.__common_function then
                    Engine.gate.__common_function()
          end
end
