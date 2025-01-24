require "ElementLibrary.Commons.Commons"
local conf = gDefaultConfiguration()
gPresentation(conf, true, "NoLoop")

P = {
          Frame {
                    text = CTextList {
                              texts = {
                                        "akjhfkashb", "rakakasaf", "akhfkajshf", "skjhkfsh", "kahfsklh", "skhgfkhs"
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
                    text = CPictureWithLabelList {
                              index = 2
                    }
          },
          Frame {
                    text = CPictureWithLabelList { index = 3 }
          }


}

gPresentation(P, true, "GeneralLoop")
