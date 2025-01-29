require "ElementLibrary.Commons.Require"
CRectanglelist = function(inCRectanglelist)
          local t = {
                    list = -1,
                    p = vec3(100, 100, gbaseDepth),
                    d = vec3(100, 100, 1),
                    cd = vec3(100, 100, 1),
                    c = vec4(1, 0, 0, 1),
                    t = 2,

          }
          return { CRectanglelist = Default(inCRectanglelist, t) }
end
gprocess.CRectanglelist = function(inPresentation, inValue, inFrameIndex, inElementName)
          local elementName = gUnique(inElementName)
          local list = inValue.list
          local p = inValue.p
          local d = inValue.d
          local cd = inValue.cd
          local c = inValue.c
          local t = inValue.t

          gprocess.CComputeImage(inPresentation, CComputeImage {
                    p = p,
                    d = d,
                    cd = cd,
                    mat1 = mat4(vec4(t, 1, 1, 1), vec4(c), vec4(0), vec4(0)),
                    mat2 = Jmath.GetIdentityMatrix4x4(),
                    c = c,
                    t = t,
                    list = list
          }.CComputeImage, inFrameIndex, elementName)

          local computeImages, computePainters = CComputeImagesGet()
          local cmd = Jkr.CmdParam.None
          local element = computeImages[elementName]

          element[1] = function(mat1, mat2, X, Y, Z, prev, new, t_)
                    local shader = computePainters["CLEAR"]
                    shader:Bind(gwindow, cmd)
                    element.cimage.BindPainter(shader)
                    shader:Draw(gwindow, PC_Mats(mat4(0.0), mat4(0.0)), X, Y, Z, cmd)

                    local shader = computePainters["RECTANGLE2D"]
                    shader:Bind(gwindow, cmd)
                    element.cimage.BindPainter(shader)

                    local prev_list = prev.list
                    local new_list = new.list
                    local min_len = math.min(#prev_list, #new_list)

                    local inter_c = glerp_4f(prev.c, new.c, t_)
                    local inter_t = glerp(prev.t, new.t, t_)

                    for i = 1, min_len do
                              local rect1 = prev_list[i]
                              local rect2 = new_list[i]
                              local inter_rect = glerp_4f(rect1, rect2, t_)
                              shader:Draw(gwindow, PC_Mats(mat4(inter_rect, inter_c, vec4(inter_t), vec4(0)), mat2), X, Y,
                                        Z, cmd)
                    end

                    element.cimage.handle:SyncAfter(gwindow, cmd)
                    element.cimage.CopyToSampled(element.sampled_image)
          end
end
