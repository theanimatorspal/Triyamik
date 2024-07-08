require("Present.require")
local inspect = require("Present.inspect")
--[============================================================[
          EXECUTE  FUNCTIONS
          these functions actually show the presenation and update it interactively
          element = { "TEXT", handle = screenElements[ElementName], value = inValue, name = ElementName },
]============================================================]

local GetPreviousFrameKeyElement = function(inPresentation, inElement, inFrameIndex)
          local PreviousFrame = gFrameKeys[inFrameIndex - 1]
          print("FrameKeys", inspect(gFrameKeys))
          if PreviousFrame then
                    local keysCount = #PreviousFrame
                    for i = 1, keysCount, 1 do
                              local Key = PreviousFrame[i]
                              for _, element in pairs(Key.Elements) do
                                        if element.name == inElement.name then
                                                  return element
                                        end
                              end
                    end
          end
end

local ExecuteFunction = {
          TEXT = function(inPresentation, inElement, inFrameIndex, t)
                    local PreviousElement = GetPreviousFrameKeyElement(inPresentation, inElement, inFrameIndex)
                    if PreviousElement then
                              local prevValue = PreviousElement.value
                              local interP = glerp_3f(
                                        ComputePositionByName(prevValue.p, prevValue.d),
                                        ComputePositionByName(inElement.value.p, inElement.value.d),
                                        t
                              )
                              local interD = glerp_3f(prevValue.d, inElement.value.d, t)
                              local interC = glerp_3f(prevValue.c, inElement.value.c, t)
                              inElement.handle:Update(interP, interD, nil, nil, interC)
                    else
                              inElement.handle:Update(ComputePositionByName(inElement.value.p, inElement.value.d),
                                        vec3(inElement.value.d.x, inElement.value.d.y, inElement.value.d.z))
                    end
                    -- print("inElement:", inspect(inElement))
                    -- print("PrevElement:", inspect(PreviousElement))
          end
}

ExecuteFrame = function(inPresentation, inFrameIndex, t)
          if (gFrameKeys[inFrameIndex]) then
                    local CurrentFrame = gFrameKeys[inFrameIndex]
                    local CurrentFrameKeyCount = #CurrentFrame
                    for i = 1, CurrentFrameKeyCount, 1 do
                              local Key = CurrentFrame[i]
                              for _, element in pairs(Key.Elements) do
                                        ExecuteFunction[element[1]](inPresentation, element, inFrameIndex, t)
                              end
                    end
                    return true
          end
end
