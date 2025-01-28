require "Present.Present"
require "ElementLibrary.Commons.Commons"
PRO = {}

PRO.CompileShaders = function()
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
                    vec4 outC = texture(uBaseColorTexture, vUV);
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
                    local Gen = PRO.GetCubeGenerator(0.5, 0.5, 0.5, "TWOSIDED")
                    PRO.cube_twosided = gshaper3d:Add(Gen, vec3(0, 0, 0))
          end
          if not PRO.cube_foursided then
                    local Gen = PRO.GetCubeGenerator(0.5, 0.5, 0.5, "FOURSIDED")
                    PRO.cube_foursided = gshaper3d:Add(Gen, vec3(0, 0, 0))
          end
          if not PRO.sphere8x8 then
                    local Gen = PRO.GetSphereGenerator(1, 8, 8)
                    PRO.sphere8x8 = gshaper3d:Add(Gen, vec3(0, 0, 0))
          end
          if not PRO.sphere32x32 then
                    local Gen = PRO.GetSphereGenerator(1, 32, 32)
                    PRO.sphere32x32 = gshaper3d:Add(Gen, vec3(0, 0, 0))
          end
end

PRO.GetSphereGenerator = function(radius, segmentsLat, segmentsLong, type)
          local c = Jkr.CustomShape3D()
          local v3ds = std_vector_Vertex3D()
          local uis = std_vector_uint()

          segmentsLat = segmentsLat or 32
          segmentsLong = segmentsLong or 32

          -- South pole
          local v = Jkr.Vertex3D()
          v.mPosition = vec3(0, -radius, 0)
          v.mNormal = vec3(0, -1, 0)
          v.mUV = vec2(0.5, 1)
          v.mColor = vec3(1)
          v3ds:add(v)

          -- Middle vertices
          for i = 1, segmentsLat - 1 do
                    local theta = math.pi * i / segmentsLat
                    local y = math.cos(theta) * radius
                    local r = math.sin(theta) * radius
                    for j = 0, segmentsLong - 1 do
                              local phi = 2 * math.pi * j / segmentsLong
                              local x = math.cos(phi) * r
                              local z = math.sin(phi) * r
                              local v = Jkr.Vertex3D()
                              v.mPosition = vec3(x, y, z)
                              v.mNormal = Jmath.Normalize(vec3(x, y, z))
                              v.mUV = vec2(j / segmentsLong, 1 - i / segmentsLat)
                              v.mColor = vec3(1)
                              v3ds:add(v)
                    end
          end

          -- North pole
          local v = Jkr.Vertex3D()
          v.mPosition = vec3(0, radius, 0)
          v.mNormal = vec3(0, 1, 0)
          v.mUV = vec2(0.5, 0)
          v.mColor = vec3(1)
          v3ds:add(v)

          -- Indices
          local southPoleIndex = 0
          local northPoleIndex = 1 + (segmentsLat - 1) * segmentsLong

          -- Middle triangles
          for i = 0, segmentsLat - 2 do
                    local currentRowStart = 1 + i * segmentsLong
                    local nextRowStart = currentRowStart + segmentsLong
                    for j = 0, segmentsLong - 1 do
                              local nextJ = (j + 1) % segmentsLong
                              uis:add(currentRowStart + j)
                              uis:add(nextRowStart + j)
                              uis:add(nextRowStart + nextJ)
                              uis:add(currentRowStart + j)
                              uis:add(nextRowStart + nextJ)
                              uis:add(currentRowStart + nextJ)
                    end
          end

          -- South pole triangles
          for j = 0, segmentsLong - 1 do
                    local nextJ = (j + 1) % segmentsLong
                    uis:add(southPoleIndex)
                    uis:add(1 + j)
                    uis:add(1 + nextJ)
          end

          -- North pole triangles
          for j = 0, segmentsLong - 1 do
                    local nextJ = (j + 1) % segmentsLong
                    uis:add(northPoleIndex)
                    uis:add(northPoleIndex - segmentsLong + nextJ)
                    uis:add(northPoleIndex - segmentsLong + j)
          end

          c.mVertices = v3ds
          c.mIndices = uis
          return Jkr.Generator(Jkr.Shapes.CustomShape3D, c)
end

PRO.GetCubeGenerator = function(sizex, sizey, sizez, type)
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
                              else
                                        v.mUV = uvs[j]
                              end
                              v.mColor = vec3(1)
                              v3ds:add(v)
                    end
          end
          for i = 1, 6 do
                    local offset = (i - 1) * 4
                    uis:add(offset)
                    uis:add(offset + 1)
                    uis:add(offset + 2)
                    uis:add(offset)
                    uis:add(offset + 2)
                    uis:add(offset + 3)
          end
          c.mVertices = v3ds
          c.mIndices = uis
          return Jkr.Generator(Jkr.Shapes.CustomShape3D, c)
