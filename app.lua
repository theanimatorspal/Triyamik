require "JkrGUIv2.Engine.Engine"
require "JkrGUIv2.WidgetsRefactor"

Validation = true
Engine:Load(Validation)

app = {}
app.window = Jkr.CreateWindow(Engine.i, "Hello", vec2(900, 480), 3)
app.wid = Jkr.CreateWidgetRenderer(Engine.i, app.window, Engine.e)
local font_test = app.wid.CreateFont("res/fonts/font.ttf", 16)
app.wid.CreateTextLabel(vec3(100, 100, 1), vec3(1), font_test, "Distance", vec4(1, 0, 0, 1))

local image_label = app.wid.CreateSampledImage(vec3(200, 200, 1), vec3(200, 200, 1), "res/images/tiger.jpg", nil,
          vec4(1))
local compute_image = app.wid.CreateComputeImage(vec3(0), vec3(0), image_label)
image_label.CopyToCompute(compute_image)

local painter = Jkr.CreateCustomImagePainter("res/testglsl.glsl",

          Engine.Shader()
          .Header(450)
          .CInvocationLayout(1, 1, 1)
          .uImage2D()
          .ImagePainterPush()
          .GlslMainBegin()
          .ImagePainterAssist()
          .Append [[
                    vec4 old_color = imageLoad(storageImage, to_draw_at);
                    imageStore(storageImage, to_draw_at, vec4(1, old_color.g, old_color.b, old_color.a));
          ]]
          .GlslMainEnd().str
)

painter:Store(Engine.i, app.window)

compute_image.RegisterPainter(painter)


local oldTime = 0.0
local frameCount = 0
local e = Engine.e
local w = app.window
local mt = Engine.mt

app.WindowClearColor = vec4(0)

local function Update()
          app.wid.Update()
end

local i = 0
local function Dispatch()
          app.wid.Dispatch()
          painter:Bind(app.window, Jkr.CmdParam.None)
          painter:BindImageFromImage(app.window, compute_image, Jkr.CmdParam.None)
          local push_constant = Jkr.DefaultCustomImagePainterPushConstant()
          push_constant.x = vec4(0)
          push_constant.y = vec4(0)
          push_constant.z = vec4(0)
          painter:Draw(app.window, push_constant, math.floor(image_label.mActualSize.x),
                    math.floor(image_label.mActualSize.y), 1,
                    Jkr.CmdParam.None)
          compute_image.CopyToSampled(image_label)
end

local function Draw()
          app.wid.Draw()
end

local function MultiThreadedDraws()
end

local function MultiThreadedExecute()
end

while not e:ShouldQuit() do
          oldTime = w:GetWindowCurrentTime()
          e:ProcessEvents()
          w:BeginUpdates()
          Update()
          WindowDimension = w:GetWindowDimension()
          w:EndUpdates()

          w:BeginDispatches()
          Dispatch()
          w:EndDispatches()

          MultiThreadedDraws()
          w:BeginUIs()
          Draw()
          w:EndUIs()

          w:BeginDraws(app.WindowClearColor.x, app.WindowClearColor.y, app.WindowClearColor.z, app.WindowClearColor.w, 1)
          MultiThreadedExecute()
          w:ExecuteUIs()
          w:EndDraws()
          w:Present()
          local delta = w:GetWindowCurrentTime() - oldTime
          if (frameCount % 100 == 0) then
                    w:SetTitle("Samprahar Frame Rate" .. 1000 / delta)
          end
          frameCount = frameCount + 1
          mt:InjectToGate("__MtDrawCount", 0)
end
