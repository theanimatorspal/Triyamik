require("JkrGUIv2.Engine.Shader")

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
          return { CImage = inTable }
end
Shader = function(inTable)
          return { Shader = inTable }
end


Shaders = {}

Shaders.FancyCircle = Engine.Shader()
