require "ElementLibrary.Commons.Require"

CLine = function(inTable)
          local t = {
                    p1 = vec3(40, 50, 0),
                    p2 = vec3(100, 200, 0),
                    c = vec4(1, 0, 0, 1),
                    t = 2
          }
          return { CLine = Default(inTable, t) }
end


local lines = {}
gprocess.CLine = function(inPresentation, inValue, inFrameIndex, inElementName)
          local elementName = gUnique(inElementName)
          local p1 = inValue.p1
          local p2 = inValue.p2
          local c = inValue.c
          local t = inValue.t
          gprocess.CComputeImage(inPresentation, CComputeImage {
                    p = vec3(0, 0, gbaseDepth),
                    d = vec3(gFrameDimension.x, gFrameDimension.y, 1),
                    cd = vec3(gFrameDimension.x, gFrameDimension.y, 1)
          }.CComputeImage, inFrameIndex, "lineImage__Line2d")

          if not lines[elementName] then
                    lines[elementName] = inValue
          end

          local computeImages, computePainters = CComputeImagesGet()
          local cmd = Jkr.CmdParam.None
          local element = computeImages["lineImage__Line2d"]
          element[1] = function(mat1, mat2, X, Y, Z)
                    local shader_type = computePainters["LINE2D"]
                    shader_type:Bind(gwindow, cmd)
                    element.cimage.BindPainter(shader_type)

                    for key, line in pairs(lines) do
                              local value = line
                              local Push = PC_Mats(
                                        mat4(
                                                  vec4(value.p1.x, value.p1.y, value.p2.x, value.p2.y),
                                                  vec4(value.c),
                                                  vec4(value.t),
                                                  vec4(1)
                                        ),
                                        Jmath.GetIdentityMatrix4x4())
                              shader_type:Draw(gwindow, Push, X, Y, Z, cmd)
                    end
                    element.cimage.handle:SyncAfter(gwindow, cmd)
                    element.cimage.CopyToSampled(element.sampled_image)
          end
end
