require "ElementLibrary.Procedurals.Image"

Pr = DefaultPresentation()

Pr:insert({

          Frame {
                    Image = PRO.Image {
                              file = "res/images/rect.png",
                              filter = "BLUR",
                              push = PC_Mats(mat4(
                                        vec4(0),
                                        vec4(0),
                                        vec4(0),
                                        vec4(19, 19, 10, 3)
                              ), mat4(0)),
                              d = vec3(500, 500, 1)
                    }
          },
})


gPresentation(Pr, true)
