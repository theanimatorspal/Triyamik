require "ElementLibrary.Commons.Commons"
local conf = gDefaultConfiguration()
gPresentation(conf, true, "NoLoop")

P = {
          Frame {
                    CPictureList {
                              path = {
                                        "image1.png",
                                        "image2.png",
                                        "image3.png",
                              }, index = 1,

                    }
          }

}

gPresentation(P, true, "GeneralLoop")
