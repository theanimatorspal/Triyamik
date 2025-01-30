require "ElementLibrary.Procedurals.Require"
PRO.Grid3D = function(inTable)
          local t = {
                    line_size = 1,
                    line_colors = { vec4(gcolors.cadetgrey, 1), vec4(gcolors.deepsaffron, 1) },
                    mark_size = vec3(1),
                    grid_color = vec4(gcolors.armygreen, 1),
                    mark_colors = { vec4(gcolors.amber, 1), vec4(gcolors.palatinatepurple, 1) },
                    size = 300,
                    mark = vec3(9, 9, 9),
                    x_count = 30,
                    y_count = 30,
                    c = vec4(1, 0, 0, 1),
                    compute = true, -- set this to false if you have already created the grid and it is runing the performance
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

          if inValue.compute then
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
                                        mark_color = inValue.mark_colors[1],
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
                                        mark_color = inValue.mark_colors[1] }
                              .CGrid,
                              inFrameIndex,
                              elementName .. "grid2")
          end

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
          local unit_size = size / inValue.x_count
          local size_z = unit_size * inValue.mark.z
          local size_y = unit_size * inValue.mark.y

          gprocess.PRO_Shape(inPresentation,
                    PRO.Shape {
                              compute_texture = elementName .. "grid1",
                              p = vec3(unit_size * inValue.mark.x, unit_size * inValue.mark.y, -unit_size * inValue.mark.z + size_z / 2),
                              d = vec3(unit_size * inValue.line_size, unit_size * inValue.line_size, size_z),
                              renderer_parameter = mat4(inValue.line_colors[1], inValue.line_colors[2], vec4(0), vec4(0)),
                    }
                    .PRO_Shape,
                    inFrameIndex, elementName .. "cube_mark_1")
          gprocess.PRO_Shape(inPresentation,
                    PRO.Shape {
                              compute_texture = elementName .. "grid1",
                              p = vec3(inValue.mark.x * unit_size, inValue.mark.y * unit_size - size_y / 2, -unit_size * inValue.mark.z),
                              d = vec3(unit_size * inValue.line_size, size_y, unit_size * inValue.line_size),
                              renderer_parameter = mat4(inValue.line_colors[1], inValue.line_colors[2], vec4(0), vec4(0)),
                    }
                    .PRO_Shape,
                    inFrameIndex, elementName .. "cube_mark_2")

          gprocess.PRO_Shape(inPresentation,
                    PRO.Shape {
                              compute_texture = elementName .. "grid1",
                              p = vec3(unit_size * inValue.mark.x, unit_size * inValue.mark.y, -unit_size * inValue.mark.z),
                              d = vec3(unit_size * inValue.mark_size.x, unit_size * inValue.mark_size.y, unit_size * inValue.mark_size.z),
                              renderer_parameter = mat4(inValue.mark_colors[1], inValue.mark_colors[2], vec4(0), vec4(0)),
                              type = "CUBE3D"
                    }
                    .PRO_Shape,
                    inFrameIndex, elementName .. "cube_mark_3")
end
