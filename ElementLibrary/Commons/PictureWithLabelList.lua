CPictureWithLabelList = function(inCPictureWithLabelList)
          local t = {
                    paths = -1,
                    texts = -1,
                    p     = vec3(200, 200, gbaseDepth),
                    d     = vec3(100, 100, 1),
                    ic    = vec4(1),
                    tc    = vec4(0, 0, 0, 1),
                    index = 1,
          }
          return { CPictureWithLabelList = Default(inCPictureWithLabelList, t) }
end

local pictureWithLabelLists = {}
gprocess.CPictureWithLabelList = function(inPresentation, inValue, inFrameIndex, inElementName)
          local elementName = gUnique(inElementName)
          local texts = inValue.texts
          local paths = inValue.paths
          local index = inValue.index


          if paths ~= -1 and texts ~= -1 then
                    pictureWithLabelLists[elementName] = { paths = paths, texts = texts }
          else
                    paths = pictureWithLabelLists[elementName].paths
                    texts = pictureWithLabelLists[elementName].texts
          end

          for i = 1, #paths do
                    local p = vec3(inValue.p)
                    local d = vec3(inValue.d)
                    local ic = vec4(inValue.ic)
                    local tc = vec4(inValue.tc)
                    local alpha = 0
                    if i == index then
                              alpha = 1
                    elseif i < index then
                              alpha = 0
                              p = vec3(inValue.p.x - inValue.d.x * 0.3, inValue.p.y, gbaseDepth + 10)
                    elseif i > index then
                              alpha = 0
                              p = vec3(inValue.p.x + inValue.d.x * 0.3, inValue.p.y, gbaseDepth + 10)
                    end
                    if i == index - 1 or i == index + 1 then
                              alpha = 0.5
                              d.y = d.y * 0.5;
                              p.y = p.y + d.y * 0.5
                    end


                    local pic_color = vec4(ic.x, ic.y, ic.z, ic.w * alpha)

                    local text_color = vec4(tc.x, tc.y, tc.z, tc.w * alpha)

                    gprocess.CPictureWithLabel(inPresentation, CPictureWithLabel {
                              path = paths[i],
                              tl = texts[i],
                              p = p,
                              d = d,
                              ic = pic_color,
                              tc = text_color,
                    }.CPictureWithLabel, inFrameIndex, elementName .. "__" .. i)
          end
end
