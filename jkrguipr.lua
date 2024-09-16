require "ElementLibrary.Fancy.Fancy"
Pr = DefaultPresentation()

local titlepage = {
          t = "Triyamik",
          st = "A Graphics Engine based on JkrGUI",
          names = {
                    "077bct024 Darshan Koirala",
                    "077bct022 Bishal Jaiswal",
                    "077bct027 Dipesh Regmi",
          }
}

P = {
          Frame {},
          Frame {
                    FancyTitlePage(titlepage)
          }
}


Pr:insert(P)
Presentation(Pr)
