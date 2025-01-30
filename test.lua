require "ElementLibrary.Commons.Commons"
require "ElementLibrary.Procedurals.Procedurals"
local conf = gGetPresentationWithDefaultConfiguration()
local Validation = true
gPresentation(conf, Validation, "NoLoop")

local x_count = 30
local size = 300
local unit_size = size / x_count

local mobile_pos = vec3(10, 2, -2) * unit_size
local mobile_dimen = vec3(5)
local laptop_pos = vec3(15, 0, -1) * unit_size
local laptop_dimen = vec3(5)

local DrawGrid = function(inCompute)
    return PRO.Grid3D {
        size = size,
        x_count = x_count,
        y_count = x_count,
        mark = vec3(50, 50, 50),
        mark_size = vec3(0),
        line_size = 0,
        compute = inCompute,
        grid_color = vec4(gcolors.rossocorsa, 0.1)
    }
end

local DrawMobile = function(inRotation)
    return PRO.Shape {
        p = mobile_pos,
        d = mobile_dimen,
        r = inRotation or vec4(0, 1, 0, 0),
        type = "GLTF",
        file_name = "tiny_res/mobile_phone/mobile_phone.gltf",
        renderer_parameter = mat4(vec4(1), vec4(0), vec4(0), vec4(0))

    }
end

local DrawLaptop = function(inRotation)
    return PRO.Shape {
        p = laptop_pos,
        d = laptop_dimen,
        r = inRotation or vec4(1, 0, 0, 0),
        type = "GLTF",
        file_name = "tiny_res/laptop/laptop.gltf"
    }
end

local TopDownCamera = function(inTarget)
    return PRO.Camera3D {
        e = vec3(0, 100, -20),
        t = inTarget or vec3(0, 0, -20),
        fov = 43,
    }
end

local CloseUpCamera = function(inPosition, inType, fov)
    -- in type = ["left", "right", center]
    local eye = vec3(0)
    local target = vec3(0)
    local fov = fov or 30
    if inType == "center" then
        eye = vec3(inPosition.x, inPosition.y, inPosition.z - 50)
        target = inPosition
    elseif inType == "left" then
        eye = vec3(inPosition.x, inPosition.y, inPosition.z - 25)
        target = vec3(inPosition.x - 5 / 30 * fov, inPosition.y, inPosition.z)
    elseif inType == "right" then
        eye = vec3(inPosition.x, inPosition.y, inPosition.z - 25)
        target = vec3(inPosition.x + 5 / 30 * fov, inPosition.y, inPosition.z)
    end
    return PRO.Camera3D {
        e = eye,
        t = target,
        fov = fov or 30

    }
end


local RightToLeft = function(inTarget)
    return PRO.Camera3D {
        e = vec3(-50, 25, -20),
        t = inTarget or vec3(100, 25, -100),
        fov = 70,

    }
end

local DownTopCamera = function(inTarget, inCamera)
    return PRO.Camera3D {
        t = inTarget or vec3(0, 0, 0),
        e = vec3(50, 5, -50),
        fov = 60,
    }
end

local MessageCube = function(p, d, r)
    return PRO.RectangleList3D {
        p = p or mobile_pos,
        d = d or vec3(1, 1, 1),
        r = r or vec4(1, 1, 1, 0),
        rectangle_lists = {
            mat4(vec4(-5, -5, 110, 110), vec4(gcolors.darkslategray, 1), vec4(0.3, 0.7, 0, 0), vec4(0)),

            -- Central golden rectangle
            mat4(vec4(30, 30, 70, 70), vec4(gcolors.goldenrod, 1), vec4(0.25, 0.725, 0, 0), vec4(0)),

            -- Gradient effect rectangles
            mat4(vec4(10, 10, 40, 40), vec4(gcolors.deepskyblue, 1), vec4(0.2, 0.76, 0, 0), vec4(0)),
            mat4(vec4(60, 10, 90, 40), vec4(gcolors.crimson, 1), vec4(0.18, 0.78, 0, 0), vec4(0)),
            mat4(vec4(10, 60, 40, 90), vec4(gcolors.limegreen, 1), vec4(0.22, 0.74, 0, 0), vec4(0)),
            mat4(vec4(60, 60, 90, 90), vec4(gcolors.darkorchid, 1), vec4(0.28, 0.71, 0, 0), vec4(0)),

            -- Floating center element
            mat4(vec4(40, 40, 60, 60), vec4(gcolors.ghostwhite, 1), vec4(0.15, 0.82, 0, 0), vec4(0)),

            -- Decorative bars
            mat4(vec4(0, 45, 100, 55), vec4(gcolors.coral, 1), vec4(0.1, 0.85, 0, 0), vec4(0)),
            mat4(vec4(45, 0, 55, 100), vec4(gcolors.teal, 1), vec4(0.1, 0.85, 0, 0), vec4(0)),

            -- Accent circles (using rectangle shader)
            mat4(vec4(20, 20, 30, 30), vec4(gcolors.gold_web_golden, 1), vec4(0.3, 0.7, 0, 0), vec4(0)),
            mat4(vec4(70, 70, 80, 80), vec4(gcolors.hotpink, 1), vec4(0.3, 0.7, 0, 0), vec4(0))
        }
    }
end


P = {
    Frame {
        cam = CloseUpCamera(mobile_pos, "center"),
        -- cam = CloseUpCamera(mobile_pos, "right"),
        grid = DrawGrid(true),
        mobile = DrawMobile(vec4(0, 0, 1, -90)),
        laptop = DrawLaptop(),
    },
    Frame {
        cam = CloseUpCamera(mobile_pos, "center"),
        -- cam = CloseUpCamera(mobile_pos, "right"),
        grid = DrawGrid(true),
        mobile = DrawMobile(vec4(0, 1, 0, -90)),
        laptop = DrawLaptop(),
        CContinue { false }
    },
    Frame {
        cam = CloseUpCamera(mobile_pos, "center"),
        grid = DrawGrid(false),
        mobile = DrawMobile(vec4(0, 1, 0, -90)),
        rectangles_3d = MessageCube()
    },
    Frame {
        grid = DrawGrid(false),
        mobile = DrawMobile(vec4(0, 1, 0, -90)),
        cam = CloseUpCamera(mobile_pos, "center", 60),
        rectangles_3d = MessageCube(vec3(mobile_pos.x, mobile_pos.y, mobile_pos.z - 30), vec3(2, 2, 2), vec4(1, 0, 0, 360))
    },
    Frame {
        grid = DrawGrid(false),
        laptop = DrawLaptop(vec4(0, 1, 0, 90)),
        mobile = DrawMobile(vec4(0, 1, 0, -90)),
        cam = CloseUpCamera(laptop_pos, "left", 100),
        rectangles_3d = MessageCube(vec3(laptop_pos.x, laptop_pos.y + 2, laptop_pos.z), vec3(2, 2, 2), vec4(0, 0, 1, 270))
    },
    Frame {
        grid = DrawGrid(false),
        laptop = DrawLaptop(vec4(0, 1, 0, 90)),
        mobile = DrawMobile(vec4(0, 1, 0, -90)),
        cam = CloseUpCamera(laptop_pos, "left", 100),
        rectangles_3d = MessageCube(vec3(laptop_pos.x, laptop_pos.y + 2, laptop_pos.z), vec3(1, 1, 1))
    }
}
gPresentation(P, Validation, "GeneralLoop")
