require "Present.Present"
local background_color = vec4(0.4 * 2, 0.2 * 1, 0.3 * 1, 1)
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

local AddToReuseText = function(inname, inT, inFrameIndex)
    if TextLibrary[inname] then
        FUCKYOU()
    else
        inT.__frame_index = inFrameIndex
        TextLibrary[inname] = inT
    end
    return inname
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


local StrechedPC =
    PC(
        vec4(0.0, 0.0, 0.95, 0.8),
        vec4(1),
        vec4(0.05, 0.5, 0.5, 0.0),
        vec4(0)
    )

local FullPC =
    PC(
        vec4(0.0, 0.0, 1, 1),
        vec4(1),
        vec4(0.5, 0.5, 0.5, 0.0),
        vec4(0)
    )

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
            _push_constant = StrechedPC
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
            { 0.5, 0.5 }),
        U()
    }, { 0.1, 0.2, 0.1, 0.4, 0.1 }
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


FancySection = function(inFancySectionTable)
    local t = {
        t = "Untitled"
    }
    return { FancySection = Default(inFancySectionTable, t) }
end

FancyStructure = function(inFancyStructureTable)
    local t = {}
    return { FancyStructure = Default(inFancyStructureTable, t) }
end


FancyTableOfContents = function(inFancyStructureTable)
    local t = {}
    return { FancyTableOfContents = Default(inFancyStructureTable, t) }
end

FancyNumbering = function(inFancyNumbering)
    return { FancyNumbering = {} }
end

gprocess.FancyStructure = function(inPresentation, inValue, inFrameIndex, inElementName)
    local frames_of_each_sections = {}
    local fancy_section_elementnames = {}
    local fancy_section_titles = {}
    local fanncy_section_element_names_linear = {}
    IterateEachFrame(inPresentation, function(eachFrameIndex, values)
        for elementname, value in pairs(values) do
            if values[elementname]["FancySection"] then
                if not fancy_section_elementnames[elementname] then
                    fancy_section_elementnames[elementname] = true
                    fancy_section_titles[#fancy_section_titles + 1] = value.FancySection.t
                    frames_of_each_sections[elementname] = {}
                    fanncy_section_element_names_linear[#fanncy_section_element_names_linear + 1] = elementname
                    table.insert(frames_of_each_sections[elementname], eachFrameIndex)
                else
                    table.insert(frames_of_each_sections[elementname], eachFrameIndex)
                end
            end
        end
    end)


    local fff = function(eachFrameIndex, _)
        if eachFrameIndex >= inFrameIndex then
            local topSectionElements = {}
            for i = 1, #fancy_section_titles, 1 do
                local element = U {
                    t = fancy_section_titles[i],
                    bc = vec4(1, 1, 1, 0.5),
                    _push_constant = StrechedPC
                }
                for key, value in pairs(frames_of_each_sections) do -- {s1 = {1, 2, 3}, s2 = {3, 4, 5}}
                    if key == fanncy_section_element_names_linear[i] then
                        for _, frame_index in ipairs(value) do
                            if eachFrameIndex == frame_index then
                                element.bc = vec4(1, 1, 1, 1)
                                break;
                            end
                        end
                    end
                end
                topSectionElements[#topSectionElements + 1] = element
            end

            V():AddComponents({
                    H():AddComponents(
                        topSectionElements,
                        CR(topSectionElements, 1)
                    ),
                    U {}
                },
                { 0.06, 0.9 }
            ):Update(vec3(0, 0, gbaseDepth),
                vec3(gFrameDimension.x, gFrameDimension.y, 1))

            local horizontal_indicators = {}
            local subelements_ko_subelements = {}
            for i, value in ipairs(topSectionElements) do
                local element_name = fanncy_section_element_names_linear[i]
                gprocess.FancyButton(inPresentation, FancyButton(value).FancyButton, eachFrameIndex,
                    "__fancy_section" .. element_name)
                local subelements = {}
                for _, frame in ipairs(frames_of_each_sections[element_name]) do
                    local element = U {
                        t = "",
                        bc = vec4(1, 1, 1, 0.5),
                        _push_constant = StrechedPC
                    }
                    if frame == eachFrameIndex then
                        element.bc = vec4(1, 1, 1, 1)
                    end
                    subelements[#subelements + 1] = element
                end
                subelements_ko_subelements[#subelements_ko_subelements + 1] = subelements
                local horizontal = H():AddComponents(subelements, CR(subelements))
                horizontal_indicators[#horizontal_indicators + 1] = horizontal
            end
            V():AddComponents({
                    U {},
                    H():AddComponents(horizontal_indicators, CR(horizontal_indicators))
                },
                { 0.06, 0.02 }
            ):Update(vec3(0, 0, gbaseDepth),
                vec3(gFrameDimension.x, gFrameDimension.y, 1))

            for i, subelements in ipairs(subelements_ko_subelements) do
                for j, element in ipairs(subelements) do
                    gprocess.FancyButton(inPresentation, FancyButton(element).FancyButton,
                        eachFrameIndex,
                        "__fancy_frame_indicators" .. i .. ":" .. j)
                end
            end
        end
    end
    IterateEachFrame(inPresentation, fff)
end

gprocess.FancySection = function(inPresentation, inValue, inFrameIndex, inElementName)
end

gprocess.FancyTableOfContents = function(inPresentation, inValue, inFrameIndex, inElementName)
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
                t = index .. "/" .. totalframecount,
                p = "BOTTOM_RIGHT",
                interpolate_t = false
            }
        end
    end)
end
