require "ElementLibrary.Commons.Commons"
Pr = gDefaultConfiguration()
Pr.Config.FullScreen = false
local Validation = false

gPresentation(Pr, Validation, "NoLoop")

P = {
          Frame {
                    background_grid = CGrid {
                              x_count = 10,
                              y_count = 10,
                              p = vec3(0, 0, gbaseDepth),
                              d = vec3(300, 300, 1),
                    },

          },

}
gPresentation(P, Validation, "GeneralLoop")
