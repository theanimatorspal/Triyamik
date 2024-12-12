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
          local runApp = true
          local bc = vec4(1, 0.5, 0, 0.5)
          local c = vec4(0, 0, 0, 1)
          local Configuration = gDefaultConfiguration()
          local Validation = false
          local CurrentLoopType = "GeneralLoop"
          Configuration.Config.FullScreen = false
          gPresentation(Configuration, Validation, "NoLoop")

          local Present = {
                    Frame {
                              obj = Cobj {
                                        filename = "C:/Users/sansk/Downloads/s3mini_lowpoly_free.glb",
                                        camera_control = "FLYCAM_KEYBOARD"
                              }
                    }
          }
          gPresentation(Present, Validation, CurrentLoopType)
end
