require("Present.require")
require("Present.ProcessPass")
require("Present.ExecutePass")
require("Present.Elements")
inspect = require "JkrGUIv2.inspect"
---@diagnostic disable-next-line: lowercase-global
--[============================================================[
          PRESENTATION  FUNCTION
]============================================================]

local ProcessFrames = function(inPresentation)
    if inPresentation.Config and inPresentation.Config.CircularSwitch then
        local FirstFrame
        IterateEachFrame(inPresentation,
            function(eachFrameIndex, value)
                if eachFrameIndex == 1 then
                    FirstFrame = { Frame = value }
                end
            end)
        table.insert(inPresentation, FirstFrame)
    end

    IterateEachFrame(inPresentation,
        function(eachFrameIndex, _)
            gFrameKeys[eachFrameIndex] = {}
            gFrameKeysCompute[eachFrameIndex] = {}
        end)

    local FrameIndex = 1
    for _, elements in ipairs(inPresentation) do
        for __, value in pairs(elements) do
            if (__ == "Frame") then
                local frameElements = value
                --[[==================================================]]
                for felementName, felement in pairs(frameElements) do
                    if type(felement) == "table" then
                        for processFunctionIndex, ElementValue in pairs(felement) do
                            if type(ElementValue) == "table" then
                                gprocess[processFunctionIndex](
                                    inPresentation, ElementValue,
                                    FrameIndex, felementName)
                            end
                        end
                    else
                        ProcessLiterals(felementName, felement)
                    end
                end
                --[[==================================================]]
                FrameIndex = FrameIndex + 1
            end
        end
    end
end

local Log = function(inContent)
    -- print(string.format("[JkrGUI Present: ] %s", inContent))
end

local CreateEngineHandles = function(Validation)
    -- If already initialized, don't again
    if not Validation then
        print("=========WARNING============")
        print("=========NO VALIDATION============")
    end
    if not Engine.i then
        Engine:Load(Validation)
    end

    if not gwindow then
        gwindow = Jkr.CreateWindow(Engine.i, "Hello", vec2(900, 480), 3, gFrameDimension)
        gwindow:BuildShadowPass()
        gWindowDimension = gwindow:GetWindowDimension()
    end

    if not gnwindow then
        gnwindow = Jkr.CreateWindowNoWindow(Engine.i, gNFrameDimension, 3)
        gnwindow:BuildShadowPass()
    end

    if not gwid then
        gwid = Jkr.CreateGeneralWidgetsRenderer(nil, Engine.i, gwindow, Engine.e)
    end

    if not gworld3d and not gshaper3d then
        gshaper3d = Jkr.CreateShapeRenderer3D(Engine.i, gwindow)
        gworld3d, gcamera3d = Engine.CreateWorld3D(gwindow, gshaper3d)
        gworld3dS["default"].world3d = gworld3d
        gworld3dS["default"].shaper3d = gshaper3d
        gworld3dS["default"].camera3d = gcamera3d
    end

    if not gnworld3d and not gnshaper3d then
        gnshaper3d = Jkr.CreateShapeRenderer3D(Engine.i, gnwindow)
        gnworld3d, gncamera3d = Engine.CreateWorld3D(gnwindow, gnshaper3d)
    end

    if not gobjects3d then
        gobjects3d = gworld3d:MakeExplicitObjectsVector()
        gworld3dS["default"].objects3d = gobjects3d
    end

    if not gshadowobjects3d then
        gshadowobjects3d = gworld3d:MakeExplicitObjectsVector()
        gworld3dS["default"].shadowobjects3d = gshadowobjects3d
    end

    gwindow:Show()
end

local function getFileNameWithoutExtension(filePath)
    local fileName = filePath:match("^.+/(.+)$") or filePath       -- Extract file name
    local nameWithoutExt = fileName:match("(.+)%..+$") or fileName -- Remove extension
    return nameWithoutExt
end

local conf
local validation = false

