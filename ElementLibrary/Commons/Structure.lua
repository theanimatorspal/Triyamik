require "ElementLibrary.Commons.Require"

CStructure = function(inCStructureTable)
          local t = {}
          return { CStructure = Default(inCStructureTable, t) }
end

gGetSectionTables = function(inPresentation)
          local frames_of_each_sections = {}
          local common_section_elementnames = {}
          local common_section_titles = {}
          local commmon_section_element_names_linear = {}
          IterateEachFrame(inPresentation, function(eachFrameIndex, values)
                    for elementname, value in pairs(values) do
                              if values[elementname]["CSection"] then
                                        if not common_section_elementnames[elementname] then
                                                  common_section_elementnames[elementname] = true
                                                  common_section_titles[#common_section_titles + 1] = value.CSection.t
                                                  frames_of_each_sections[elementname] = {}
                                                  commmon_section_element_names_linear[#commmon_section_element_names_linear + 1] =
                                                      elementname
                                                  table.insert(frames_of_each_sections[elementname], eachFrameIndex)
                                        else
                                                  table.insert(frames_of_each_sections[elementname], eachFrameIndex)
                                        end
                              end
                    end
          end)
          return frames_of_each_sections,
              common_section_elementnames,
              common_section_titles,
              commmon_section_element_names_linear
end

gprocess.CStructure = function(inPresentation, inValue, inFrameIndex, inElementName)
          local frames_of_each_sections,
          common_section_elementnames,
          common_section_titles,
          commmon_section_element_names_linear = gGetSectionTables(inPresentation)

          local InsertElements = function(eachFrameIndex, _)
                    if eachFrameIndex >= inFrameIndex then
                              local topSectionElements = {}
                              for i = 1, #common_section_titles, 1 do
                                        local element = U {
                                                  t = common_section_titles[i],
                                                  bc = very_transparent_color,
                                                  _push_constant = StrechedPC
                                        }
                                        for key, value in pairs(frames_of_each_sections) do -- {s1 = {1, 2, 3}, s2 = {3, 4, 5}}
                                                  if key == commmon_section_element_names_linear[i] then
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
                                        { 0.06, 1 }
                              ):Update(vec3(0, 0, gbaseDepth),
                                        vec3(gFrameDimension.x, gFrameDimension.y, 1))


                              local horizontal_indicators = {}
                              local subelements_ko_subelements = {}
                              gprocess.CButton(
                                        inPresentation,
                                        CButton({ t = " ", p = "OUT_OUT" }).CButton,
                                        eachFrameIndex,
                                        "__common_section" .. "REMDIATION OF BUG")
                              local funcs = {}
                              for i, value in ipairs(topSectionElements) do
                                        local element_name = commmon_section_element_names_linear[i]
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
                                        gprocess.CButton(
                                                  inPresentation,
                                                  CButton(value).CButton,
                                                  eachFrameIndex,
                                                  "__common_section" .. element_name)
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
                                                  gprocess.CButton(inPresentation, CButton(element).CButton,
                                                            eachFrameIndex,
                                                            "__common_frame_indicators" .. i .. ":" .. j)
                                        end
                              end
                    end
          end
          IterateEachFrame(inPresentation, InsertElements)
end


--
--
--
--
--
-- MISC STRUCTURES
--
--
--
--

CSection = function(inCSectionTable)
          local t = {
                    t = "__Untitled"
          }
          return { CSection = Default(inCSectionTable, t) }
end


CTableOfContents = function(inCStructureTable)
          local t = {}
          return { CTableOfContents = Default(inCStructureTable, t) }
end


--[[




    FANCY STRUCTURE




]]


--[[



    FANCY SECTION



]]

gprocess.CSection = function(inPresentation, inValue, inFrameIndex, inElementName)
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
          --     gprocess.CButton(inPresentation,
          --         CButton(value).CButton,
          --         inFrameIndex,
          --         "__fancy_titlepage_title")
          -- end
end

--[[



    FANCY Table OF Contents



]]

gprocess.CTableOfContents = function(inPresentation, inValue, inFrameIndex, inElementName)
end

--[[



    FANCY NUMBERING



]]

CNumbering = function(inCNumbering)
          return { CNumbering = {} }
end

gprocess.CNumbering = function(inPresentation, inValue, inFrameIndex, inElementName)
          local totalframecount = 0
          IterateEachFrame(inPresentation, function(eachFrameIndex, _)
                    if eachFrameIndex >= inFrameIndex then
                              totalframecount = totalframecount + 1
                    end
          end)

          IterateEachFrame(inPresentation, function(eachFrameIndex, value)
                    local index = eachFrameIndex - inFrameIndex + 1
                    if eachFrameIndex >= inFrameIndex then
                              value.__fancy_numbering = CButton {
                                        t = "(" .. gTitle .. "): " .. index .. "/" .. totalframecount,
                                        p = "BOTTOM_RIGHT",
                                        interpolate_t = false
                              }
                    end
          end)
end
