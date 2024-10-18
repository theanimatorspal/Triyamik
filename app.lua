require "ElementLibrary.Fancy.Fancy"
require "src.TwoDApplication"
Pr = DefaultPresentation()
-- Pr.Config.FullScreen = true

P = {
          Frame { FancyButton { t = "HEllO" } },
          Frame { TwoDApplication {} },
          Frame { FancyButton { t = "BYE BYE" } },
}

Pr:insert(P)
gPresentation(Pr, true)
