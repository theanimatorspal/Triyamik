require "ElementLibrary.Commons.Commons"
-- require "ElementLibrary.Procedurals.Procedurals"

do
          local Configuration = gGetPresentationWithDefaultConfiguration()
          local Validation = false
          local CurrentLoopType = "GeneralLoop"
          Configuration.Config.FullScreen = false
          Configuration.Config.StepTime = 0.001
          gPresentation(Configuration, Validation, "NoLoop")

          local Generate = function(inT)
                    local t = {}
                    for i = 1, 5 * 5 do
                              t[#t + 1] = inT
                    end
                    return t
          end
          local Present = {
                    -- Config = {
                    -- ContinousAutoPlay = {
                    --           func = gMoveForward
                    -- },
                    -- CircularSwitch = true,
                    -- StepTime = 0.001,
                    -- InterpolationType = "LINEAR"
                    -- },
                    -- Frame {
                    --           CAndroid {},
                    -- },
                    -- Frame {
                    --           comp = CComputeImage {
                    --                     mat1 = mat4(
                    --                               vec4(30, 10, 50, 20),
                    --                               vec4(1, 0, 0, 1),
                    --                               vec4(3),
                    --                               vec4(1)
                    --                     ),
                    --                     mat2 = Jmath.GetIdentityMatrix4x4()
                    --           }
                    -- }
                    -- Frame {
                    --           text = PRO.Text3D_group {
                    --                     each_color = vec4(1),
                    --                     background_color = vec4(0, 0, 0, 1),
                    --                     each_d = vec3(0.3, 0.1, 2),
                    --                     type = "UNIFIED",
                    --                     texts = Generate("20x")
                    --           },
                    --           PRO.Camera3D {
                    --                     fov = 1.0,
                    --                     type = "ORTHO"
                    --           }
                    -- },
                    -- Frame {
                    --           text = PRO.Text3D_group {
                    --                     each_d = vec3(0.3, 0.1, 0.001),
                    --                     type = "GRID2D",
                    --                     texts = Generate("20x"),
                    --           },
                    --           PRO.Camera3D {
                    --                     fov = 45.0,
                    --                     -- type = "ORTHO"
                    --           }
                    -- },
                    -- Frame {
                    --           text = PRO.Text3D_group {
                    --                     p = vec3(0, 0, 2),
                    --                     each_color = vec4(1, 1, 1, 1),
                    --                     each_d = vec3(0.5, 0.5, 0.001),
                    --                     type = "CIRCLE2D",
                    --                     background_color = vec4(1, 0, 0, 1),
                    --                     texts = Generate("20x")
                    --           },
                    --           PRO.Camera3D {
                    --                     fov = 45.0,
                    --                     -- type = "ORTHO"
                    --           }
                    -- }
                    -- Frame {
                    --           text = PRO.Text3D_group {
                    --                     type = "GRID2D",
                    --           }
                    -- },
                    -- Frame {
                    --           text = PRO.Text3D_group {
                    --                     texts = Generate("X"),
                    --                     each_d = vec3(0.1, 0.1, 0.00001)
                    --           },
                    --           PRO.Camera3D {
                    --                     fov = 45.0
                    --           }
                    -- },
                    -- Frame {
                    --           CTest {}
                    -- }
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
                    --                               local vshader, fshader = Engine.GetAppropriateShader("NORMAL",
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
                    --                               test_cube.mId                 = test_cubeid
                    --                               test_cube.mAssociatedSimple3D = simple3did
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
                    --                     renderer = "PBR_SHADOW",
                    --                     shadows = true,
                    --                     -- renderer = "PBR",
                    --                     p = vec3(0, 0, 0),
                    --                     r = vec4(1, 1, 1, 0),
                    --                     d = vec3(1, 1, 1),
                    --                     world = "fuck_it_shit",
                    --                     renderer_parameter = mat4(vec4(0), vec4(0), vec4(0), vec4(1.5, 11.2, 1 / 2.2, 1))
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
          -- print(inspect(gFrameKeys))

          ClosePresentations()
end
