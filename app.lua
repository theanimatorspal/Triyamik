require "ElementLibrary.Fancy.Fancy"
require "ElementLibrary.Contexts.GLTFViewer"
require "src.TwoDApplication"

Pr = DefaultPresentation()
-- Pr.Config.FullScreen = true

P = {
          Frame { FancyButton { t = "HEllO" } },
          Frame { CON.GLTFViewer {} },
          Frame { FancyButton { t = "BYE BYE" } },
}

Pr:insert(P)
gPresentation(Pr, true)
