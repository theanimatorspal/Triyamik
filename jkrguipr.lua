require "ElementLibrary.Commons.Commons"
Pr = gDefaultConfiguration()
Pr.Config.StepTime = 0.1
Pr.Config.FullScreen = true
-- todo commonenumerate hide bug, should write all over again

local titlepage = {
          t = "Triyamik",
          st = "A Graphics Engine based on JkrGUI",
          names = {
                    "077bct022 Bishal Jaiswal",
                    "077bct024 Darshan Koirala",
                    "077bct027 Dipesh Regmi",
          },
          logo = "tulogo.png"
}

local architecture_minor = function()
          return V({
                    U { t = "Application", en = "ping", c = vec4(vec3(1), 0), bc = vec4(vec3(1), 0) },
                    U { t = "jkrgui", en = "jkrgui" },
                    U { t = "jkrengine (2D)", en = "jkrengine" },
                    U { t = "jkrjni", en = "jkrjni", bc = vec4(vec3(1), 0), c = vec4(vec3(1), 0) },
                    H({ U { t = "SDL(Events)", en = "sdl" }, U { t = "ksaivulkan", en = "kvk" } }, { 0.5, 0.5 }),
                    H({ U { t = "Win, Mac", en = "papi" }, U { t = "Vulkan API", en = "vapi" } }, { 0.5, 0.5 })
          }, { 0, 0.25, 0.25, 0, 0.25, 0.25 })
end


local minor_layout = function()
          return V({
                    U(),
                    H({ U(), architecture_minor(), U() }, { 0.2, 0.6, 0.2 }),
                    U()
          }, { 0.25, 0.6, 0.25 })
end

local count = 6
local architecture_major = function()
          return V({
                    U { t = "Application", en = "ping", bc = transparent_color },
                    U { t = "jkrgui", en = "jkrgui", bc = vec4(1, 0.9, 0.5, 0.5) },
                    U { t = "jkrengine (2D + 3D)", en = "jkrengine", bc = vec4(1, 0.9, 0.5, 0.5) },
                    U { t = "jkrjni", en = "jkrjni", bc = transparent_color },
                    H({ U { t = "SDL(Events)", en = "sdl" }, U { t = "ksaivulkan", en = "kvk" } }, { 0.5, 0.5 }),
                    H({ U { t = "Win, Mac, Android", en = "papi" }, U { t = "Vulkan API", en = "vapi" } }, { 0.5, 0.5 })
          }, { 1 / count, 1 / count, 1 / count, 1 / count, 1 / count, 1 / count })
end

local major_layout = function()
          return V({
                    U(),
                    H({ U(), architecture_major(), U() }, { 0.2, 0.6, 0.2 }),
                    U()
          }, { 0.25, 0.6, 0.25 })
end


