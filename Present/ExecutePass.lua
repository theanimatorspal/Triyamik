require("Present.require")
local inspect = require("Present.inspect")
--[============================================================[
          EXECUTE  FUNCTIONS
          these functions actually show the presenation and update it interactively
          element = { "TEXT", handle = screenElements[ElementName], value = inValue, name = ElementName },
]============================================================]

local GetPreviousFrameKeyElement = function(inPresentation, inElement, inFrameIndex)
          local PreviousFrame = gFrameKeys[inFrameIndex - 1]
          -- print("FrameKeys", inspect(gFrameKeys))
          if PreviousFrame then
                    tracy.ZoneBeginN("GetPreviousFrameKeyElement")
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
                    tracy.ZoneEnd()
          end
end

local ExecuteFunction = {
          TEXT = function(inPresentation, inElement, inFrameIndex, t, inDirection)
                    tracy.ZoneBeginN("TEXT Execute")
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

                    if PreviousElement then
                              local prevValue = PreviousElement.value
                              local interP = glerp_3f(
                                        ComputePositionByName(prevValue.p, prevValue.d),
                                        ComputePositionByName(inElement.value.p, inElement.value.d),
                                        t
                              )
                              local interD = glerp_3f(prevValue.d, inElement.value.d, t)
                              local interC = glerp_4f(prevValue.c, inElement.value.c, t)
                              inElement.handle:Update(interP, interD, nil, nil, interC)
                    else
                              inElement.handle:Update(ComputePositionByName(inElement.value.p, inElement.value.d),
                                        vec3(inElement.value.d.x, inElement.value.d.y, inElement.value.d.z))
                    end
                    -- print("inElement:", inspect(inElement))
                    -- print("PrevElement:", inspect(PreviousElement))
                    tracy.ZoneEnd()
          end
}

ExecuteFrame = function(inPresentation, inFrameIndex, t, inDirection)
          if (gFrameKeys[inFrameIndex]) then
                    tracy.ZoneBeginN("ExecuteFrame")
                    local CurrentFrame = gFrameKeys[inFrameIndex]
                    local CurrentFrameKeyCount = #CurrentFrame
                    for i = 1, CurrentFrameKeyCount, 1 do
                              local Key = CurrentFrame[i]
                              for _, element in pairs(Key.Elements) do
                                        ExecuteFunction[element[1]](inPresentation, element, inFrameIndex, t, inDirection)
                              end
                    end
                    tracy.ZoneEnd()
                    return true
          end
end
