require "ElementLibrary.Commons.Require"
CRectanglelist = function(inCRectanglelist)
          local t = {
                    list = -1,
                    p = vec3(100, 100, gbaseDepth),
                    d = vec3(100, 100, 1),
                    cd = vec3(100, 100, 1),

          }
          return { CRectanglelist = Default(inCRectanglelist, t) }
end
gprocess.CRectanglelist = function(inPresentation, inValue, inFrameIndex, inElementName)
          local elementName = gUnique(inElementName)
          local list = inValue.list
          local p = inValue.p
          local d = inValue.d
          local cd = inValue.cd

          gprocess.CComputeImage(inPresentation, CComputeImage {
                    p = p,
                    d = d,
                    cd = cd,
                    mat1 = Jmath.GetIdentityMatrix4x4(),
                    mat2 = Jmath.GetIdentityMatrix4x4(),
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

                    local shader = computePainters["RECTANGLE"]
                    shader:Bind(gwindow, cmd)
                    element.cimage.BindPainter(shader)

                    local prev_list = prev.list
                    local new_list = new.list
                    local min_len = math.min(#prev_list, #new_list)


                    for i = 1, min_len do
                              local rect1 = prev_list[i]
                              local rect2 = new_list[i]
                              local inter_rect = glerp_mat4f(rect1, rect2, t_)
                              shader:Draw(gwindow, PC_Mats(inter_rect, mat2), X, Y,
                                        Z, cmd)
                    end

                    element.cimage.handle:SyncAfter(gwindow, cmd)
                    element.cimage.CopyToSampled(element.sampled_image)
          end
end
