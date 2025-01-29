require "ElementLibrary.Procedurals.Procedurals"
require "sync"

local conf = gGetPresentationWithDefaultConfiguration()
local Validation = VALIDATION
gPresentation(conf, Validation, "NoLoop")

P = {
          Frame {
                    aab = PRO.Grid3D { mark = vec3(1, 1, 1), line_size = 0.1 },
                    camera = PRO.Camera3D {
                              t = vec3(0, 0, 0),
                              e = vec3(100, 100, -100),
                              type = "PERSPECTIVE",
                              fov = 50
                    }
          },
          Frame {
                    aab = PRO.Grid3D { mark = vec3(5, 5, 5), line_size = 0.5 },
                    camera = PRO.Camera3D {
                              t = vec3(0),
                              e = vec3(100, 100, -150),
                              type = "PERSPECTIVE",
                              fov = 43
                    }
          },
          Frame {
                    aab = PRO.Grid3D { mark = vec3(30, 20, 10) },
                    camera = PRO.Camera3D {
                              t = vec3(0),
                              e = vec3(0, 0, -400),
                              type = "PERSPECTIVE",
                              fov = 43
                    }
          },
}

P = {
          Frame {
                    a = PRO.LineList3D { line_lists = { vec4(20, 40, 80, 10), vec4(100, 30, 20, 75) } }
          },
}
P = {
          Frame {
                    camera = PRO.Camera3D {
                              t = vec3(0),
                              e = vec3(0, 0, -5),
                              type = "PERSPECTIVE",
                              fov = 43
                    },
                    rectangles_3d = PRO.RectangleList3D {
                              rectangle_lists = {
                                        -- Base background with subtle rounding
                                        mat4(vec4(-5, -5, 110, 110), vec4(gcolors.darkslategray, 1), vec4(0.3, 0.7, 0, 0), vec4(0)),

                                        -- Central golden rectangle
                                        mat4(vec4(30, 30, 70, 70), vec4(gcolors.goldenrod, 1), vec4(0.25, 0.725, 0, 0), vec4(0)),

                                        -- Gradient effect rectangles
                                        mat4(vec4(10, 10, 40, 40), vec4(gcolors.deepskyblue, 1), vec4(0.2, 0.76, 0, 0), vec4(0)),
                                        mat4(vec4(60, 10, 90, 40), vec4(gcolors.crimson, 1), vec4(0.18, 0.78, 0, 0), vec4(0)),
                                        mat4(vec4(10, 60, 40, 90), vec4(gcolors.limegreen, 1), vec4(0.22, 0.74, 0, 0), vec4(0)),
                                        mat4(vec4(60, 60, 90, 90), vec4(gcolors.darkorchid, 1), vec4(0.28, 0.71, 0, 0), vec4(0)),

                                        -- Floating center element
                                        mat4(vec4(40, 40, 60, 60), vec4(gcolors.ghostwhite, 1), vec4(0.15, 0.82, 0, 0), vec4(0)),

                                        -- Decorative bars
                                        mat4(vec4(0, 45, 100, 55), vec4(gcolors.coral, 1), vec4(0.1, 0.85, 0, 0), vec4(0)),
                                        mat4(vec4(45, 0, 55, 100), vec4(gcolors.teal, 1), vec4(0.1, 0.85, 0, 0), vec4(0)),

                                        -- Accent circles (using rectangle shader)
                                        mat4(vec4(20, 20, 30, 30), vec4(gcolors.gold_web_golden, 1), vec4(0.3, 0.7, 0, 0), vec4(0)),
                                        mat4(vec4(70, 70, 80, 80), vec4(gcolors.hotpink, 1), vec4(0.3, 0.7, 0, 0), vec4(0))
                              }
                    }
          },

          Frame {
                    camera = PRO.Camera3D {
                              t = vec3(0),
                              e = vec3(5, 5, -5),
                              type = "PERSPECTIVE",
                              fov = 43
                    },
                    rectangles_3d = PRO.RectangleList3D {
                              rectangle_lists = {
                                        mat4(vec4(0, 0, 100, 100), vec4(gcolors.black, 1), vec4(0, 1, 0, 0), vec4(0)),
                                        mat4(vec4(25, 25, 75, 75), vec4(gcolors.blue, 1), vec4(0, 1, 0, 0), vec4(0)),
                                        mat4(vec4(35, 35, 65, 65), vec4(gcolors.green_colorwheel_x11green, 1), vec4(0.2, 0.7, 0, 0), vec4(0)),
                                        mat4(vec4(40, 40, 60, 60), vec4(gcolors.ghostwhite, 1), vec4(0.15, 0.82, 0, 0), vec4(0)),
                                        mat4(vec4(25, 40, 60, 60), vec4(gcolors.green_yellow, 1), vec4(0.15, 0.82, 0, 0), vec4(0)),

                                        -- Decorative bars
                                        mat4(vec4(0, 45, 100, 55), vec4(gcolors.coral, 1), vec4(0.1, 0.85, 0, 0), vec4(0)),
                                        mat4(vec4(45, 0, 55, 100), vec4(gcolors.teal, 1), vec4(0.1, 0.85, 0, 0), vec4(0)),

                                        -- Accent circles (using rectangle shader)
                                        mat4(vec4(20, 20, 30, 30), vec4(gcolors.gold_web_golden, 1), vec4(0.3, 0.7, 0, 0), vec4(0)),
                                        mat4(vec4(70, 70, 80, 80), vec4(gcolors.hotpink, 1), vec4(0.3, 0.7, 0, 0), vec4(0)),
                                        mat4(vec4(45, 45, 50, 50), vec4(gcolors.red, 1), vec4(0.1, 0.8, 0, 0), vec4(0)),
                              }
                    },
          },
}
P.Config = {
          FullScreen = false,
          FontSizes = gGetDefaultFontSizes(),
          FontFilePaths = { "font.ttf" }
}
gPresentation(P, Validation, "GeneralLoop")
