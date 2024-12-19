require "Present.Present"

--@note will have both compute image and non compute image
CComputeImage = function(inComputeImageTable)
          local t = {
                    p = "CENTER_CENTER",
                    d = vec3(100, 100, 1),
                    cd = vec3(100, 100, 1),
                    src = "NETWORK" -- OR {FileName = ""}
          }
          return { CComputeImage = Default(inComputeImageTable, t) }
end

gprocess.CComputeImage = function(inPresentation, inValue, inFrameIndex, inElementName)
          local ElementName = gUnique(inElementName)
          if inValue.src == "NETWORK" then
                    if not gscreenElements[ElementName] then
                              gscreenElements[ElementName] = {
                                        cimage = gwid.CreateComputeImage(
                                                  ComputePositionByName(inValue.p, inValue.d),
                                                  inValue.cd),
                                        sampled_image = gwid.CreateSampledImage(
                                                  ComputePositionByName(inValue.p, inValue.d),
                                                  inValue.d, nil, true, nil
                                        ),
                              }
                              local push = Jkr.Matrix2CustomImagePainterPushConstant()
                              push.a = mat4(vec4(0.0), vec4(1), vec4(0.3), vec4(0.0))
                              gscreenElements[ElementName].simage = gwid.CreateQuad(
                                        ComputePositionByName(inValue.p, inValue.d),
                                        inValue.d,
                                        push,
                                        "showImage",
                                        gscreenElements[ElementName].sampled_image.mId
                              )
                    end

                    gAddFrameKeyElement(inFrameIndex, {
                              {
                                        "CComputeImage",
                                        handle = gscreenElements[ElementName],
                                        value = inValue,
                                        name = inElementName
                              }
                    })

                    if Engine.gate.android_device_connected then
                              Engine.net.BroadCast(function()
                                        Jkr.Java.InitializeCamera("BACK")
                              end)
                    else
                              print("Android Device not connected")
                    end
          end
end

ExecuteFunctions["CComputeImage"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
          local PreviousElement, inElement = GetPreviousFrameKeyElementD(inPresentation, inElement,
                    inFrameIndex, inDirection)
          local new = inElement.value
          if PreviousElement then
                    local prev = PreviousElement.value
                    local interp = glerp_3f(ComputePositionByName(prev.p, prev.d), ComputePositionByName(new.p, new.d), t)
                    interp.z = ComputePositionByName(new.p, new.d).z
                    local interd = glerp_3f(prev.d, new.d, t)
                    inElement.handle.simage:Update(interp, interd)
          else
                    inElement.handle.simage:Update(ComputePositionByName(new.p, new.d), new.d)
          end

          if Engine.gate.android_device_connected then
                    Engine.net.BroadCast(function()
                              local CameraImage = Jkr.Java.GetCameraImage(" ")
                              local Message = Jkr.Message()
                              Message:InsertVChar(CameraImage)
                              Engine.net.SendToServer(Message)
                    end)
                    local message = Engine.net.listenOnce()
                    if type(message) == "userdata" then
                              local vchar = message:GetVChar()
                              print("new.cd:", new.cd.x, new.cd.y)
                              local ivchar = Jkr.GetVCharRawFromVCharImage(vchar, math.floor(new.cd.x),
                                        math.floor(new.cd.y))
                              Jkr.FillComputeImageWithVectorChar(Engine.i, ivchar, inElement.handle.cimage.handle)
                              gwid.c:PushOneTime(Jkr.CreateDispatchable(
                                        function()
                                                  inElement.handle.cimage.CopyToSampled(
                                                            inElement.handle.sampled_image)
                                        end
                              ), 1)
                    end
          end
end
