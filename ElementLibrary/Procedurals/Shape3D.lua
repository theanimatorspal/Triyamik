require "ElementLibrary.Procedurals.Require"

PRO.Shape = function(inTable)
          local t = {
                    type = "CUBE3D", -- "GLTF" | "SPHERE3D"
                    compute_texture = -1,
                    p = vec3(0),
                    d = vec3(1),
                    r = vec4(1, 1, 1, 1),
                    -- renderer_parameter = mat4(0),
                    renderer_parameter = mat4(vec4(1, 0, 0, 1), vec4(0), vec4(0), vec4(0)),
                    sidedness = "FOURSIDED"
          }
          return { PRO_Shape = Default(inTable, t) }
end

gprocess.PRO_Shape = function(inPresentation, inValue, inFrameIndex, inElementName)
          if not PRO.cube_ShowImageShader then
                    local vshader, fshader = Engine.GetAppropriateShader("NORMAL",
                              Jkr.CompileContext.Default, nil, nil,
                              nil, nil, { baseColorTexture = true })
                    fshader = Basics.GetConstantFragmentHeader()
                        .Append "layout(set = 0, binding = 32) uniform sampler2DArray shadowMap;\n"
                        .uSampler2D(3, "uBaseColorTexture")
                    PBR.PreCalcImages(fshader)
                    fshader.GlslMainBegin()
                        .Append [[
                    vec4 color = Push.m2[0];
                    vec4 background_color = Push.m2[1];
                    vec4 outC = texture(uBaseColorTexture, vUV) + background_color;
                    outFragColor = vec4(
                              (outC.x) * color.x,
                              (outC.y) * color.y,
                              (outC.z) * color.z,
                              (outC.w) * color.w
                    );
                    if(outC.w == 0.00) {
                        outFragColor = background_color;
                    }
                    ]]
                        .GlslMainEnd()

                    local simple3did = gworld3d:AddSimple3D(Engine.i, gwindow)
                    local simple3d = gworld3d:GetSimple3D(simple3did)
                    simple3d:CompileEXT(
                              Engine.i,
                              gwindow,
                              "cache/3d_background_color_shader.glsl",
                              vshader.str,
                              fshader.str,
                              "",
                              false,
                              Jkr.CompileContext.Default
                    )
                    PRO.cube_ShowImageShader = {}
                    PRO.cube_ShowImageShader.simple3did = simple3did
                    PRO.cube_ShowImageShader.simple3d = simple3d
          end
          if not PRO.cube_twosided then
                    local Gen = Jkr.Generator(Jkr.Shapes.Cube3D, vec3(1, 1, 1))
                    Gen = PRO.GetCubeGenerator(1, 1, 1, "TWOSIDED")
                    PRO.cube_twosided = gshaper3d:Add(Gen, vec3(0, 0, 0))
          end
          if not PRO.cube_foursided then
                    local Gen = Jkr.Generator(Jkr.Shapes.Cube3D, vec3(1, 1, 1))
                    Gen = PRO.GetCubeGenerator(1, 1, 1, "FOURSIDED")
                    PRO.cube_foursided = gshaper3d:Add(Gen, vec3(0, 0, 0))
          end

          local elementName = gUnique(inElementName)
          local p = inValue.p
          local d = inValue.d
          local r = inValue.r
          local compute_texture = inValue.compute_texture
          local renderer_parameter = inValue.renderer_parameter
          if inValue.type == "CUBE3D" then
                    if compute_texture ~= -1 then
                              local computeImages, computePainters = CComputeImagesGet()
                              local element = computeImages[compute_texture]
                              gprocess.Cobj(inPresentation, Cobj {
                                        load = function()
                                                  local uniform3did = gworld3d:AddUniform3D(Engine.i, gwindow)
                                                  local uniform3d = gworld3d:GetUniform3D(uniform3did)
                                                  uniform3d:Build(PRO.cube_ShowImageShader.simple3d)

                                                  Jkr.RegisterShape2DImageToUniform3D(
                                                            gwid.s.handle,
                                                            uniform3d,
                                                            element.sampled_image.mId,
                                                            3
                                                  )
                                                  -- Jkr.RegisterShape2DImageToUniform3D(gwid.st.handle,
                                                  --           uniform3d,
                                                  --           texts[i].mId.mImgId,
                                                  --           3)

                                                  local obj = Jkr.Object3D()
                                                  if inValue.sidedness == "TWOSIDED" then
                                                            obj.mId = PRO.cube_twosided
                                                  elseif inValue.sidedness == "FOURSIDED" then
                                                            obj.mId = PRO.cube_foursided
                                                  end
                                                  obj.mAssociatedUniform = uniform3did
                                                  obj.mAssociatedSimple3D = PRO.cube_ShowImageShader.simple3did
                                                  return { obj }
                                        end,
                                        p = p,
                                        d = d,
                                        renderer_parameter = renderer_parameter,
                                        r = r,
                                        camera_control = "EDITOR_MOUSE",
                              }.Cobj, inFrameIndex, elementName)
                    end
          end
end
