require "ElementLibrary.Commons.Require"

Cobj = function(inOBJViewTable)
    local t = {
        filename = "", -- expects GLTF
        renderer = "CONSTANT_COLOR",
        skinning = -1,
        animation = vec2(-1, -1), --(index, deltatime)
        p = vec3(0, 0, 0),
        r = vec4(1, 1, 1, 0),
        d = vec3(1, 1, 1),
        load = "None" -- expects a function (if provided, it will not load the filename)
    }
    return { Cobj = Default(inOBJViewTable, t) }
end

gprocess["Cobj"] = function(inPresentation, inValue, inFrameIndex, inElementName)
    local ElementName = gUnique(inElementName)
    if inValue.r.x == 0 and inValue.r.y == 0 and inValue.r.z == 0 then
        inValue = vec4(1, 1, 1, 0)
    end
    if inValue.skinning == -1 then
        inValue.skinning = false
    end
    if not gscreenElements[ElementName] then
        if type(inValue.load) == "function" then
            local obs = inValue.load()
            for i = 1, #obs, 1 do
                if obs[i].mP2 ~= 1 then
                    obs[i].mP2 = 1
                end
            end
            gscreenElements[ElementName] = inValue.load()
        else
            local OBJObjects = Engine.AddAndConfigureGLTFToWorld(gwindow, gworld3d, gshaper3d,
                inValue.filename,
                inValue.renderer,
                Jkr.CompileContext.Default, inValue.skinning)
            gscreenElements[ElementName] = OBJObjects
        end
    end
    local Element = {
        "*Cobj*",
        handle = gscreenElements[ElementName],
        value = inValue,
        name = ElementName
    }
    gAddFrameKeyElement(inFrameIndex, { Element })
end

local FlycamKeyboardCameraControl, EditorMouseCameraControl, AndroidSensorCameraControl

