require "Present.Present"

Object = function(inTest3D)
    local t = {
        type = "TEST"
    }
    return { PRO_Object = Default(inTest3D, t) }
end

local Shaders = {}
local Objects = {}
local Compile


gprocess.PRO_Object = function(inPresentation, inValue, inFrameIndex, inElementName)
    Compile()
    local ElementName = gUnique(inElementName)
    --- @warning MESHES SHOULD BE ADDED BEFORE COMPUTE OPERATIONS
    --- @warning @todo Create "Multiple VertexBuffers" for this later if needed, but lot to change
    --- @ in code for this one
    --- @todo Precompute this afterwards
    local GeneratedObject = Jkr.Generator(Jkr.Shapes.Zeros3D, vec2(512 * 3, 512 * 3))
    local ui = gshaper3d:Add(GeneratedObject, vec3(0, 0, 0))

    if inValue.type == "TEST" and not gscreenElements[ElementName] then
        local CustomPainterImage = gwid.CreateComputeImage(vec3(0), vec3(50, 50, 1))
        CustomPainterImage.RegisterPainter(Shaders.TerrainGenerate.handle, 0)
        Jkr.RegisterShapeRenderer3DToCustomPainterImage(Engine.i, gshaper3d, CustomPainterImage.handle,
            Shaders.TerrainGenerate.vertexStorageBufferIndex, Shaders.TerrainGenerate.indexStorageBufferIndex)

        local Object = Jkr.Object3D()
        Object.mId = ui
        Object.mAssociatedUniform = -1
        Object.mAssociatedModel = -1
        Object.mAssociatedSimple3D = 0
        Object.mIndexCount = gshaper3d:GetIndexCount(ui)
        local ShapeVertexOffsetId = gshaper3d:GetVertexOffsetAbsolute(ui)
        local ShapeIndexOffsetId = gshaper3d:GetIndexOffsetAbsolute(ui)
        gwid.c:PushOneTime(Jkr.CreateDispatchable(function()
            CustomPainterImage.handle:SyncBefore(gwindow, Jkr.CmdParam.None)
            TwoDimensionalIPs.Circle.handle:BindImageFromImage(gwindow, CustomPainterImage, Jkr.CmdParam.None)
            TwoDimensionalIPs.Circle.handle:Bind(gwindow, Jkr.CmdParam.None)

            TwoDimensionalIPs.Circle.handle:Draw(gwindow, PC_Mats(
                mat4(
                    vec4(0, 0, 0.7, 1), -- p1
                    vec4(1),            -- p2
                    vec4(1, 0, 0, 0),   -- p3
                    vec4(1)             -- p4
                ),
                mat4(
                    vec4(0.0),
                    vec4(0.0),
                    vec4(0.0),
                    vec4(0.0)
                )
            ), math.int(4), math.int(4), 1, Jkr.CmdParam.None)
        end), 1)

        Objects[ElementName] = {
            Image = CustomPainterImage,
            ShapeVertexOffsetId = ShapeVertexOffsetId,
            ShapeIndexOffsetId = ShapeIndexOffsetId,
            Object = Object
        }
    end

    gAddFrameKeyElementCompute(inFrameIndex, {
        {
            "*PRO_Object*",
            handle = Objects[ElementName],
            value = inValue,
            name = ElementName
        }
    })
end

DispatchFunctions["*PRO_Object*"] = function(inPresentation, inElement, t, inDirection)
    gobjects3d:add(inElement.handle.Object) -- gobjects3d is erased at each frame
    Shaders.TerrainGenerate.handle:Bind(gwindow, Jkr.CmdParam.None)
    Shaders.TerrainGenerate.handle:BindImageFromImage(gwindow, inElement.handle.Image, Jkr.CmdParam.None)
    inElement.handle.Image.handle:SyncBefore(gwindow, Jkr.CmdParam.None)
    Shaders.TerrainGenerate.handle:Draw(gwindow, PC_Mats(
        mat4(
            vec4(inElement.handle.ShapeVertexOffsetId, inElement.handle.ShapeIndexOffsetId, 0.0, 0.0), -- p1
            vec4(9, 9, 1, 0),                                                                          -- p2
            vec4(0.0),
            vec4(0.0)
        ),
        mat4(
            vec4(0.0),
            vec4(0.0),
            vec4(0.0),
            vec4(0.0)
        )
    ), math.int(2), math.int(2), 1, Jkr.CmdParam.None)
    -- inElement.handle.Image.handle:SyncAfter(gwindow, Jkr.CmdParam.None)
