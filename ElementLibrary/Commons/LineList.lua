require "ElementLibrary.Commons.Require"

CLineList = function(inTable)
          local t = {
                    lines = -1,
                    p = vec3(100, 100, gbaseDepth), -- screen ma aako position // bhitta is fullwindow
                    d = vec3(100, 100, 1),          -- screen ma aako ko dimension
                    cd = vec3(100, 100, 1),         -- mobile ko dimen
                    c = vec4(1, 0, 0, 1),
                    t = 2
          }
          return { CLineList = Default(inTable, t) }
end

gprocess.CLineList = function(inPresentation, inValue, inFrameIndex, inElementName)
          local elementName = gUnique(inElementName)
          local lines = inValue.lines
          local p = inValue.p
          local d = inValue.d
          local cd = inValue.cd
          local c = inValue.c
          local t = inValue.t

          gprocess.CComputeImage(inPresentation, CComputeImage {
                    p = p,
                    d = d,
                    cd = cd,
                    mat1 = mat4(vec4(t, 1, 1, 1), vec4(c), vec4(0), vec4(0)), mat2 = Jmath.GetIdentityMatrix4x4()
          }.CComputeImage, inFrameIndex, elementName)

          local computeImages, computePainters = CComputeImagesGet()
          local cmd = Jkr.CmdParam.None
          local element = computeImages[elementName]

          element[1] = function(mat1, mat2, X, Y, Z, prev, new, t)
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
                    print(inspect(prev))
                    print(inspect(new))
                    local prev_lines = prev.lines
                    local new_lines = new.lines
                    local min_len = 0
                    if #prev_lines < #new_lines then
                              min_len = #prev_lines
                    else
                              min_len = #new_lines
                    end

                    for i = 1, min_len do
                              local line1 = prev_lines[i]
                              local line2 = new_lines[i]
                              local inter_line = glerp_4f(line1, line2, t)
                              shader:Draw(gwindow, PC_Mats(mat4(inter_line, c, vec4(t), vec4(0)), mat2), X, Y, Z, cmd)
                    end
                    element.cimage.handle:SyncAfter(gwindow, cmd)
                    element.cimage.CopyToSampled(element.sampled_image)
          end
end
