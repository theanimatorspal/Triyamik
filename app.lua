require "ElementLibrary.Commons.Commons"
do
          local Configuration = gDefaultConfiguration()
          local Validation = false
          local CurrentLoopType = "GeneralLoop"
          Configuration.Config.FullScreen = false
          gPresentation(Configuration, Validation, "NoLoop")

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
                              laptop = Cobj {
                                        filename = "res/models/laptop/laptop.gltf",
                                        camera_control = "EDITOR_MOUSE",
                                        p = vec3(0, 0, 0),
                                        r = vec4(1, 1, 1, 0),
                                        d = vec3(1, 1, 1),
                                        world = "default"
                              }
                    },
                    Frame {
                              fuck = Cobj {
                                        filename = "res/models/sponza-gltf-pbr/sponza-gltf-pbr/sponza.glb",
                                        hdr_filename = "res/images/lakeside.hdr",
                                        camera_control = "EDITOR_MOUSE",
                                        renderer = "CONSTANT_COLOR",
                                        p = vec3(0, 0, 0),
                                        r = vec4(1, 1, 1, 0),
                                        d = vec3(1, 1, 1),
                                        world = "fuck_world"
                              }
                    },
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
