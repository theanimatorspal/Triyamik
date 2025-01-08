require "ElementLibrary.Procedurals.Require"

PRO.Text3D = function(inImageTable)
          local t = {
                    t = "JkrGUIv2",
                    p = "CENTER_CENTER",
                    d = vec3(100, 100, 1),
                    push = PC_Mats(mat4(1.0), mat4(1.0)),
                    mode = "SEPARATED_NUMBER"
          }
          return { PRO_Text3D = Default(inImageTable, t) }
end

gprocess.PRO_Text3D = function(inPresentation, inValue, inFrameIndex, inElementName)
          local totalframecount = 0
          IterateEachFrame(inPresentation, function(eachFrameIndex, _)
                    if eachFrameIndex >= inFrameIndex then
                              totalframecount = totalframecount + 1
                    end
          end)
end

-- ExecuteFunctions["*PRO_Text3D*"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
-- end
