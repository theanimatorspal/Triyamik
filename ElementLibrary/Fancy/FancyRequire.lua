require "Present.Present"
background_color = vec4(0.6 * 1, 0.4 * 2, 0.6 * 2, 1)
accent_color = vec4(0.6, 0.4, 0.5, 0.7)
inverse_text_color = vec4(1)
transparent_color = vec4(1, 1, 1, 0.8)
very_transparent_color = vec4(1, 1, 1, 0.2)
white_color = vec4(1)

function U(inValue)
          if not inValue then inValue = {} end
          inValue.Update = function(self, inPosition_3f, inDimension_3f)
                    inValue.d = vec3(inDimension_3f)
                    inValue.p = vec3(inPosition_3f)
          end
          return inValue
end

TextLibrary = {}
GetFromReuseText = function(inname, inT, inFrameIndex)
          if TextLibrary[inname] then
                    FUCKYOU()
          else
                    for key, value in pairs(TextLibrary) do
                              if TextLibrary[key].f == inT.f and TextLibrary[key].__frame_index ~= inFrameIndex then
                                        TextLibrary[key] = nil
                                        return key
                              end
                    end
          end
end

AddToReuseText = function(inname, inT, inFrameIndex)
          if TextLibrary[inname] then
                    FUCKYOU()
          else
                    inT.__frame_index = inFrameIndex
                    TextLibrary[inname] = inT
          end
          return inname
end

function CR(inelements, intotal_1)
          if not intotal_1 then intotal_1 = 1 end
          local namesratio = {}
          if type(inelements) ~= "number" then
                    for _ = 1, #inelements, 1 do
                              namesratio[#namesratio + 1] = (intotal_1) / #inelements
                    end
          elseif type(inelements) == "number" then
                    for _ = 1, inelements, 1 do
                              namesratio[#namesratio + 1] = intotal_1 / inelements
                    end
          end
          return namesratio
end

UPK = table.unpack

function V()
          return Jkr.VLayout:New()
end

function H()
          return Jkr.HLayout:New()
end

function S()
          return Jkr.StackLayout:New()
end

function PC(a, b, c, d)
          local Push = Jkr.Matrix2CustomImagePainterPushConstant()
          Push.a = mat4(a, b, c, d)
          return Push
end

StrechedPC =
    PC(
              vec4(0.0, 0.0, 0.95, 0.8),
              vec4(1),
              vec4(0.05, 0.5, 0.5, 0.0),
              vec4(0)
    )

FullPC =
    PC(
              vec4(0.0, 0.0, 1, 1),
              vec4(1),
              vec4(0.5, 0.5, 0.5, 0.0),
              vec4(0)
    )
