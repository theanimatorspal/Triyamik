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
    IterateEachFrame(inPresentation,
        function(eachFrameIndex, _)
            gFrameKeys[eachFrameIndex] = {}
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
    gFrameCount = FrameIndex
end

local Log = function(inContent)
    -- print(string.format("[JkrGUI Present: ] %s", inContent))
end

local CreateEngineHandles = function()
    local Validation = false

    -- If already initialized, don't again
    if not Engine.i then
        Engine:Load(Validation)
    end

    if not gwindow then
        gwindow = Jkr.CreateWindow(Engine.i, "Hello", vec2(900, 480), 3, gFrameDimension)
        gWindowDimension = gwindow:GetWindowDimension()
        gwid = Jkr.CreateGeneralWidgetsRenderer(nil, Engine.i, gwindow, Engine.e)
    end

    if not gworld3d and not gshaper3d then
        gshaper3d = Jkr.CreateShapeRenderer3D(Engine.i, gwindow)
        gworld3d = Jkr.World3D(gshaper3d)
        gcamera3d = Jkr.Camera3D()
        gcamera3d:SetAttributes(vec3(0, 0, 0), vec3(0, -10, 10))
        gcamera3d:SetPerspective(0.3, 16 / 9, 0.1, 10000)
        gworld3d:AddCamera(gcamera3d)
        gdummypiplineindex = gworld3d:AddSimple3D(Engine.i, gwindow);
        gdummypipline = gworld3d:GetSimple3D(gdummypiplineindex)
        local light0 = {
            pos = vec4(-1, -2, 2, 4),
            dir = Jmath.Normalize(vec4(0, 0, 0, 0) - vec4(10, 10, -10, 1))
        }
        gworld3d:AddLight3D(light0.pos, light0.dir)

        local vshader, fshader = Engine.GetAppropriateShader("CONSTANT_COLOR",
            Jkr.CompileContext.Default
        )

        gdummypipline:CompileEXT(
            Engine.i,
            gwindow,
            "cache/dummyshader.glsl",
            vshader.str,
            fshader.str,
            "",
            false,
            Jkr.CompileContext.Default
        )

        local globaluniformindex = gworld3d:AddUniform3D(Engine.i)
        local globaluniformhandle = gworld3d:GetUniform3D(globaluniformindex)
        globaluniformhandle:Build(gdummypipline) -- EUTA PIPELINE BANAUNU PRXA
        gworld3d:AddWorldInfoToUniform3D(globaluniformindex)
    end

    if not gobjects3d then
        gobjects3d = gworld3d:MakeExplicitObjectsVector()
    end

    gwindow:Show()
end

local function getFileNameWithoutExtension(filePath)
    local fileName = filePath:match("^.+/(.+)$") or filePath       -- Extract file name
    local nameWithoutExt = fileName:match("(.+)%..+$") or fileName -- Remove extension
    return nameWithoutExt
end
gPresentation = function(inPresentation)
    CreateEngineHandles()
    local shouldRun = true
    if inPresentation.Config then
        local conf = inPresentation.Config
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
    else
        Log("Error: No Config provided.")
    end

    if shouldRun then
        ProcessFrames(inPresentation)

        local oldTime = 0.0
        local frameCount = 0
        local e = Engine.e
        local w = gwindow
        local mt = Engine.mt
        if inPresentation.Config.FullScreen then
            w:ToggleWindowFullScreen()
        end

        WindowClearColor = vec4(1)



        --[==================================================================]
        --
        --
        -- Event and Updates
        --
        --
        --[==================================================================]
        local currentFrame = 1
        local t = 0
        local hasNextFrame = false

        local currentTime = w:GetWindowCurrentTime()
        local stepTime = 0.01
        local residualTime = 0
        local direction = 1
        local animate = true
        local receive_events = true

        gMoveForward = function()
            if receive_events and (hasNextFrame) then
                t = 0.0
                currentFrame = currentFrame + 1
                direction = 1
                animate = true
            end
            print("currentFrame: ", currentFrame)
        end

        gMoveBackward = function()
            if receive_events and (currentFrame > 1) then
                t = 1.0
                currentFrame = currentFrame - 1
                direction = -1
                animate = true
            end
            print("currentFrame: ", currentFrame)
        end

        local Event = function()
            if receive_events then
                if (e:IsKeyPressed(Keyboard.SDLK_RIGHT)) then
                    gMoveForward()
                end

                if (e:IsKeyPressed(Keyboard.SDLK_LEFT)) then
                    gMoveBackward()
                end
            end

            ---
            ---
            --- This is for External State management
            ---
            ---

            -- local newcurrentFrame, newdirection, newshouldRun, newt, newanimate =
            --     PresentationEventFunction(
            --         currentFrame,
            --         direction,
            --         shouldRun,
            --         t,
            --         animate)

            -- direction = newdirection
            -- shouldRun = newshouldRun
            -- t = newt
            -- animate = newanimate

            -- if newcurrentFrame <= gFrameCount and newcurrentFrame >= 1 then
            --     currentFrame = newcurrentFrame
            -- end

            -- ---
            -- ---
            -- --- This is for External State management
            -- ---
            -- ---

            if (e:IsCloseWindowEvent()) then
                shouldRun = false
            end
            gwid:Event()
        end



        local function Update()
            gwid:Update()
            gworld3d:Update(e)
            hasNextFrame = ExecuteFrame(inPresentation, currentFrame, t, direction)
            if w:GetWindowCurrentTime() - currentTime > stepTime then
                if animate then
                    t = t + direction * (stepTime + residualTime)
                    if t <= 0.0 or t >= 1.0 then
                        animate = false
                        receive_events = true
                        if t <= 0.0 then
                            t = 0.0
                        else
                            t = 1.0
                        end
                    else
                        receive_events = false
                    end
                end
                residualTime = (w:GetWindowCurrentTime() - currentTime) / 1000
                currentTime = w:GetWindowCurrentTime()
            else
                residualTime = residualTime / 1000 + stepTime -
                    (w:GetWindowCurrentTime() - currentTime) / 1000
            end
        end

        local function Dispatch()
            gwid:Dispatch()
        end

        local function Draw()
            gworld3d:DrawObjectsExplicit(gwindow, gobjects3d, Jkr.CmdParam.UI)
            gwid:Draw()
            gobjects3d:clear()
        end

        local function MultiThreadedDraws()
        end

        local function MultiThreadedExecute()
        end

        e:SetEventCallBack(Event)
        while shouldRun do
            oldTime = w:GetWindowCurrentTime()
            e:ProcessEventsEXT(gwindow)
            w:BeginUpdates()
            Update()
            gWindowDimension = w:GetWindowDimension()
            w:EndUpdates()

            w:BeginDispatches()
            Dispatch()
            w:EndDispatches()

            MultiThreadedDraws()
            w:BeginUIs()
            Draw()
            w:EndUIs()

            w:BeginDraws(WindowClearColor.x, WindowClearColor.y, WindowClearColor.z,
                WindowClearColor.w, 1)
            MultiThreadedExecute()
            w:ExecuteUIs()
            w:EndDraws()
            w:Present()
            local delta = w:GetWindowCurrentTime() - oldTime
            if (frameCount % 100 == 0) then
                w:SetTitle("JkrGUI Present : " .. 1000 / delta)
            end
            frameCount = frameCount + 1
        end
        Engine.gate.application_has_ended = true
        w:Hide()
    end
end


function DefaultPresentation()
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
            FontFilePaths = { "res/fonts/font.ttf", "res/fonts/Laila.ttf" }
        },
        insert = function(self, inTable)
            for _, value in pairs(inTable) do
                table.insert(self, value)
            end
        end
    }
    return o
end