end

PRO.GetCylinderGenerator = function(radius, height, segments, type)
          local c = Jkr.CustomShape3D()
          local v3ds = std_vector_Vertex3D()
          local uis = std_vector_uint()

          local halfHeight = height / 2
          segments = segments or 32

          -- Top circle
          for i = 0, segments - 1 do
                    local angle = 2 * math.pi * i / segments
                    local x = radius * math.cos(angle)
                    local z = radius * math.sin(angle)
                    local v = Jkr.Vertex3D()
                    v.mPosition = vec3(x, halfHeight, z)
                    v.mNormal = vec3(0, 1, 0)
                    v.mUV = vec2(0.5 + 0.5 * x / radius, 0.5 + 0.5 * z / radius)
                    v.mColor = vec3(1)
                    v3ds:add(v)
          end

          -- Bottom circle
          for i = 0, segments - 1 do
                    local angle = 2 * math.pi * i / segments
                    local x = radius * math.cos(angle)
                    local z = radius * math.sin(angle)
                    local v = Jkr.Vertex3D()
                    v.mPosition = vec3(x, -halfHeight, z)
                    v.mNormal = vec3(0, -1, 0)
                    v.mUV = vec2(0.5 + 0.5 * x / radius, 0.5 + 0.5 * z / radius)
                    v.mColor = vec3(1)
                    v3ds:add(v)
          end

          -- Side vertices
          local sideStart = #v3ds
          for i = 0, segments - 1 do
                    local angle = 2 * math.pi * i / segments
                    local normal = vec3(math.cos(angle), 0, math.sin(angle))
                    local vTop = Jkr.Vertex3D()
                    vTop.mPosition = vec3(normal.x * radius, halfHeight, normal.z * radius)
                    vTop.mNormal = normal
                    vTop.mUV = vec2(i / segments, 1)
                    vTop.mColor = vec3(1)
                    v3ds:add(vTop)

                    local vBottom = Jkr.Vertex3D()
                    vBottom.mPosition = vec3(normal.x * radius, -halfHeight, normal.z * radius)
                    vBottom.mNormal = normal
                    vBottom.mUV = vec2(i / segments, 0)
                    vBottom.mColor = vec3(1)
                    v3ds:add(vBottom)
          end

          -- Top and bottom centers
          local topCenter = Jkr.Vertex3D()
          topCenter.mPosition = vec3(0, halfHeight, 0)
          topCenter.mNormal = vec3(0, 1, 0)
          topCenter.mUV = vec2(0.5, 0.5)
          topCenter.mColor = vec3(1)
          v3ds:add(topCenter)

          local bottomCenter = Jkr.Vertex3D()
          bottomCenter.mPosition = vec3(0, -halfHeight, 0)
          bottomCenter.mNormal = vec3(0, -1, 0)
          bottomCenter.mUV = vec2(0.5, 0.5)
          bottomCenter.mColor = vec3(1)
          v3ds:add(bottomCenter)

          -- Top and bottom indices
          local topStart = 0
          local bottomStart = segments
          local topCenterIndex = segments * 2 + 2 * segments
          local bottomCenterIndex = topCenterIndex + 1

          for i = 0, segments - 1 do
                    local nextI = (i + 1) % segments
                    -- Top face
                    uis:add(topCenterIndex)
                    uis:add(topStart + i)
                    uis:add(topStart + nextI)
                    -- Bottom face
                    uis:add(bottomCenterIndex)
                    uis:add(bottomStart + nextI)
                    uis:add(bottomStart + i)
          end

          -- Side indices
          for i = 0, segments - 1 do
                    local currentTop = sideStart + 2 * i
                    local currentBottom = currentTop + 1
                    local nextTop = sideStart + 2 * ((i + 1) % segments)
                    local nextBottom = nextTop + 1

                    uis:add(currentTop)
                    uis:add(currentBottom)
                    uis:add(nextBottom)
                    uis:add(currentTop)
                    uis:add(nextBottom)
                    uis:add(nextTop)
          end

          c.mVertices = v3ds
          c.mIndices = uis
          return Jkr.Generator(Jkr.Shapes.CustomShape3D, c)
end

