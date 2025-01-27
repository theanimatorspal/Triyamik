require "ElementLibrary.Commons.Commons"
require "ElementLibrary.Procedurals.Procedurals"
require "sync"

local Validation = VALIDATION

local BG = function(inTable)
          local t = {
                    x_count = 25,
                    y_count = 25,
                    p = vec3(math.huge, 0, gbaseDepth),
                    d = vec3(1000, 1000, 1),
                    cd = vec3(100, 100, 1)
          }
          inTable = Default(inTable, t)
          return CGrid(inTable)
end

local Initialize = {
          Frame {
                    background_grid = BG {},
          }
}

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
                    background_grid = BG {},
                    something = PRO.Shape {
                              type = "CUBE3D",
                              compute_texture = "background_grid"
                    }

          },
          Frame {
                    CTitlePage { act = "structure" },
                    background_grid = BG {},
                    something = PRO.Shape {
                              type = "CUBE3D",
                              compute_texture = "background_grid"
                    }
          }


}

P.Config = {
          FullScreen = true,
          FontSizes = gGetDefaultFontSizes(),
          FontFilePaths = { "font.ttf" }
}
gPresentation(P, Validation, "GeneralLoop")
