require "Present.Present"

local function CreateUpdatable(inValue)
    inValue.Update = function(self, inPosition_3f, inDimension_3f)
        inValue.d = vec3(inDimension_3f)
        inValue.p = vec3(inPosition_3f)
    end
    return inValue
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

ProcessFunctions["FancyTitlePage"] = function(inPresentation, inValue, inFrameIndex, inElementName)
    local ElementName = Unique(inElementName)
    local Push = Jkr.Matrix2CustomImagePainterPushConstant()
    Push.a = mat4(
        vec4(0.0, 0.0, 0.86, 0.86),
        vec4(1),
        vec4(0.1, 0.5, 0.5, 0.0),
        vec4(0)
    )
    local background = {
        t = " ",
        p = vec3(-40, -40, gbaseDepth + 20),
        d = vec3(gFrameDimension.x + 80, gFrameDimension.y + 80, 1),
        bc = vec4(0.8, 0.4, 0.5, 1),
        _push_constant = Push
    }
    ProcessFunctions["FancyButton"](inPresentation, FancyButton(background).FancyButton, inFrameIndex,
        "__fancy__background" .. inElementName)
    local t = CreateUpdatable({ f = "Huge", t = inValue.t, _push_constant = Push })
    local st = CreateUpdatable({ f = "Large", t = inValue.st, _push_constant = Push })
    local names = { CreateUpdatable({}) }
    local namesratio = { 0.3 }
    for _, value in pairs(inValue.names) do
        names[#names + 1] = CreateUpdatable({ t = value, bc = vec4(1, 1, 1, 0.8), Push })
    end

    Push.a = mat4(
        vec4(0.0, 0.0, 1.0, 1.0),
        vec4(1),
        vec4(0.1, 0.5, 0.5, 0.0),
        vec4(0)
    )

    for _ = 1, #names, 1 do
        namesratio[#namesratio + 1] = (1 - 0.3) / #names
    end

    local function V()
        return Jkr.VLayout:New()
    end
    local function H()
        return Jkr.HLayout:New()
    end

    V():AddComponents({
        t,
        st,
        V():AddComponents(names, namesratio)
    }, { 0.3, 0.2, 0.5 }
    ):Update(vec3(0, 0, gbaseDepth), vec3(gFrameDimension.x, gFrameDimension.y, 1))

    ProcessFunctions["FancyButton"](inPresentation, FancyButton(t).FancyButton, inFrameIndex,
        "__fancy_titlepage_title" .. ElementName)
    ProcessFunctions["FancyButton"](inPresentation, FancyButton(st).FancyButton, inFrameIndex,
        "__fancy_titlepage_sub_title" .. ElementName)

    for i = 1, #names - 1, 1 do
        ProcessFunctions["FancyButton"](inPresentation, FancyButton(names[i + 1]).FancyButton, inFrameIndex,
            "__fancy__name__" .. names[i + 1].t)
    end
end
