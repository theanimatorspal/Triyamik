CTextList = function(inCTextList)
          local t = {
                    texts = -1,
                    p = vec3(100, 100, gbaseDepth),
                    c = vec4(0, 0, 0, 1),
                    f = "Normal",
                    index = 1,
          }
          return { CTextList = Default(inCTextList, t) }
end


local textLists = {}
gprocess.CTextList = function(inPresentation, inValue, inFrameIndex, inElementName)
          local elementName = gUnique(inElementName)
          local texts = inValue.texts
          local index = inValue.index
          local d = {}

          if texts ~= -1 then
                    textLists[elementName] = texts
          else
                    texts = textLists[elementName]
          end
          for i = 1, #texts do
                    d[i] = gFontMap[inValue.f]:GetTextDimension(texts[i])
          end

          for i = 1, #texts do
                    local p = vec3(inValue.p)
                    local c = vec4(inValue.c)
                    local alpha = 0

                    if i == index then
                              alpha = 1
                    elseif i < index then
                              alpha = 0
                              p = vec3(inValue.p.x - d[index].x * 2, inValue.p.y, gbaseDepth)
                    elseif i > index then
                              alpha = 0
                              p = vec3(inValue.p.x + d[index].x * 2, inValue.p.y, gbaseDepth)
                    end
                    if i == index - 1 or i == index + 1 then
                              alpha = 0.5
                    end

                    local color = vec4(c.x, c.y, c.z, c.w * alpha)
                    gprocess.CText(inPresentation, CText {
                                        t = texts[i],
                                        p = p,
                                        c = color,
                              }.CText,
                              inFrameIndex,
                              elementName .. "__" .. i)
          end
end
