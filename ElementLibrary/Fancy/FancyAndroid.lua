require "Present.Present"

FancyAndroid = function(inFancyAndroidTable)
          return { FancyAndroid = inFancyAndroidTable }
end
-- TODO Fancy defer listen = false at last,
-- do this later in execution
gprocess.FancyAndroid = function(inPresentation, inValue, inFrameIndex, inElementName)
          Engine.net.Server() -- dont start the server but provide  the functions
          Engine.gate[0] = function()
                    Engine = mt:Get("Engine", StateId)
                    Engine:PrepareMultiThreadingAndNetworking()
                    local gate = Engine.gate
                    local net = Engine.net
                    Engine.net.Server()
                    net.Start()
                    gate.net = Engine.net
                    local listen = true
                    while listen do
                              if gate.application_has_ended == true then
                                        print("OUT")
                                        listen = false
                              end
                              net.BroadCast(
                                        function()
                                                  Engine.net.SendToServer("Connection Established")
                                        end
                              )
                              Jkr.SleepForMiliSeconds(100000)
                              local msg = net.listenOnce()
                              if type(msg) == "string" and msg == "Connection Established" then
                                        listen = false
                                        gate.__fancy_android_device_connected = true
                                        net.BroadCast(function()
                                                  gwr = Jkr.CreateGeneralWidgetsRenderer(nil, Engine.i, w, e)
                                                  f = gwr.CreateFont("font.ttf", 14)
                                                  REMOTE_NEXT_BUTTON = gwr.CreatePressButton(vec3(0, 0, 20),
                                                            vec3(framed.x, framed.y / 2, 1),
                                                            function()
                                                                      Engine.net.SendToServer(function()
                                                                                print("FUCK THAT")
                                                                                gMoveForward()
                                                                      end)
                                                            end, false, f, "Next",
                                                            vec4(0, 0, 0, 1), vec4(1))
                                                  REMOTE_NEXT_BUTTON:Update(vec3(0, 0, 20),
                                                            vec3(framed.x, framed.y / 2, 1))


                                                  REMOVE_PREV_BUTTON = gwr.CreatePressButton(vec3(0, 0, 20),
                                                            vec3(framed.x, framed.y / 2, 1), function()
                                                                      Engine.net.SendToServer(function()
                                                                                print("FUCK THAT PREV")
                                                                                gMoveBackward()
                                                                      end)
                                                            end, false, f, "Previous",
                                                            vec4(0, 0, 0, 1), vec4(1))

                                                  REMOVE_PREV_BUTTON:Update(vec3(0, framed.y / 2, 20),
                                                            vec3(framed.x, framed.y / 2, 1))
                                        end
                                        )
                              end
                    end
          end
          IterateEachFrame(inPresentation, function(inEachFrame, _)
                    gAddFrameKeyElement(inEachFrame, {
                              {
                                        "*FANDR*",
                                        handle = nil,
                                        value = inValue,
                                        name = "__fancy_android_listener"
                              }
                    })
          end)
end


ExecuteFunctions["*FANDR*"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
          if not Engine.net.listenOnce then
                    Engine.net.Server()
          end
          if Engine.gate.__fancy_android_device_connected then
                    local Message = Engine.net.listenOnce()
                    if type(Message) == "function" then
                              Message()
                    end
          end
          if Engine.gate.__fancy_function then
                    Engine.gate.__fancy_function()
          end
end