end

Shaders.TerrainGenerate = Engine.Shader()
    .Header(450)
    .CInvocationLayout(16, 16, 1)
    .uImage2D(0) -- "storageImage"
    .Random()
    .ImagePainterPushMatrix2()
    .ImagePainterVIStorageLayout()
    .Append [[
       vec4 LoadExtentImage(ivec2 inAt, in ivec2 inImageSize)
       {
            return imageLoad(storageImage, clamp(inAt, ivec2(0, 0), inImageSize - ivec2(1, 1)));
       }
    ]]
    .GlslMainBegin()
    .ImagePainterAssistMatrix2()
    .Append [[
    int startingIndex = int(p1.y);
    int height = int(p2.y);
    int width = int(p2.x);
    uint y = gID.y;
    uint x = gID.x;
    uint z = gID.z;

    if (y < height && x < width)
    {
        uint v0_index = inIndices[startingIndex].mId;
        int p1x = int(p1.x);

        uint bottomLeft = y * width + x;
        uint bottomRight = y * width + x + 1;
        uint topLeft = (y + 1) * width + x;
        uint topRight = (y + 1) * width + x + 1;
        inVertices[p1x + bottomLeft].mPosition = vec3(0.0f);

        uint stiplusbl = startingIndex + bottomLeft * 6;
        if(x < width - 1 && y < height - 1)
        {
            inIndices[stiplusbl + 0].mId = p1x + bottomLeft;
            inIndices[stiplusbl + 1].mId = p1x + topRight;
            inIndices[stiplusbl + 2].mId = p1x + topLeft;

            inIndices[stiplusbl + 3].mId = p1x + bottomLeft;
            inIndices[stiplusbl + 4].mId = p1x + bottomRight;
            inIndices[stiplusbl + 5].mId = p1x + topRight;
        }

        vec3 pos = vec3(-width / 2.0f + x, 0.0f, -height / 2.0f + y);
        vec2 height_pos = vec2(
            image_size.x * x / float(width),
            image_size.y * y / float(height)
        );
        ivec2 height_pos_int = ivec2(int(height_pos.x), int(height_pos.y));
        vec4 heightmap = imageLoad(storageImage, height_pos_int);
        pos.y = heightmap.y * 10;

        // Normal Calculation
        ivec2 height_pos_xdir1 = ivec2(height_pos_int.x + 1, height_pos_int.y);
        ivec2 height_pos_xdir2 = ivec2(height_pos_int.x - 1, height_pos_int.y);

        ivec2 height_pos_ydir1 = ivec2(height_pos_int.x, height_pos_int.y + 1);
        ivec2 height_pos_ydir2 = ivec2(height_pos_int.x, height_pos_int.y - 1);

        vec3 v1 = vec3(2,
                       (LoadExtentImage(height_pos_xdir1, image_size).y -
                       LoadExtentImage(height_pos_xdir2, image_size).y) * 10,
                       0);
        vec3 v2 = vec3(0,
                       (LoadExtentImage(height_pos_ydir1, image_size).y -
                       LoadExtentImage(height_pos_ydir2, image_size).y) * 10,
                       2);

        vec3 Normal = normalize(cross(v2, v1));
        debugPrintfEXT("Normal: %f, %f, %f", Normal.x, Normal.y, Normal.z);

        inVertices[p1x + bottomLeft].mPosition = pos;
        inVertices[p1x + bottomLeft].mColor = Normal;
    }
    ]]
    .GlslMainEnd()


Compile = function()
    if not Shaders.all_compiled then
        local sh = Jkr.CreateCustomImagePainter
        Shaders.TerrainGenerate.handle = sh("cache2/PRO_ObjectTest3D.glsl", Shaders.TerrainGenerate.str)
        Shaders.TerrainGenerate.handle:Store(Engine.i, gwindow)

        TwoDimensionalIPs.ConstantColor.handle = sh("cache2/PRO_ObjectConstantColor.glsl",
            TwoDimensionalIPs.ConstantColor.str)
        TwoDimensionalIPs.ConstantColor.handle:Store(Engine.i, gwindow)

        TwoDimensionalIPs.Circle.handle = sh("cache2/PRO_ObjectTwoDimensionalIPs.glsl",
            TwoDimensionalIPs.Circle.str)
        TwoDimensionalIPs.Circle.handle:Store(Engine.i, gwindow)

        Shaders.all_compiled = true
    end
end
