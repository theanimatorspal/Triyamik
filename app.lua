require "ElementLibrary.Commons.Commons"
require "ElementLibrary.Contexts.GLTFViewer"
require "src.TwoDApplication"

Pr = DefaultPresentation()
-- Pr.Config.FullScreen = true

P = {
          Frame { CButton { t = "HEllO" } },
          Frame { CON.GLTFViewer {} },
          Frame { CButton { t = "BYE BYE" } },
}

Pr:insert(P)
-- gPresentation(Pr, true)

local file = io.popen(
          "powershell -Command \"Add-Type -AssemblyName System.Windows.Forms; $f = New-Object System.Windows.Forms.OpenFileDialog; $f.Filter = 'All Files (*.*)|*.*'; if ($f.ShowDialog() -eq 'OK') { $f.FileName }\"")
local filePath = file:read("*a"):gsub("%s+$", "") -- Read and trim output
file:close()

if filePath ~= "" then
          print("Selected file: " .. filePath)
else
          print("No file selected")
end
