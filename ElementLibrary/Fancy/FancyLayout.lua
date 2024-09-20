require "Present.Present"

FancyLayout = function(inFancyLayoutTable)
          return {
                    FancyLayout = inFancyLayoutTable,
                    Apply = function(ToApply)
                              IterateEachElementRecursively(inFancyLayoutTable, function(inValue)
                                        if type(inValue) == "table" and inValue.t then
                                                  inValue.c = inValue.c or ToApply.c
                                                  inValue.bc = inValue.bc or ToApply.bc
                                        end
                              end
                              )
                              return { FancyLayout = inFancyLayoutTable }
                    end,
                    ApplyAll = function(ToApply)
                              IterateEachElementRecursively(inFancyLayoutTable, function(inValue)
                                        if type(inValue) == "table" and inValue.t then
                                                  inValue.c = ToApply.c or inValue.c
                                                  inValue.bc = ToApply.bc or inValue.bc
                                        end
                              end
                              )
                              return { FancyLayout = inFancyLayoutTable }
                    end,
          }
end


gprocess.FancyLayout = function(inPresentation, inValue, inFrameIndex, inElementName)
          local Layout = inValue.layout
          Layout:Update(vec3(0, 0, gbaseDepth), vec3(gFrameDimension.x, gFrameDimension.y, 1))
          local Elements = {}
          IterateEachElementRecursively(Layout, function(inValue)
                    if type(inValue) == "table" and inValue.t and inValue.p and inValue.d then
                              table.insert(Elements, Copy(inValue))
                    end
          end
          )
          for i, value in ipairs(Elements) do
                    gprocess.FancyButton(inPresentation, Copy(FancyButton(value).FancyButton), inFrameIndex, value.en)
          end
end
