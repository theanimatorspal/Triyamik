function Main()
    -- Jkr.ShowToastNotification("Fuck you Bro")
    gdisplayloop = true
    Engine:Load(true)
    local framed = vec2(200, 400)
    w = Jkr.CreateWindow(Engine.i, "Hello Anroid", vec2(400, 700), 3, framed)
    e = Engine.e
    gwr = Jkr.CreateGeneralWidgetsRenderer(nil, Engine.i, w, e)
    f = gwr.CreateFont("font.ttf", 14)

    e:SetEventCallBack(
        function()
            gwr:Event()
        end
    )
    local Background = gwr.CreatePressButton(vec3(0, 0, 50), vec3(100, 100, 1),
        function() end,
        false, f,
        "", vec4(0),
        vec4(0.5, 0.8, 0.95, 1))
    Background:Update(vec3(-20, -20, 50), vec3(framed.x + 40, framed.y + 40, 1))

    local DisplayText = " "
    local Display = gwr.CreatePressButton(vec3(math.huge, math.huge, 20), vec3(100, 100, 1),
        function() end,
        false, f,
        DisplayText,
        vec4(1, 1, 0, 1))

    local UpdateDisplay = function()

    end


    local Clear = gwr.CreatePressButton(vec3(math.huge, math.huge, 20), vec3(100, 100, 1),
        function()
            DisplayText = " "
            UpdateDisplay()
        end,
        false, f,
        "Clear",
        vec4(0.2, 0.4, 0, 1))

    local cpbf = function(inTextToAppend)
        return gwr.CreatePressButton(vec3(math.huge, math.huge, 20), vec3(100, 100, 1), function()
                DisplayText = DisplayText .. inTextToAppend
                UpdateDisplay()
            end,
            false, f,
            inTextToAppend,
            vec4(0.5, 0, 0, 1), vec4(1, 1, 1, 0.8))
    end

    local spbf = function(inText, inFunction)
        if not inFunction then
            return gwr.CreatePressButton(vec3(math.huge, math.huge, 20), vec3(100, 100, 1), function() print(inText) end,
                false,
                f,
                inText,
                vec4(0, 0, 0, 1), vec4(1, 1, 1, 0.8))
        else
            return gwr.CreatePressButton(vec3(math.huge, math.huge, 20), vec3(100, 100, 1), inFunction,
                false,
                f,
                inText,
                vec4(0, 0, 0, 1), vec4(1, 1, 1, 0.8))
        end
    end

    local ScreenVLayout = Jkr.VLayout:New(0)

    local TopInfoHLayout_1 = Jkr.HLayout:New(0)
    TopInfoHLayout_1:AddComponents({ spbf("Write"), spbf("IP"), Clear }, { 1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0 })

    local DisplayHLayout_2 = Jkr.HLayout:New(0)
    DisplayHLayout_2:AddComponents({ Display }, { 1 })

    local NRatioTable = { 1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0 }
    local NumericHLayout_3 = Jkr.HLayout:New(0)
    NumericHLayout_3:AddComponents({ cpbf("1"), cpbf("2"), cpbf("3") }, NRatioTable)

    local NumericHLayout_4 = Jkr.HLayout:New(0)
    NumericHLayout_4:AddComponents({ cpbf("4"), cpbf("5"), cpbf("6"), }, NRatioTable)

    local NumericHLayout_5 = Jkr.HLayout:New(0)
    NumericHLayout_5:AddComponents({ cpbf("7"), cpbf("8"), cpbf("9"), }, NRatioTable)

    local NumericHLayout_6 = Jkr.HLayout:New(0)
    NumericHLayout_6:AddComponents({ cpbf("."), cpbf("0"), spbf("Submit", function()
        local function afunction()
            net = Engine.net
            net.Client(string.sub(DisplayText, 2, #DisplayText))
        end
        if pcall(afunction) then
            Jkr.ShowToastNotification("Connection Succeeded")
            gnetworkloop = true
        else
            Jkr.ShowToastNotification("Connection Failed")
        end
    end), }, NRatioTable)

    ScreenVLayout:AddComponents({
        TopInfoHLayout_1,
        DisplayHLayout_2,
        NumericHLayout_3,
        NumericHLayout_4,
        NumericHLayout_5,
        NumericHLayout_6
    }, { 0.1, 0.3, 0.15, 0.15, 0.15, 0.15 })

    ScreenVLayout:Update(vec3(0, 0, 20), vec3(framed.x, framed.y, 1))

    UpdateDisplay = function()
        Display:Update(vec3(20), vec3(0), f, DisplayText, vec4(0.2, 0.4, 0, 1))
        ScreenVLayout:Update(vec3(0, 0, 20), vec3(framed.x, framed.y, 1))
    end

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
    --
    Update = function()
        gwr:Update()
    end

    Dispatch = function()
        gwr:Dispatch()
    end

    UIDraw = function()
        gwr:Draw()
    end

    Draw = function()
        w:BeginDraws(0, 0, 0, 1, 1)
        w:ExecuteUIs()
        w:EndDraws()
    end

    while not e:ShouldQuit() and gdisplayloop do
        -- if gnetworkloop then
        --     gnetwork_value = net.listenOnce()
        --     if type(gnetwork_value) == "function" then
        --         if not pcall(gnetwork_value) then
        --             Jkr.ShowToastNotification("Error Calling the function")
        --         end
        --     end
        --     if type(gnetwork_value) == "string" then
        --         Jkr.ShowToastNotification("M:" .. gnetwork_value)
        --         if gnetwork_value == "JkrGUIv2Start" then
        --             net.SendToServer("JkrGUIv2Start")
        --             gnetwork_value = nil
        --         end
        --     end
        -- end
        print("FUCK")
        e:ProcessEventsEXT(w)
        w:BeginUpdates()
        gWindowDimension = w:GetWindowDimension()
        Update()
        w:EndUpdates()

        w:BeginDispatches()
        Dispatch()
        w:EndDispatches()

        w:BeginUIs()
        UIDraw()
        w:EndUIs()

        Draw()
        w:Present()
    end
end

Main()
