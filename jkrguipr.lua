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
                    FancyStructure {},
                    FancyTitlePage(titlepage),
                    FancyNumbering {},
          },
          Frame {
                    FancyTableOfContents {}
          },
          Frame {
                    s1 = FancySection { t = "Introduction" },
          },
          Frame {
                    s1 = FancySection {},
          },
          Frame {
                    s1 = FancySection {},
          },
          Frame {
                    s1 = FancySection {}
          },
          Frame {
                    s2 = FancySection { t = "Explaination" },
          },
          Frame {
                    s2 = FancySection {}
          },
          Frame {
                    s2 = FancySection {},
                    thank_you = FancyButton { t = "The it is", p = "OUT_OUT" }
          },
          Frame {
                    thank_you = FancyButton { t = "Thank You", p = "CENTER_CENTER" }
          }
}


Pr:insert(P)
Presentation(Pr)
