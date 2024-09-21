require "ElementLibrary.Fancy.FancyRequire"


FancyButton = function(inButtonTable)
          local t = {
                    t = "JkrGUIv2",       -- Text
                    p = "CENTER_CENTER",  -- Position
                    d = -1,               -- Dimension
                    onclick = nil,        -- onclick function
                    c = vec4(0, 0, 0, 1), -- text color
                    bc = vec4(1),         -- background color
                    interpolate_t = -1,
                    f = "Normal",
                    _push_constant = -1,
                    o = "CENTER",
                    picture = -1
          }
          return { FancyButton = Default(inButtonTable, t) }
end

gprocess["FancyButton"] = function(inPresentation, inValue, inFrameIndex, inElementName)
          local ElementName = gUnique(inElementName)
          if inValue.d == -1 then
                    local d = gFontMap[inValue.f]:GetTextDimension(inValue.t) * 1.5
                    inValue.d = vec3(d.x, d.y, 1)
          end
          if inValue._push_constant == -1 then
                    inValue._push_constant = nil
          end
          if inValue.interpolate_t == -1 then
                    inValue.interpolate_t = true
          end
          if not gscreenElements[ElementName] then
                    gscreenElements[ElementName] = gwid.CreateGeneralButton(
                              vec3(math.huge), vec3(inValue.d), inValue.onclick, false, gFontMap[inValue.f],
                              inValue.t, inValue.c, inValue.bc, inValue._push_constant
                    )
          end
          gAddFrameKeyElement(inFrameIndex, {
                    {
                              "*FB*",
                              handle = gscreenElements[ElementName],
                              value = inValue,
                              name = ElementName
                    }
          })
end

ExecuteFunctions["*FB*"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
          local PreviousElement, inElement = GetPreviousFrameKeyElementD(inPresentation, inElement,
                    inFrameIndex, inDirection)
          local new = inElement.value
          if PreviousElement then
                    local prev = PreviousElement.value
                    local interp = glerp_3f(ComputePositionByName(prev.p, prev.d), ComputePositionByName(new.p, new.d), t)
                    local interd = glerp_3f(prev.d, new.d, t)
                    local interc = glerp_4f(prev.c, new.c, t)
                    local interbc = glerp_4f(prev.bc, new.bc, t)
                    local intert
                    if new.interpolate_t == true then
                              intert = TextInterop(prev.t, new.t, t)
                    else
                              if inDirection == -1 then
                                        intert = prev.t
                              else
                                        intert = new.t
                              end
                    end

                    local interf
                    if inDirection == 1 then
                              interf = new.f
                    else
                              interf = prev.f
                    end
                    inElement.handle:Update(interp, interd, gFontMap[interf], intert, interc, interbc, new.o)
          else
                    inElement.handle:Update(ComputePositionByName(new.p, new.d), new.d, gFontMap[new.f], new.t, new.c,
                              new.bc, new.o)
          end
end
