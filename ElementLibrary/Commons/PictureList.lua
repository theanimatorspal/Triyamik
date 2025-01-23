CPictureList = function(inCPictureList)
          local t = {
                    paths = -1,
                    p = vec3(100, 100, gbaseDepth),
                    d = vec3(100, 100, 1),
                    c = vec4(1),
                    index = 1,
          }
          return { CPictureList = Default(inCPictureList, t) }
end


local pictureLists = {}
gprocess.CPictureList = function(inPresentation, inValue, inFrameIndex, inElementName)
          local elementName = gUnique(inElementName)
          local paths = inValue.paths
          local index = inValue.index

          if paths ~= -1 then
                    pictureLists[elementName] = paths
          else
                    paths = pictureLists[elementName]
          end

          for i = 1, #paths do
                    local p = vec3(inValue.p)
                    local d = vec3(inValue.d)
                    local c = vec4(inValue.c)
                    local alpha = 0
                    if i == index then
                              alpha = 1
                    elseif i < index then
                              alpha = 0
                              p = vec3(inValue.p.x - inValue.d.x, inValue.p.y, gbaseDepth)
                    elseif i > index then
                              alpha = 0
                              p = vec3(inValue.p.x + inValue.d.x, inValue.p.y, gbaseDepth)
                    end
                    if i == index - 1 or i == index + 1 then
                              alpha = 0.5
                              d.y = d.y * 0.5;
                              p.y = p.y + d.y * 0.5
                    end


                    local color = vec4(c.x, c.y, c.z, c.w * alpha)
                    gprocess.CPicture(inPresentation, CPicture {
                                        pic = paths[i],
                                        p = p,
                                        d = d,
                                        c = color,
                                        bc = color
                              }.CPicture,
                              inFrameIndex,
                              elementName .. "__" .. i)
          end
end
