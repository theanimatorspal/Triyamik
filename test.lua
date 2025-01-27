require "ElementLibrary.Commons.Commons"
local conf = gGetPresentationWithDefaultConfiguration()
local Validation = true
gPresentation(conf, Validation, "NoLoop")

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


-- P = {
--           Frame {
--                     line = CLine {
--                               p1 = vec3(50, 50, 1),
--                               p2 = vec3(50, 90, 1),
--                               t = 3
--                     },
--                     line2 = CLine {
--                               p1 = vec3(10, 50, 1),
--                               p2 = vec3(70, 90, 1),
--                               t = 3
--                     }
--           }
-- }
-- P = {
--           Frame {
--                     jpt = CAxis {
--                               type = "XY",
--                               text = "aabbddksdjflasj",
--                               r = 0
--                     },
--                     CContinue { true },
--                     CCircularSwitch { true }
--           },

--           Frame {
--                     jpt = CAxis {
--                               type = "XY",
--                               r = 90
--                     }
--           },

--           Frame {
--                     jpt = CAxis {
--                               type = "XY",
--                               r = 270
--                     },
--           },
--           Frame {
--                     jpt = CAxis {
--                               type = "XY",
--                               r = 360
--                     }
--           }

P = {
          Frame {
                    jpt = CLineList {
                              lines = {
                                        vec4(10, 10, 100, 100),
                                        vec4(60, 100, 30, 67),
                              },
                              t = 5,
                    },
                    -- CContinue { true },
                    -- CCircularSwitch { true }
          },
          Frame {
                    jpt = CLineList {
                              lines = { vec4(50, 67, 0, 0),
                                        vec4(100, 60, 67, 30),
                              },
                              t = 1,
                    }
          }
}

P = {
          -- Frame {
          --           one = CGrid {
          --                     x_count = 10,
          --                     y_count = 10,
          --                     d = vec3(200, 200, 1),
          --           },

          -- },
          Frame {
                    one = CGrid {
                              x_count = 6,
                              y_count = 6,
                              p = vec3(0, 0, 1),
                              d = vec3(500, 500, 1)
                    }
          }
}
gPresentation(P, Validation, "GeneralLoop")
