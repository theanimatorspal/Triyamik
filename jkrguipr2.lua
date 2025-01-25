require "ElementLibrary.Commons.Commons"
Pr = gDefaultConfiguration()
Pr.Config.FullScreen = false
local Validation = false

gPresentation(Pr, Validation, "NoLoop")

P = {
          Frame {
                    background_grid = CGrid {
                              x_count = 25,
                              y_count = 25,
                              t = 0.1,
                              p = vec3(0, 0, gbaseDepth),
                              d = vec3(1000, 1000, 1),
                              cd = vec3(200, 200, 1)
                    },

          },
          Frame {
                    axis = CAxis {

                    }
          }

}
gPresentation(P, Validation, "GeneralLoop")
