require "Present.Present"

CTest = function(inCPictureTable)
          local t = {
          }
          return { CTest = Default(inCPictureTable, t) }
end


gprocess.CTest = function(inPresentation, inValue, inFrameIndex, inElementName)
          local Gen = Jkr.Generator()
          gAddFrameKeyElement(inFrameIndex, {
                    {
                              "CTest",
                              handle = gscreenElements[ElementName],
                              value = inValue,
                              name = ElementName
                    }
          })
end

ExecuteFunctions["CTest"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
end
