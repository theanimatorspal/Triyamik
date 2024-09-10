-- repl.Window(0)
-- repl.WidgetRenderer()
-- f = wid.CreateFont("res/fonts/font.ttf", 32)
-- t = wid.CreateTextLabel(vec3(100, 100, 1), vec3(0), f, "Hello", vec4(1, 0, 0, 1))
-- b = wid.CreateButton(vec3(100, 100, 1), vec3(0), function() print("hello") end, true)
require "Present.Present"


Pr = DefaultPresentation()
Pr.__statebuf = Jkr.CreateCallBuffers()
PresentationEventFunction = function(inJumpToFrame,
                                     inDirection,
                                     shouldRun,
                                     int,
                                     inanimate)
          Pr.__statebuf.__forward = function()
                    inJumpToFrame = inJumpToFrame + 1
          end
          Pr.__statebuf.__backward = function()
                    inJumpToFrame = inJumpToFrame + 1
          end
          Pr.__statebuf:Update()
          return inJumpToFrame, inDirection, shouldRun, int, inanimate
end

Pr:insert(
          Frame {
                    Plot = Shader({}, "Plotter")
          })
Pr:insert(Frame {
          btext1 = ButtonText {
                    t = "button1",
                    p = "BOTTOM_RIGHT",
                    onclick = function()
                              Pr.__statebuf:PushOneTime(Jkr.CreateUpdatable(function()
                                        print("Hello World")
                                        Pr.__statebuf.__backward()
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
                    text1 = Text { p = "CENTER_LEFT" },
                    cimg = CImage {
                              shader = "Plot",
                              p = "CENTER_LEFT"
                    }
          }
);

Presentation(Pr)
