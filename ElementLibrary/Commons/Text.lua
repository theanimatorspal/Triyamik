require "ElementLibrary.Commons.Require"

CText = function(inTextTable)
          local t = {
                    t = "JkrGUIv2",
                    p = vec3(gFrameDimension.x / 2, gFrameDimension.y / 2, gbaseDepth),
                    c = vec4(0, 0, 0, 1),
                    f = "Normal"
          }
          return { CText = Default(inTextTable, t) }
end


local texts = {}
gprocess["CText"] = function(inPresentation, inValue, inFrameIndex, inElementName)
          local elementName = gUnique(inElementName)
          local t = inValue.t
          local p = inValue.p
          local c = inValue.c
          local f = inValue.f
          if not texts[elementName] then
                    texts[elementName] = gwid.CreateTextLabel(p, vec3(0), gFontMap[f], t, c)
          end
          gAddFrameKeyElement(inFrameIndex, {
                    {
                              "*CText*",
                              handle = texts[elementName],
                              value = inValue,
                              name = elementName
                    }
          })
          gFontMap["Normal"]:GetTextDimension()
end

ExecuteFunctions["*CText*"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
          local PreviousElement, inElement = GetPreviousFrameKeyElementD(inPresentation, inElement,
                    inFrameIndex, inDirection)
          local new = inElement.value
          if PreviousElement then
                    local prev = PreviousElement.value
                    local interc = glerp_4f(prev.c, new.c, t)
                    local interp = glerp_3f(prev.p, new.p, t)
                    local intert = TextInterop(prev.t, new.t, t)

                    inElement.handle:Update(interp, vec3(0), gFontMap[new.f], intert, interc)
          else
                    inElement.handle:Update(new.p, vec3(0), gFontMap[new.f], new.t, new.c)
          end
end
