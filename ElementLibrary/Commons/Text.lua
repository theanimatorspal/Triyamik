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
end
