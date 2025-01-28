require "ElementLibrary.Procedurals.Require"
PRO_Grid3D = function(inTable)
          local t = {
                    size = 100,
                    mark = vec3(1, 1, 1),
                    x_count = 5,
                    y_count = 5,
                    c = vec4(1, 0, 0, 1),
                    t = 2,

          }
          return { PRO_Grid3D = Default(inTable, t) }
end

gprocess.PRO_Grid3D = function(inPresentation, inValue, inFrameIndex, inElementName)
          local elementName = gUnique(inElementName)
          local size = inValue.size

          gprocess.CGrid(inPresentation,
                    CGrid { p = vec3(1000, 1000, 1), c = inValue.c, cd = vec3(1000, 1000, 1), t = 5, x_count = inValue.x_count, y_count = inValue.y_count }
                    .CGrid,
                    inFrameIndex,
                    elementName .. "grid1")

          gprocess.CGrid(inPresentation,
                    CGrid { p = vec3(1000, 1000, 1), c = inValue.c, cd = vec3(1000, 1000, 1), t = 5, x_count = inValue.x_count, y_count = inValue.y_count }
                    .CGrid,
                    inFrameIndex,
                    elementName .. "grid2")

          gprocess.PRO_Shape(inPresentation,
                    PRO.Shape { compute_texture = elementName .. "grid1", d = vec3(size, 0.01, size) }.PRO_Shape,
                    inFrameIndex, elementName .. "cube_h")

          gprocess.PRO_Shape(inPresentation,
                    PRO.Shape { compute_texture = elementName .. "grid2", p = vec3(0, size / 2, 0), d = vec3(size, size, 0.01) }
                    .PRO_Shape,
                    inFrameIndex, elementName .. "cube_v")

          gprocess.PRO_Shape(inPresentation,
                    PRO.Shape { compute_texture = elementName .. "grid1", p = inValue.mark, d = vec3(1, 1, 1), renderer_parameter = mat4(vec4(0, 1, 0, 1), vec4(0, 0, 0, 1), vec4(0), vec4(0)) }
                    .PRO_Shape,
                    inFrameIndex, elementName .. "cube_mark")
end
