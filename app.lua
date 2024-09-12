require "JkrGUIv2.Widgets.General"
require "JkrGUIv2.Engine.Engine"
Engine:Load(true)
local w = Jkr.CreateWindow(Engine.i, "Hello Anroid", vec2(200, 200), 3, vec2(200, 200))
local e = Engine.e
local gwr = Jkr.CreateGeneralWidgetsRenderer(nil, Engine.i, w, e)
local f = gwr.CreateFont("res/fonts/font.ttf", 16)
gwr.CreatePressButton(vec3(100, 100, 20), vec3(100, 100, 1), function() print("pressed") end, false, f, "Press",
    vec4(1, 0, 0, 1))
e:SetEventCallBack(
    function()
        gwr:Event()
    end
)

local hlayout = Jkr.HLayout()

while not e:ShouldQuit() do
    e:ProcessEventsEXT(w)
    w:BeginUpdates()
    gWindowDimension = w:GetWindowDimension()
    gwr:Update()
    w:EndUpdates()

    w:BeginDispatches()
    gwr:Dispatch()
    w:EndDispatches()

    w:BeginUIs()
    gwr:Draw()
    w:EndUIs()

    w:BeginDraws(0, 0, 0, 1, 1)
    w:ExecuteUIs()
    w:EndDraws()
    w:Present()
end
