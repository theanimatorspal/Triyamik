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
                    FancyTitlePage(titlepage),
                    FancyNumbering {},
                    FancyStructure {},
          },
          Frame {
                    -- s1 = FancySection { t = "Introduction" },
                    FancyTitlePage { act = "structure" }
          },
          Frame {
                    s1 = FancySection { t = "Introduction" },
          },
          Frame {
                    s1 = FancySection {},
          },
          Frame {
                    s2 = FancySection { t = "Tasks Completed" }
          },
          Frame {
                    s2 = FancySection {}
          },
          Frame {
                    s2 = FancySection {}
          },
          Frame {
                    s2 = FancySection {}
          },
          Frame {
                    s3 = FancySection { t = "Demonstration" },
          },
          Frame {
                    s3 = FancySection {},
          },
          Frame {
                    s4 = FancySection { t = "Remaining Works" },
          },
          Frame {
                    s4 = FancySection {}
          },
          Frame {
                    thank_you = Text { t = "Thank You", p = "CENTER_CENTER", f = "Huge", c = vec4(1, 1, 1, 0) }
          },
          Frame {
                    thank_you = Text { t = "Thank You, Any Questions ?", p = "CENTER_CENTER", f = "Huge", c = vec4(0, 0, 0, 1) }
          }
}

Pr:insert(P)
Presentation(Pr)

-- print(inspect(gFrameKeys))
