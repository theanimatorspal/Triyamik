require "ElementLibrary.Commons.Commons"
require "ElementLibrary.Procedurals.Procedurals"
Pr = gDefaultConfiguration()
Pr.Config.FullScreen = false
local Validation = false

gPresentation(Pr, Validation, "NoLoop")

P = {
          Frame {
                    background_grid = CGrid {
                              x_count = 25,
                              y_count = 25,
                              t = 3,
                              p = vec3(math.huge, 0, gbaseDepth),
                              d = vec3(1000, 1000, 1),
                              cd = vec3(200, 200, 1)
                    },
                    -- CContinue { true },

                    -- PRO.Camera3D {
                    --           fov = 45.0
                    -- }

          },
          Frame {
                    background_grid = CGrid {
                              x_count = 10,
                              y_count = 10,
                              t = 1,
                              p = vec3(math.huge, 0, gbaseDepth),
                              d = vec3(1000, 1000, 1),
                              cd = vec3(200, 200, 1)
                    },
                    something = PRO.Shape {
                              type = "CUBE3D",
                              compute_texture = "background_grid"
                    }
                    -- axis = CAxis {
                    --
                    -- }

          },
          Frame {
                    background_grid = CGrid {
                              x_count = 25,
                              y_count = 25,
                              t = 1,
                              p = vec3(math.huge, 0, gbaseDepth),
                              d = vec3(1000, 1000, 1),
                              cd = vec3(200, 200, 1)
                    },
                    something = PRO.Shape {
                              type = "CUBE3D",
                              compute_texture = "background_grid"
                    }
          }


}

gPresentation(P, Validation, "GeneralLoop")
