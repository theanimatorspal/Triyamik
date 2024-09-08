require("JkrGUIv2.Engine.Shader")

function default(inTable, def)
    if type(inTable) == "table" and type(def) == "table" then
        for key, value in pairs(def) do
            inTable[key] = default(inTable[key], value)
        end
        return inTable
    else
        return inTable or def
    end
end

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
CImage = function(inTable, inP, inD)
    if not inP then inP = "CENTER_CENTER" end
    if not inD then inD = vec2(500, 500) end
    local def = {
        shader = "",
        shader_parameters = {
            threads = vec3(100, 100, 1),
            p1 = vec4(0.0, 0.0, 1, 1),
            p2 = vec4(0, 0, 0, 0),
            p3 = vec4(0, 0, 0, 0),
        },
        p = inP,
        d = inD
    }
    return { CImage = default(inTable, def) }
end
Shader = function(inTable)
    return { Shader = inTable }
end


Shaders = {}

Shaders.FancyCircle = Engine.Shader()
