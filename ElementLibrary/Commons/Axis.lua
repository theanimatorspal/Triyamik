require "ElementLibrary.Commons.Require"

CAxis = function(inTable)
          local t = {
                    p = vec3(100, 100, 1),
                    d = vec3(200, 200, 1),
                    cd = vec3(100, 100, 1),
                    type = "XY",
                    c = vec4(1, 0, 1, 1),
                    t = 1,
                    r = 90,
                    d_t = 8
          }
          return { CAxis = Default(inTable, t) }
end

gprocess.CAxis = function(inPresentation, inValue, inFrameIndex, inElementName)
          local elementName = gUnique(inElementName)
          local p = inValue.p
          local d = inValue.d
          local cd = inValue.cd
          local type = inValue.type
          local c = inValue.c
          local t = inValue.t
          local r = inValue.r
          local d_t = inValue.d_t

          local mat = Jmath.GetIdentityMatrix4x4()
          mat = Jmath.Translate(mat, vec3(cd.x / 2, cd.y / 2, 1))
          mat = Jmath.Rotate_deg(mat, r, vec3(0, 0, 1))
          mat = Jmath.Translate(mat, vec3(-cd.x / 2, -cd.y / 2, 1))
          gprocess.CComputeImage(inPresentation, CComputeImage {
                    p = p,
                    d = d,
                    cd = cd,
                    mat1 = mat4(vec4(t, r, 1, 1), vec4(c), vec4(0), vec4(0)),
                    mat2 = mat

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
                    local t = mat1[1].x
                    local c = mat1[2]
                    if type == "X" or type == "XY" then
                              shader:Draw(gwindow, PC_Mats(
                                        mat4(vec4(cd.x / 2, cd.y / 2, cd.x * 0.95, cd.y / 2), c, vec4(t), vec4(0)),
                                        mat2
                              ), X, Y, Z, cmd)
                              shader:Draw(gwindow, PC_Mats(
                                        mat4(vec4(cd.x * 0.95, cd.y / 2, cd.x * 0.95 - 4, (cd.y / 2) - 4), c, vec4(t * 2),
                                                  vec4(0)),
                                        mat2
                              ), X, Y, Z, cmd)
                              shader:Draw(gwindow, PC_Mats(
                                        mat4(vec4(cd.x * 0.95, cd.y / 2, cd.x * 0.95 - 4, (cd.y / 2) + 4), c, vec4(t * 2),
                                                  vec4(0)),
                                        mat2
                              ), X, Y, Z, cmd)
                    end
                    if type == "Y" or type == "XY" then
                              shader:Draw(gwindow, PC_Mats(
                                        mat4(vec4(cd.x / 2, cd.y / 2, cd.x / 2, 2), c, vec4(t), vec4(0)),
                                        mat2
                              ), X, Y, Z, cmd)
                              -- horizontal ko lagi arrow
                              -- vertical  ko lagi arrow
                              shader:Draw(gwindow, PC_Mats(
                                        mat4(vec4((cd.x / 2), 2, (cd.x / 2) + 4, 6), c, vec4(t * 2), vec4(0)),
                                        mat2
                              ), X, Y, Z, cmd)
                              shader:Draw(gwindow, PC_Mats(
                                        mat4(vec4((cd.x / 2), 2, (cd.x / 2) - 4, 6), c, vec4(t * 2), vec4(0)),
                                        mat2
                              ), X, Y, Z, cmd)
                    end
                    shader:Draw(gwindow, PC_Mats(
                              mat4(vec4(cd.x / 2, cd.y / 2, cd.x / 2, cd.y / 2), c, vec4(t * d_t), vec4(0)),
                              mat2
                    ), X, Y, Z, cmd)
                    element.cimage.handle:SyncAfter(gwindow, cmd)
                    element.cimage.CopyToSampled(element.sampled_image)
          end
end
