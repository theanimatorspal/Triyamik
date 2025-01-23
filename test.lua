require "ElementLibrary.Commons.Commons"
local conf = gDefaultConfiguration()
gPresentation(conf, true, "NoLoop")

P = {
          Frame {
                    text = CPictureWithLabelList {
                              paths = { "image1.png", "image2.png", "image3.png" },
                              texts = { "one", "two", "three" },
                              index = 1
                    }
          },
          Frame {
                    text = CPictureWithLabelList {
                              index = 2
                    }
          },
          Frame {
                    text = CPictureWithLabelList { index = 3 }
          }


}

gPresentation(P, true, "GeneralLoop")
