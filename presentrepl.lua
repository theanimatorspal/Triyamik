require "Present.Present"
require "ElementLibrary.Fancy.Fancy"

Pr = DefaultPresentation()

Pr:insert({
          Frame {},
          Frame {
                    gltf = FancyGLTF {
                              filename = "res/models/CesiumManBlend/CesiumMan.gltf"
                    },
                    skinning = true,
                    animation = vec2(0, 0.1)
          },

          Frame {
                    gltf = FancyGLTF {
                              filename = "res/models/CesiumManBlend/CesiumMan.gltf",
                              r = vec4(1, 0, 0, -90),
                              d = vec3(2, 2, 2)
                    },
                    skinning = true,
                    animation = vec2(0, 0.1)
          }
}
)

Presentation(Pr)
