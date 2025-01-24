require "ElementLibrary.Commons.Commons"
local conf = gDefaultConfiguration()
gPresentation(conf, false, "NoLoop")

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
P = {
          Frame {
                    CLayout {
                              layout = V({
                                        U { t = "Slide 1", en = "1", bc = vec4(1, 1, 1, 1), pic = "tulogo.png", et = "CPicture" },
                                        H({ U { t = "left", en = "left", bc = vec4(1, 0, 1, 1) }, U { t = "right", en = "right", bc = transparent_color } }, { 0.5, 0.5 }),
                                        H({ U { t = "left1", en = "left1", bc = vec4(1, 0, 1, 1) }, U { t = "right1", en = "right1", bc = transparent_color } }, { 0.5, 0.5 }),
                              }
                              , { 0.4, 0.4, 0.2 }

                              )
                    }
          },
          Frame {
                    CLayout {
                              layout = V({
                                        U { t = "Slide 1", en = "1", bc = transparent_color },
                                        H({ U { t = "left", en = "left", bc = vec4(1, 0, 1, 1) }, U { t = "right", en = "right", bc = transparent_color } }, { 0.8, 0.2 }),
                                        H({ U { t = "left1", en = "left1", bc = vec4(1, 0, 1, 1) }, U { t = "right1", en = "right1", bc = transparent_color } }, { 0.3, 0.7 }),
                              }
                              , { 0.3, 0.4, 0.3 }

                              )
                    }
          }
}
P = {
          Frame {
                    first = CPictureList {
                              type = "VERTICAL",
                              paths = { "image1.png", "image2.png", "image3.png" },
                              index = 1
                    }
          },

          Frame {
                    first = CPictureList {
                              type = "HORIZONTAL",
                              index = 2
                    }
          },

          Frame {
                    first = CPictureList {
                              type = "VERTICAL",
                              index = 3
                    }
          }
}

P = {
          Frame {
                    one = CGrid {

                    }
          }
}
gPresentation(P, false, "GeneralLoop")
