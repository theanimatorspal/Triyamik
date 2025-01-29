require "ElementLibrary.Commons.Commons"
require "ElementLibrary.Procedurals.Procedurals"
require "sync"

local Validation = VALIDATION

local BG = function(inTable)
          local t = {
                    line_size = 0,
                    mark_size = vec3(0),
                    grid_color = vec4(gcolors.dandelion, 1),
                    x_count = 50,
                    y_count = 50,
                    mark = vec3(0),
          }
          inTable = Default(inTable, t)
          return PRO.Grid3D(inTable)
end

local C = function(inTable)
          local t = {
                    e = vec3(100, 10, -100),
                    type = "ORTHO",
                    fov = 44,

          }
          inTable = Default(inTable, t)
          return PRO.Camera3D(inTable)
end

local Initialize = {
          -- Frame {
          --           background_grid = BG {},
          -- }
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


gPresentation(Initialize, Validation, "NoLoop")

local P = {
          Frame {
                    CTitlePage {
                              t = "Triyamik",
                              st = "A Graphics Engine based on JkrGUI",
                              names = {
                                        "077bct022 Bishal Jaiswal",
                                        "077bct024 Darshan Koirala",
                                        "077bct027 Dipesh Regmi",
                              },
                              logo = "tulogo.png"
                    },
                    CNumbering {},
                    camera = C {},
                    background_grid = BG {},
          },
          Frame {
                    CTitlePage { act = "structure" },
                    camera = C {},
                    background_grid = BG {},
          },
          Frame {
                    camera = C {},
                    background_grid = BG {
                    },
                    first = CPictureWithLabelList {
                              type = "HORIZONTAL",
                              paths = { "tiny_res/sample app2.png", "tiny_res/sampleapp3.png", "tiny_res/SampleApplication.png", "tiny_res/simulated annealing stuff.png" },
                              texts = { "app1", "app2", "app3", "app4" },
                              ic = vec4(gcolors.amber, 0),
                              tc = vec4(gcolors.amber, 0),
                              index = 1
                    }
          },
          Frame {
                    first = CPictureWithLabelList {
                              type = "HORIZONTAL",
                              p = vec3(((gFrameDimension.x / 2) - 100), ((gFrameDimension.y / 2) - 100), 1),
                              d = vec3(200, 200, 1),
                              paths = { "tiny_res/sample app2.png", "tiny_res/sampleapp3.png", "tiny_res/SampleApplication.png", "tiny_res/simulated annealing stuff.png" },
                              texts = { "app1", "app2", "app3", "app4" },
                              index = 1
                    }
          },
          Frame {
                    first = CPictureWithLabelList {
                              p = vec3(((gFrameDimension.x / 2) - 100), ((gFrameDimension.y / 2) - 100), 1),
                              d = vec3(200, 200, 1),
                              type = "HORIZONTAL",
                              index = 2
                    }
          },
          Frame {
                    first = CPictureWithLabelList {
                              p = vec3(((gFrameDimension.x / 2) - 100), ((gFrameDimension.y / 2) - 100), 1),
                              d = vec3(200, 200, 1),
                              type = "HORIZONTAL",
                              index = 3
                    }
          },
          Frame {
                    first = CPictureWithLabelList {
                              p = vec3(((gFrameDimension.x / 2) - 100), ((gFrameDimension.y / 2) - 100), 1),
                              d = vec3(200, 200, 1),
                              type = "HORIZONTAL",
                              index = 4
                    },
                    CLayout { layout = minor_layout() }.Apply({ bc = vec4(0), c = vec4(0) }),
          },
          Frame {
                    first = CPictureWithLabelList {
                              ic = vec4(gcolors.red, 0),
                              tc = vec4(gcolors.red, 0),
                              type = "HORIZONTAL",
                              index = 4
                    },
                    s1 = CSection {},
                    minmaj = CEnumerate { view = 1 },
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
}

P.Config = {
          FullScreen = false,
          FontSizes = gGetDefaultFontSizes(),
          FontFilePaths = { "font.ttf" }
}
gPresentation(P, Validation, "GeneralLoop")
