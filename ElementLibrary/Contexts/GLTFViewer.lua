require "ElementLibrary.Contexts.Require"

CON.GLTFViewer = function(inTable)
          local t = {
                    file_path = "",
                    mode = "PRESENT",
                    fd = vec2(256, 256),
                    wcc = vec4(0.2, 0.2, 0.2, 1),
                    threed_res = vec2(256, 256)
          }
          return { CON_GLTFViewer = Default(inTable, t) }
end

local e
local w
local mt
local wc
local wr_
local nw
local cimage
local simage
local shapes = {}
local worlds = {}

gprocess["CON_GLTFViewer"] = function(inP, inValue, inFrameIndex, inElementName)
          local ElementName = gUnique(inElementName)
          gAddFrameKeyElement(inFrameIndex, {
                    {
                              "CON.GLTFViewer",
                              handle = nil,
                              value = inValue,
                              name = ElementName
                    }
          })
          do ---@PREPARE_FOR_STUFFS
                    e = Jkr.CreateEventManager()
                    w = gwindow
                    mt = Engine.mt
                    wc = inValue.wcc
                    wr_ = Jkr.CreateGeneralWidgetsRenderer(nil, Engine.i, w, e)
                    nw = Jkr.CreateWindowNoWindow(Engine.i, inValue.fd)
                    cimage = wr_.CreateComputeImage(vec3(0), inValue.fd)
          end
end

ExecuteFunctions["CON.GLTFViewer"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
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


                              nw:Wait()
                              nw:BeginRecording()
                              nw:BeginUIs()
                              nw:EndUIs()
                              nw:BeginDraws(0, 1, 0, wc.w, 1)
                              nw:ExecuteUIs()
                              nw:EndDraws()
                              nw:EndRecording()

                              ---@note Present Window
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
