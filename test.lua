require "ElementLibrary.Commons.Commons"
local conf = gDefaultConfiguration()
gPresentation(conf, true, "NoLoop")

P = {
          Frame {
                    text = CTextList {
                              texts = {
                                        "apple", "ball", "cat",
                              },
                              index = 1,
                    },
          },
          Frame {
                    text = CTextList {
                              index = 2,
                    }
          },
          Frame {
                    text = CTextList {
                              index = 3,
                    }
          }

}

gPresentation(P, true, "GeneralLoop")
