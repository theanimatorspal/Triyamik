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
                              vec4(x_count, y_count, inValue.t),
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
                    -- mat1 ra mat2 vaneko interpolate gareko values ho
                    local shader = computePainters["LINE2D"]
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
                    shader:Bind(gwindow, cmd)
                    element.cimage.BindPainter(shader)

                    local x_count = mat1[1].x
                    local y_count = mat1[1].y
                    local c       = mat1[2]

                    -- calculation garera grid banaunu paro
                    -- for loop for x axis
                    shader:Draw(gwindow, PC_Mats(
                              mat4(0),
                              mat2
                    ), X, Y, Z, cmd)
                    -- end forloop
                    -- for loop for y axis
                    -- end forloop

                    element.cimage.handle:SyncAfter(gwindow, cmd)
                    element.cimage.CopyToSampled(element.sampled_image)
          end
end
