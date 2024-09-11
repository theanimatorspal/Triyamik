-- repl.Window(0)
-- repl.WidgetRenderer()
-- f = wid.CreateFont("res/fonts/font.ttf", 32)
-- t = wid.CreateTextLabel(vec3(100, 100, 1), vec3(0), f, "Hello", vec4(1, 0, 0, 1))
-- b = wid.CreateButton(vec3(100, 100, 1), vec3(0), function() print("hello") end, true)
require "Present.Present"


Pr = DefaultPresentation()

Pr:insert(
          Frame {
                    Plot = Shader({}, "Plotter")
          })

Pr:insert(Frame {
          btext1 = ButtonText {
                    t = "button1",
                    p = "BOTTOM_RIGHT",
                    onclick = function()
                              gstate:PushOneTime(Jkr.CreateUpdatable(function()
                                        print("Hello World")
                                        gstate.__backward()
                              end), 1)
                    end
          },
          text1 = Text { p = "CENTER_CENTER" },
          cimg = CImage {
                    shader = "Plot",
                    shader_parameters = {
                              p1 = vec4(0.0, 0.0, 0.3, 1),
                              p2 = vec4(1),
                              p3 = vec4(10.0, 0, 0, 0)
                    },
                    p = vec3(100, 100, 900)
          }
})
Pr:insert(
          Frame {
                    text1 = Text { t = "My name is Darshan Koirala", p = "CENTER_LEFT" },
                    cimg = CImage {
                              shader = "Plot",
                              p = "OUT_OUT"
                    }
          }
);

Presentation(Pr)
