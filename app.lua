require "ElementLibrary.Commons.Commons"
do
          local Configuration = gDefaultConfiguration()
          local Validation = false
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
                    --           Cobj {
                    --                     camera_control = "EDITOR_MOUSE",
                    --                     load = function()
                    --                               local text = gwid.CreateTextLabel(
                    --                                         vec3(math.huge, math.huge, gbaseDepth),
                    --                                         vec3(1),
                    --                                         gFontMap.Huge,
                    --                                         "महामूर्ख")
                    --                               local Gen = Jkr.Generator(Jkr.Shapes.Cube3D, vec3(1, 4, 0.1))
                    --                               local test_cubeid = gshaper3d:Add(Gen, vec3(0, 0, 0))
                    --                               local vshader, fshader = Engine.GetAppropriateShader("CONSTANT_COLOR",
                    --                                         Jkr.CompileContext.Default, nil, nil,
                    --                                         nil, nil, { baseColorTexture = true })
                    --                               local simple3did = gworld3d:AddSimple3D(Engine.i, gwindow)
                    --                               local simple3d = gworld3d:GetSimple3D(simple3did)
                    --                               local uniform3did = gworld3d:AddUniform3D(Engine.i, gwindow)
                    --                               local uniform3d = gworld3d:GetUniform3D(uniform3did)

                    --                               simple3d:CompileEXT(
                    --                                         Engine.i,
                    --                                         gwindow,
                    --                                         "cache/test_shader.glsl",
                    --                                         vshader.Print().str,
                    --                                         fshader.Print().str,
                    --                                         "",
                    --                                         false,
                    --                                         Jkr.CompileContext.Default
                    --                               )

                    --                               uniform3d:Build(simple3d)
                    --                               Jkr.RegisterShape2DImageToUniform3D(gwid.st.handle, uniform3d,
                    --                                         text.mId.mImgId, 3)

                    --                               local test_cube               = Jkr.Object3D()
                    --                               test_cube.mAssociatedSimple3D = simple3did
                    --                               test_cube.mId                 = test_cubeid
                    --                               test_cube.mAssociatedUniform  = uniform3did

                    --                               return { test_cube }
                    --                     end,
                    --                     renderer_parameter = mat4(vec4(1, 0, 0, 1), vec4(0), vec4(0), vec4(0))
                    --           }
                    -- },
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
