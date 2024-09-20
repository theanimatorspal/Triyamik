require("Present.require")
--[============================================================[
          EXECUTE  FUNCTIONS
          these functions actually show the presenation and update it interactively
          element = { "TEXT", handle = screenElements[ElementName], value = inValue, name = ElementName },
]============================================================]
local sub = string.sub
local byte = string.byte
local char = string.char
local max = math.max
local rep = string.rep

function TextInterop(inText1, inText2, t)
          if inText1 == inText2 then
                    return inText1
          end

          local inText1_length = #inText1
          local inText2_length = #inText2
          local max_length = max(inText1_length, inText2_length)

          inText1 = inText1 .. rep(" ", max_length - inText1_length)
          inText2 = inText2 .. rep(" ", max_length - inText2_length)

          local interm = {}

          for i = 1, max_length do
                    local x1 = byte(inText1, i)
                    local x2 = byte(inText2, i)
                    local char = char(math.floor(glerp(x1, x2, t)))
                    interm[i] = char
          end

          local final_length = math.floor(glerp(inText1_length, inText2_length, t))

          return table.concat(interm):sub(1, final_length)
end

GetPreviousFrameKeyElement = function(inPresentation, inElement, inFrameIndex)
          local PreviousFrame = gFrameKeys[inFrameIndex - 1]
          -- print("FrameKeys", inspect(gFrameKeys))
          if PreviousFrame then
                    -- tracy.ZoneBeginN("GetPreviousFrameKeyElement")
                    local keysCount = #PreviousFrame
                    for i = 1, keysCount, 1 do
                              local Key = PreviousFrame[i]
                              local elements = Key.Elements
                              local elementCount = #elements
                              for i = 1, elementCount, 1 do
                                        if elements[i].name == inElement.name then
                                                  return elements[i]
                                        end
                              end
                    end
                    -- tracy.ZoneEnd()
          end
end

GetPreviousFrameKeyElementD = function(inPresentation, inElement, inFrameIndex, inDirection)
          local PreviousElement = 0
          if inDirection == 1 then
                    PreviousElement = GetPreviousFrameKeyElement(inPresentation, inElement, inFrameIndex)
          elseif inDirection == -1 then
                    PreviousElement = GetPreviousFrameKeyElement(inPresentation, inElement, inFrameIndex + 2)
                    if PreviousElement then
                              local newel = PreviousElement
                              PreviousElement = inElement
                              inElement = newel
                    end
          end
          return PreviousElement, inElement
end

ExecuteFunctions = {
          TEXT = function(inPresentation, inElement, inFrameIndex, t, inDirection)
                    local PreviousElement, inElement = GetPreviousFrameKeyElementD(inPresentation, inElement,
                              inFrameIndex, inDirection)

                    local new = inElement.value
                    if PreviousElement then
                              local prev = PreviousElement.value
                              local interP = glerp_3f(
                                        ComputePositionByName(prev.p, prev.d),
                                        ComputePositionByName(new.p, inElement.value.d),
                                        t
                              )
                              local interD = glerp_3f(prev.d, new.d, t)
                              local interC = glerp_4f(prev.c, new.c, t) -- C means Color here
                              local interT = TextInterop(prev.t, new.t, t)
                              inElement.handle:Update(interP, interD, gFontMap[inElement.value.f], interT, interC)
                    else
                              inElement.handle:Update(ComputePositionByName(new.p, new.d),
                                        vec3(new.d.x, new.d.y, new.d.z))
                    end
          end,
          BUTTON = function(inPresentation, inElement, inFrameIndex, t, inDirection)
                    local PreviousElement, inElement = GetPreviousFrameKeyElementD(inPresentation, inElement,
                              inFrameIndex,
                              inDirection)
                    local new = inElement.value
                    if PreviousElement then
                              local prev = PreviousElement.value
                              local interP = glerp_3f(
                                        ComputePositionByName(prev.p, prev.d),
                                        ComputePositionByName(new.p, inElement.value.d),
                                        t
                              )
                              local interD = glerp_3f(prev.d, new.d, t)
                              local interC = glerp_4f(prev.c, new.c, t)
                              inElement.handle:Update(interP, interD)
                    else
                              inElement.handle:Update(ComputePositionByName(new.p, new.d),
                                        vec3(new.d.x, new.d.y, new.d.z))
                    end
          end,
          CIMAGE = function(inPresentation, inElement, inFrameIndex, t, inDirection)
                    local PreviousElement, inElement = GetPreviousFrameKeyElementD(inPresentation, inElement,
                              inFrameIndex,
                              inDirection)
                    local new = inElement.value
                    local shader_parameters
                    if PreviousElement then
                              local prev = PreviousElement.value
                              local interP = glerp_3f(
                                        ComputePositionByName(prev.p, prev.d),
                                        ComputePositionByName(new.p, new.d),
                                        t
                              )
                              local interD = glerp_2f(prev.d, new.d, t)
                              local shader_parameters_ = {
                                        threads = glerp_3f(prev.shader_parameters.threads, prev.shader_parameters
                                                  .threads, t),
                                        p1 = glerp_4f(prev.shader_parameters.p1, new.shader_parameters.p1, t),
                                        p2 = glerp_4f(prev.shader_parameters.p2, new.shader_parameters.p2, t),
                                        p3 = glerp_4f(prev.shader_parameters.p3, new.shader_parameters.p3, t),
                              }
                              inElement.handle.sampledImage:Update(interP, interD)
                              shader_parameters = shader_parameters_
                    else
                              inElement.handle.sampledImage:Update(ComputePositionByName(new.p, new.d),
                                        vec3(new.d.x, new.d.y, 1))
                              shader_parameters = new.shader_parameters
                    end

                    local computeImage = inElement.handle.computeImage
                    local painter = gscreenElements[new.shader]
                    local threads = shader_parameters.threads
                    local thread_x = math.floor(threads.x)
                    local thread_y = math.floor(threads.y)
                    local thread_z = math.floor(threads.z)

                    local pushconstant = Jkr.DefaultCustomImagePainterPushConstant()
                    pushconstant.x = shader_parameters.p1
                    pushconstant.y = shader_parameters.p2
                    pushconstant.z = shader_parameters.p3

                    gwid.c:PushOneTime(Jkr.CreateDispatchable(function()
                              computeImage.BindPainter(painter)
                              computeImage.DrawPainter(painter, pushconstant, thread_x, thread_y, thread_z)
                              computeImage.CopyToSampled(inElement.handle.sampledImage)
                    end), 1)
          end
}

ExecuteFrame = function(inPresentation, inFrameIndex, t, inDirection)
          if (gFrameKeys[inFrameIndex]) then
                    -- tracy.ZoneBeginN("ExecuteFrame")
                    local CurrentFrame = gFrameKeys[inFrameIndex]
                    local CurrentFrameKeyCount = #CurrentFrame
                    for i = 1, CurrentFrameKeyCount, 1 do
                              local Key = CurrentFrame[i]
                              for _, element in pairs(Key.Elements) do
                                        ExecuteFunctions[element[1]](inPresentation, element, inFrameIndex, t,
                                                  inDirection)
                              end
                    end
                    -- tracy.ZoneEnd()
                    return true
          end
end
