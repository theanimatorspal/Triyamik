require "Present.Present"
require "ElementLibrary.Commons.Commons"
PRO = {}
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
