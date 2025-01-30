require "ElementLibrary.Procedurals.Require"
PRO.RectangleList3D = function(inTable)
          local t = {
                    rectangle_lists = {},
                    cd = vec3(100, 100, 1),
                    p = vec3(0),
                    d = vec3(1),
                    compute = true, -- turn this false if you don't need any dynamic animation and have already computed rectangle list
          }
          return { PRO_RectangleList3D = Default(inTable, t) }
end

gprocess.PRO_RectangleList3D = function(inPresentation, inValue, inFrameIndex, inElementName)
          local elementName = gUnique(inElementName)
          if inValue.compute then
                    gprocess.CRectanglelist(inPresentation,
                              CRectanglelist { list = inValue.rectangle_lists, p = vec3(1000, 1000, 1), d = inValue.d, cd = inValue.cd }
                              .CRectanglelist, inFrameIndex,
                              elementName .. "rectangles")
          end

          gprocess.PRO_Shape(inPresentation,
                    PRO.Shape {
                              compute_texture = elementName .. "rectangles",
                              p = inValue.p,
                              d = inValue.d,
                    }
                    .PRO_Shape,
                    inFrameIndex, elementName .. "cube_h")
end
