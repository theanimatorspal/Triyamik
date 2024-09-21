require "ElementLibrary.Fancy.FancyRequire"

FancyStructure = function(inFancyStructureTable)
    local t = {}
    return { FancyStructure = Default(inFancyStructureTable, t) }
end

gGetSectionTables = function(inPresentation)
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
                    fanncy_section_element_names_linear[#fanncy_section_element_names_linear + 1] =
                        elementname
                    table.insert(frames_of_each_sections[elementname], eachFrameIndex)
                else
                    table.insert(frames_of_each_sections[elementname], eachFrameIndex)
                end
            end
        end
    end)
    return frames_of_each_sections,
        fancy_section_elementnames,
        fancy_section_titles,
        fanncy_section_element_names_linear
end

gprocess.FancyStructure = function(inPresentation, inValue, inFrameIndex, inElementName)
    local frames_of_each_sections = {}
    local fancy_section_elementnames = {}
    local fancy_section_titles = {}
    local fanncy_section_element_names_linear = {}
    frames_of_each_sections,
    fancy_section_elementnames,
    fancy_section_titles,
    fanncy_section_element_names_linear = gGetSectionTables(inPresentation)

    -- IterateEachFrame(inPresentation, function(eachFrameIndex, values)
    --           for elementname, value in pairs(values) do
    --                     if values[elementname]["FancySection"] then
    --                               if not fancy_section_elementnames[elementname] then
    --                                         fancy_section_elementnames[elementname] = true
    --                                         fancy_section_titles[#fancy_section_titles + 1] = value.FancySection.t
    --                                         frames_of_each_sections[elementname] = {}
    --                                         fanncy_section_element_names_linear[#fanncy_section_element_names_linear + 1] =
    --                                             elementname
    --                                         table.insert(frames_of_each_sections[elementname], eachFrameIndex)
    --                               else
    --                                         table.insert(frames_of_each_sections[elementname], eachFrameIndex)
    --                               end
    --                     end
    --           end
    -- end)


    local InsertElements = function(eachFrameIndex, _)
        if eachFrameIndex >= inFrameIndex then
            local topSectionElements = {}
            for i = 1, #fancy_section_titles, 1 do
                local element = U {
                    t = fancy_section_titles[i],
                    bc = very_transparent_color,
                    _push_constant = StrechedPC
                }
                for key, value in pairs(frames_of_each_sections) do -- {s1 = {1, 2, 3}, s2 = {3, 4, 5}}
                    if key == fanncy_section_element_names_linear[i] then
                        for _, frame_index in ipairs(value) do
                            if eachFrameIndex == frame_index then
                                element.bc = white_color
                                break;
                            end
                        end
                    end
                end
                topSectionElements[#topSectionElements + 1] = element
            end

            V():Add({
                    H():Add(
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
            gprocess.FancyButton(
                inPresentation,
                FancyButton({ t = " ", p = "OUT_OUT" }).FancyButton,
                eachFrameIndex,
                "__fancy_section" .. "REMDIATION OF BUG")
            local funcs = {}
            for i, value in ipairs(topSectionElements) do
                local element_name = fanncy_section_element_names_linear[i]
                local subelements = {}
                for _, frame in ipairs(frames_of_each_sections[element_name]) do
                    local element = U {
                        t = "",
                        bc = very_transparent_color,
                        _push_constant = StrechedPC
                    }
                    if frame == eachFrameIndex then
                        element.bc = white_color
                    end
                    subelements[#subelements + 1] = element
                end
                subelements_ko_subelements[#subelements_ko_subelements + 1] = subelements
                local horizontal = H():Add(subelements, CR(subelements))
                horizontal_indicators[#horizontal_indicators + 1] = horizontal
                gprocess.FancyButton(
                    inPresentation,
                    FancyButton(value).FancyButton,
                    eachFrameIndex,
                    "__fancy_section" .. element_name)
            end
            V():Add({
                    U {},
                    H():Add(horizontal_indicators, CR(horizontal_indicators))
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
    IterateEachFrame(inPresentation, InsertElements)
end
