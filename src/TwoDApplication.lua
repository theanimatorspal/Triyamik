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
          wr_.CreateWindowScissor(vec3(100, 100, 50), vec3(100, 100, 1), font, "hello", vec4(0, 0, 0, 1),
                    vec4(1, 1, 1, 1), vec4(1, 0.3, 1, 1), true)
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
                              oldTime = w:GetWindowCurrentTime()
                              e:ProcessEventsEXT(w)
                              wr_:Update()

                              w:BeginUpdates()
                              w:EndUpdates()

                              w:BeginDispatches()
                              wr_:Dispatch()
                              w:EndDispatches()

                              w:BeginUIs()
                              wr_:Draw()
                              w:EndUIs()

                              w:BeginDraws(wc.x, wc.y, wc.z, wc.w, 1)
                              w:ExecuteUIs()
                              w:EndDraws()
                              w:Present()
                    end
          end
end
