require "ElementLibrary.Fancy.Fancy"
Pr = DefaultPresentation()
Pr.Config.FullScreen = true
-- todo fancyenumerate hide bug, should write all over again

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
                    -- FancyAndroid {},
          },
          Frame {
                    FancyTitlePage(titlepage),
                    FancyNumbering {},
                    FancyStructure {},
          },
          Frame {
                    FancyTitlePage { act = "structure" },
                    minmaj = FancyEnumerate {
                              items = {
                                        "Minor Project Overview",
                                        "Major Project Overview",
                                        "Scope",
                              },
                              hide = "all"
                    },
          },
          Frame {
                    s1 = FancySection { t = "Introduction" },
                    minmaj = FancyEnumerate {},
                    FancyLayout { layout = minor_layout() }.ApplyAll({ bc = vec4(vec3(1), 0), c = vec4(vec3(1), 0) }),
          },
          Frame {
                    s1 = FancySection {},
                    minmaj = FancyEnumerate { view = 1 },
                    FancyLayout { layout = minor_layout() }.Apply({ bc = very_transparent_color, c = vec4(0, 0, 0, 1) }),
          },
          Frame {
                    s1 = FancySection {},
                    minmaj = FancyEnumerate { view = 2 },
                    FancyLayout { layout = minor_layout() }.Apply({ bc = very_transparent_color, c = vec4(0, 0, 0, 1) }),
          },
          Frame {
                    s1 = FancySection {},
                    minmaj = FancyEnumerate { view = 2 },
                    FancyLayout { layout = major_layout() }.Apply({ bc = very_transparent_color, c = vec4(0, 0, 0, 1) }),
                    scope_enum = FancyEnumerate {
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
                    s1 = FancySection {},
                    minmaj = FancyEnumerate { view = 3 },
                    FancyLayout { layout = major_layout() }.ApplyAll({ bc = vec4(vec3(1), 0), c = vec4(vec3(1), 0) }),
                    scope_enum = FancyEnumerate { order = { 3, 1, 2 } },
                    it_was_all = Text { t = "It was all ", f = "Huge", c = vec4(vec3(1), 0) }
          },
          Frame {
                    s1 = FancySection {},
                    minmaj = FancyEnumerate { view = 3 },
                    scope_enum = FancyEnumerate { items = {} },
                    it_was_all = Text { t = "It was all ", f = "Huge", c = vec4(vec3(1), 0) },
                    FancyLayout { layout = major_layout() }.ApplyAll({ bc = vec4(vec3(1), 0), c = vec4(vec3(1), 0) }),
          },
          Frame {
                    s3 = FancySection { t = "Demonstration" },
                    minmaj = FancyEnumerate { hide = { 1, 2, 3 } },
                    scope_enum = FancyEnumerate { hide = { 1, 2, 3 } },
                    it_was_all = Text { t = "It was all ", f = "Huge", c = vec4(0, 0, 0, 0.5) }
          },
          Frame {
                    s3 = FancySection {},
                    it_was_all = Text {
                              t = "It was all a demonstration",
                              c = vec4(0, 0, 0, 1),
                              f = "Huge"
                    }
          },
          Frame {
                    s3 = FancySection {},
                    en = FancyEnumerate {
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
                    s2 = FancySection { t = "Tasks Completed" },
                    en = FancyEnumerate {},
                    it_was_all = Text { t = "Other Demonstrations", c = vec4(vec3(1), 0), f = "Huge" },
                    remain_enum = FancyEnumerate {
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
                    s4 = FancySection { t = "Remaining Works" },
                    en = FancyEnumerate { hide = { 1, 2, 3, 4, 5, 6 } },
                    remain_enum = FancyEnumerate {},
                    thank_you = Text { t = "Thank You", p = "CENTER_CENTER", f = "Huge", c = vec4(1, 1, 1, 0) }
          },
          Frame {
                    s4 = FancySection {},
                    remain_enum = FancyEnumerate { hide = "all" },
                    thank_you = Text { t = "Thank You, Any Questions ?", p = "CENTER_CENTER", f = "Huge", c = vec4(0, 0, 0, 1) }
          }
}

Pr:insert(P)
gPresentation(Pr, false)