PRO.GetGearGenerator = function(innerRadius, outerRadius, numTeeth, toothDepth, thickness, type)
          local c = Jkr.CustomShape3D()
          local v3ds = std_vector_Vertex3D()
          local uis = std_vector_uint()

          local numPoints = numTeeth * 2
          local angleStep = 2 * math.pi / numPoints

          -- Front face
          for i = 0, numPoints - 1 do
                    local radius = i % 2 == 0 and outerRadius or innerRadius
                    local angle = i * angleStep
                    local x = radius * math.cos(angle)
                    local y = radius * math.sin(angle)
                    local v = Jkr.Vertex3D()
                    v.mPosition = vec3(x, y, 0)
                    v.mNormal = vec3(0, 0, 1)
                    v.mUV = vec2(0.5 + x / (2 * outerRadius), 0.5 + y / (2 * outerRadius))
                    v.mColor = vec3(1)
                    v3ds:add(v)
          end

          -- Back face
          for i = 0, numPoints - 1 do
                    local radius = i % 2 == 0 and outerRadius or innerRadius
                    local angle = i * angleStep
                    local x = radius * math.cos(angle)
                    local y = radius * math.sin(angle)
                    local v = Jkr.Vertex3D()
                    v.mPosition = vec3(x, y, thickness)
                    v.mNormal = vec3(0, 0, -1)
                    v.mUV = vec2(0.5 + x / (2 * outerRadius), 0.5 + y / (2 * outerRadius))
                    v.mColor = vec3(1)
                    v3ds:add(v)
          end

          -- Front and back centers
          local frontCenter = Jkr.Vertex3D()
          frontCenter.mPosition = vec3(0, 0, 0)
          frontCenter.mNormal = vec3(0, 0, 1)
          frontCenter.mUV = vec2(0.5, 0.5)
          frontCenter.mColor = vec3(1)
          v3ds:add(frontCenter)

          local backCenter = Jkr.Vertex3D()
          backCenter.mPosition = vec3(0, 0, thickness)
          backCenter.mNormal = vec3(0, 0, -1)
          backCenter.mUV = vec2(0.5, 0.5)
          backCenter.mColor = vec3(1)
          v3ds:add(backCenter)

          -- Front and back indices
          local frontStart = 0
          local backStart = numPoints
          local frontCenterIndex = numPoints * 2
          local backCenterIndex = frontCenterIndex + 1

          for i = 0, numPoints - 1 do
                    local nextI = (i + 1) % numPoints
                    -- Front face
                    uis:add(frontCenterIndex)
                    uis:add(frontStart + i)
                    uis:add(frontStart + nextI)
                    -- Back face
                    uis:add(backCenterIndex)
                    uis:add(backStart + nextI)
                    uis:add(backStart + i)
          end

          -- Side faces
          for i = 0, numPoints - 1 do
                    local nextI = (i + 1) % numPoints
                    local currentFront = frontStart + i
                    local currentBack = backStart + i
                    local nextFront = frontStart + nextI
                    local nextBack = backStart + nextI

                    -- Calculate normal
                    local edge = v3ds[nextFront + 1].mPosition - v3ds[currentFront + 1].mPosition
                    local normal = Jmath.Normalize(vec3(-edge.y, edge.x, 0))

                    -- Side vertices
                    local v1 = Jkr.Vertex3D()
                    v1.mPosition = v3ds[currentFront].mPosition
                    v1.mNormal = normal
                    v1.mUV = vec2(i / numPoints, 0)
                    v1.mColor = vec3(1)
                    v3ds:add(v1)

                    local v2 = Jkr.Vertex3D()
                    v2.mPosition = v3ds[currentBack].mPosition
                    v2.mNormal = normal
                    v2.mUV = vec2(i / numPoints, 1)
                    v2.mColor = vec3(1)
                    v3ds:add(v2)

                    local v3 = Jkr.Vertex3D()
                    v3.mPosition = v3ds[nextBack].mPosition
                    v3.mNormal = normal
                    v3.mUV = vec2((i + 1) / numPoints, 1)
                    v3.mColor = vec3(1)
                    v3ds:add(v3)

                    local v4 = Jkr.Vertex3D()
                    v4.mPosition = v3ds[nextFront].mPosition
                    v4.mNormal = normal
                    v4.mUV = vec2((i + 1) / numPoints, 0)
                    v4.mColor = vec3(1)
                    v3ds:add(v4)

                    local sideStart = #v3ds - 4
                    uis:add(sideStart)
                    uis:add(sideStart + 1)
                    uis:add(sideStart + 2)
                    uis:add(sideStart)
                    uis:add(sideStart + 2)
                    uis:add(sideStart + 3)
          end

          c.mVertices = v3ds
          c.mIndices = uis
          return Jkr.Generator(Jkr.Shapes.CustomShape3D, c)
end
