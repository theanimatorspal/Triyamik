require "ElementLibrary.Procedurals.Require"

PRO.Text3D = function(inText3DTable)
          local t = {
                    t = "001",
                    p = vec3(0),
                    d = vec3(1, 1, 0.1),
                    mode = "SEPARATED", -- "COMBINED"
                    sidedness = "TWOSIDED",
                    callback_foreachchar = nil
          }
          return { PRO_Text3D = Default(inText3DTable, t) }
end

local text3ds = {}
gprocess.PRO_Text3D = function(inPresentation, inValue, inFrameIndex, inElementName)
          local elementName = gUnique(inElementName)
          if not text3ds[elementName] then
                    local elementName_ = elementName .. 0
                    text3ds[elementName] = { { inValue, inFrameIndex, elementName_ } }

                    inValue.renderer_parameter = mat4(vec4(0, 1, 0, 1), vec4(0), vec4(0), vec4(0))
                    gprocess.PRO_Text3Dbase(inPresentation, inValue, inFrameIndex, elementName_)
          else
                    if text3ds[elementName].t ~= inValue.t then
                              text3ds[elementName].t = inValue.t

                              inValue.renderer_parameter = mat4(vec4(0.0, 1, 0.0, 1), vec4(0.0), vec4(0.0), vec4(0.0))

                              -- Here, interpolate
                              -- Create a Text3Dbase element (different elementName_)
                              local elementName_ = elementName .. #text3ds[elementName]
                              text3ds[elementName][#text3ds[elementName] + 1] = { inValue, inFrameIndex, elementName_ }

                              -- new text at current frame (opacity 1)
                              -- new text at previous frame (opacity 0.0)
                              inValue.renderer_parameter = mat4(vec4(0.0, 1, 0.0, 1), vec4(0.0), vec4(0.0), vec4(0.0))
                              gprocess.PRO_Text3Dbase(inPresentation, inValue, inFrameIndex, elementName_)
                              inValue.renderer_parameter = mat4(vec4(0.0, 1, 0.0, 0.0), vec4(0.0), vec4(0.0), vec4(0.0))
                              inValue.r = vec4(0, 1, 0, 360)
                              gprocess.PRO_Text3Dbase(inPresentation, inValue, inFrameIndex - 1, elementName_)

                              -- old text at current frame (opacity 0.0)
                              local eN = text3ds[elementName][#text3ds[elementName] - 1]
                              print(inspect(eN))
                              eN[1].renderer_parameter = mat4(vec4(0.0, 1, 0.0, 0.0), vec4(0.0), vec4(0.0), vec4(0.0))
                              eN[1].r = vec4(0, 1, 0, 360)
                              gprocess.PRO_Text3Dbase(inPresentation, eN[1], inFrameIndex, eN[3])
                    else
                              inValue.renderer_parameter = mat4(vec4(0.0, 1, 0.0, 1), vec4(0.0), vec4(0.0), vec4(0.0))
                              local elementName_ = elementName .. #text3ds[elementName]
                              gprocess.PRO_Text3Dbase(inPresentation, inValue, inFrameIndex,
                                        elementName_)
                    end
          end
end

PRO.Text3Dbase = function(inImageTable)
          local t = {
                    t = "001",
                    p = vec3(0),
                    d = vec3(1, 1, 0.1),
                    mode = "SEPARATED"
          }
          return { PRO_Text3Dbase = Default(inImageTable, t) }
end

local Local = {}
local GetTextCubeGenerator = function(sizex, sizey, sizez, type)
          local c = Jkr.CustomShape3D()
          local v3ds = std_vector_Vertex3D()
          local uis = std_vector_uint()
          local x = sizex;
          local y = sizey;
          local z = sizez;
          local positions = {
                    vec3(-x, -y, z),
                    vec3(x, -y, z),
                    vec3(x, -y, -z),
                    vec3(-x, -y, -z),
                    vec3(-x, y, z),
                    vec3(x, y, z),
                    vec3(x, y, -z),
                    vec3(-x, y, -z),
          }
          local normals = {
                    vec3(0, -1, 0),
                    vec3(0, 1, 0),
                    vec3(-1, 0, 0),
                    vec3(0, 0, 1),
                    vec3(0, 0, -1),
                    vec3(0, 0, 1),
          };

          local uvs = {
                    vec2(1, 1),
                    vec2(0, 1),
                    vec2(0, 0),
                    vec2(1, 0),
          }

          local faceIndices = {
                    { 0, 1, 2, 3 },
                    { 4, 5, 6, 7 },
                    { 0, 1, 5, 4 },
                    { 3, 2, 6, 7 },
                    { 0, 3, 7, 4 },
                    { 1, 2, 6, 5 }
          }
          for i = 1, 6 do
                    for j = 1, 4 do
                              local faceIndex = faceIndices[i][j]
                              local v = Jkr.Vertex3D()
                              v.mPosition = positions[faceIndex + 1]
                              v.mNormal = normals[i]
                              if type == "TWOSIDED" then
                                        if i == 4 or i == 3 then
                                                  v.mUV = uvs[j]
                                        else
                                                  v.mUV = vec2(0, 0)
                                        end
                              elseif type == "FOURSIDED" then
                                        v.mUV = uvs[j]
                              end
                              v.mColor = vec3(1)
                              v3ds:add(v)
                    end
          end
          for i = 1, 6 do
                    uis:add(i * 4)
                    uis:add(i * 4 + 1)
                    uis:add(i * 4 + 2)
                    uis:add(i * 4)
                    uis:add(i * 4 + 2)
                    uis:add(i * 4 + 3)
          end
          c.mVertices = v3ds
          c.mIndices = uis
          return Jkr.Generator(Jkr.Shapes.CustomShape3D, c)
end

gprocess.PRO_Text3Dbase = function(inPresentation, inValue, inFrameIndex, inElementName)
          if not Local.cube_twosided then
                    local Gen = Jkr.Generator(Jkr.Shapes.Cube3D, vec3(1, 1, 1))
                    Gen = GetTextCubeGenerator(1, 1, 1, "TWOSIDED")
                    Local.cube_twosided = gshaper3d:Add(Gen, vec3(0, 0, 0))
          end
          if not Local.cube_foursided then
                    local Gen = Jkr.Generator(Jkr.Shapes.Cube3D, vec3(1, 1, 1))
                    Gen = GetTextCubeGenerator(1, 1, 1, "FOURSIDED")
                    Local.cube_foursided = gshaper3d:Add(Gen, vec3(0, 0, 0))
          end
          if not PRO.Text3D_textShader then
                    local vshader, fshader = Engine.GetAppropriateShader("NORMAL",
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
          if inValue.mode == "SEPARATED" then
                    if not gscreenElements[ElementName] then
                              gscreenElements[ElementName] = {}
                              for i = 1, #inValue.t do
                                        local text = gwid.CreateTextLabel(
                                                  vec3(math.huge, math.huge, gbaseDepth),
                                                  vec3(1),
                                                  gFontMap.Huge,
                                                  string.sub(inValue.t, i, i), nil, true)
                                        gscreenElements[ElementName][#gscreenElements[ElementName] + 1] = text
                              end
                    end
                    local texts = gscreenElements[ElementName]
                    for i = 1, #texts do
                              local p, d, renderer_parameter, r
                              p = vec3(inValue.p.x - inValue.d.x * (i - 1) * 2, inValue.p.y, inValue.p.z)
                              d = inValue.d
                              renderer_parameter = inValue.renderer_parameter
                              r = inValue.r
                              if inValue.callback_foreachchar then
                                        p, d, r, renderer_parameter = inValue.callback_foreachchar(p, d, r,
                                                  renderer_parameter, i,
                                                  #texts)
                              end

                              gprocess.Cobj(inPresentation, Cobj {
                                        load = function()
                                                  local uniform3did = gworld3d:AddUniform3D(Engine.i, gwindow)
                                                  local uniform3d = gworld3d:GetUniform3D(uniform3did)
                                                  uniform3d:Build(Local.Text3D_textShader.simple3d)
                                                  -- print(texts[i], texts[i].mId, texts[i].mId.mImgId)
                                                  Jkr.RegisterShape2DImageToUniform3D(gwid.st.handle,
                                                            uniform3d,
                                                            texts[i].mId.mImgId,
                                                            3)
                                                  local obj = Jkr.Object3D()
                                                  if inValue.sidedness == "TWOSIDED" then
                                                            obj.mId = Local.cube_twosided
                                                  elseif inValue.sidedness == "FOURSIDED" then
                                                            obj.mId = Local.cube_foursided
                                                  end
                                                  obj.mAssociatedUniform = uniform3did
                                                  obj.mAssociatedSimple3D = Local.Text3D_textShader.simple3did
                                                  return { obj }
                                        end,
                                        p = p,
                                        d = d,
                                        renderer_parameter = renderer_parameter,
                                        r = r
                              }.Cobj, inFrameIndex, ElementName .. "threed" .. i)
                    end
          end
          if inValue.mode == "COMBINED" then
                    if not gscreenElements[ElementName] then
                              local text = gwid.CreateTextLabel(
                                        vec3(math.huge, math.huge, gbaseDepth),
                                        vec3(1),
                                        gFontMap.Huge,
                                        inValue.t, nil, true)
                              gscreenElements[ElementName] = text
                    end
                    local texts = gscreenElements[ElementName]
                    gprocess.Cobj(inPresentation, Cobj {
                              load = function()
                                        local uniform3did = gworld3d:AddUniform3D(Engine.i, gwindow)
                                        local uniform3d = gworld3d:GetUniform3D(uniform3did)
                                        uniform3d:Build(Local.Text3D_textShader.simple3d)
                                        -- print(texts[i], texts[i].mId, texts[i].mId.mImgId)
                                        Jkr.RegisterShape2DImageToUniform3D(gwid.st.handle,
                                                  uniform3d,
                                                  texts.mId.mImgId,
                                                  3)
                                        local obj = Jkr.Object3D()
                                        if inValue.sidedness == "TWOSIDED" then
                                                  obj.mId = Local.cube_twosided
                                        elseif inValue.sidedness == "FOURSIDED" then
                                                  obj.mId = Local.cube_foursided
                                        end
                                        obj.mAssociatedUniform = uniform3did
                                        obj.mAssociatedSimple3D = Local.Text3D_textShader.simple3did
                                        return { obj }
                              end,
                              p = inValue.p,
                              d = inValue.d,
                              r = inValue.r,
                              renderer_parameter = inValue.renderer_parameter
                    }.Cobj, inFrameIndex, ElementName .. "threed")
          end
end
