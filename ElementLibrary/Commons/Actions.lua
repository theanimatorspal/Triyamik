CContinue = function(inTable)
          -- { boolean_true_false, function_that_is_invoked_each_time_and_returns_true_or_false}
          return { CContinue = inTable }
end

gprocess.CContinue = function(inPresentation, inValue, inFrameIndex, inElementName)
          gAddFrameKeyElement(inFrameIndex, {
                    {
                              "CContinue",
                              inValue
                    }
          })
end

ExecuteFunctions["CContinue"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
          if (inElement[2][2]) then
                    inPresentation.ContinousAutoPlay(inElement[2][2]())
          else
                    inPresentation.ContinousAutoPlay(inElement[2][1])
          end
end

CCircularSwitch = function(inTable)
          return { CCircularSwitch = inTable }
end

gprocess.CCircularSwitch = function(inPresentation, inValue, inFrameIndex, inElementName)
          gAddFrameKeyElement(inFrameIndex, {
                    {
                              "CCircularSwitch",
                              inValue
                    }
          })
end

ExecuteFunctions["CCircularSwitch"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
          if (inElement[2][2]) then
                    inPresentation.CircularSwitch(inElement[2][2]())
          else
                    inPresentation.CircularSwitch(inElement[2][1])
          end
end

CReverse = function(inTable)
          return { CReverse = inTable }
end

gprocess.CReverse = function(inPresentation, inValue, inFrameIndex, inElementName)
          gAddFrameKeyElement(inFrameIndex, {
                    {
                              "CReverse",
                              inValue
                    }
          })
end

ExecuteFunctions["CReverse"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
          inPresentation.SetDirection(inElement[2])
end
