require "Present.Present"
require "ElementLibrary.Commons.Commons"
PRO = {}
function PC(a, b, c, d, e, f, g, h)
          local Push = Jkr.Matrix2CustomImagePainterPushConstant()
          Push.a = mat4(a, b, c, d)
          if e and f and g and h then
                    Push.b = mat4(e, f, g, h)
          end
          return Push
end

function PC_Mats(a, b)
          local Push = Jkr.Matrix2CustomImagePainterPushConstant()
          Push.a = a
          Push.b = b
          return Push
end
