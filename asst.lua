require "ElementLibrary.Procedurals.Image"

Pr = DefaultPresentation()

Pr:insert({

          Frame {
                    Image = PRO.Image {
                              file = "res/images/tiger.jpg",
                              filter = "BLUR",
                              push = PC_Mats(mat4(
                                        vec4(0),
                                        vec4(0),
                                        vec4(0),
                                        vec4(15, 15, 50, 3)
                              ), mat4(0)),
                              d = vec3(500, 500, 1)
                    }
          },
})


gPresentation(Pr, true)
