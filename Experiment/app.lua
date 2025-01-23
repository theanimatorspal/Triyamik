function Main()
    if not ANDROID then
        require "JkrGUIv2.Widgets.General"
        require "JkrGUIv2.Engine.Engine"
        inspect = require "JkrGUIv2.inspect"
    end
    Jkr.GetLayoutsAsVH()
    Engine:Load(true)
    FrameD = vec2(400, 700)
    W = Jkr.CreateWindow(Engine.i, "Hello Anroid", vec2(400, 700), 3, FrameD)
    E = Engine.e
    GWR = Jkr.CreateGeneralWidgetsRenderer(nil, Engine.i, W, E)
    F = GWR.CreateFont("font.ttf", 18)
    SHOULD_SEND_TCP = false
    TCP_FILE_IN = Jkr.FileJkr()
    TCP_FILE_IN:WriteFunction("CTRL", function()
        gMoveForward()
    end)

    GBASE_DEPTH = 50

    ELEMENTS = {}
    function U(inValue)
        if not inValue.e then
            inValue.p = inValue.p or vec3(0, 0, GBASE_DEPTH)
            inValue.d = inValue.d or vec3(100, 100, 1)
            inValue.onclick = inValue.onclick or function() end
            inValue.c = inValue.c or vec4(vec3(0), 1)
            inValue.bc = inValue.bc or vec4(0.9, 0.8, 0.95, 0.6)
            inValue.f = inValue.f or F
            local Value = GWR.CreateGeneralButton(
                inValue.p,
                inValue.d,
                inValue.onclick,
                inValue.continous,
                inValue.f,
                inValue.t,
                inValue.c,
                inValue.bc,
                inValue.pc,
                inValue.img
            )
            if inValue.en then
                ELEMENTS[inValue.en] = Value
            elseif inValue.t then
                ELEMENTS[inValue.t] = Value
            end
            inValue = Value
        else
            inValue.Update = function(self, inPosition_3f, inDimension_3f)
            end
        end
        return inValue
    end

    local DisplayText = ""
    local B = function(inNumber)
        local onclickf = function()
            DisplayText = DisplayText .. inNumber
            local el = ELEMENTS["DisplayText"]
            el:Update(el.mPosition_3f, el.mDimension_3f, F, DisplayText)
        end
        if type(inNumber) == "string" then
            return U { t = inNumber, onclick = onclickf }
        else
            return U { t = tostring(inNumber), onclick = onclickf }
        end
    end

    local Background = U { p = vec3(-80, -80, 50),
        d = vec3(FrameD.x + 160, FrameD.y + 160, 1),
        bc = vec4(0.5, 0.8, 0.95, 1) }

    local BackSpace = function()
        DisplayText = string.sub(DisplayText, 1, #DisplayText - 1)
        local el = ELEMENTS["DisplayText"]
        el:Update(el.mPosition_3f, el.mDimension_3f, F, DisplayText)
    end

    local ConnectToPC = function()
        local function afunction()
            net = Engine.net
            net.Client()
            net.Start(DisplayText)
        end
        if pcall(afunction) then
            Jkr.ShowToastNotification("Connection Tried")
            GNetworkLoop = true
        else
            Jkr.ShowToastNotification("Connection Failed")
        end
    end

    MainLayout = V(
        {
            H({ U { t = "Write Ip", bc = vec4(0.9) }, U { t = "<<", onclick = BackSpace } }, { 0.7, 0.3 }),
            U { t = "", en = "DisplayText", bc = vec4(1) },
            H({ B(1), B(2), B(3) }, { 1 / 3.0, 1 / 3.0, 1 / 3.0 }),
            H({ B(4), B(5), B(6) }, { 1 / 3.0, 1 / 3.0, 1 / 3.0 }),
            H({ B(7), B(8), B(9) }, { 1 / 3.0, 1 / 3.0, 1 / 3.0 }),
            H({ B(0), B(".") }, { 0.5, 0.5 }),
            U { t = "Connect To PC", onclick = ConnectToPC, bc = vec4(0.9) },
        },
        { 0.1, 0.4, 0.1, 0.1, 0.1, 0.1, 0.1 }
    )
    MainLayout:Update(vec3(0, 0, 50), vec3(FrameD.x, FrameD.y, 1))
    GWR.AnimationPush(MainLayout, vec3(-10, 0, 50), vec3(0, 0, 50), vec3(0, 20, 1), vec3(FrameD.x, FrameD.y, 1))

    --
    --
    --
    --
    --
    --
    --
    --
    --
    --
    --
    --
    --
    E:SetEventCallBack(
        function()
            GWR:Event()
        end
    )

    Update = function()
        GWR:Update()
    end

    Dispatch = function()
        GWR:Dispatch()
    end

    UIDraw = function()
        GWR:Draw()
    end

    Draw = function()
    end

    GDisplayLoop = true

    while not E:ShouldQuit() and GDisplayLoop do
        if GNetworkLoop then
            GNetworkValue = net.listenOnce()
            if type(GNetworkValue) == "function" then
                local success, result = pcall(GNetworkValue)
                if not success then
                    Jkr.ShowToastNotification(result)
                    print(" ")
                end
            end
            if type(GNetworkValue) == "string" then
                Jkr.ShowToastNotification("M:" .. GNetworkValue)
                if GNetworkValue == "JkrGUIv2Start" then
                    net.SendToServer("JkrGUIv2Start")
                    GNetworkValue = nil
                end
            end

            if SHOULD_SEND_TCP then
                local msg = Jkr.Message()
                local vchar = TCP_FILE_IN:GetDataFromMemory()
                msg:InsertVChar(vchar)
                net.SendToServer(msg)
                SHOULD_SEND_TCP = false;
                TCP_FILE_IN:Clear();
            end
        end
        if not GForeignLoop then
            E:ProcessEventsEXT(W)
            Update()

            W:Wait()
            W:AcquireImage()
            W:BeginRecording()
            Dispatch()

            W:BeginUIs()
            UIDraw()
            W:EndUIs()

            W:BeginDraws(0, 0, 0, 1, 1)
            W:ExecuteUIs()
            W:EndDraws()

            W:BlitImage()
            W:EndRecording()
            W:Present()
        end
    end
end

Main()
