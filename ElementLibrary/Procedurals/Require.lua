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
end
