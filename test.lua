require "ElementLibrary.Commons.Commons"
local conf = gDefaultConfiguration()
gPresentation(conf, true, "NoLoop")

P = {
          Frame {
                    CPictureWithLabel {
                              tl = "FUCK",
                              path = "tulogo.png"
                    }
          }

}

gPresentation(P, true, "GeneralLoop")
