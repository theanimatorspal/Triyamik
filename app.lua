-- require "ElementLibrary.Commons.Commons"
-- require "ElementLibrary.Contexts.GLTFViewer"
-- require "src.TwoDApplication"

-- Pr = gDefaultConfiguration()
-- -- Pr.Config.FullScreen = true

-- P = {
--           Frame { CButton { t = "HEllO" } },
--           Frame { CON.GLTFViewer {} },
--           Frame { CButton { t = "BYE BYE" } },
-- }

-- Pr:insert(P)
-- -- gPresentation(Pr, true)

-- local file = io.popen(
--           "powershell -Command \"Add-Type -AssemblyName System.Windows.Forms; $f = New-Object System.Windows.Forms.OpenFileDialog; $f.Filter = 'All Files (*.*)|*.*'; if ($f.ShowDialog() -eq 'OK') { $f.FileName }\"")
-- local filePath = file:read("*a"):gsub("%s+$", "") -- Read and trim output
-- file:close()

-- if filePath ~= "" then
--           print("Selected file: " .. filePath)
-- else
--           print("No file selected")
-- end

require "ElementLibrary.Commons.Commons"
do
          local Configuration = gDefaultConfiguration()
          local Validation = true
          local CurrentLoopType = "GeneralLoop"
          Configuration.Config.FullScreen = false
          gPresentation(Configuration, Validation, "NoLoop")

          local Present = {
                    Config = {
                              ContinousAutoPlay = {
                                        func = gMoveForward
                              },
                              CircularSwitch = true,
                              StepTime = 0.001
                    },
                    Frame {
                              laptop = Cobj {
                                        filename = "res/models/laptop/laptop.gltf",
                                        camera_control = "EDITOR_MOUSE",
                                        p = vec3(0, 0, 0),
                                        r = vec4(1, 1, 1, 0),
                                        d = vec3(1, 1, 1),
                              }
                    },
                    Frame {
                              laptop = Cobj {
                                        p = vec3(-5, 0, 0),
                                        r = vec4(1, 1, 1, 0),
                                        d = vec3(1, 1, 1),
                              }
                    },
                    Frame {
                              laptop = Cobj {
                                        p = vec3(5, 0, 0),
                                        r = vec4(0, 1, 0, 0),
                                        d = vec3(1, 1, 1),
                              }
                    },
          }
          gPresentation(Present, Validation, CurrentLoopType)

          ClosePresentations()
end
