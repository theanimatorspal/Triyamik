function Main()
    if not ANDROID then
        require "JkrGUIv2.Widgets.General"
        require "JkrGUIv2.Engine.Engine"
        inspect = require "JkrGUIv2.inspect"
    end
    Jkr.GetLayoutsAsVH()
    Engine:Load(true)
    FrameD = vec2(200, 400)
    W = Jkr.CreateWindow(Engine.i, "Hello Anroid", vec2(400, 700), 3, FrameD)
    E = Engine.e
    GWR = Jkr.CreateGeneralWidgetsRenderer(nil, Engine.i, W, E)
    F = GWR.CreateFont("font.ttf", 14)

    ELEMENTS = {}
    function U(inValue)
        if not inValue.e then
            inValue.p = inValue.p or vec3(0, 0, 50)
            inValue.d = inValue.d or vec3(100, 100, 1)
            inValue.onclick = inValue.onclick or function() end
            inValue.c = inValue.c or vec4(vec3(0), 1)
            inValue.bc = inValue.bc or vec4(0.9, 0.8, 0.95, 1)
            inValue.f = inValue.f or F
            inValue = GWR.CreateGeneralButton(
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
                ELEMENTS[inValue.en] = inValue
                print("invalue.en", inValue.en)
            elseif inValue.t then
                ELEMENTS[inValue.t] = inValue
                print("invalue.t", inValue.t)
            end
        else
            inValue.Update = function(self, inPosition_3f, inDimension_3f)

            end
        end
        return inValue
    end

    local DisplayText = " "
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

    local MainLayout = V(
        {
            H({ U { t = "Write Ip" }, U { t = "<-" } }, { 0.7, 0.3 }),
            U { t = "", en = "DisplayText" },
            H({ B(1), B(2), B(3) }, { 1 / 3.0, 1 / 3.0, 1 / 3.0 }),
            H({ B(4), B(5), B(6) }, { 1 / 3.0, 1 / 3.0, 1 / 3.0 }),
            H({ B(7), B(8), B(9) }, { 1 / 3.0, 1 / 3.0, 1 / 3.0 }),
            H({ B(0), B(".") }, { 0.5, 0.5 }),
            U { t = " Connect" },
        },
        { 0.1, 0.4, 0.1, 0.1, 0.1, 0.1, 0.1 }
    )
    MainLayout:Update(vec3(0, 0, 50), vec3(FrameD.x, FrameD.y, 1))

    -- local Background = GWR.CreateGeneralButton(vec3(0, 0, 50), vec3(100, 100, 1),
    --     function() end,
    --     false, F,
    --     "", vec4(vec3(1), 0),
    --     vec4(0.5, 0.8, 0.95, 1))
    -- Background:Update(vec3(-20, -20, 50), vec3(FrameD.x + 40, FrameD.y + 40, 1))

    -- local DisplayText = " "
    -- local Display = GWR.CreateGeneralButton(vec3(math.huge, math.huge, 20), vec3(100, 100, 1),
    --     nil,
    --     false, F,
    --     DisplayText,
    --     vec4(1, 1, 0, 1))

    -- local UpdateDisplay = function()

    -- end


    -- local Clear = GWR.CreateGeneralButton(vec3(math.huge, math.huge, 20), vec3(100, 100, 1),
    --     function()
    --         DisplayText = " "
    --         UpdateDisplay()
    --     end,
    --     false, F,
    --     "Clear",
    --     vec4(0.2, 0.4, 0, 1))

    -- local cpbf = function(inTextToAppend)
    --     return GWR.CreateGeneralButton(vec3(math.huge, math.huge, 20), vec3(100, 100, 1), function()
    --             DisplayText = DisplayText .. inTextToAppend
    --             UpdateDisplay()
    --         end,
    --         false, F,
    --         inTextToAppend,
    --         vec4(0.5, 0, 0, 1), vec4(1, 1, 1, 0.8))
    -- end

    -- local spbf = function(inText, inFunction)
    --     if not inFunction then
    --         return GWR.CreateGeneralButton(vec3(math.huge, math.huge, 20), vec3(100, 100, 1),
    --             nil,
    --             false,
    --             F,
    --             inText,
    --             vec4(0, 0, 0, 1), vec4(1, 1, 1, 0.8))
    --     else
    --         return GWR.CreateGeneralButton(vec3(math.huge, math.huge, 20), vec3(100, 100, 1), inFunction,
    --             false,
    --             F,
    --             inText,
    --             vec4(0, 0, 0, 1), vec4(1, 1, 1, 0.8))
    --     end
    -- end

    -- local ScreenVLayout = Jkr.VLayout:New(0)

    -- local TopInfoHLayout_1 = Jkr.HLayout:New(0)
    -- TopInfoHLayout_1:Add({ spbf("Write"), spbf("IP"), Clear }, { 1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0 })

    -- local DisplayHLayout_2 = Jkr.HLayout:New(0)
    -- DisplayHLayout_2:Add({ Display }, { 1 })

    -- local NRatioTable = { 1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0 }
    -- local NumericHLayout_3 = Jkr.HLayout:New(0)
    -- NumericHLayout_3:Add({ cpbf("1"), cpbf("2"), cpbf("3") }, NRatioTable)

    -- local NumericHLayout_4 = Jkr.HLayout:New(0)
    -- NumericHLayout_4:Add({ cpbf("4"), cpbf("5"), cpbf("6"), }, NRatioTable)

    -- local NumericHLayout_5 = Jkr.HLayout:New(0)
    -- NumericHLayout_5:Add({ cpbf("7"), cpbf("8"), cpbf("9"), }, NRatioTable)

    -- local NumericHLayout_6 = Jkr.HLayout:New(0)
    -- NumericHLayout_6:Add({ cpbf("."), cpbf("0"), spbf("Submit", function()
    --     local function afunction()
    --         net = Engine.net
    --         net.Client()
    --         net.Start(string.sub(DisplayText, 2, #DisplayText))
    --     end
    --     if pcall(afunction) then
    --         Jkr.ShowToastNotification("Connection Tried")
    --         GNetworkLoop = true
    --     else
    --         Jkr.ShowToastNotification("Connection Failed")
    --     end
    -- end), }, NRatioTable)

    -- ScreenVLayout:Add({
    --     TopInfoHLayout_1,
    --     DisplayHLayout_2,
    --     NumericHLayout_3,
    --     NumericHLayout_4,
    --     NumericHLayout_5,
    --     NumericHLayout_6
    -- }, { 0.1, 0.3, 0.15, 0.15, 0.15, 0.15 })

    -- ScreenVLayout:Update(vec3(0, 0, 20), vec3(FrameD.x, FrameD.y, 1))

    -- UpdateDisplay = function()
    --     Display.sampledText:Update(vec3(20), vec3(0), F, DisplayText, vec4(0.2, 0.4, 0, 1))
    --     ScreenVLayout:Update(vec3(0, 0, 20), vec3(FrameD.x, FrameD.y, 1))
    -- end

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
