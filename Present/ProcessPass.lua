require("Present.require")

local index = 0
gUnique = function(inElementName) -- Generate Unique Name
    if type(inElementName) == "number" then
        index = index + 1
        return index
    elseif type(inElementName) == "string" then
        return inElementName
    end
end

local AddFrameKey = function(inKey, inFrameIndex)
    gFrameKeys[inFrameIndex][#gFrameKeys[inFrameIndex] + 1] = inKey
end

gAddFrameKeyElement = function(inFrameIndex, inElements)
    AddFrameKey({
        FrameIndex = inFrameIndex,
        Elements = inElements,
    }, inFrameIndex)
end

local AddFrameKeyCompute = function(inKey, inFrameIndex)
    gFrameKeysCompute[inFrameIndex][#gFrameKeysCompute[inFrameIndex] + 1] = inKey
end

gAddFrameKeyElementCompute = function(inFrameIndex, inElements)
    AddFrameKeyCompute({
        FrameIndex = inFrameIndex,
        Elements = inElements,
    }, inFrameIndex)
end

gprocess = {
    Text = function(inPresentation, inValue, inFrameIndex, inElementName)
        local ElementName = gUnique(inElementName)
        if not gscreenElements[ElementName] then
            gscreenElements[ElementName] =
                gwid.CreateTextLabel(
                    vec3(math.huge),
                    vec3(math.huge),
                    gFontMap[inValue.f],
                    inValue.t,
                    inValue.c
                )
        end
        inValue.d = gFontMap[inValue.f]:GetTextDimension(inValue.t)
        AddFrameKey({
            FrameIndex = inFrameIndex,
            Elements = { {
                "TEXT",
                handle = gscreenElements[ElementName],
                value = inValue,
                name = ElementName
            } }
        }, inFrameIndex)
    end,
}
