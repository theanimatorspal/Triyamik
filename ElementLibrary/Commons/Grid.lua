require "ElementLibrary.Commons.Require"

CGrid = function(inTable)
          local t = {
                    mark_size = 1,
                    mark = vec2(5, 3),
                    mark_color = vec4(0, 1, 0, 1),
                    mark_line_color = vec4(0, 0, 1, 1),
                    p = vec3(100, 100, gbaseDepth),
                    d = vec3(100, 100, 1),
                    cd = vec3(100, 100, 1),
                    x_count = 20,
                    y_count = 20,
                    c = vec4(1, 0, 0, 1),
                    t = 2,
          }
          return { CGrid = Default(inTable, t) }
end

gprocess.CGrid = function(inPresentation, inValue, inFrameIndex, inElementName)
          local elementName = gUnique(inElementName)
          local p = inValue.p
          local d = inValue.d
          local x_count = inValue.x_count
          local y_count = inValue.y_count
          local c = inValue.c
          local cd = inValue.cd
          local mark = inValue.mark
          local mark_color = inValue.mark_color
          local mark_size = inValue.mark_size
          local mark_line_color = inValue.mark_line_color

          gprocess.CComputeImage(inPresentation, CComputeImage {
                    p = p,
                    d = d,
                    cd = cd,
                    mat1 = mat4(
                              vec4(x_count, y_count, inValue.t, 1),
                              vec4(c),
                              vec4(mark.x, mark.y, 1, 1),
                              vec4(0)
                    ),
                    mat2 = Jmath.GetIdentityMatrix4x4(),
          }.CComputeImage, inFrameIndex, elementName)

          local computeImages, computePainters = CComputeImagesGet()
          local cmd = Jkr.CmdParam.None
          local element = computeImages[elementName]

          element[1] = function(mat1, mat2, X, Y, Z)
                    local shader = computePainters["CLEAR"]
                    shader:Bind(gwindow, cmd)
                    element.cimage.BindPainter(shader)
                    shader:Draw(gwindow, PC_Mats(
                              mat4(0.0),
                              mat4(0.0)
                    ), X, Y, Z, cmd)

                    local shader = computePainters["LINE2D"]
                    shader:Bind(gwindow, cmd)
                    element.cimage.BindPainter(shader)

                    local x_count          = mat1[1].x
                    local y_count          = mat1[1].y
                    local c                = mat1[2]
                    local t                = mat1[1].z
                    local del_y            = cd.y / y_count
                    local del_x            = cd.x / x_count
                    local mark             = vec2(mat1[3].x, mat1[3].y)
                    local offsetx, offsety = del_x / 2, del_y / 2
                    local x                = offsetx
                    local y                = offsety

                    shader:Draw(gwindow, PC_Mats(
                              mat4(
                                        vec4(x + del_x * (mark.x - 1) + offsetx, y + del_y * (mark.y - 1) + offsety,
                                                  x + del_x * (mark.x - 1) + offsetx, y + del_y * (mark.y - 1) + offsety),
                                        mark_color, vec4(del_x * mark_size),
                                        vec4(0)),
                              mat2
                    ), X, Y, Z, cmd)
                    x = offsetx
                    y = offsety
                    for i = 1, x_count do
                              local color = vec4(c)
                              if i == mark.x then
                                        color = mark_line_color
                              end

                              shader:Draw(gwindow, PC_Mats(
                                        mat4(vec4(x, 0, x, cd.y), color, vec4(t), vec4(0)),
                                        mat2
                              ), X, Y, Z, cmd)

                              x = x + del_x
                    end

                    for i = 1, y_count do
                              local color = vec4(c)
                              if i == mark.y then
                                        color = mark_line_color
                              end
                                        shader:Draw(gwindow, PC_Mats(
                                                  mat4(vec4(0, y, cd.x, y), color, vec4(t), vec4(0)),
                                                  mat2
                                        ), X, Y, Z, cmd)
                                        y = y + del_y
                              
                    end


                    element.cimage.handle:SyncAfter(gwindow, cmd)
                    element.cimage.CopyToSampled(element.sampled_image)
          end
end
