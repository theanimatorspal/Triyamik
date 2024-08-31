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
                .Append [[
                float plot(vec2 st, float fx, float inthickness) {
                        return smoothstep(fx - inthickness, fx, st.y) -
                        smoothstep(fx, fx + inthickness, st.y);
                }
                vec3 rgb2hsb( in vec3 c ){
                    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
                    vec4 p = mix(vec4(c.bg, K.wz),
                                vec4(c.gb, K.xy),
                                step(c.b, c.g));
                    vec4 q = mix(vec4(p.xyw, c.r),
                                vec4(c.r, p.yzx),
                                step(p.x, c.r));
                    float d = q.x - min(q.w, q.y);
                    float e = 1.0e-10;
                    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)),
                                d / (q.x + e),
                                q.x);
                }

                //  Function from Iñigo Quiles
                //  https://www.shadertoy.com/view/MsS3Wc
                vec3 hsb2rgb( in vec3 c ){
                    vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),
                                            6.0)-3.0)-1.0,
                                    0.0,
                                    1.0 );
                    rgb = rgb*rgb*(3.0-2.0*rgb);
                    return c.z * mix(vec3(1.0), rgb, c.y);
                }
                float circle(in vec2 _st, in float _radius){
                        vec2 dist = _st-vec2(0.5);
                        return 1.-smoothstep(_radius-(_radius*0.01), _radius+(_radius*0.01),
                                            dot(dist,dist)*4.0);
                }
                vec2 tile(vec2 _st, float _zoom){
                    _st *= _zoom;
                    return fract(_st);
                }
                float random (vec2 st) {
                    return fract(sin(dot(st.xy,
                                        vec2(12.9898,78.233)))*
                        43758.5453123);
                }
                float rand(float inx) {
                    return fract(sin(inx) * 43758.5453123);
                }
                float noise(float x)
                {
                    float i = floor(x);
                    float f = fract(x);
                    float y = rand(i);
                    float u = f * f * (3.0 - 2.0 * f ); // custom cubic curve
                    y = mix(rand(i), rand(i + 1.0), u);
                    return y;
                }
                    // 2D Noise based on Morgan McGuire @morgan3d
                    // https://www.shadertoy.com/view/4dS3Wd
                    float noise (in vec2 st) {
                        vec2 i = floor(st);
                        vec2 f = fract(st);

                        // Four corners in 2D of a tile
                        float a = random(i);
                        float b = random(i + vec2(1.0, 0.0));
                        float c = random(i + vec2(0.0, 1.0));
                        float d = random(i + vec2(1.0, 1.0));

                        // Smooth Interpolation

                        // Cubic Hermine Curve.  Same as SmoothStep()
                        vec2 u = f*f*(3.0-2.0*f);
                        // u = smoothstep(0.,1.,f);

                        // Mix 4 coorners percentages
                        return mix(a, b, u.x) +
                                (c - a)* u.y * (1.0 - u.x) +
                                (d - b) * u.x * u.y;
                    }
                #define OCTAVES 4
                float fbm (in vec2 st) {
                    // Initial values
                    float value = 0.0;
                    float amplitude = .5;
                    float frequency = 0.;
                    //
                    // Loop of octaves
                    for (int i = 0; i < OCTAVES; i++) {
                        value += amplitude * noise(st);
                        st *= 2.;
                        amplitude *= .5;
                    }
                    return value;
                }
                float fbmext ( in vec2 _st) {
                    float v = 0.0;
                    float a = 0.5;
                    vec2 shift = vec2(100.0);
                    // Rotate to reduce axial bias
                    mat2 rot = mat2(cos(0.5), sin(0.5),
                                    -sin(0.5), cos(0.50));
                    for (int i = 0; i < OCTAVES; ++i) {
                        v += a * noise(_st);
                        _st = rot * _st * 2.0 + shift;
                        a *= 0.5;
                    }
                    return v;
                }
                ]]
                .GlslMainBegin()
                .ImagePainterAssist()
                .Append [[
                    vec4 incolor = push.mColor;
                    vec3 color = vec3(0.0);
                    float time = push.mParam.x;
                    vec2 st = xy;
                    imageStore(storageImage, to_draw_at, vec4(color, 1.0));
                    xy *= 5;
                    color.xyz = vec3(fbm(xy));
                    vec2 q = vec2(0.);
                    q.x = fbm( st + 0.00*time);
                    q.y = fbm( st + vec2(1.0));

                    vec2 r = vec2(0.);
                    r.x = fbm( st + 1.0*q + vec2(1.7,9.2)+ 0.15* time );
                    r.y = fbm( st + 1.0*q + vec2(8.3,2.8)+ 0.126* time);

                    float f = fbm(st+r);

                    color = mix(vec3(0.101961,0.619608,0.666667),
                                vec3(0.666667,0.666667,0.498039),
                                clamp((f*f)*4.0,0.0,1.0));

                    color = mix(color,
                                vec3(0,0,0.164706),
                                clamp(length(q),0.0,1.0));

                    color = mix(color,
                                vec3(0.666667,1,1),
                                clamp(length(r.x),0.0,1.0));
                    imageStore(storageImage, to_draw_at,  vec4((f*f*f+.6*f*f+.5*f)*color,1.));
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
            shader_parameters = { threads = vec3(100, 100, 1), p1 = vec4(0.0, 0.0, 0.3, 1), p2 = vec4(1), p3 = vec4(10.0, 0, 0, 0) },
            p = "CENTER_RIGHT",
            d = vec2(100, 100)
        }
    },
    Frame {
        Cimage1 = CImage {
            shader = "FancyCircle1",
            shader_parameters = { threads = vec3(100, 100, 1), p1 = vec4(0.0, 0.0, 1, 1), p2 = vec4(1, 0, 0, 1), p3 = vec4(0.1, 1, 0, 0) },
            p = "CENTER_CENTER",
            d = vec2(700, 700)
        },
        Tex1 = Text { t = "Hello", f = "Normal", p = "CENTER_LEFT", c = vec4(0, 1, 0, 1) },
        Tex2 = Text { t = "Fucker", f = "Normal", p = "CENTER_RIGHT", c = vec4(0, 1, 1, 1) },
        Tex3 = Text { t = "I am darshan", f = "Normal", p = "OUT_OUT", c = vec4(1, 1, 1, 1) }
    },
    Frame {
        Cimage1 = CImage {
            shader = "FancyCircle1",
            shader_parameters = { threads = vec3(100, 100, 1), p1 = vec4(0.0, 0.0, 1, 1), p2 = vec4(1, 0, 1, 1), p3 = vec4(10.0, 0, 0, 0) },
            p = "CENTER_LEFT",
            d = vec2(700, 700)
        },
        Tex1 = Text { t = "Hello", f = "Normal", p = "BOTTOM_CENTER", c = vec4(1, 1, 1, 1) },
        Tex2 = Text { t = "Fucker", f = "Normal", p = "TOP_CENTER", c = vec4(1, 1, 1, 1) },
        Tex3 = Text { t = "I am darshan", f = "Normal", p = "TOP_CENTER", c = vec4(1, 1, 1, 1) }
    },
    Frame {
        Tex3 = Text { t = "I am darshan", f = "Normal", p = "OUT_OUT", c = vec4(1, 1, 1, 1) }
    }
}
