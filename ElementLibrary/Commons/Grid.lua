require "ElementLibrary.Commons.Require"

CGrid = function(inTable)
          local t = {
                    p = vec3(100, 100, 1),
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

          gprocess.CComputeImage(inPresentation, CComputeImage {
                    p = p,
                    d = d,
                    cd = cd,
                    mat1 = mat4(
                              vec4(x_count, y_count, inValue.t, 1),
                              vec4(c),
                              vec4(0),
                              vec4(0)
                    ),
                    mat2 = Jmath.GetIdentityMatrix4x4(),
          }.CComputeImage, inFrameIndex, elementName)

          local computeImages, computePainters = CComputeImagesGet()
          local cmd = Jkr.CmdParam.None
          local element = computeImages[elementName]

          -- yo function pratyek frame ma chalxa
          element[1] = function(mat1, mat2, X, Y, Z)
                    local shader = computePainters["CLEAR"]
                    shader:Bind(gwindow, cmd)
                    element.cimage.BindPainter(shader)
                    shader:Draw(gwindow, PC_Mats(
                              mat4(0.0),
                              mat4(0.0)
                    ), X, Y, Z, cmd)

                    -- mat1 ra mat2 vaneko interpolate gareko values ho
                    local shader = computePainters["LINE2D"]
                    shader:Bind(gwindow, cmd)
                    element.cimage.BindPainter(shader)
                    -- specific
                    -- push constant vanne kura chae shader le linxa
                    -- tesma 2 ota matrix hunxa
                    -- local push = PC_Mats(a, b), where a and b are matrices
                    --[[
                              a = mat4(
                                        vec4(p1_x, p1_y, p2_x, p2_y),
                                        vec4(color_4f),
                                        vec4(thicness, 1, 1, 1),
                                        vec4(1)
                              ),
                              b = tranformation matrix -> set default as Jmath.GetIdentityMatrix4x4()
                    ]]

                    local x_count          = mat1[1].x
                    local y_count          = mat1[1].y
                    local c                = mat1[2]
                    local t                = mat1[1].z
                    local del_y            = cd.y / y_count
                    local del_x            = cd.x / x_count
                    -- for i = 1, y_count do
                    --           shader:Draw(gwindow, PC_Mats(
                    --                     mat4(vec4(x, y, x, y + del_y)),
                    --                     mat2
                    --           ), X, Y, Z, cmd)
                    --           for j = 1, x_count do
                    --                     shader:Draw(gwindow, PC_Mats(
                    --                               mat4(vec4(x, y, x + del_x, y)),
                    --                               mat2
                    --                     ), X, Y, Z, cmd)
                    --                     x = x + del_x
                    --           end
                    --           y = y + del_y
                    -- end
                    local offsetx, offsety = del_x / 2, del_y / 2
                    local x                = offsetx
                    for i = 1, x_count do
                              shader:Draw(gwindow, PC_Mats(
                              -- mat4(vec4(x, 0, x, cd.y), c, vec4(t), vec4(0)),
                                        mat4(vec4(x, 0, x, cd.y), c, vec4(t), vec4(0)),
                                        mat2
                              ), X, Y, Z, cmd)

                              x = x + del_x
                    end

                    local y = offsety
                    for i = 1, y_count do
                              shader:Draw(gwindow, PC_Mats(
                                        mat4(vec4(0, y, cd.x, y), c, vec4(t), vec4(0)),
                                        mat2
                              ), X, Y, Z, cmd)
                              y = y + del_y
                    end
                    -- calculation garera grid banaunu paro
                    -- for loop for x axis
                    -- end forloop
                    -- for loop for y axis
                    -- end forloop

                    element.cimage.handle:SyncAfter(gwindow, cmd)
                    element.cimage.CopyToSampled(element.sampled_image)
          end
end
