require("Present.require")
require("Present.ProcessPass")
require("Present.ExecutePass")
require("Present.Elements")
--[============================================================[
          PRESENTATION  FUNCTION
]============================================================]

Presentation = function(inPresentation)
          local Log = function(inContent)
                    -- print(string.format("[JkrGUI Present: ] %s", inContent))
          end
          local shouldRun = true
          local Validation = false
          Engine:Load(Validation)
          gwindow = Jkr.CreateWindow(Engine.i, "Hello", vec2(900, 480), 3)
          gWindowDimension = gwindow:GetWindowDimension()
          gwid = Jkr.CreateWidgetRenderer(Engine.i, gwindow, Engine.e)

          if inPresentation.Config then
                    local conf = inPresentation.Config
                    gFontMap.Tiny = gwid.CreateFont(conf.Font.Tiny[1], conf.Font.Tiny[2])
                    gFontMap.Small = gwid.CreateFont(conf.Font.Small[1], conf.Font.Small[2])
                    gFontMap.Normal = gwid.CreateFont(conf.Font.Normal[1], conf.Font.Normal[2])
                    gFontMap.large = gwid.CreateFont(conf.Font.large[1], conf.Font.large[2])
                    gFontMap.Large = gwid.CreateFont(conf.Font.Large[1], conf.Font.Large[2])
                    gFontMap.huge = gwid.CreateFont(conf.Font.huge[1], conf.Font.huge[2])
                    gFontMap.Huge = gwid.CreateFont(conf.Font.Huge[1], conf.Font.Huge[2])
                    gFontMap.gigantic = gwid.CreateFont(conf.Font.gigantic[1], conf.Font.gigantic[2])
                    gFontMap.Gigantic = gwid.CreateFont(conf.Font.Gigantic[1], conf.Font.Gigantic[2])
          else
                    Log("Error: No Config provided.")
          end

          if shouldRun then
                    --[[
                    Presentation {
                              {Frame = table}
                    }
                    ]]

                    local FrameIndex = 1
                    for _, elements in ipairs(inPresentation) do
                              for __, value in pairs(elements) do
                                        if (__ == "Frame") then
                                                  gFrameKeys[FrameIndex] = {}
                                                  local frameElements = value
                                                  --[[==================================================]]
                                                  for felementName, felement in pairs(frameElements) do
                                                            if type(felement) == "table" then
                                                                      for processFunctionIndex, ElementValue in pairs(felement) do
                                                                                ProcessFunctions[processFunctionIndex](
                                                                                          inPresentation, ElementValue,
                                                                                          FrameIndex, felementName)
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

                    local oldTime = 0.0
                    local frameCount = 0
                    local e = Engine.e
                    local w = gwindow
                    local mt = Engine.mt

                    WindowClearColor = vec4(0)
                    -- ExecuteFrame(inPresentation, 1, 1)

                    local currentFrame = 1
                    ExecuteFrame(inPresentation, currentFrame, 1)
                    local Event = function()
                              if (e:IsKeyPressed(Keyboard.SDLK_RIGHT)) then
                                        if (ExecuteFrame(inPresentation, currentFrame, 1)) then
                                                  currentFrame = currentFrame + 1
                                        end
                              end
                    end

                    local function Update()
                              gwid.Update()
                    end

                    local function Dispatch()
                              gwid.Dispatch()
                    end

                    local function Draw()
                              gwid.Draw()
                    end

                    local function MultiThreadedDraws()
                    end

                    local function MultiThreadedExecute()
                    end


                    e:SetEventCallBack(Event)
                    while not e:ShouldQuit() and shouldRun do
                              oldTime = w:GetWindowCurrentTime()
                              e:ProcessEvents()
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
                                        w:SetTitle("Samprahar Frame Rate" .. 1000 / delta)
                              end
                              frameCount = frameCount + 1
                              mt:InjectToGate("__MtDrawCount", 0)
                    end
          end
end
