require "Present.Present"


Pr = DefaultPresentation()

Pr:insert(
          Frame {
                    Plot = Shader({}, "Plotter"),
          })

Pr:insert(Frame {
          EnableNumbering {},
          btext1 = ButtonText {
                    t = "button1",
                    p = "BOTTOM_LEFT",
                    onclick = function()
                              gstate:PushOneTime(Jkr.CreateUpdatable(function()
                                        print("Hello World")
                                        gstate.__backward()
                              end), 1)
                    end
          },
          text22 = Text { p = "CENTER_RIGHT", t = "I lvoe you" },
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
                    text22 = Text { p = "TOP_CENTER", t = "I hate you" },
                    text1 = Text { t = "My name is Darshan Koirala", p = "CENTER_LEFT" },
                    cimg = CImage {
                              shader = "Plot",
                              p = "OUT_OUT"
                    }
          }
);


-- CreateEngineHandles()
-- ProcessFrames(Pr)
-- print(inspect(Pr))
Presentation(Pr)
-- print(inspect(Pr))
