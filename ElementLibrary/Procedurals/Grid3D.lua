require "ElementLibrary.Procedurals.Require"
PRO.Grid3D = function(inTable)
          local t = {
                    grid_color = vec4(gcolors.armygreen, 1),
                    mark_color = vec4(gcolors.blue, 1),
                    size = 300,
                    mark = vec3(9, 9, 9),
                    x_count = 30,
                    y_count = 30,
                    c = vec4(1, 0, 0, 1),
                    t = 1,

          }
          return { PRO_Grid3D = Default(inTable, t) }
end

gprocess.PRO_Grid3D = function(inPresentation, inValue, inFrameIndex, inElementName)
          local elementName = gUnique(inElementName)
          local size = inValue.size
          local grid_position = vec3(1000, 1000, gbaseDepth)
          inValue.mark.x = inValue.x_count - inValue.mark.x
          inValue.mark.y = inValue.y_count - inValue.mark.y
          inValue.mark.z = inValue.x_count - inValue.mark.z

          gprocess.CGrid(inPresentation,
                    CGrid {
                              p = grid_position,
                              c = inValue.grid_color,
                              cd = vec3(size, size, 1),
                              t = inValue.t,
                              x_count = inValue.x_count,
                              y_count = inValue.y_count,
                              mark_list = { vec2(inValue.mark.x, inValue.mark.z) },
                              should_mark = true,
                              mark_color = inValue.mark_color,
                    }
                    .CGrid,
                    inFrameIndex,
                    elementName .. "grid1")

          gprocess.CGrid(inPresentation,
                    CGrid {
                              p = grid_position,
                              c = inValue.grid_color,
                              cd = vec3(size, size, 1),
                              t = inValue.t,
                              x_count = inValue.x_count,
                              y_count = inValue.y_count,
                              mark_list = { vec2(inValue.mark.x, inValue.mark.y) },
                              should_mark = true,
                              mark_color = inValue.mark_color }
                    .CGrid,
                    inFrameIndex,
                    elementName .. "grid2")

          gprocess.PRO_Shape(inPresentation,
                    PRO.Shape {
                              compute_texture = elementName .. "grid1",
                              p = vec3(size / 2, 0, -size / 2),
                              d = vec3(size, 0.01, size),
                    }
                    .PRO_Shape,
                    inFrameIndex, elementName .. "cube_h")

          gprocess.PRO_Shape(inPresentation,
                    PRO.Shape {
                              compute_texture = elementName .. "grid2",
                              p = vec3(size / 2, size / 2, 0),
                              d = vec3(size, size, 0.01),
                    }
                    .PRO_Shape,
                    inFrameIndex, elementName .. "cube_v")

          inValue.mark.x = inValue.x_count - inValue.mark.x
          inValue.mark.y = inValue.y_count - inValue.mark.y
          inValue.mark.z = inValue.y_count - inValue.mark.z

          gprocess.PRO_Shape(inPresentation,
                    PRO.Shape {
                              compute_texture = elementName .. "grid1",
                              p = vec3(inValue.mark.x, inValue.mark.y, -inValue.mark.z) * size / inValue.x_count,
                              d = vec3(size / inValue.x_count, size / inValue.x_count, size * 1000 / inValue.x_count) * 0.1,
                              renderer_parameter = mat4(vec4(0, 1, 0, 1), vec4(0, 0, 0, 1), vec4(0), vec4(0)),
                    }
                    .PRO_Shape,
                    inFrameIndex, elementName .. "cube_mark_1")
          gprocess.PRO_Shape(inPresentation,
                    PRO.Shape {
                              compute_texture = elementName .. "grid1",
                              p = vec3(inValue.mark.x, inValue.mark.y, -inValue.mark.z) * size / inValue.x_count,
                              d = vec3(size / inValue.x_count, size * 1000 / inValue.x_count, size / inValue.x_count) * 0.1,
                              renderer_parameter = mat4(vec4(0, 1, 0, 1), vec4(0, 0, 0, 1), vec4(0), vec4(0)),
                    }
                    .PRO_Shape,
                    inFrameIndex, elementName .. "cube_mark_2")
end
