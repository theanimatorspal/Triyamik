require "Present.Present"
local background_color = vec4(0.02, 0.4 * 2, 0.5 * 2, 1)
local accent_color = vec4(0.6, 0.4, 0.5, 0.7)
local inverse_text_color = vec4(1)
local transparent_color = vec4(1, 1, 1, 0.8)

local function U(inValue)
    if not inValue then inValue = {} end
    inValue.Update = function(self, inPosition_3f, inDimension_3f)
        inValue.d = vec3(inDimension_3f)
        inValue.p = vec3(inPosition_3f)
    end
    return inValue
end

local TextLibrary = {}
local GetFromReuseText = function(inname, inT, inFrameIndex)
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

local function CR(inelements, intotal_1)
    if not intotal_1 then intotal_1 = 1 end
    local namesratio = {}
    if type(inelements) ~= "number" then
        for _ = 1, #inelements, 1 do
            namesratio[#namesratio + 1] = (intotal_1) / #inelements
        end
        return namesratio
    elseif type(inelements) == "number" then
        for _ = 1, inelements, 1 do
            namesratio[#namesratio + 1] = intotal_1 / inelements
        end
    end
end
local UPK = table.unpack

local function V()
    return Jkr.VLayout:New()
end
local function H()
    return Jkr.HLayout:New()
end

local function S()
    return Jkr.StackLayout:New()
end

local function PC(a, b, c, d)
    local Push = Jkr.Matrix2CustomImagePainterPushConstant()
    Push.a = mat4(a, b, c, d)
    return Push
end


FancyTitlePage = function(inTitlePage)
    local t = {
        t = "JkrGUIv2",
        st = "shitty bull",
        names = {
            "Name A",
            "Name B",
            "Name C"
        },
        left = "", -- OR "filepath"
        remove = false
    }
    return { FancyTitlePage = Default(inTitlePage, t) }
end

gprocess["FancyTitlePage"] = function(inPresentation, inValue, inFrameIndex, inElementName)
    local ElementName = Unique(inElementName)
    local Push = PC(
        vec4(0.0, 0.0, 0.5, 0.5),
        vec4(1),
        vec4(0.8, 0.5, 0.5, 0.0),
        vec4(0)
    )
    local background = {
        t = " ",
        p = vec3(-40, -40, gbaseDepth + 20),
        d = vec3(gFrameDimension.x + 80, gFrameDimension.y + 80, 1),
        bc = background_color,
        _push_constant = Push
    }
    gprocess.FancyButton(inPresentation, FancyButton(background).FancyButton, inFrameIndex,
        "__fancy__background")
    local t = U({
        f = "Huge",
        t = inValue.t,
        _push_constant = Push,
        bc = transparent_color,
    })
    local st = U({
        f = "Large",
        t = inValue.st,
        _push_constant = Push,
        bc = transparent_color,
    })
    local names = { U() }
    for _, value in pairs(inValue.names) do
        names[#names + 1] = U({
            t = value,
            bc = transparent_color,
            _push_constant = PC(
                vec4(0.0, 0.0, 0.95, 0.8),
                vec4(1),
                vec4(0.05, 0.5, 0.5, 0.0),
                vec4(0)
            )
        })
    end
    local namesratio = { 0.3, UPK(CR(names, 1 - 0.3)) }


    V():AddComponents({
        U(),
        t,
        st,
        H():AddComponents({
                U(),
                V():AddComponents(names, namesratio),
            },
            { 0.5, 0.5 })
    }, { 0.1, 0.2, 0.1, 0.5 }
    ):Update(vec3(0, 0, gbaseDepth), vec3(gFrameDimension.x, gFrameDimension.y, 1))

    gprocess.FancyButton(inPresentation, FancyButton(t).FancyButton, inFrameIndex,
        "__fancy_titlepage_title")
    gprocess.FancyButton(inPresentation, FancyButton(st).FancyButton, inFrameIndex,
        "__fancy_titlepage_sub_title")

    for i = 1, #names - 1, 1 do
        gprocess.FancyButton(inPresentation, FancyButton(names[i + 1]).FancyButton, inFrameIndex,
            "__fancy__name__" .. i)
    end
end

FancyStructure = function(inFancyStructureTable)
    local t = {}
    return { FancyStructure = Default(inFancyStructureTable, t) }
end

FancySection = function()
    local t = {
        t = "A section"
    }
end
