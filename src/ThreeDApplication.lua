require "Present.Present"

ThreeDApplication = function(inTable)
          local t = {

          }
          return { ThreeDApplication = Default(inTable, t) }
end


local now
gprocess["ThreeDApplication"] = function(inP, inValue, inFrameIndex, inElementName)
          local ElementName = gUnique(inElementName)
          gAddFrameKeyElement(inFrameIndex, {
                    {
                              "ThreeDApplication",
                              handle = nil,
                              value = inValue,
                              name = ElementName
                    }
          })
          now = Jkr.CreateWindowNoWindow(Engine.i, vec2(256, 256))
end

ExecuteFunctions["ThreeDApplication"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)

end
