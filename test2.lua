require "ElementLibrary.Procedurals.Procedurals"

local conf = gGetPresentationWithDefaultConfiguration()
local Validation = true
gPresentation(conf, Validation, "NoLoop")

P = {
          Frame {
                    aab = PRO_Grid3D {},
          }
}

P.Config = {
          FullScreen = false,
          FontSizes = gGetDefaultFontSizes(),
          FontFilePaths = { "font.ttf" }
}
gPresentation(P, Validation, "GeneralLoop")
