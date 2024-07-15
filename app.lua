require "Present.Present"

Presentation {
    Title = "Introduction to JkrGUI Presentation Engine",
    Date = "18th Jeshtha, 2020",
    Author = { "Darshan Koirala" },
    Config = {
        Font = {
            Tiny = { "res/fonts/font.ttf", 10 },     -- \tiny
            Small = { "res/fonts/font.ttf", 12 },    -- \small
            Normal = { "res/fonts/font.ttf", 16 },   -- \normalsize
            large = { "res/fonts/font.ttf", 20 },    -- \large
            Large = { "res/fonts/font.ttf", 24 },    -- \Large
            huge = { "res/fonts/font.ttf", 28 },     -- \huge
            Huge = { "res/fonts/font.ttf", 32 },     -- \Huge
            gigantic = { "res/fonts/font.ttf", 38 }, -- \gigantic
            Gigantic = { "res/fonts/font.ttf", 42 }, -- \Gigantic
        }
    },
    Animation {
        Interpolation = "Constant",
    },
    Frame {
        FancyCircle1 = Shader {
            cs = Engine.Shader()
                .Header(450)
                .CInvocationLayout(1, 1, 1)
                .uImage2D()
                .ImagePainterPush()
                .GlslMainBegin()
                .ImagePainterAssist()
                .Append [[
                    imageStore(storageImage, to_draw_at, vec4(0));
                    vec2 center = vec2(push.mPosDimen.x, push.mPosDimen.y);
                    vec2 hw = vec2(push.mPosDimen.z, push.mPosDimen.w);
                    float radius = push.mParam.x;
                    float color = length(xy - center) * sin(to_draw_at.x + push.mParam.y / 10.0f) - radius;
                    color = smoothstep(-0.05, 0.05, -color);
                    vec4 old_color = imageLoad(storageImage, to_draw_at);
                    vec4 final_color = vec4(push.mColor.x * color, push.mColor.y * color, push.mColor.z * color, push.mColor.w * color);
                    final_color = mix(final_color, old_color, (1 - color));
                    imageStore(storageImage, to_draw_at, final_color);
                ]]
                .GlslMainEnd().str
        }
    },
    Frame {
        Title = "Introduction",
        Tex1 = Text { t = "Hello", f = "Normal", p = "TOP_RIGHT", c = vec4(1, 0, 0, 1) },
        Tex2 = Text { t = "Fucker", f = "Normal", p = "CENTER_LEFT", c = vec4(1, 0, 0, 1) },
        Cimage1 = CImage {
            shader = "FancyCircle1",
            shader_parameters = { threads = vec3(500, 500, 1), p1 = vec4(0.0, 0.0, 0.3, 1), p2 = vec4(1), p3 = vec4(0.5, 0, 0, 0) },
            p = "CENTER_RIGHT",
            d = vec2(500, 500)
        }
    },
    Frame {
        Cimage1 = CImage {
            shader = "FancyCircle1",
            shader_parameters = { threads = vec3(500, 500, 1), p1 = vec4(0.0, 0.0, 1, 1), p2 = vec4(1, 0, 0, 1), p3 = vec4(0.5, 100, 0, 0) },
            p = "CENTER_LEFT",
            d = vec2(500, 500)
        },
        Tex1 = Text { t = "Hello", f = "Normal", p = "CENTER_LEFT", c = vec4(0, 1, 0, 1) },
        Tex2 = Text { t = "Fucker", f = "Normal", p = "CENTER_RIGHT", c = vec4(0, 1, 1, 1) },
        Tex3 = Text { t = "I am darshan", f = "Normal", p = "OUT_OUT", c = vec4(1, 1, 1, 1) }
    },
    Frame {
        Tex1 = Text { t = "Hello", f = "Normal", p = "BOTTOM_CENTER", c = vec4(1, 1, 1, 1) },
        Tex2 = Text { t = "Fucker", f = "Normal", p = "TOP_CENTER", c = vec4(1, 1, 1, 1) },
        Tex3 = Text { t = "I am darshan", f = "Normal", p = "TOP_CENTER", c = vec4(1, 1, 1, 1) }
    },
    Frame {
        Tex3 = Text { t = "I am darshan", f = "Normal", p = "OUT_OUT", c = vec4(1, 1, 1, 1) }
    }
}
