require "ElementLibrary.Procedurals.Procedurals"
require "sync"

local conf = gGetPresentationWithDefaultConfiguration()
local Validation = VALIDATION
gPresentation(conf, Validation, "NoLoop")

P = {
          Frame {
                    aab = PRO.Grid3D { mark = vec3(1, 1, 1) },
                    camera = PRO.Camera3D {
                              t = vec3(0),
                              e = vec3(0, 0, -100),
                              type = "PERSPECTIVE",
                              fov = 43
                    }
          },
          Frame {
                    aab = PRO.Grid3D { mark = vec3(5, 5, 5) },
                    camera = PRO.Camera3D {
                              t = vec3(0),
                              e = vec3(0, 0, -400),
                              type = "PERSPECTIVE",
                              fov = 43
                    }
          },
          Frame {
                    aab = PRO.Grid3D { mark = vec3(30, 20, 10) },
                    camera = PRO.Camera3D {
                              t = vec3(0),
                              e = vec3(0, 0, -400),
                              type = "ORTHO",
                              fov = 45
                    }

          },
}

P.Config = {
          FullScreen = false,
          FontSizes = gGetDefaultFontSizes(),
          FontFilePaths = { "font.ttf" }
}
gPresentation(P, Validation, "GeneralLoop")
