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
          local ElementName = gUnique(inElementName)
          if inValue.r.x == 0 and inValue.r.y == 0 and inValue.r.z == 0 then
                    inValue = vec4(1, 1, 1, 0)
          end
          print(inValue.skinning)
          if inValue.skinning == -1 then
                    inValue.skinning = false
          end
          if not gscreenElements[ElementName] then
                    local GLTFObjects = Engine.AddAndConfigureGLTFToWorld(gwindow, gworld3d, gshaper3d, inValue.filename,
                              inValue.renderer,
                              Jkr.CompileContext.Default, inValue.skinning)
                    gscreenElements[ElementName] = GLTFObjects
          end
          local Element = {
                    "*GLTF*",
                    handle = gscreenElements[ElementName],
                    value = inValue,
                    name = ElementName
          }
          gAddFrameKeyElement(inFrameIndex, { Element })
end

local CameraControl

ExecuteFunctions["*GLTF*"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
          if inElement.value.camera_control == "FLYCAM_KEYBOARD" then
                    gwid.c:PushOneTime(Jkr.CreateUpdatable(CameraControl), 1)
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
                                                  local gltf = gworld3d:GetGLTFModel(Element.mAssociatedModel)
                                                  local uniform = gworld3d:GetUniform3D(Element.mAssociatedUniform)
                                                  gltf:UpdateAnimationNormalizedTime(math.int(new.animation.x), intera,
                                                            true)
                                                  uniform:UpdateByGLTFAnimation(gltf)
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
                                                  local gltf = gworld3d:GetGLTFModel(Element.mAssociatedModel)
                                                  local uniform = gworld3d:GetUniform3D(Element.mAssociatedUniform)
                                                  gltf:UpdateAnimationNormalizedTime(math.int(new.animation.x),
                                                            new.animation.y,
                                                            true)
                                                  uniform:UpdateByGLTFAnimation(gltf)
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
                    gobjects3d:add(Element) -- gobjects3d is erased at each frame
          end
end

CameraControl = function()
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
