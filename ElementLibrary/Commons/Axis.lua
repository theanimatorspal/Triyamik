require "ElementLibrary.Commons.Require"

CAxis = function(inTable)
          local t = {
                    p = vec3(100, 100, 1),
                    d = vec3(100, 100, 1),
                    cd = vec3(100, 100, 1),
                    type = "XY",
                    c = vec4(1, 1, 1, 0),
                    t = 1,
                    r = 90
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

          gprocess.CComputeImage(inPresentation, CComputeImage {
                    p = p,
                    d = d,
                    cd = cd,
                    mat1 = mat4(vec4(t, r, 1, 1), vec4(c), vec4(0), vec4(0)),
                    mat2 = Jmath.GetIdentityMatrix4x4(),

          }.CComputeImage, inFrameIndex, elementName)
          local computeImages, computePainters = CComputeImagesGet()
          local cmd = Jkr.CmdParam.None
          local element = computeImages[elementName]
          element[1] = function(mat1, mat2, X, Y, Z)
                    local shader = computePainters["LINE2D"]
                    shader:Bind(gwindow, cmd)
                    element.cimage.BindPainter(shader)
                    
          end
end