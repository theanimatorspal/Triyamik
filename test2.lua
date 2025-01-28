require "ElementLibrary.Procedurals.Procedurals"
require "sync"

local conf = gGetPresentationWithDefaultConfiguration()
local Validation = VALIDATION
gPresentation(conf, Validation, "NoLoop")

P = {
          Frame {
                    aab = PRO.Grid3D { mark = vec3(1, 1, 1) },
          },
          Frame {
                    aab = PRO.Grid3D { mark = vec3(5, 5, 5) }
          },
          Frame {
                    aab = PRO.Grid3D { mark = vec3(9, 7, 8) },

          },
}

P.Config = {
          FullScreen = false,
          FontSizes = gGetDefaultFontSizes(),
          FontFilePaths = { "font.ttf" }
}
gPresentation(P, Validation, "GeneralLoop")
