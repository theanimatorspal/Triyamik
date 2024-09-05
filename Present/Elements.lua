require("JkrGUIv2.Engine.Shader")

-- local function default(inTable, )
-- end
-- yet to do

Frame = function(inTable)
          return { Frame = inTable }
end
TitlePage = function(inTable) return { TitlePage = inTable } end
Enumerate = function(inTable) return { Enumerate = inTable } end
Animation = function(inStyle) return { Style = inStyle } end
Item = function(inStr)
          return inStr
end
Text = function(inText)
          return { Text = inText }
end
CImage = function(inTable)
          local t = {
                    shader = inTable.shader or "",
                    shader_parameters = inTable.shader_parameters or
                        {
                                  threads = vec3(100, 100, 1),
                                  p1 = vec4(0.0, 0.0, 1, 1),
                                  p2 = vec4(1, 0, 0, 1),
                                  p3 = vec4(0.1, 1, 0, 0),
                        },
                    p = inTable.p or "CENTER_CENTER",
                    d = inTable.d or vec2(700, 700)
          }
          return { CImage = t }
end
Shader = function(inTable)
          return { Shader = inTable }
end


Shaders = {}

Shaders.FancyCircle = Engine.Shader()
