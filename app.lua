require "Present.Present"

Presentation {
          Title = "Introduction to JkrGUI Presentation Engine",
          Date = "18th Jeshtha, 2020",
          Author = { "Darshan Koirala" },
          Config = {
                    Font = {
                              Tiny = { "res/fonts/font.ttf", 10 },     -- \tiny
                              Small = { "res/fonts/font.ttf", 12 },    -- \small
                              Normal = { "res/fonts/font.ttf", 16 },   -- \normalsize
                              large = { "res/fonts/font.ttf", 20 },    -- \large
                              Large = { "res/fonts/font.ttf", 24 },    -- \Large
                              huge = { "res/fonts/font.ttf", 28 },     -- \huge
                              Huge = { "res/fonts/font.ttf", 32 },     -- \Huge
                              gigantic = { "res/fonts/font.ttf", 38 }, -- \gigantic
                              Gigantic = { "res/fonts/font.ttf", 42 }, -- \Gigantic
                    }
          },
          Animation {
                    Interpolation = "Constant",
          },
          -- Frame { TitlePage {} },
          Frame {
                    Title = "Introduction",
                    enum = Enumerate {
                              Item "The Best Presentation Engine",
                              Item "I love this Presenation Engine",
                              Item "You will love this too",
                              Item "Thank You",
                    },
                    Tex1 = Text { t = "Hello", f = "Normal", p = "CENTER", c = vec4(1, 0, 0, 1) }
          },
          Frame {
                    Tex1 = Text { t = "Hello", f = "Normal", p = "CENTER", c = vec4(0, 1, 0, 1) }
          }
}
