require "ElementLibrary.Commons.Commons"
require "ElementLibrary.Procedurals.Procedurals"
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

-- P = {
--           Frame {
--                     jpt = CLineList {
--                               lines = {
--                                         vec4(10, 10, 100, 100),
--                                         vec4(60, 100, 30, 67),
--                               },
--                               t = 5,
--                     },
--                     -- CContinue { true },
--                     -- CCircularSwitch { true }
--           },
--           Frame {
--                     jpt = CLineList {
--                               lines = { vec4(50, 67, 0, 0),
--                                         vec4(100, 60, 67, 30),
--                               },
--                               t = 1,
--                     }
--           }
-- }

-- P = {
--           Frame {
--                     one = CGrid {
--                               x_count = 10,
--                               y_count = 10,
--                               d = vec3(500, 500, 1),
--                               should_mark = true
--                     },

-- },
--           Frame {
--                     one = CGrid {
--                               x_count = 6,
--                               y_count = 6,
--                               p = vec3(0, 0, 1),
--                               d = vec3(500, 500, 1)
--                     }
--           }
-- }

P = {
    Frame {
        a = CTextList {
            type = "VERTICAL",
            texts = { "a for apple", "jkr", "whahahah" },
            index = 1
        }
    },
    Frame {
        a = CTextList {
            type = "VERTICAL",
            index = 2
        }
    },
    Frame {
        a = CTextList {
            type = "VERTICAL",
            index = 3
        },
    }
}

P = {
    Frame {
        b = CDate {

        }
    },
    Frame {
        b = CDate {
            year = 2080,
            month = 10,
            day = 22
        }
    },
    Frame {
        b = CDate {
            year = 2081,
            month = 1,
            day = 10
        }
    },

}

P = {
    Frame {
        sth = CRectanglelist {
            list = {
                mat4(vec4(1, 1, 50, 30), vec4(gcolors.bluebell, 1), vec4(0.1, 0.7, 0, 0), vec4(0)),
                mat4(vec4(50, 30, 100, 100), vec4(gcolors.cadetgrey, 1), vec4(0.1, 0.7, 0, 0), vec4(0)),
            }
        }
    }
}


local x_count = 100
local size = 1000
local unit_size = size / x_count


local TopDownCamera = function(inTarget)
    return PRO.Camera3D {
        e = vec3(0, 100, -20),
        t = inTarget or vec3(0, 0, -20),
        fov = 43,
    }
end

local RightToLeft = function(inTarget)
    return PRO.Camera3D {
        e = vec3(-50, 25, -20),
        t = inTarget or vec3(100, 25, -100),
        fov = 70,

    }
end

local LeftToRight = function(inTarget)
    return PRO.Camera3D {
        e = vec3(),
        t = vec3(),
    }
end

local DownTopCamera = function(inTarget)
    return PRO.Camera3D {
        t = inTarget or vec3(0, 0, 0),
        e = vec3(50, 5, -50),
        fov = 60,
    }
end


P = {
    Frame {
        cam = RightToLeft(),
        grid = PRO.Grid3D {
            size = size,
            x_count = x_count,
            y_count = x_count,
            mark = vec3(1),
            mark_size = vec3(0),
            line_size = 0,

        },
        -- Grid Banau
        mobile_phone = PRO.Shape {
            p = vec3(1, 1, -1) * unit_size,
            d = vec3(4),
            type = "GLTF",
            file_name = "tiny_res/mobile_phone/mobile_phone.gltf"

        },
        laptop = PRO.Shape {
            p = vec3(1, 5, -15) * unit_size,
            d = vec3(4),
            type = "GLTF",
            file_name = "tiny_res/laptop/laptop.gltf"
        },


        --- J garera pani, euta cube CrectangleList3D, chae mobile bata niksera tyo k rey, laptop ma janu paro,
        -- camera lai pani animate gara
    },
    Frame {
        cam = PRO.Camera3D {
            t = vec3(0),
            e = vec3(1, 1, -50),
            f = 40,
        },
        grid = PRO.Grid3D {
            size = size,
            x_count = x_count,
            y_count = x_count,
            mark = vec3(1),
            mark_size = vec3(0),
            line_size = 0,
        },
        mobile_phone = PRO.Shape {
            r = vec4(0, 1, 0, -90),
            p = vec3(1, 1, -1) * unit_size,
            d = vec3(4),
            type = "GLTF",
            file_name = "tiny_res/mobile_phone/mobile_phone.gltf"

        },
        rectangles_3d = PRO.RectangleList3D
            {
                p = vec3(1, 1, -1) * unit_size,
                d = vec3(1, 1, 1),
                rectangle_lists = {
                    mat4(vec4(1, 1, 100, 100), vec4(gcolors.red, 1), vec4(0, 1, 0, 0), vec4(0)),
                    --     mat4(vec4(10, 10, 100, 100), vec4(gcolors.green_yellow, 1), vec4(0.15, 0.82, 0, 0), vec4(0)),
                }
            }
    },
    Frame {
        grid = PRO.Grid3D {
            size = size,
            x_count = x_count,
            y_count = x_count,
            mark = vec3(1),
            mark_size = vec3(0),
            line_size = 0,
        },
        mobile_phone = PRO.Shape {
            r = vec4(0, 1, 0, -90),
            p = vec3(1, 1, -1) * unit_size,
            d = vec3(4),
            type = "GLTF",
            file_name = "tiny_res/mobile_phone/mobile_phone.gltf"

        },
        cam = PRO.Camera3D {
            t = vec3(0),
            e = vec3(1, 1, -50),
            f = 40,
        },
        rectangles_3d = PRO.RectangleList3D {
            p = vec3(1, 1, -2) * unit_size,
            d = vec3(2, 2, 2),
            rectangle_lists = {
                mat4(vec4(10, 10, 100, 100), vec4(gcolors.red, 1), vec4(0, 1, 0, 0), vec4(0)),
            }

        }
    }
}
gPresentation(P, Validation, "GeneralLoop")
-- mobile bata crectangle list mobile to laptop and laptop to mobile
