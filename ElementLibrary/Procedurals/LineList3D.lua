require "ElementLibrary.Procedurals.Require"
PRO.LineList3D = function(inTable)
          local t = {
                    line_lists = {},
                    c = vec4(gcolors.indiagreen, 1),
                    cd = vec3(100, 100, 1),
                    p = vec3(0),
                    d = vec3(1),
          }
          return { PRO_LineList3D = Default(inTable, t) }
end

gprocess.PRO_LineList3D = function(inPresentation, inValue, inFrameIndex, inElementName)
          local elementName = gUnique(inElementName)
          gprocess.CLineList(inPresentation,
                    CLineList { lines = inValue.line_lists, p = vec3(1000, 1000, 1), d = inValue.d, c = inValue.line_color, cd = inValue.cd }
                    .CLineList, inFrameIndex,
                    elementName .. "lines")

          gprocess.PRO_Shape(inPresentation,
                    PRO.Shape {
                              compute_texture = elementName .. "lines",
                              p = inValue.p,
                              d = inValue.d,
                    }
                    .PRO_Shape,
                    inFrameIndex, elementName .. "cube_h")
end
