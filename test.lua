require "ElementLibrary.Commons.Commons"
local conf = gDefaultConfiguration()
gPresentation(conf, true, "NoLoop")

P = {
          Frame {
                    text = CPictureList {
                              paths = { "tulogo.png",
                                        "image1.png",
                                        "image2.png",
                                        "image3.png",
                                        "tulogo.png",
                              },
                              index = 1,
                    },
          },
          Frame {
                    text = CPictureList {
                              index = 2,
                    }
          },
          Frame {
                    text = CPictureList {
                              index = 3,
                    }
          }

}

gPresentation(P, true, "GeneralLoop")