ExecuteFunctions["*Cobj*"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
    local camControl = inElement.value.camera_control
    if camControl == "FLYCAM_KEYBOARD" then
        gwid.c:PushOneTime(Jkr.CreateUpdatable(FlycamKeyboardCameraControl), 1)
    elseif camControl == "EDITOR_MOUSE" then
        gwid.c:PushOneTime(Jkr.CreateUpdatable(EditorMouseCameraControl), 1)
    elseif camControl == "ANDROID_SENSOR" then
        gwid.c:PushOneTime(Jkr.CreateUpdatable(AndroidSensorCameraControl), 1)
    end
    for i = 1, #inElement.handle, 1 do
        Element = inElement.handle[i]
        if Element.mP2 == 1 then
            local PreviousElement, inElement = GetPreviousFrameKeyElementD(inPresentation, inElement,
                inFrameIndex, inDirection)
            local new = inElement.value
            if PreviousElement then
                local prev = PreviousElement.value
                if new.skinning and prev.skinning then
                    local intera = glerp(prev.animation.y, new.animation.y, t)
                    local gltf = gworld3d:GetOBJModel(Element.mAssociatedModel)
                    local uniform = gworld3d:GetUniform3D(Element.mAssociatedUniform)
                    gltf:UpdateAnimationNormalizedTime(math.int(new.animation.x), intera,
                        true)
                    uniform:UpdateByOBJAnimation(gltf)
                end
                local interp = glerp_3f(prev.p, new.p, t)
                local interr = glerp_4f(prev.r, new.r, t)
                local interd = glerp_3f(prev.d, new.d, t)
                local Matrix = Jmath.Scale(Element.mMatrix3, vec3(1))
                -- Jmath.PrintMatrix(Matrix)
                -- rotate
                local rotateby = vec3(interr.x, interr.y, interr.z)
                local rotateby_deg = interr.w
                Matrix = Jmath.Rotate_deg(Matrix, rotateby_deg, rotateby)
                -- scale
                Matrix = Jmath.Scale(Matrix, interd)
                -- translate
                Matrix = Jmath.Translate(Matrix, interp)
                Element.mMatrix = Matrix
            else
                if new.skinning then
                    local gltf = gworld3d:GetOBJModel(Element.mAssociatedModel)
                    local uniform = gworld3d:GetUniform3D(Element.mAssociatedUniform)
                    gltf:UpdateAnimationNormalizedTime(math.int(new.animation.x),
                        new.animation.y,
                        true)
                    uniform:UpdateByOBJAnimation(gltf)
                end
                local interp = new.p
                local interr = new.r
                local interd = new.d
                local Matrix = Jmath.Scale(Element.mMatrix3, vec3(1))
                -- rotate
                local rotateby = vec3(interr.x, interr.y, interr.z)
                local rotateby_deg = interr.w
                Matrix = Jmath.Rotate_deg(Matrix, rotateby_deg, rotateby)
                -- scale
                Matrix = Jmath.Scale(Matrix, interd)
                -- translate
                Matrix = Jmath.Translate(Matrix, interp)
                Element.mMatrix = Matrix
            end
        end
    end
    ---@todo Fix this, the model is only shown for a moment
    gobjects3d:add(Element) -- gobjects3d is erased at each frame
end


FlycamKeyboardCameraControl = function()
    local e = Engine.e
    local cam = gworld3d:GetCurrentCamera()
    if (e:IsKeyPressedContinous(Keyboard.SDL_SCANCODE_W)) then
        cam:MoveForward(1)
    end
    if (e:IsKeyPressedContinous(Keyboard.SDL_SCANCODE_S)) then
        cam:MoveBackward(1)
    end
    if (e:IsKeyPressedContinous(Keyboard.SDL_SCANCODE_A)) then
        cam:MoveLeft(1)
    end
    if (e:IsKeyPressedContinous(Keyboard.SDL_SCANCODE_D)) then
        cam:MoveRight(1)
    end
    if (e:IsKeyPressedContinous(Keyboard.SDL_SCANCODE_Q)) then
        cam:Yaw(0.5)
    end
    if (e:IsKeyPressedContinous(Keyboard.SDL_SCANCODE_E)) then
        cam:Yaw(-0.5)
    end
    if (e:IsKeyPressedContinous(Keyboard.SDL_SCANCODE_UP)) then
        cam:Pitch(0.5)
    end
    if (e:IsKeyPressedContinous(Keyboard.SDL_SCANCODE_DOWN)) then
        cam:Pitch(-0.5)
    end
    cam:SetPerspective()
end

_LOCAL_Mouse_control = {
    WorldMatrix = Jmath.GetIdentityMatrix4x4(),
    rx = 0,
    ry = 0
}

EditorMouseCameraControl = function()
    local lmc = _LOCAL_Mouse_control
    local e = Engine.e
    local cam = gworld3d:GetCurrentCamera()
    local rmouse = e:GetRelativeMousePos() * 0.1
    local rmat = Jmath.GetIdentityMatrix4x4()
    if (e:IsLeftButtonPressedContinous()) then
        if (e:IsKeyPressedContinous(Keyboard.SDL_SCANCODE_LALT)) then
            lmc.rx = lmc.rx + rmouse.x
            lmc.ry = lmc.ry + rmouse.y
        end
        if e:IsKeyPressedContinous(Keyboard.SDL_SCANCODE_LCTRL) then
            cam:MoveForward(rmouse.x)
        end
        if e:IsKeyPressedContinous(Keyboard.SDL_SCANCODE_LSHIFT) then
            cam:MoveLeft(rmouse.x)
            cam:MoveUp(rmouse.y)
        end
    end
    rmat = Jmath.Rotate_deg(rmat, lmc.ry * 2, vec3(1, 0, 0))
    rmat = Jmath.Rotate_deg(rmat, lmc.rx * 2, vec3(0, 1, 0))
    cam:SetPerspective()
    gworld3d:SetWorldMatrix(rmat)
end



_LOCAL_Android_Sensor_Camera_Control = { FirstTime = true }
AndroidSensorCameraControl = function()
    local asc = _LOCAL_Android_Sensor_Camera_Control
    if asc.FirstTime and Engine.gate.android_device_connected then
        local function StartUDP()
            Engine.net.UDP()
            Engine.net.StartUDP(6523)
            local vc = Jkr.ConvertToVChar(vec3(0))
            Jkr.SetBufferSizeUDP(#vc)
        end
        local function StartUDPInAndroid()
            Engine.net.UDP()
            Engine.net.StartUDP(6524)
            local vc = Jkr.ConvertToVChar(vec3(0))
            Jkr.SetBufferSizeUDP(#vc)
        end
        StartUDP()

        local android_udp_func = string.format("GSERVER_IP_ADDRESSES = {}\n")
        for i = 1, #Engine.gate.ip_addresses do
            android_udp_func = android_udp_func ..
                string.format("GSERVER_IP_ADDRESSES[%d] = '%s'\n", i, Engine.gate.ip_addresses[i])
        end

        ---@note In UDP Message is not needed FUCK
        local f, e = load(android_udp_func)
        Engine.net.BroadCast(f)
        Engine.net.BroadCast(StartUDPInAndroid)
        Engine.net.BroadCast(function()
            local function GUDPSend()
                for i = 1, #GSERVER_IP_ADDRESSES do
                    -- print("SENT")
                    local ip = GSERVER_IP_ADDRESSES[i]
                    local v3 = vec3(4, 5, 6)
                    Engine.net.SendUDP(v3, ip, 6523)
                end
            end

            GWR.c:Push(Jkr.CreateUpdatable(GUDPSend))
        end)
        asc.FirstTime = false
    end


    local rmat = Jmath.GetIdentityMatrix4x4()
    local message = Engine.net.listenOnceUDP(vec3(0))
    if message and type(message) == "userdata" then
        local ort = message
        rmat = Jmath.Rotate_deg(rmat, math.floor(ort.y * 10) / 10 * 5, vec3(1, 0, 0))
        rmat = Jmath.Rotate_deg(rmat, math.floor(ort.x * 10) / 10 * 5, vec3(0, 1, 0))
        gworld3d:SetWorldMatrix(rmat)
    end
    --   if msg then
    --             print(msg.x, msg.y, msg.z)
    --   end
    -- if Engine.gate.android_device_connected then
    --           Engine.net.BroadCast(
    --                     function()
    --                               local data = Jkr.GetAccelerometerData()
    --                               local msg = Jkr.Message()
    --                               msg.mHeader.mId = 1000
    --                               msg:InsertVec3(data)
    --                               Jkr.SendMessageFromClient(0, msg)
    --                     end
    --           )
    --           local message = Engine.net.listenOnce()
    --           if message and type(message) == "userdata" then
    --                     local ort = message:GetVec3()
    --                     rmat = Jmath.Rotate_deg(rmat, math.floor(ort.y * 10) / 10 * 5, vec3(1, 0, 0))
    --                     rmat = Jmath.Rotate_deg(rmat, math.floor(ort.x * 10) / 10 * 5, vec3(0, 1, 0))
    --                     gworld3d:SetWorldMatrix(rmat)
    --           end
    -- else
    --           print("Android Device not connected")
    -- end
end
