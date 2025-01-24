require "Present.Present"

CPicture = function(inCPictureTable)
          local t = {
                    pic = -1,
                    p = "CENTER_CENTER",
                    d = vec3(100, 100, 1),
                    ar = 1,       -- aspect ratio
                    -- bh = "BY_HEIGHT", -- do it
                    c = vec4(1),  -- Image color
                    bc = vec4(1), -- Image color
          }
          return { CPicture = Default(inCPictureTable, t) }
end


gprocess.CPicture = function(inPresentation, inValue, inFrameIndex, inElementName)
          if inValue.pic ~= -1 then
                    local ElementName = gUnique(inElementName)
                    local PrevD = vec3(inValue.d.x, inValue.d.y, inValue.d.z)
                    if inValue.ar and inValue.bh then
                              if inValue.bh == "BY_HEIGHT" then
                                        inValue.d.x = inValue.ar * inValue.d.y
                              elseif inValue.bh == "BY_WIDTH" then
                                        inValue.d.y = inValue.ar * inValue.d.x
                              end
                    end
                    -- if PrevD.x > inValue.d.x then
                    --           inValue.p.x = inValue.p.x + (PrevD.x - inValue.d.x) / 2
                    -- end
                    -- if PrevD.y > inValue.d.y then
                    --           inValue.p.y = inValue.p.y + (PrevD.y - inValue.d.y) / 2
                    -- end
                    if not gscreenElements[ElementName] then
                              if inValue.pic ~= -1 then
                                        gscreenElements[ElementName] = gwid.CreateGeneralButton(
                                                  vec3(math.huge), vec3(inValue.d), inValue.onclick, false, nil,
                                                  nil, inValue.c, inValue.bc, nil, inValue.pic
                                        )
                              end
                    end
                    gAddFrameKeyElement(inFrameIndex, {
                              {
                                        "*CP*",
                                        handle = gscreenElements[ElementName],
                                        value = inValue,
                                        name = ElementName
                              }
                    })
          end
end

ExecuteFunctions["*CP*"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
          local PreviousElement, inElement = GetPreviousFrameKeyElementD(inPresentation, inElement,
                    inFrameIndex, inDirection)
          local new = inElement.value
          if PreviousElement then
                    local prev = PreviousElement.value
                    local interp = glerp_3f(ComputePositionByName(prev.p, prev.d), ComputePositionByName(new.p, new.d), t)
                    local interd = glerp_3f(prev.d, new.d, t)
                    local interc = glerp_4f(prev.c, new.c, t)
                    local interbc = glerp_4f(prev.bc, new.bc, t)
                    inElement.handle:Update(interp, interd, nil, nil, interc, interbc)
          else
                    inElement.handle:Update(ComputePositionByName(new.p, new.d), new.d, nil, nil, new.c,
                              new.bc, new.o)
          end
end
