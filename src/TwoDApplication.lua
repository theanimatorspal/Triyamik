require "Present.Present"

TwoDApplication = function(inTable)
          local t = {

          }
          return { TwoDApplication = Default(inTable, t) }
end

local e
local w
local mt
local wc
local wr_
local nw
local cimage
local simage
local squad
local shape3d
local world3d
local world3dfile
local world3dobjects
local world3dobjectsptr

gprocess["TwoDApplication"] = function(inP, inValue, inFrameIndex, inElementName)
          local ElementName = gUnique(inElementName)
          gAddFrameKeyElement(inFrameIndex, {
                    {
                              "TwoDApplication",
                              handle = nil,
                              value = inValue,
                              name = ElementName
                    }
          })
          e = Jkr.CreateEventManager()
          w = gwindow
          mt = Engine.mt
          wc = vec4(1, 0, 0, 1)
          wr_ = Jkr.CreateGeneralWidgetsRenderer(nil, Engine.i, w, e)
          local font = wr_.CreateFont("font.ttf", 14)
          local WC = wr_.CreateWindowScissor(vec3(100, 100, 50), vec3(100, 100, 1), font, "hello", vec4(0, 0, 0, 1),
                    vec4(1, 1, 1, 1), vec4(1, 0.3, 1, 1), true)

          local fd = vec3(256, 256, 1)
          nw = Jkr.CreateWindowNoWindow(Engine.i, fd)
          cimage = wr_.CreateComputeImage(vec3(0), fd)
          simage = wr_.CreateSampledImage(vec3(200, 200, 50), fd, nil, nil)

          PushConstant = Jkr.Matrix2CustomImagePainterPushConstant()
          PushConstant.a = mat4(
                    vec4(1, 1, 1, 1),
                    vec4(1),
                    vec4(0.1, 0.5, 0.5, 0.0),
                    vec4(0)
          )
          WC.Set()
          squad = wr_.CreateQuad(vec3(20, 20, 50), gFrameDimension, PushConstant, "showImage", simage.mId)
          WC.Reset()

          shape3d = Jkr.CreateShapeRenderer3D(Engine.i, nw)
          world3d = Engine.CreateWorld3D(nw, shape3d)
          world3dfile = Jkr.FileJkr("WorldShapeFile.jkr");
          Jkr.SerializeDeserializeShape3D(Engine.i, "pbr_shape->", world3dfile, shape3d)
          Jkr.SerializeDeserializeWorld3D(Engine.i, nw, "pbr_world->", world3dfile, world3d)
          world3dobjects = world3dfile:ReadObject3DVector("object3ds")
          world3dobjectsptr = world3d:MakeExplicitObjectsVector()
          for i = 1, #world3dobjects, 1 do
                    world3dobjectsptr:add(world3dobjects[i])
          end
end

ExecuteFunctions["TwoDApplication"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
          if t == 0.0 or t == 1.0 then
                    local run = true
                    local events = function()
                              if (e:IsKeyPressed(Keyboard.SDLK_ESCAPE)) then
                                        run = false
                              end
                    end
                    e:SetEventCallBack(events)
                    while run do
                              e:ProcessEventsEXT(w)
                              wr_:Update()
                              world3d:Update(e)
                              nw:Wait()
                              nw:BeginRecording()
                              nw:BeginUIs()
                              world3d:DrawObjectsExplicit(nw, world3dobjectsptr, Jkr.CmdParam.UI)
                              nw:EndUIs()
                              nw:BeginDraws(0, 1, 0, wc.w, 1)
                              nw:ExecuteUIs()
                              nw:EndDraws()
                              nw:EndRecording()
                              -- nw:Submit()

                              -- Present Window
                              w:Wait()
                              w:AcquireImage()
                              w:BeginRecording()
                              cimage.CopyFromWindowTargetImage(nw)
                              cimage.CopyToSampled(simage)
                              wr_:Dispatch()
                              w:BeginUIs()
                              wr_:Draw()
                              w:EndUIs()

                              w:BeginDraws(wc.x, wc.y, wc.z, wc.w, 1)
                              w:ExecuteUIs()
                              w:EndDraws()
                              w:BlitImage()
                              w:EndRecording()
                              -- w:Present()
                              Jkr.SyncSubmitPresent(nw, w)
                    end
          end
end
