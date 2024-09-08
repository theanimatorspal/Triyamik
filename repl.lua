-- repl.Window(0)
-- repl.WidgetRenderer()
-- f = wid.CreateFont("res/fonts/font.ttf", 32)
-- t = wid.CreateTextLabel(vec3(100, 100, 1), vec3(0), f, "Hello", vec4(1, 0, 0, 1))

require "Present.Present"

Pr = DefaultPresentation()

Pr:insert(
          Frame {
                    Plot = Shader {
                              cs = Plotter()
                    }
          }
)

Pr:insert(
          Frame {
                    cimg = CImage {
                              shader = "Plot"
                    }
          }
)
