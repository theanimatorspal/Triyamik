require "ElementLibrary.Procedurals.Require"

PRO.Text3D = function(inImageTable)
          local t = {
                    t = "001",
                    p = vec3(50, 50, 1),
                    d = vec3(100, 100, 1),
                    push = PC_Mats(mat4(1.0), mat4(1.0)),
                    mode = "SEPARATED"
          }
          return { PRO_Text3D = Default(inImageTable, t) }
end

local Local = {}
Local.Text3D_textShader = nil
Local.cube = nil
gprocess.PRO_Text3D = function(inPresentation, inValue, inFrameIndex, inElementName)
          if not Local.cube then
                    local Gen = Jkr.Generator(Jkr.Shapes.Cube3D, vec3(1, 4, 0.1))
                    Local.cube = gshaper3d:Add(Gen, vec3(0, 0, 0))
          end
          if not PRO.Text3D_textShader then
                    local vshader, fshader = Engine.GetAppropriateShader("CONSTANT_COLOR",
                              Jkr.CompileContext.Default, nil, nil,
                              nil, nil, { baseColorTexture = true })
                    local simple3did = gworld3d:AddSimple3D(Engine.i, gwindow)
                    local simple3d = gworld3d:GetSimple3D(simple3did)
                    simple3d:CompileEXT(
                              Engine.i,
                              gwindow,
                              "cache/test_shader.glsl",
                              vshader.str,
                              fshader.str,
                              "",
                              false,
                              Jkr.CompileContext.Default
                    )
                    Local.Text3D_textShader = {}
                    Local.Text3D_textShader.simple3did = simple3did
                    Local.Text3D_textShader.simple3d = simple3d
          end

          local ElementName = gUnique(inElementName)
          if not gscreenElements[ElementName] then
                    gscreenElements[ElementName] = {}
                    for i = 1, #inValue.t do
                              local text = gwid.CreateTextLabel(
                                        vec3(math.huge, math.huge, gbaseDepth),
                                        vec3(1),
                                        gFontMap.Huge,
                                        string.sub(inValue.t, i, i))
                              gscreenElements[ElementName][#gscreenElements[ElementName] + 1] = text
                    end
          end

          local p = inValue.p
          local texts = gscreenElements[ElementName]
          for i = 1, #inValue.t do
                    gprocess.Cobj(inPresentation, Cobj {
                              load = function()
                                        local uniform3did = gworld3d:AddUniform3D(Engine.i, gwindow)
                                        local uniform3d = gworld3d:GetUniform3D(uniform3did)
                                        uniform3d:Build(Local.Text3D_textShader.simple3d)
                                        Jkr.RegisterShape2DImageToUniform3D(gwid.st.handle, uniform3d,
                                                  texts[i].mId.mImgId, 3)
                                        local obj = Jkr.Object3D()
                                        obj.mId = Local.cube
                                        obj.mAssociatedUniform = uniform3did
                                        obj.mAssociatedSimple3D = Local.Text3D_textShader.simple3did
                                        return { obj }
                              end,
                              p = vec3(p.x + inValue.d.x, p.y, p.z),
                              d = inValue.d
                    }.Cobj, inFrameIndex, ElementName .. "threed" .. i)
          end
          print(inspect(gFrameKeys))

          local totalframecount = 0
          IterateEachFrame(inPresentation, function(eachFrameIndex, _)
                    if eachFrameIndex >= inFrameIndex then
                              totalframecount = totalframecount + 1
                    end
          end)
end

ExecuteFunctions["*PRO_Text3D*"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
end
