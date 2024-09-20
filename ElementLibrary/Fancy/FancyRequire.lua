require "Present.Present"
background_color = vec4(0.6 * 1, 0.4 * 2, 0.6 * 2, 1)
accent_color = vec4(0.6, 0.4, 0.5, 0.7)
inverse_text_color = vec4(1)
transparent_color = vec4(1, 1, 1, 0.8)
very_transparent_color = vec4(1, 1, 1, 0.2)
white_color = vec4(1)

table.contains = function(inTable, inValue)
    for i, value in pairs(inTable) do
        if inValue == value then
            return value
        end
    end
    for i, value in ipairs(inTable) do
        if inValue == value then
            return value
        end
    end
    return false
end

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

function V(inComponents, inComponentsRatio)
    if not inComponents and not inComponentsRatio then
        return Jkr.VLayout:New()
    else
        local v = Jkr.VLayout:New()
        v:AddComponents(inComponents, inComponentsRatio)
        return v
    end
end

function H(inComponents, inComponentsRatio)
    if not inComponents and not inComponentsRatio then
        return Jkr.HLayout:New()
    else
        local h = Jkr.HLayout:New()
        h:AddComponents(inComponents, inComponentsRatio)
        return h
    end
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


rel_to_abs_p = function(inP)
    local relx = (inP.x + 1) / 2.0 * gFrameDimension.x
    local rely = (inP.y + 1) / 2.0 * gFrameDimension.y
    return vec3(relx, rely, gbaseDepth)
end

rel_to_abs_d = function(inD)
    local relx = inD.x * gFrameDimension.x
    local rely = inD.y * gFrameDimension.y
    return vec3(relx, rely, 1.0)
end
