require "ElementLibrary.Commons.Require"

CAxis = function(inTable)
          local t = {
                    p = vec3(100, 100, gbaseDepth),
                    d = vec3(200, 200, 1),
                    cd = vec3(100, 100, 1),
                    type = "XY",
                    text = " ",
                    c = vec4(1, 0, 1, 1),
                    t = 1,
                    r = 90,
                    d_t = 8
          }
          return { CAxis = Default(inTable, t) }
end

local AXIS_VALUES = {}
gAN_AXIS_CMD_ROTATE_90_LEFT = function(inName)
          AXIS_VALUES[inName].r = AXIS_VALUES[inName].r - 90
end
gAN_AXIS_CMD_ROTATE_90_RIGHT = function(inName)
          AXIS_VALUES[inName].r = AXIS_VALUES[inName].r + 90
end

local AndroidUI = function()
          local dimension = vec3(FrameD.x, FrameD.y, 1)
          if not AXIS_ANDROID_UI then
                    local Next = function()
                              SHOULD_SEND_TCP = true
                              TCP_FILE_IN:WriteFunction("CTRL",
                                        function()
                                                  gAN_AXIS_CMD_ROTATE_90_LEFT("FUCKYOU")
                                        end
                              )
                    end
                    local Prev = function()
                              SHOULD_SEND_TCP = true
                              TCP_FILE_IN:WriteFunction("CTRL",
                                        function()
                                                  gAN_AXIS_CMD_ROTATE_90_LEFT("FUCKYOU")
                                        end
                              )
                    end
                    local _c = vec4(1)
                    local pos = vec3(0, 0, GBASE_DEPTH)
                    AXIS_ANDROID_UI = V(
                              {
                                        H(
                                                  {
                                                            U { t = "Left 90", bc = _c, onclick = Prev },
                                                            U { t = "Right 90", bc = _c, onclick = Next },
                                                            U { e = true },
                                                  },
                                                  { 0.45, 0.45, 0.1 }
                                        ),
                                        U { e = true, bc = _c },
                              },
                              { 0.1, 0.9 }
                    )
          end
          AXIS_ANDROID_UI:Update(vec3(0, 0, GBASE_DEPTH), dimension)
end



gprocess.CAxis = function(inPresentation, inValue, inFrameIndex, inElementName)
          local elementName = gUnique(inElementName)
          gFUNCTIONS_TO_BE_SEND_TO_ANDROID[inFrameIndex] = AndroidUI
          local p = inValue.p
          local d = inValue.d
          local cd = inValue.cd
          local type = inValue.type
          local c = inValue.c
          local t = inValue.t
          local r = inValue.r
          local d_t = inValue.d_t
          local text = inValue.text

          if not AXIS_VALUES[inElementName] then
                    AXIS_VALUES[elementName] = inValue
          end

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

          gprocess.CText(inPresentation,
                    CText { p = vec3((p.x + d.x) / 2, p.y + d.y * 0.45, gbaseDepth - 1), t = text }.CText,
                    inFrameIndex, elementName .. "axis")

          local computeImages, computePainters = CComputeImagesGet()
          local cmd = Jkr.CmdParam.None
          local element = computeImages[elementName]
          element[1] = function(mat1, mat2, X, Y, Z, prev, new, t_)
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
