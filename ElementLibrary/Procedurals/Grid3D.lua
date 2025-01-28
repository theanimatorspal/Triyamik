require "ElementLibrary.Procedurals.Require"
PRO_Grid3D = function(inTable)
          local t = {
                    x_count = 5,
                    y_count = 5,
                    c = vec4(1, 0, 0, 1),
                    t = 2,

          }
          return { PRO_Grid3D = Default(inTable, t) }
end

gprocess.PRO_Grid3D = function(inPresentation, inValue, inFrameIndex, inElementName)
          local elementName = gUnique(inElementName)



          gprocess.CGrid(inPresentation,
                    CGrid { p = vec3(1000, 1000, 1), c = inValue.c, cd = vec3(1000, 1000, 1), t = 5, x_count = inValue.x_count, y_count = inValue.y_count }
                    .CGrid,
                    inFrameIndex,
                    elementName .. "grid")
          gprocess.PRO_Shape(inPresentation,
                    PRO.Shape { compute_texture = elementName .. "grid", d = vec3(100, 0.01, 100) }.PRO_Shape,
                    inFrameIndex, elementName .. "cube_h")

          gprocess.PRO_Shape(inPresentation,
                    PRO.Shape { compute_texture = elementName .. "grid", d = vec3(100, 100, 0.01) }.PRO_Shape,
                    inFrameIndex, elementName .. "cube_v")
end
