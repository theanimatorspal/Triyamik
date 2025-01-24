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
                    mat1 = mat4(0),
                    mat2 = mat4(0),
          }.CComputeImage, inFrameIndex, elementName)

          local computeImages, computePainters = CComputeImagesGet()
          local cmd = Jkr.CmdParam.None
          local element = computeImages[elementName]
          element[1] = function(mat1, mat2, X, Y, Z)
                    local shader = computePainters["LINE2"]
                    shader:Bind(gwindow, cmd)
                    element.cimage.BindPainter(shader)
          end
end
