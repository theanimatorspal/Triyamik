require "ElementLibrary.Procedurals.Image"
require "ElementLibrary.Procedurals.Object"
require "ElementLibrary.common.common"

Pr = gGetPresentationWithDefaultConfiguration()

Pr:insert({
          -- Frame {
          --           Image = PRO.Image {
          --                     file = "res/images/rect.png",
          --                     filter = "BLUR",
          --                     push = PC_Mats(mat4(
          --                               vec4(0),
          --                               vec4(0),
          --                               vec4(0),
          --                               vec4(19, 19, 10, 3)
          --                     ), mat4(0)),
          --                     d = vec3(500, 500, 1)
          --           }
          -- },
          Frame {
                    gltf = CGLTF {
                              -- filename = "res/models/Lantern/Lantern.gltf",
                              filename = "C:/Users/sansk/OneDrive/Desktop/PBR/res/models/sponza-gltf-pbr/sponza-gltf-pbr/sponza.glb",
                              -- filename = "C:/Users/sansk/OneDrive/Documents/check.glb",
                              camera_control = "FLYCAM_KEYBOARD"
                    }
                    -- Three = Object {},
          },
          -- Frame {
          -- gltf = commonGLTF {
          --           r = vec4(0, 0, 1, 180),
          --           camera_control = "FLYCAM_KEYBOARD"
          -- }
          -- }
})

gPresentation(Pr, false)
