require("Present.require")
--[============================================================[
          EXECUTE  FUNCTIONS
          these functions actually show the presenation and update it interactively
          element = { "TEXT", handle = screenElements[ElementName], value = inValue, name = ElementName },
]============================================================]

local GetPreviousFrameKeyElement = function(inPresentation, inElement, inFrameIndex)
          local PreviousFrame = gFrameKeys[inFrameIndex - 1]
          if PreviousFrame then
                    local Key = PreviousFrame[i]
                    for _, element in pairs(Key.Elements) do
                              if element.name == inElement.name then
                                        return element
                              end
                    end
          end
end

local ExecuteFunction = {
          TEXT = function(inPresentation, inElement, inFrameIndex, t)
                    local PreviousElement = GetPreviousFrameKeyElement(inPresentation, inElement, inFrameIndex)
                    if PreviousElement then
                              -- interpolate
                    else
                              inElement.handle:Update(ComputePositionByName(inElement.value.p, inElement.value.d),
                                        vec3(inElement.value.d.x, inElement.value.d.y, inElement.value.d.z))
                    end
          end
}

ExecuteFrame = function(inPresentation, inFrameIndex, t)
          local CurrentFrame = gFrameKeys[inFrameIndex]
          local CurrentFrameKeyCount = #CurrentFrame
          for i = 1, CurrentFrameKeyCount, 1 do
                    local Key = CurrentFrame[i]
                    for _, element in pairs(Key.Elements) do
                              print(element[1], ExecuteFunction[element[1]])
                              ExecuteFunction[element[1]](inPresentation, element, inFrameIndex, t)
                    end
          end
end
