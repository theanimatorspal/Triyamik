require "JkrGUIv2.Engine.Shader"

local lerp = Jmath.Lerp

Engine.Load = function(self, inEnableValidation)
    self.i = Jkr.CreateInstance(inEnableValidation)
    self.e = Jkr.CreateEventManager()
    self.mt = Jkr.MultiThreading(self.i)

    self.PrepareMultiThreadingAndNetworking = function(self)
        self.gate = {
            run = function(f, t)
                self.mt:AddJobFIndex(f, t)
            end
        }
        setmetatable(self.gate, {
            __index = function(_, key)
                return self.mt:Get(key, StateId)
            end,
            __newindex = function(_, k, v)
                if k == "_run" and type(v) == "function" then
                    self.mt:AddJobF(v)
                elseif type(k) == "number" then
                    self.mt:AddJobFIndex(v, k)
                else
                    self.mt:Inject(k, v)
                end
            end,
        })

        self.port = 6345
        self.net = {}
        self.net = {
            Server = function(inport)
                self.net.Start = function()
                    if not inport then inport = self.port else self.port = inport end
                    return Jkr.StartServer(self.port)
                end

                self.net.listenOnce = function(FileName)
                    if not Jkr.IsMessagesBufferEmpty() then
                        local msg = Jkr.PopFrontMessagesBuffer()
                        local id = msg.mHeader.mId
                        if id == 1 then
                            local name = msg:GetString()
                            if string.sub(name, #name, #name) == ":" then -- in this format "name.txt:" then it is a file
                                self.net.listenOnce(string.sub(name, 1, #name - 1))
                            else
                                return name
                            end
                        elseif id == 2 then
                            return msg:GetFloat()
                        elseif id == 3 then
                            return load(msg:GetFunction())
                        elseif id == 4 then
                            msg:GetFile(FileName)
                        end
                        return msg
                    end
                end

                self.net.BroadCast = function(inToSend)
                    local msg = Jkr.Message()
                    if type(inToSend) == "string" then
                        if string.sub(inToSend, 1, 1) == ":" and string.sub(inToSend, #inToSend, #inToSend) == ":" then -- represents a file :name.txt: in this way
                            local fileName = string.sub(inToSend, 2, #inToSend - 1)
                            local fileNameToBeSent = string.sub(inToSend, 2, #inToSend)
                            self.net.BroadCast(fileNameToBeSent) -- send the filename in name.txt: this way
                            msg.mHeader.mId = 4
                            msg:InsertFile(fileName)             -- and then send the file
                        else
                            msg.mHeader.mId = 1
                            msg:InsertString(inToSend)
                        end
                    elseif type(inToSend) == "number" then
                        msg.mHeader.mId = 2
                        msg:InsertFloat(inToSend)
                    elseif type(inToSend) == "function" then
                        msg.mHeader.mId = 3
                        msg:InsertFunction(inToSend)
                    else
                        msg = inToSend
                    end
                    -- TODO Improve this client ID
                    Jkr.BroadcastServer(msg)
                end
            end,

            Client = function()
                self.net.Start = function(inIp, inId)
                    if not inId then inId = 0 end
                    Jkr.AddClient()
                    Jkr.ConnectFromClient(inId, inIp, self.port)
                end
                self.net.SendToServer = function(inToSend)
                    local msg = Jkr.Message()
                    if type(inToSend) == "string" then
                        if string.sub(inToSend, 1, 1) == ":" and string.sub(inToSend, #inToSend, #inToSend) == ":" then -- represents a file :name.txt: in this way
                            local fileName = string.sub(inToSend, 2, #inToSend - 1)
                            local fileNameToBeSent = string.sub(inToSend, 2, #inToSend)
                            self.net.SendToServer(fileNameToBeSent) -- send the filename in name.txt: this way
                            msg.mHeader.mId = 4
                            msg:InsertFile(fileName)                -- and then send the file
                        else
                            msg.mHeader.mId = 1
                            msg:InsertString(inToSend)
                        end
                    elseif type(inToSend) == "number" then
                        msg.mHeader.mId = 2
                        msg:InsertFloat(inToSend)
                    elseif type(inToSend) == "function" then
                        msg.mHeader.mId = 3
                        msg:InsertFunction(inToSend)
                    else
                        msg = inToSend
                    end
                    -- TODO Improve this client ID
                    Jkr.SendMessageFromClient(0, msg)
                end

                self.net.listenOnce = function(inFileName)
                    if not Jkr.IsIncomingMessagesEmptyClient(0) then
                        local msg = Jkr.PopFrontIncomingMessagesClient(0)
                        local id = msg.mHeader.mId
                        if id == 1 then
                            local name = msg:GetString()
                            if string.sub(name, #name, #name) == ":" then -- in this format "name.txt:" then it is a file
                                self.net.listenOnce(string.sub(name, 1, #name - 1))
                            else
                                return name
                            end
                        elseif id == 2 then
                            return msg:GetFloat()
                        elseif id == 3 then
                            return load(msg:GetFunction())
                        elseif id == 4 then
                            return msg:GetFile(inFileName)
                        end
                        return msg
                    end
                end
            end,

            --@warning you have to use TCP connection as above to set the UDP's Buffer,
            --using Jkr.SetBufferSizeUDP() call before receiving or sending anything
            UDP = function()
                self.net.StartUDP = function(inPort)
                    Jkr.StartUDP(inPort)
                end
                self.net.SendUDP = function(inMessage, inDestination, inPort)
                    local msg = Jkr.ConvertToVChar(inMessage)
                    Jkr.SendUDP(msg, inDestination, inPort)
                end
                self.net.listenOnceUDP = function(inTypeExample)
                    if not Jkr.IsMessagesBufferEmptyUDP() then
                        local msg = Jkr.PopFrontMessagesBufferUDP()
                        return Jkr.ConvertFromVChar(inTypeExample, msg)
                    end
                end
            end
        }
    end

    self:PrepareMultiThreadingAndNetworking()
    self.MakeGlobals = function()
        _G.mt = self.mt
        _G.gate = self.gate
        _G.net = self.net
        _G.i = self.i
        _G.e = self.e
    end

    -- in multithreading, in threads other than main thread,
    -- Globalify the main handles for convenience
    self.mt:Inject("Engine", self)
    self.mt:Inject("mt", self.mt)
    self.mt:Inject("gate", self.gate)
end


Engine.PrintGLTFInfo = function(inLoadedGLTF)
    io.write(string.format(
        [[
GLTF:-
Vertices = %d,
Indices = %d,
Images = %d,
Textures = %d,
Materials = %d,
Nodes = %d,
Skins = %d,
Animations = %d,
Meshes = %d
                ]],
        inLoadedGLTF:GetVerticesSize(),
        inLoadedGLTF:GetIndicesSize(),
        inLoadedGLTF:GetImagesSize(),
        inLoadedGLTF:GetTexturesSize(),
        inLoadedGLTF:GetMaterialsSize(),
        inLoadedGLTF:GetNodesSize(),
        inLoadedGLTF:GetSkinsSize(),
        inLoadedGLTF:GetAnimationsSize(),
        inLoadedGLTF:GetMeshesSize()
    ))
end

Engine.GetGLTFInfo = Engine.PrintGLTFInfo

Engine.CreatePBRShaderByGLTFMaterial = function(inGLTF, inMaterialIndex, inShadow)
    inMaterialIndex = inMaterialIndex + 1
    local Material = inGLTF:GetMaterialsRef()[inMaterialIndex]
    local vShader = Engine.Shader()
        .Header(450)
        .NewLine()
        .VLayout()
        .Out(0, "vec2", "vUV")
        .Out(1, "vec3", "vNormal")
        .Out(2, "vec3", "vWorldPos")
        .Out(3, "vec4", "vTangent")
        .Out(4, "int", "vVertexIndex")
        .Out(5, "vec3", "vViewPos")
        .Push()
        .Ubo()
        .inTangent()
        .GlslMainBegin()
        .Indent()
        .Append(
            [[
              vec4 Pos = Push.model * vec4(inPosition, 1.0);
              gl_Position = Ubo.proj * Ubo.view * Pos;
              vUV = inUV;
              vWorldPos = vec3(Pos);
              vVertexIndex = gl_VertexIndex;

              mat3 mNormal = transpose(inverse(mat3(Push.model)));
              vNormal = mNormal * normalize(inNormal.xyz);
              vec4 IN_Tangent = inTangent[gl_VertexIndex].mTangent;
              vec3 tangentttt = mNormal * normalize(IN_Tangent.w > 0 ? IN_Tangent.xyz : vec3(-IN_Tangent.x, IN_Tangent.y, IN_Tangent.z));
              vTangent = vec4(tangentttt, 1.0f);
              vec3 pos = inPosition + Ubo.lights[0].xyz;
              vViewPos = (Ubo.view * vec4(pos.xyz, 1.0)).xyz;
        ]]
        )
        .NewLine()
        .InvertY()
        .GlslMainEnd()
        .NewLine()

    local fShader = Engine.Shader()
        .Header(450)
        .NewLine()
        .In(0, "vec2", "vUV")
        .In(1, "vec3", "vNormal")
        .In(2, "vec3", "vWorldPos")
        .In(3, "vec4", "vTangent")
        .In(4, "flat int", "vVertexIndex")
        .In(5, "vec3", "vViewPos")
        .uSamplerCubeMap(20, "samplerCubeMap", 0)
        .uSampler2D(23, "samplerBRDFLUT", 0)
        .uSamplerCubeMap(24, "samplerIrradiance", 0)
        .uSamplerCubeMap(25, "prefilteredMap", 0)
        .Append [[
        layout (set = 0, binding = 32) uniform sampler2DArray shadowMap;
        ]]

    fShader.Ubo()
        .outFragColor()
        .Push()

    if inShadow then
        fShader.Append [[
        const mat4 biasMat = mat4(
            0.5, 0.0, 0.0, 0.0,
            0.0, 0.5, 0.0, 0.0,
            0.0, 0.0, 1.0, 0.0,
            0.5, 0.5, 0.0, 1.0
        );
        ]]
            .Shadow_textureProj()
            .filterPCF()
    end
    fShader
        .Append [[

    struct PushConsts {
              float roughness;
              float metallic;
              float specular;
              float r;
              float g;
              float b;
    } material;

        ]]
        .PI()


    local binding = 3
    if (Material.mBaseColorTextureIndex ~= -1) then
        fShader.uSampler2D(binding, "uBaseColorTexture")
        binding = binding + 1
    end
    if (Material.mMetallicRoughnessTextureIndex ~= -1) then
        fShader.uSampler2D(binding, "uMetallicRoughnessTexture")
        binding = binding + 1
    end
    if (Material.mNormalTextureIndex ~= -1) then
        fShader.uSampler2D(binding, "uNormalTexture")
        binding = binding + 1
    end
    if (Material.mOcclusionTextureIndex ~= -1) then
        fShader.uSampler2D(binding, "uOcclusionTexture")
        binding = binding + 1
    end
    if (Material.mEmissiveTextureIndex ~= -1) then
        fShader.uSampler2D(binding, "uEmissiveTexture")
        binding = binding + 1
    end

    if (Material.mMetallicRoughnessTextureIndex ~= -1) then
        fShader.Append "#define ALBEDO pow(texture(uBaseColorTexture, vUV).rgb, vec3(2.2))"
            .NewLine()
    else
        fShader
            .Append "#define ALBEDO vec3(material.r, material.g, material.b)"
            .NewLine()
    end

    fShader
        .Append "vec3 MaterialColor() {return vec3(material.r, material.g, material.b);}"
        .NewLine()
        .Uncharted2Tonemap()
        .D_GGX()
        .G_SchlicksmithGGX()
        .F_Schlick()
        .F_SchlickR()
        .PrefilteredReflection()
        .SpecularContribution()
        .SRGBtoLINEAR()

    if Material.mNormalTextureIndex ~= -1 then
        fShader
            .Append [[
vec3 calculateNormal()
{
    vec3 tangentNormal = texture(uNormalTexture, vUV).xyz * 2.0 - 1.0;
    vec3 N = normalize(vNormal);
    vec3 T = normalize(vTangent.xyz);
    vec3 B = normalize(cross(N, T));
    mat3 TBN = mat3(T, B, N);
    return normalize(TBN * tangentNormal);
}
        ]]
    else
        fShader.Append [[
vec3 calculateNormal()
{
    return vec3(0, 0, 1);
}
        ]]
    end


    fShader.GlslMainBegin()
    if Material.mNormalTextureIndex ~= -1 then
        fShader.Append [[
    vec3 N = calculateNormal();
    ]]
    else
        fShader.Append [[
    vec3 N = vNormal;
    ]]
    end

    fShader.Append [[
    vec3 V = normalize(Ubo.campos - vWorldPos);
    vec3 R = reflect(-V, N);
    ]]

    if (Material.mMetallicRoughnessTextureIndex ~= -1) then
        fShader.Append [[

            float metallic = texture(uMetallicRoughnessTexture, vUV).b;
            float roughness = texture(uMetallicRoughnessTexture, vUV).g;
            // metallic = 0;
            // roughness = 0.5;
         ]]
    else
        fShader.Append [[

            float metallic = material.metallic;
            float roughness = material.roughness;

         ]]
    end

    if (Material.mEmissiveTextureIndex ~= -1) then
        fShader.Append [[

    vec3 Emissive = texture(uEmissiveTexture, vUV).rgb;

        ]]
    else
        fShader.Append [[

    vec3 Emissive = vec3(0);
        ]]
    end

    fShader.Append [[


    vec3 F0 = vec3(0.04);
    F0 = mix(F0, vec4(ALBEDO, 1.0).xyz, metallic);
    vec3 Lo = vec3(0.0);
    for(int i = 0; i < Ubo.lights[i].length(); i++) {
        vec3 L = normalize(Ubo.lights[i].xyz - vWorldPos) * Ubo.lights[i].w;
        Lo += SpecularContribution(L, V, N, F0, metallic, roughness);
    }

    vec2 brdf = texture(samplerBRDFLUT, vec2(max(dot(N, V), 0.0), roughness)).rg;
    vec3 reflection = PrefilteredReflection(R, roughness).rgb;	
    vec3 irradiance = texture(samplerIrradiance, N).rgb;

    // Diffuse based on irradiance
    vec3 diffuse = irradiance * ALBEDO;	

    vec3 F = F_SchlickR(max(dot(N, V), 0.0), F0, roughness);

    // Specular reflectance
    vec3 specular = reflection * (F * brdf.x + brdf.y);

    // Ambient part
    vec3 kD = 1.0 - F;
    kD *= 1.0 - metallic;	

    ]]

    if (Material.mOcclusionTextureIndex ~= -1) then
        fShader.Append [[

                vec3 ambient = (kD * diffuse + specular) * texture(uOcclusionTexture, vUV).rrr;
        ]]
    else
        fShader.Append [[

                vec3 ambient = (kD * diffuse + specular);
        ]]
    end

    if inShadow then
        fShader.Append [[
    int SHADOW_MAP_CASCADE_COUNT = 4;
    vec4 cascadeSplits = Push.m2[1];
    int enablePCF = 0;
    uint cascadeIndex = 0;
    for(uint i = 0; i < SHADOW_MAP_CASCADE_COUNT; ++i)
    {
        if(vViewPos.z < cascadeSplits[i])
        {
            cascadeIndex = i + 1;
        }
    }
    vec4 shadowCoord = (biasMat * Ubo.shadowMatrix[cascadeIndex]) * vec4 (vWorldPos + Ubo.lights[0].xyz, 1.0);

    float shadow = 0;
    if (enablePCF == 1) {
        shadow = filterPCF(shadowCoord / shadowCoord.w, cascadeIndex, length(ambient));
    } else {
        shadow = textureProj(shadowCoord / shadowCoord.w, vec2(0.0), cascadeIndex, length(ambient));
    }
    ambient *= shadow;
        ]]
    end

    fShader.Append [[

    vec4 p1 = Push.m2[0];
    vec4 p2 = Push.m2[1];
    vec4 p3 = Push.m2[2];
    vec4 p4 = Push.m2[3];

    vec3 color = ambient + Lo;
    color = Uncharted2Tonemap(color * p4.x); // Tone mapping exposure = 1.5
    color = color * (1.0f / Uncharted2Tonemap(vec3(p4.y)));	// norma 11.2
    color = pow(color, vec3(p4.z)); // Gamma correction gamma = 1/2.2

    outFragColor = vec4(color + Emissive, 1.0);
    ]]
    -- if inShadow then
    --     fShader.Append [[
    --    outFragColor = outFragColor.rgba * shadow;
    --    ]]
    -- end

    fShader.GlslMainEnd()

    return { vShader = vShader, fShader = fShader }
end

Engine.CreateObjectByGLTFPrimitiveAndUniform = function(inWorld3d,
                                                        inGLTFModelId,
                                                        inGLTFModelInWorld3DId,
                                                        inMaterialToSimple3DIndex,
                                                        inMeshIndex,
                                                        inPrimitive)
    local uniformIndex = inWorld3d:AddUniform3D(i)
    local uniform = inWorld3d:GetUniform3D(uniformIndex)
    local simple3dIndex = inMaterialToSimple3DIndex[inPrimitive.mMaterialIndex + 1]
    local simple3d = inWorld3d:GetSimple3D(simple3dIndex)
    local gltf = inWorld3d:GetGLTFModel(inGLTFModelId)
    uniform:Build(simple3d, gltf, inPrimitive)

    local Object3D = Jkr.Object3D()
    Object3D.mId = inGLTFModelInWorld3DId
    Object3D.mAssociatedUniform = uniformIndex
    Object3D.mAssociatedModel = inGLTFModelId
    Object3D.mAssociatedSimple3D = simple3dIndex
    Object3D.mIndexCount = inPrimitive.mIndexCount
    Object3D.mFirstIndex = inPrimitive.mFirstIndex
    local NodeIndices = gltf:GetNodeIndexByMeshIndex(inMeshIndex - 1)
    Object3D.mMatrix = gltf:GetNodeMatrixByIndex(NodeIndices)

    return Object3D
        .Append [[
            layout(set = 0, binding = 32) uniform sampler2DArray shadowMap;
            ]]
end


Engine.AddObject = function(modObjects, modObjectsVector, inId, inAssociatedModel, inUniformIndex, inSimple3dIndex,
                            inGLTFHandle,
                            inMeshIndex)
    local Object = Jkr.Object3D()
    if inId then Object.mId = inId end
    if inAssociatedModel then Object.mAssociatedModel = math.floor(inAssociatedModel) end
    if inUniformIndex then Object.mAssociatedUniform = math.floor(inUniformIndex) end
    if inSimple3dIndex then Object.mAssociatedSimple3D = math.floor(inSimple3dIndex) end
    if (inGLTFHandle) then
        local NodeIndices = inGLTFHandle:GetNodeIndexByMeshIndex(inMeshIndex)
        Object.mMatrix = inGLTFHandle:GetNodeMatrixByIndex(NodeIndices)
    end
    modObjects[#modObjects + 1] = Object
    modObjectsVector:add(Object)
    return #modObjectsVector
end

Engine.AddAndConfigureGLTFToWorld = function(w,
                                             inworld3d,
                                             inshape3d,
                                             ingltfmodelname,
                                             inshadertype,
                                             incompilecontext,
                                             inskinning,
                                             inhdrenvfilename)
    local shouldload = false
    if not incompilecontext then incompilecontext = Jkr.CompileContext.Default end
    local SkyboxObject
    if inshadertype == "PBR" or inshadertype == "PBR_SHADOW" then
        local globaluniformhandle = inworld3d:GetUniform3D(0)
        local Skybox = Jkr.Generator(Jkr.Shapes.Cube3D, vec3(1, 1, 1))
        local skyboxId = inshape3d:Add(Skybox, vec3(0, 0, 0))
        PBR.Setup(w, inworld3d, inshape3d, skyboxId, globaluniformhandle, "PBR_FREAK", inhdrenvfilename)
        SkyboxObject = Jkr.Object3D()
        SkyboxObject.mId = skyboxId
        SkyboxObject.mP2 = 1
        local skybox_shaderindex = inworld3d:AddSimple3D(Engine.i, w)
        local skybox_shader = inworld3d:GetSimple3D(skybox_shaderindex)
        local vshader, fshader = Engine.GetAppropriateShader("SKYBOX")
        skybox_shader:CompileEXT(
            Engine.i,
            w,
            "cache/constant_color.glsl",
            vshader.str,
            fshader.str,
            "",
            shouldload,
            incompilecontext
        )
        SkyboxObject.mAssociatedSimple3D = skybox_shaderindex
    end

    local gltfmodelindex = inworld3d:AddGLTFModel(ingltfmodelname)
    local gltfmodel = inworld3d:GetGLTFModel(gltfmodelindex)
    local shapeindex = inshape3d:Add(gltfmodel) -- this ACUTALLY loads the GLTF Model
    local Nodes = gltfmodel:GetNodesRef()
    Engine.GetGLTFInfo(gltfmodel)
    local Objects = {}
    local materials = {}

    for NodeIndex = 1, #Nodes, 1 do
        local primitives = Nodes[NodeIndex].mMesh.mPrimitives

        for PrimitiveIndex = 1, #primitives, 1 do
            local inprimitive = primitives[PrimitiveIndex]
            local materialindex = inprimitive.mMaterialIndex
            if not materials[materialindex] then
                local uniform3dindex = inworld3d:AddUniform3D(Engine.i)
                local uniform = inworld3d:GetUniform3D(uniform3dindex)
                local shaderindex = inworld3d:AddSimple3D(Engine.i, w)
                local shader = inworld3d:GetSimple3D(shaderindex)
                local vshader, fshader = Engine.GetAppropriateShader(inshadertype, incompilecontext, gltfmodel,
                    materialindex,
                    inskinning)
                shader:CompileEXT(
                    Engine.i,
                    w,
                    "cache/constant_color.glsl",
                    vshader.str,
                    fshader.str,
                    "",
                    shouldload,
                    incompilecontext
                )
                local allocate_for_skinning = false
                local allocate_for_tangent = true
                if inskinning then allocate_for_skinning = true end
                uniform:Build(shader, gltfmodel, 0, allocate_for_skinning, allocate_for_tangent)
                uniform:Build(shader, gltfmodel, primitives[PrimitiveIndex])
                materials[materialindex] = { shaderindex = shaderindex, uniformindex = uniform3dindex }
            end

            local object = Jkr.Object3D()
            object.mId = shapeindex;
            object.mAssociatedModel = gltfmodelindex;
            object.mAssociatedUniform = materials[materialindex].uniformindex;
            object.mAssociatedSimple3D = materials[materialindex].shaderindex;
            object.mFirstIndex = inprimitive.mFirstIndex
            object.mIndexCount = inprimitive.mIndexCount
            object.mMatrix = Nodes[NodeIndex]:GetLocalMatrix()
            object.mP1 = NodeIndex

            Objects[#Objects + 1] = object
        end

        if #primitives == 0 and #Nodes[NodeIndex].mChildren ~= 0 then
            local object = Jkr.Object3D()
            object.mId = shapeindex;
            object.mAssociatedModel = gltfmodelindex;
            object.mAssociatedUniform = -1;
            object.mAssociatedSimple3D = -1;
            object.mFirstIndex = -1
            object.mIndexCount = -1
            object.mDrawable = false
            object.mMatrix = Nodes[NodeIndex]:GetLocalMatrix()
            ---@note This is supposed to be used for storage of the abovematrix
            object.mMatrix3 = Nodes[NodeIndex]:GetLocalMatrix()
            object.mP1 = NodeIndex
            object.mP2 = 1 -- This indicates the object is the root object
            Objects[#Objects + 1] = object
        end
    end

    -- @warning You've to store this Objects {} table somewhere
    for i = 1, #Objects, 1 do
        for j = 1, #Objects, 1 do
            if i ~= j then
                if gltfmodel:IsNodeParentOf(Nodes[Objects[i].mP1], Nodes[Objects[j].mP1]) then
                    Objects[i]:SetParent(Objects[j])
                end
            end
        end
    end
    ---@note If there is a single object in the gltf file then it has to be the root object
    if #Objects == 1 then
        Objects[1].mP2 = 1
    end
    Objects[#Objects + 1] = SkyboxObject
    return Objects
end

Engine.CreateWorld3D = function(w, inshaper3d)
    local world3d = Jkr.World3D(inshaper3d)
    local camera3d = Jkr.Camera3D()
    camera3d:SetAttributes(vec3(0, 0, 0), vec3(-0.12, 1.14, -2.25))
    camera3d:SetPerspective(45.0 * 180.0 / math.pi, 16 / 9, 0.001, 10000)
    world3d:AddCamera(camera3d)
    local dummypipelineindex = world3d:AddSimple3D(Engine.i, w);
    local dummypipeline = world3d:GetSimple3D(dummypipelineindex)
    local light0 = {
        pos = vec4(-1, 5, 3, 40),
        dir = Jmath.Normalize(vec4(0, 0, 0, 0) - vec4(10, 10, -10, 1))
    }
    world3d:AddLight3D(light0.pos, light0.dir)

    local vshader, fshader = Engine.GetAppropriateShader("GENERAL_UNIFORM",
        Jkr.CompileContext.Default, nil, nil, false, false
    )

    dummypipeline:CompileEXT(
        Engine.i,
        w,
        "cache/dummyshader.glsl",
        vshader.str,
        fshader.str,
        "",
        false,
        Jkr.CompileContext.Default
    )

    local globaluniformindex = world3d:AddUniform3D(Engine.i)
    local globaluniformhandle = world3d:GetUniform3D(globaluniformindex)
    globaluniformhandle:Build(dummypipeline)
    world3d:AddWorldInfoToUniform3D(globaluniformindex)
    Jkr.RegisterShadowPassImageToUniform3D(w, globaluniformhandle, 32)
    return world3d, camera3d
end
