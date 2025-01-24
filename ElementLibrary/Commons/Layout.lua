require "Present.Present"

CLayout = function(inCLayoutTable)
          return {
                    CLayout = inCLayoutTable,
                    Apply = function(ToApply)
                              IterateEachElementRecursively(inCLayoutTable, function(inValue)
                                        if type(inValue) == "table" and inValue.t then
                                                  inValue.c = inValue.c or ToApply.c
                                                  inValue.bc = inValue.bc or ToApply.bc
                                        end
                              end
                              )
                              return { CLayout = inCLayoutTable }
                    end,
                    ApplyAll = function(ToApply)
                              IterateEachElementRecursively(inCLayoutTable, function(inValue)
                                        if type(inValue) == "table" and inValue.t then
                                                  inValue.c = ToApply.c or inValue.c
                                                  inValue.bc = ToApply.bc or inValue.bc
                                        end
                              end
                              )
                              return { CLayout = inCLayoutTable }
                    end,
          }
end


gprocess.CLayout = function(inPresentation, inValue, inFrameIndex, inElementName)
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
                    -- et = elementType i.e. CButton
                    if not value.et then
                              gprocess.CButton(inPresentation, Copy(CButton(value).CButton), inFrameIndex, value.en)
                    else
                              gprocess[value.et](inPresentation, Copy(_G[value.et](value)[value.et]),
                                        inFrameIndex, value.en)
                    end
          end
end
