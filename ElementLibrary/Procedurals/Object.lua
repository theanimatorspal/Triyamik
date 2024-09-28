require "Present.Present"

Object = function(inTest3D)
    local t = {
        type = "TEST"
    }
    return { PRO_Object = Default(inTest3D, t) }
end

local Shaders = {}
local Objects = {}
gprocess.PRO_Object = function(inPresentation, inValue, inFrameIndex, inElementName)
    local ElementName = gUnique(inElementName)
    --- @warning MESHES SHOULD BE ADDED BEFORE COMPUTE OPERATIONS
    --- @todo Precompute this afterwards
    local GeneratedObject = Jkr.Generator(Jkr.Shapes.Triangles3D, vec2(30, 30))
    local ui = gshaper3d:Add(GeneratedObject, vec3(0, 0, 0))
    if inValue.type == "TEST" and not gscreenElements[ElementName] then
        local CustomImagePainter = Jkr.CreateCustomImagePainter("cache2/Test3D.glsl", Shaders.ComputeShader.Print().str)
        CustomImagePainter:Store(Engine.i, gwindow)
        local CustomPainterImage = gwid.CreateComputeImage(vec3(0), vec3(50, 50, 1))
        CustomPainterImage.RegisterPainter(CustomImagePainter, 0)
        Jkr.RegisterShapeRenderer3DToCustomPainterImage(Engine.i, gshaper3d, CustomPainterImage.handle,
            Shaders.ComputeShader.vertexStorageBufferIndex, Shaders.ComputeShader.indexStorageBufferIndex)

        local Object = Jkr.Object3D()
        Object.mId = ui
        Object.mAssociatedUniform = -1
        Object.mAssociatedModel = -1
        Object.mAssociatedSimple3D = 0
        Object.mIndexCount = gshaper3d:GetIndexCount(ui)

        Objects[ElementName] = {
            Painter = CustomImagePainter,
            Image = CustomPainterImage,
            ShapeVertexOffsetId = gshaper3d:GetVertexOffsetAbsolute(ui),
            ShapeIndexOffsetId = gshaper3d:GetIndexOffsetAbsolute(ui),
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
    inElement.handle.Painter:Bind(gwindow, Jkr.CmdParam.None)
    inElement.handle.Painter:BindImageFromImage(gwindow, inElement.handle.Image, Jkr.CmdParam.None)
    inElement.handle.Painter:Draw(gwindow, PC_Mats(
        mat4(
            vec4(inElement.handle.ShapeVertexOffsetId, inElement.handle.ShapeIndexOffsetId, 0.0, 0.0), -- p1
            vec4(7, 7, 1, 0),                                                                          -- p2
            vec4(0.0),
            vec4(0.0)
        ),
        mat4(
            vec4(0.0),
            vec4(0.0),
            vec4(0.0),
            vec4(0.0)
        )
    ), 2, 2, 30, Jkr.CmdParam.None)
end

Shaders.ComputeShader = Engine.Shader()
    .Header(450)
    .CInvocationLayout(16, 16, 1)
    .uImage2D(0) -- "storageImage"
    .ImagePainterPushMatrix2()
    .ImagePainterVIStorageLayout()
    .GlslMainBegin()
    .ImagePainterAssistMatrix2()
    .Append [[
    // p1 ma vako jati sappai starting stuff
    int startingIndex = int(p1.y);
    // p2 ma vako jati sappai height + width
    int height = int(p2.y);
    int width = int(p2.x);
    uint y = gID.y;
    uint x = gID.x;
    uint z = gID.z;
    uint v0_index = inIndices[startingIndex].mId;
    int p1x = int(p1.x);
    if(y < height && x < width && z % 6 == 0)
    {
            uint bottomLeft = y * width + x;
            uint bottomRight = y * width + x + 1;
            uint topLeft = (y + 1) * width + x;
            uint topRight = (y + 1) * width + x + 1;
            if(bottomLeft == startingIndex + z)
            {
                inIndices[startingIndex + z + 0].mId = p1x + bottomLeft;
                inIndices[startingIndex + z + 1].mId = p1x + topRight;
                inIndices[startingIndex + z + 2].mId = p1x + topLeft;

                inIndices[startingIndex + z + 3].mId = p1x + bottomLeft;
                inIndices[startingIndex + z + 4].mId = p1x + bottomRight;
                inIndices[startingIndex + z + 5].mId = p1x + topRight;
            }
            debugPrintfEXT("xyz(%d, %d, %d), bl:%d, br:%d, tl:%d, tr:%d, p1x:%d", x, y, z, bottomLeft, bottomRight, topLeft, topRight, p1x);
    }
    ]]
    .GlslMainEnd()