P = {
          Frame {
                    CAndroid {},
          },
          Frame {
                    CTitlePage(titlepage),
                    CNumbering {},
                    CStructure {},
          },
          Frame {
                    CTitlePage { act = "structure" },
                    minmaj = CEnumerate {
                              items = {
                                        "Minor Project Overview",
                                        "Major Project Overview",
                                        "Scope",
                              },
                              hide = "all"
                    },
                    -- CButton {
                    --           onclick = function()
                    --                     gMoveToParicular(13)
                    --           end
                    -- }
          },
          Frame {
                    s1 = CSection { t = "Introduction" },
                    minmaj = CEnumerate {},
                    CLayout { layout = minor_layout() }.ApplyAll({ bc = vec4(vec3(1), 0), c = vec4(vec3(1), 0) }),
          },
          Frame {
                    s1 = CSection {},
                    minmaj = CEnumerate { view = 1 },
                    CLayout { layout = minor_layout() }.Apply({ bc = very_transparent_color, c = vec4(0, 0, 0, 1) }),
          },
          Frame {
                    s1 = CSection {},
                    minmaj = CEnumerate { view = 2 },
                    CLayout { layout = minor_layout() }.Apply({ bc = very_transparent_color, c = vec4(0, 0, 0, 1) }),
          },
          Frame {
                    s1 = CSection {},
                    minmaj = CEnumerate { view = 2 },
                    CLayout { layout = major_layout() }.Apply({ bc = very_transparent_color, c = vec4(0, 0, 0, 1) }),
                    scope_enum = CEnumerate {
                              items = {
                                        "2D + 3D Rendering and Presentation",
                                        "Mobile <-> PC Communication",
                                        "Research for Android Devices"
                              },
                              hide = "all"
                    },
                    it_was_all = Text { t = "It was all ", f = "Huge", c = vec4(vec3(1), 0) }
          },
          Frame {
                    s1 = CSection {},
                    minmaj = CEnumerate { view = 3 },
                    CLayout { layout = major_layout() }.ApplyAll({ bc = vec4(vec3(1), 0), c = vec4(vec3(1), 0) }),
                    scope_enum = CEnumerate { order = { 3, 1, 2 } },
                    it_was_all = Text { t = "It was all ", f = "Huge", c = vec4(vec3(1), 0) }
          },
          Frame {
                    s1 = CSection {},
                    minmaj = CEnumerate { view = 3 },
                    scope_enum = CEnumerate { items = {} },
                    it_was_all = Text { t = "It was all ", f = "Huge", c = vec4(vec3(1), 0) },
                    CLayout { layout = major_layout() }.ApplyAll({ bc = vec4(vec3(1), 0), c = vec4(vec3(1), 0) }),
          },
          Frame {
                    s3 = CSection { t = "Demonstration" },
                    minmaj = CEnumerate { hide = { 1, 2, 3 } },
                    scope_enum = CEnumerate { hide = { 1, 2, 3 } },
                    it_was_all = Text { t = "It was all ", f = "Huge", c = vec4(0, 0, 0, 0.5) }
          },
          Frame {
                    s3 = CSection {},
                    it_was_all = Text {
                              t = "It was all a demonstration",
                              c = vec4(0, 0, 0, 1),
                              f = "Huge"
                    }
          },
          Frame {
                    s3 = CSection {},
                    en = CEnumerate {
                              items = {
                                        "Refactoring Code (C++, Lua, Java) and Interlop C++ <-> Lua <-> Java",
                                        "Basic PBR with Texture, and IBL",
                                        "Deferred Rendering",
                                        "Shadow Mapping",
                                        "Basic Architecture of Presentation Engine",
                                        "Basic Networking and RCE",
                              },
                              hide = "all"
                    },
                    it_was_all = Text { t = "Other Demonstrations", c = vec4(0, 0, 0, 1), f = "Huge" }
          },
          Frame {
                    s2 = CSection { t = "Tasks Completed" },
                    en = CEnumerate {},
                    it_was_all = Text { t = "Other Demonstrations", c = vec4(vec3(1), 0), f = "Huge" },
                    remain_enum = CEnumerate {
                              items = {
                                        "Architecture Finalization and 3D Integration",
                                        "Context Aware UI",
                                        "Robust Networking Support(Multiple Clients)",
                                        "Full PBR, Large Scenes 3D Support",
                                        "Procedural 2D/3D Animations (Compute  Shaders)",
                                        "Accelerometer + Event Management",
                                        "Sample Applications",
                                        "Optimization + Documentation",
                              },
                              hide = "all"
                    }
          },
          Frame {
                    s4 = CSection { t = "Remaining Works" },
                    en = CEnumerate { hide = { 1, 2, 3, 4, 5, 6 } },
                    remain_enum = CEnumerate {},
                    thank_you = Text { t = "Thank You", p = "CENTER_CENTER", f = "Huge", c = vec4(1, 1, 1, 0) }
          },
          Frame {
                    s4 = CSection {},
                    remain_enum = CEnumerate { hide = "all" },
                    thank_you = Text { t = "Thank You, Any Questions ?", p = "CENTER_CENTER", f = "Huge", c = vec4(0, 0, 0, 1) }
          }
}

-- Pr:insert(P)
-- gPresentation(Pr, true, "GeneralLoop")

-- P = {
--           Frame {
--                     text = CText {
--                               t = "FUCK YOU",
--                     }
--           },
--           Frame {
--                     text = CText {
--                               t = "How are you",
--                               p = vec3(0, 0, gbaseDepth)
--                     }
--           }
-- }

Pr:insert(P)
gPresentation(Pr, true, "GeneralLoop")

-- print(inspect(gFrameKeys))
