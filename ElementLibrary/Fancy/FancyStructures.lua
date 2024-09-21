require "ElementLibrary.Fancy.FancyRequire"

FancySection = function(inFancySectionTable)
    local t = {
        t = "__Untitled"
    }
    return { FancySection = Default(inFancySectionTable, t) }
end


FancyTableOfContents = function(inFancyStructureTable)
    local t = {}
    return { FancyTableOfContents = Default(inFancyStructureTable, t) }
end


--[[




    FANCY STRUCTURE




]]


--[[



    FANCY SECTION



]]

gprocess.FancySection = function(inPresentation, inValue, inFrameIndex, inElementName)
    -- if inValue.t ~= "__Untitled" then
    --     local value = U(Copy(gTitlePageData.t))
    --     value.t = inValue.t
    --     value.f = "Normal"
    --     V():Add(
    --         {
    --             U(),
    --             value,
    --             U()
    --         }, { 0.1, 0.1, 0.85 }):Update(vec3(0, 0, gbaseDepth), vec3(gFrameDimension.x, gFrameDimension.y, 1))
    --     gprocess.FancyButton(inPresentation,
    --         FancyButton(value).FancyButton,
    --         inFrameIndex,
    --         "__fancy_titlepage_title")
    -- end
end

--[[



    FANCY Table OF Contents



]]

gprocess.FancyTableOfContents = function(inPresentation, inValue, inFrameIndex, inElementName)
end

--[[



    FANCY NUMBERING



]]

FancyNumbering = function(inFancyNumbering)
    return { FancyNumbering = {} }
end

gprocess.FancyNumbering = function(inPresentation, inValue, inFrameIndex, inElementName)
    local totalframecount = 0
    IterateEachFrame(inPresentation, function(eachFrameIndex, _)
        if eachFrameIndex >= inFrameIndex then
            totalframecount = totalframecount + 1
        end
    end)

    IterateEachFrame(inPresentation, function(eachFrameIndex, value)
        local index = eachFrameIndex - inFrameIndex + 1
        if eachFrameIndex >= inFrameIndex then
            value.__fancy_numbering = FancyButton {
                t = "(" .. gTitle .. "): " .. index .. "/" .. totalframecount,
                p = "BOTTOM_RIGHT",
                interpolate_t = false
            }
        end
    end)
end
