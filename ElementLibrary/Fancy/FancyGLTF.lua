require "ElementLibrary.Fancy.FancyRequire"

FancyGLTF = function(inGLTFViewTable)
          local t = {
                    filename = "",
                    renderer = "CONSTANT_COLOR",
                    skinning = -1,
                    animation = vec2(-1, -1), --(index, deltatime)
                    p = vec3(0, 0, 0),
                    r = vec4(1, 1, 1, 0),
                    d = vec3(1, 1, 1)
          }
          return { FancyGLTF = Default(inGLTFViewTable, t) }
end

gprocess["FancyGLTF"] = function(inPresentation, inValue, inFrameIndex, inElementName)
          if inValue.r.x == 0 and inValue.r.y == 0 and inValue.r.z == 0 then
                    inValue = vec4(1, 1, 1, 0)
          end
          print(inValue.skinning)
          if inValue.skinning == -1 then
                    inValue.skinning = false
          end
          if not gscreenElements[inElementName] then
                    local GLTFObjects = Engine.AddAndConfigureGLTFToWorld(gwindow, gworld3d, gshaper3d, inValue.filename,
                              inValue.renderer,
                              Jkr.CompileContext.Default, inValue.skinning)
                    gscreenElements[inElementName] = GLTFObjects
          end
          local Elements = {}
          local ElementCount = #gscreenElements[inElementName]
          for i = 1, ElementCount, 1 do
                    Elements[#Elements + 1] = {
                              "*GLTF*",
                              handle = gscreenElements[inElementName][i],
                              value = inValue,
                              name = inElementName .. i
                    }
          end
          gAddFrameKeyElement(inFrameIndex, Elements)
end

local function CameraControl()
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
          if (e:IsKeyPressedContinous(Keyboard.SDL_SCANCODE_UP)) then
                    cam:Pitch(0.5)
          end
          if (e:IsKeyPressedContinous(Keyboard.SDL_SCANCODE_DOWN)) then
                    cam:Pitch(-0.5)
          end
          cam:SetPerspective()
end

ExecuteFunctions["*GLTF*"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
          if inElement.value.camera_control == "FLYCAM_KEYBOARD" then
                    gwid.c:PushOneTime(Jkr.CreateUpdatable(CameraControl), 1)
          end
          local PreviousElement, inElement = GetPreviousFrameKeyElementD(inPresentation, inElement,
                    inFrameIndex, inDirection)
          local new = inElement.value
          gobjects3d:add(inElement.handle) -- gobjects3d is erased at each frame
          if PreviousElement then
                    local prev = PreviousElement.value
                    if new.skinning and prev.skinning then
                              local intera = glerp(prev.animation.y, new.animation.y, t)
                              local gltf = gworld3d:GetGLTFModel(inElement.handle.mAssociatedModel)
                              local uniform = gworld3d:GetUniform3D(inElement.handle.mAssociatedUniform)
                              gltf:UpdateAnimationNormalizedTime(math.int(new.animation.x), intera, true)
                              uniform:UpdateByGLTFAnimation(gltf)
                    end
                    local interp = glerp_3f(prev.p, new.p, t)
                    local interr = glerp_4f(prev.r, new.r, t)
                    local interd = glerp_3f(prev.d, new.d, t)
                    local Matrix = Jmath.Scale(inElement.handle.mMatrix, vec3(1))
                    -- Jmath.PrintMatrix(Matrix)
                    -- rotate
                    local rotateby = vec3(interr.x, interr.y, interr.z)
                    local rotateby_deg = interr.w
                    Matrix = Jmath.Rotate_deg(Matrix, rotateby_deg, rotateby)
                    -- scale
                    Matrix = Jmath.Scale(Matrix, interd)
                    -- translate
                    Matrix = Jmath.Translate(Matrix, interp)
                    gobjects3d[#gobjects3d].mMatrix = Matrix
          else
                    if new.skinning then
                              local gltf = gworld3d:GetGLTFModel(inElement.handle.mAssociatedModel)
                              local uniform = gworld3d:GetUniform3D(inElement.handle.mAssociatedUniform)
                              gltf:UpdateAnimationNormalizedTime(math.int(new.animation.x), new.animation.y, true)
                              uniform:UpdateByGLTFAnimation(gltf)
                    end
                    local interp = new.p
                    local interr = new.r
                    local interd = new.d
                    local Matrix = Jmath.Scale(inElement.handle.mMatrix, vec3(1))
                    -- rotate
                    local rotateby = vec3(interr.x, interr.y, interr.z)
                    local rotateby_deg = interr.w
                    Matrix = Jmath.Rotate_deg(Matrix, rotateby_deg, rotateby)
                    -- scale
                    Matrix = Jmath.Scale(Matrix, interd)
                    -- translate
                    Matrix = Jmath.Translate(Matrix, interp)
                    gobjects3d[#gobjects3d].mMatrix = Matrix
          end
end
