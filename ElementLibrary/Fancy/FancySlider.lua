require "ElementLibrary.Fancy.FancyRequire"

FancySlider = function(inSliderTable)
          local t = {
                    t = "JkrGUIv2",       -- Text
                    p = "CENTER_CENTER",  -- Position
                    d = vec3(90, 10, 1),  -- Dimension
                    c = vec4(0, 0, 0, 1), -- text color
                    bc = vec4(1),         -- background color
                    range_start = 0,
                    range_end = 1,
                    value = 0,
                    step = 0.1
          }
          return { FancySlider = Default(inSliderTable, t) }
end

gprocess.FancySlider = function(inPresentation, inValue, inFrameIndex, inElementName)
          local ElementName = gUnique(inElementName)
          if not gscreenElements[ElementName] then
                    gscreenElements[ElementName] = gwid.CreateSlider(vec3(math.huge,
                              math.huge,
                              50), vec3(inValue.d), inValue.range_start, inValue.range_end, inValue.value, inValue.step)
          end
          gAddFrameKeyElement(inFrameIndex, {
                    {
                              "*FSLID*",
                              handle = gscreenElements[ElementName],
                              value = inValue,
                              name = ElementName
                    }
          })
end

ExecuteFunctions["*FSLID*"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
          local PreviousElement, inElement = GetPreviousFrameKeyElementD(inPresentation, inElement,
                    inFrameIndex, inDirection)
          local new = inElement.value
          if PreviousElement then
                    local prev = PreviousElement.value
                    local interp = glerp_3f(ComputePositionByName(prev.p, prev.d), ComputePositionByName(new.p, new.d), t)
                    local interd = glerp_3f(prev.d, new.d, t)
                    interd.d = new.d

                    inElement.handle:Update(interp, interd)
          else
                    inElement.handle:Update(ComputePositionByName(new.p, new.d), new.d, gFontMap[new.f], new.t, new.c,
                              new.bc, new.o)
          end
end
