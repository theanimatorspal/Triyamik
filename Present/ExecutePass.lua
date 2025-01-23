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
          --tracy.ZoneBeginN("luaTextInterop")
          if inText1 == inText2 then
                    --tracy.ZoneEnd()
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

          --tracy.ZoneEnd()
          return table.concat(interm):sub(1, final_length)
end

GetPreviousFrameKeyElement = function(inPresentation, inElement, inFrameIndex)
          local PreviousFrame = gFrameKeys[inFrameIndex - 1]
          -- print("FrameKeys", inspect(gFrameKeys))
          if PreviousFrame then
                    -- --tracy.ZoneBeginN("GetPreviousFrameKeyElement")
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
                    -- --tracy.ZoneEnd()
          end
end

GetPreviousFrameKeyElementD = function(inPresentation, inElement, inFrameIndex, inDirection)
          --tracy.ZoneBeginN("luaGetPreviousFrameKeyElementD")
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
          --tracy.ZoneEnd()
          return PreviousElement, inElement
end

DispatchFunctions = {}

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
}

ExecuteFrame = function(inPresentation, inFrameIndex, t, inDirection)
          if (gFrameKeys[inFrameIndex]) then
                    -- --tracy.ZoneBeginN("ExecuteFrame")
                    local CurrentFrame = gFrameKeys[inFrameIndex]
                    local CurrentFrameKeyCount = #CurrentFrame
                    for i = 1, CurrentFrameKeyCount, 1 do
                              local Key = CurrentFrame[i]
                              local ElementCount = #Key.Elements
                              local Elements = Key.Elements
                              for ii = 1, ElementCount, 1 do
                                        local element = Elements[ii]
                                        ExecuteFunctions[element[1]](
                                                  inPresentation,
                                                  element,
                                                  inFrameIndex,
                                                  t,
                                                  inDirection)
                              end
                    end
                    -- --tracy.ZoneEnd()
                    return true
          end
end

DispatchFrame = function(inPresentation, inFrameIndex, t, inDirection)
          if gFrameKeysCompute[inFrameIndex] and #gFrameKeysCompute[inFrameIndex] > 0 then
                    -- --tracy.ZoneBeginN("ExecuteFrame")
                    local CurrentFrame = gFrameKeysCompute[inFrameIndex]
                    local CurrentFrameKeyCount = #CurrentFrame
                    for i = 1, CurrentFrameKeyCount, 1 do
                              local Key = CurrentFrame[i]
                              for _, element in pairs(Key.Elements) do
                                        if DispatchFunctions[element[1]] then
                                                  DispatchFunctions[element[1]](inPresentation,
                                                            element,
                                                            inFrameIndex,
                                                            t,
                                                            inDirection)
                                        end
                              end
                    end
                    -- --tracy.ZoneEnd()
                    return true
          end
end
