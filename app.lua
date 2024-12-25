require "ElementLibrary.Commons.Commons"
do
          local Configuration = gDefaultConfiguration()
          local Validation = true
          local CurrentLoopType = "GeneralLoop"
          Configuration.Config.FullScreen = false
          gPresentation(Configuration, Validation, "NoLoop")
          gwindow:BuildShadowPass()

          local Present = {
                    -- Config = {
                    -- ContinousAutoPlay = {
                    --           func = gMoveForward
                    -- },
                    -- CircularSwitch = true,
                    -- StepTime = 0.001,
                    -- InterpolationType = "LINEAR"
                    -- },
                    Frame {
                              CAndroid {},
                    },
                    Frame {
                              CTest {}
                    }
                    -- Frame {
                    --           laptop = Cobj {
                    --                     filename = "res/models/laptop/laptop.gltf",
                    --                     camera_control = "EDITOR_MOUSE",
                    --                     hdr_filename = "res/images/lakeside.hdr",
                    --                     renderer = "CONSTANT_COLOR",
                    --                     p = vec3(0, 0, 0),
                    --                     r = vec4(1, 1, 1, 0),
                    --                     d = vec3(1, 1, 1),
                    --                     world = "default"
                    --           }
                    -- },
                    -- Frame {
                    --           fuck = Cobj {
                    --                     filename = "res/models/DamagedHelmet/DamagedHelmet.gltf",
                    --                     hdr_filename = "res/images/warm.hdr",
                    --                     camera_control = "EDITOR_MOUSE",
                    --                     renderer = "PBR",
                    --                     p = vec3(0, 0, 0),
                    --                     r = vec4(1, 1, 1, 0),
                    --                     d = vec3(1, 1, 1),
                    --                     world = "fuck_world",
                    --                     renderer_parameter = mat4(vec4(0), vec4(0), vec4(0), vec4(1, 11.2, 1 / 2.2, 1))
                    --           }
                    -- },
                    -- Frame {
                    --           fuck = Cobj {
                    --                     filename = "res/models/sponza-gltf-pbr/sponza-gltf-pbr/sponza.glb",
                    --                     hdr_filename = "res/images/warm.hdr",
                    --                     camera_control = "EDITOR_MOUSE",
                    --                     renderer = "PBR",
                    --                     p = vec3(0, 0, 0),
                    --                     r = vec4(1, 1, 1, 0),
                    --                     d = vec3(1, 1, 1),
                    --                     world = "fuck_world",
                    --                     renderer_parameter = mat4(vec4(0), vec4(0), vec4(0), vec4(1, 11.2, 1 / 2.2, 1))
                    --           }
                    -- },
                    -- Frame {
                    --           img = CComputeImage {
                    --                     cd = vec3(640, 480, 1),
                    --                     d = vec3(1920, 1080, 1)
                    --           }
                    -- }
          }
          gPresentation(Present, Validation, CurrentLoopType)

          ClosePresentations()
end