gPresentation = function(inPresentation, inValidation, inLoopType)
    if inValidation then validation = true end
    CreateEngineHandles(validation)
    local shouldRun = true
    local shouldUpdate = true
    local circularSwitch
    local continousAutoPlay
    if inPresentation.Config then
        conf = inPresentation.Config
        if conf.LoopType then
            inLoopType = conf.LoopType
        end
        if conf.InterpolationType then
            gSetInterpolationType(conf.InterpolationType)
        end
        circularSwitch = conf.CircularSwitch
        continousAutoPlay = conf.ContinousAutoPlay
        if conf.FontSizes then
            gFontMap.SetFont = function(inFontFileName, inShortFontName)
                gFontMap[inShortFontName] = {}
                gFontMap[inShortFontName].Tiny = gwid.CreateFont(inFontFileName, conf.FontSizes.Tiny)
                gFontMap[inShortFontName].Small = gwid.CreateFont(inFontFileName, conf.FontSizes.Small)
                gFontMap[inShortFontName].Normal = gwid.CreateFont(inFontFileName, conf.FontSizes.Normal)
                gFontMap[inShortFontName].large = gwid.CreateFont(inFontFileName, conf.FontSizes.large)
                gFontMap[inShortFontName].Large = gwid.CreateFont(inFontFileName, conf.FontSizes.Large)
                gFontMap[inShortFontName].huge = gwid.CreateFont(inFontFileName, conf.FontSizes.huge)
                gFontMap[inShortFontName].Huge = gwid.CreateFont(inFontFileName, conf.FontSizes.Huge)
                gFontMap[inShortFontName].gigantic = gwid.CreateFont(inFontFileName, conf.FontSizes.gigantic)
                gFontMap[inShortFontName].Gigantic = gwid.CreateFont(inFontFileName, conf.FontSizes.Gigantic)
                gFontMap.__current_selected_font = inShortFontName
            end

            setmetatable(gFontMap, {
                __index = function(_, k)
                    return gFontMap[gFontMap.__current_selected_font][k]
                end
            })

            for _, value in ipairs(conf.FontFilePaths) do
                gFontMap.SetFont(value, getFileNameWithoutExtension(value))
            end
            print(inspect(gFontMap.Tiny))
        end
    else
        Log("Error: No Config provided.")
    end

    if shouldRun then
        ProcessFrames(inPresentation)

        local oldTime = 0.0
        local frameCount = 0
        local e = Engine.e
        local w = gwindow
        local nw = gnwindow
        local mt = Engine.mt
        if conf and conf.FullScreen then
            w:ToggleWindowFullScreen()
        end

        wcc = vec4(1)


        --[==================================================================]
        --
        --
        -- Event and Updates
        --
        --
        --[==================================================================]
        local currentFrame = 1
        local t = 1
        local hasNextFrame = false

        local currentTime = w:GetWindowCurrentTime()
        local stepTime = 0.05
        local residualTime = 0
        local direction = 1
        local animate = true
        local receive_events = true

        if conf and conf.StepTime then
            stepTime = conf.StepTime
        end

        inPresentation.ContinousAutoPlay = function(value)
            continousAutoPlay = value
        end
        inPresentation.CircularSwitch = function(value)
            circularSwitch = value
        end
        inPresentation.SetDirection = function(inValue)
            direction = inValidation
        end
        gMoveForward = function(inT)
            if receive_events and hasNextFrame and (currentFrame < gFrameCount - 1) then
                if inT then t = inT else t = 0.0 end
                currentFrame = currentFrame + 1
                direction = 1
                animate = true
            end
            print("currentFrame: ", currentFrame, "gFrameCount:", gFrameCount)
        end

        gMoveBackward = function(inT)
            if receive_events and (currentFrame > 1) then
                if inT then t = inT else t = 1.0 end
                currentFrame = currentFrame - 1
                direction = -1
                animate = true
            end
            print("currentFrame: ", currentFrame, "gFrameCount:", gFrameCount)
        end

        gMoveToParicular = function(inFrameNumber)
            local hasNextFrame = true
            if currentFrame > inFrameNumber then
                local frame = currentFrame
                while hasNextFrame and frame >= inFrameNumber do
                    hasNextFrame = ExecuteFrame(inPresentation, frame, 1, -1)
                    frame = frame - 1
                end
            elseif currentFrame < inFrameNumber then
                local frame = currentFrame
                while hasNextFrame and frame <= inFrameNumber do
                    hasNextFrame = ExecuteFrame(inPresentation, frame, 1, 1)
                    frame = frame + 1
                end
            end
            currentFrame = inFrameNumber
        end

        local Update, Event, Dispatch, Draw
        gEndPresentation = function(inNullifyWidgetRenderer)
            shouldRun = false
            shouldUpdate = false
            if inNullifyWidgetRenderer then
                gwid.c = Jkr.CreateCallBuffers()
                gscreenElements = {}
            end
        end

        Event = function()
            if receive_events then
                if (e:IsKeyPressed(Keyboard.SDLK_RIGHT)) then
                    gMoveForward()
                end

                if (e:IsKeyPressed(Keyboard.SDLK_LEFT)) then
                    gMoveBackward()
                end
            end

            if (e:IsCloseWindowEvent()) then
                shouldRun = false
            end
            gwid:Event()
        end

        Update = function()
            if continousAutoPlay then
                gMoveForward()
            end
            if circularSwitch then
                if currentFrame == gFrameCount - 1 and t >= 1.0 then
                    currentFrame = 1
                elseif currentFrame == 1 and t <= 0.0 then
                    currentFrame = gFrameCount - 1
                end
            end

            if w:GetWindowCurrentTime() - currentTime > stepTime and shouldUpdate then
                if animate then
                    t = t + direction * (stepTime + residualTime)
                    if t <= 0.0 or t >= 1.0 then
                        animate = false
                        receive_events = true
                        if t < 0.0 then
                            t = 0.0
                        elseif t > 1.0 then
                            t = 1.0
                        end
                    else
                        receive_events = false
                    end
                end
                hasNextFrame = ExecuteFrame(inPresentation, currentFrame, t, direction)
                residualTime = (w:GetWindowCurrentTime() - currentTime) / 1000
                currentTime = w:GetWindowCurrentTime()
            else
                residualTime = residualTime / 1000 + stepTime -
                    (w:GetWindowCurrentTime() - currentTime) / 1000
            end

            gwid:Update()
            gworld3d:Update(e, w)
        end

        local cmd_none = Jkr.CmdParam.None
        local cmd_ui = Jkr.CmdParam.UI
        local mat4s = std_vector_mat4()
        local uniforms = std_vector_int()
        local simple3ds = std_vector_int()
        Dispatch = function()
            if gshadowobjects3d then
                for i = 0, 3 do
                    w:BeginShadowPass(i, 1.0)
                    for ii = 1, #gshadowobjects3d do
                        mat4s:add(gshadowobjects3d[ii].mMatrix2)
                        uniforms:add(gshadowobjects3d[ii].mAssociatedUniform)
                        simple3ds:add(gshadowobjects3d[ii].mAssociatedSimple3D)
                        gshadowobjects3d[ii].mMatrix2 = mat4(vec4(i, 0, 0, 0), vec4(0), vec4(0), vec4(0))
                        gshadowobjects3d[ii].mAssociatedUniform = -1
                        gshadowobjects3d[ii].mAssociatedSimple3D = math.floor(gshadowsimple3did)
                    end
                    gworld3d:DrawObjectsExplicit(gwindow, gshadowobjects3d, cmd_none)
                    for ii = 1, #gshadowobjects3d do
                        gshadowobjects3d[ii].mMatrix2 = mat4s[ii]
                        gshadowobjects3d[ii].mAssociatedUniform = uniforms[ii]
                        gshadowobjects3d[ii].mAssociatedSimple3D = simple3ds[ii]
                    end
                    mat4s:clear()
                    uniforms:clear()
                    simple3ds:clear()
                    w:EndShadowPass()
                end
                gshadowobjects3d = nil
            end
            -- gshadowobjects3d:clear()
            gwid:Dispatch()
            DispatchFrame(inPresentation, currentFrame, t, direction)
        end

        Draw = function()
            gworld3d:DrawObjectsExplicit(gwindow, gobjects3d, cmd_ui)
            gwid:Draw()
            gobjects3d:clear()
        end

        DrawNW3D = function()
        end

        local function MultiThreadedDraws()
        end

        local function MultiThreadedExecute()
        end

        e:RemoveEventCallBacks();
        e:SetEventCallBack(Event)
        if inLoopType == "GeneralLoop" then
            while shouldRun do
                e:ProcessEventsEXT(gwindow)
                Update()

                w:Wait()
                w:AcquireImage()
                w:BeginRecording()
                Dispatch()
                MultiThreadedDraws()


                w:BeginUIs()
                Draw()
                w:EndUIs()

                w:BeginDraws(wcc.x, wcc.y, wcc.z, wcc.w, 1)
                MultiThreadedExecute()
                w:ExecuteUIs()
                w:EndDraws()

                w:BlitImage()
                w:EndRecording()
                w:Present()
            end
        elseif inLoopType == "NoWindowLoop" then
            e:ProcessEventsEXT(w)
            wid:Update()
            nw:Wait()
            nw:BeginRecording()
            nw:BeginUIs()
            world3d:DrawObjectsExplicit(nw, world3dobjectsptr, Jkr.CmdParam.UI)
            nw:EndUIs()
            nw:BeginDraws(0, 1, 0, wc.w, 1)
            nw:ExecuteUIs()
            nw:EndDraws()
            nw:EndRecording()

            w:Wait()
            w:AcquireImage()
            w:BeginRecording()
            Dispatch()
            MultiThreadedDraws()

            w:BeginUIs()
            Draw()
            w:EndUIs()

            w:BeginDraws(wcc.x, wcc.y, wcc.z, wcc.w, 1)
            MultiThreadedExecute()
            w:ExecuteUIs()
            w:EndDraws()

            w:BlitImage()
            w:EndRecording()
            Jkr.SyncSubmitPresent(nw, w)
        end
    end
end

ClosePresentations = function()
    Engine.gate.application_has_ended = true
    Engine.mt:Wait()
end

function gGetDefaultFontSizes()
    return {
        Tiny = 10,     -- \tiny
        Small = 12,    -- \small
        Normal = 16,   -- \normalsize
        large = 20,    -- \large
        Large = 24,    -- \Large
        huge = 28,     -- \huge
        Huge = 32,     -- \Huge
        gigantic = 38, -- \gigantic
        Gigantic = 42, -- \Gigantic
    }
end

function gGetPresentationWithDefaultConfiguration()
    local o = {
        Config = {
            -- FullScreen = true,
            FontSizes = {
                Tiny = 10,     -- \tiny
                Small = 12,    -- \small
                Normal = 16,   -- \normalsize
                large = 20,    -- \large
                Large = 24,    -- \Large
                huge = 28,     -- \huge
                Huge = 32,     -- \Huge
                gigantic = 38, -- \gigantic
                Gigantic = 42, -- \Gigantic
            },
            FontFilePaths = { "font.ttf", "font.ttf" }
        },
        insert = function(self, inTable)
            for _, value in pairs(inTable) do
                table.insert(self, value)
            end
        end
    }
    return o
end
