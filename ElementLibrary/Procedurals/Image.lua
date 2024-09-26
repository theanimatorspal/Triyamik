require "ElementLibrary.Procedurals.Require"
function PC(a, b, c, d, e, f, g, h)
    local Push = Jkr.Matrix2CustomImagePainterPushConstant()
    Push.a = mat4(a, b, c, d)
    if e and f and g and h then
        Push.b = mat4(e, f, g, h)
    end
    return Push
end

function PC_Mats(a, b)
    local Push = Jkr.Matrix2CustomImagePainterPushConstant()
    Push.a = a
    Push.b = b
    return Push
end

local FilterShaders = {}

PRO.Image = function(inImageTable)
    local t = {
        filter = "NONE",
        p = "CENTER_CENTER",
        d = vec3(100, 100, 1),
        push = PC_Mats(mat4(1.0), mat4(1.0)),
        show = "OUTPUT" -- or "INPUT"
    }
    return { PRO_Image = Default(inImageTable, t) }
end

local Images = {}
gprocess.PRO_Image = function(inPresentation, inValue, inFrameIndex, inElementName)
    local ElementName = gUnique(inElementName)
    if not Images[ElementName] then
        local InputSampledImage = gwid.CreateSampledImage(ComputePositionByName(vec3(math.huge), inValue.d),
            inValue.d,
            inValue.file, true) -- no draw
        local InputComputeImage = gwid.CreateComputeImage(ComputePositionByName(inValue.p, inValue.d),
            inValue.d,
            InputSampledImage)
        local OutputSampledImage = gwid.CreateSampledImage(ComputePositionByName(inValue.p, inValue.d),
            InputSampledImage.mActualSize)

        OutputSampledImage:Update(ComputePositionByName(inValue.p, inValue.d), inValue.d)

        if inValue.show == "INPUT" then
            gwid.c:PushOneTime(Jkr.CreateDispatchable(function()
                InputSampledImage.CopyToCompute(InputComputeImage)
                InputComputeImage.CopyToSampled(OutputSampledImage)
            end), 1)
        end

        if inValue.show == "OUTPUT" then
            if inValue.filter == "NONE" then
                gwid.c:PushOneTime(Jkr.CreateDispatchable(function()
                    InputSampledImage.CopyToCompute(InputComputeImage)
                    InputComputeImage.CopyToSampled(OutputSampledImage)
                end), 1)
            else
                --[[
                ===================================================
                ===================================================
                BLUR SHADER
                ===================================================
                ===================================================
                ]]
                if inValue.filter == "BLUR" then
                    local OutputComputeImage = gwid.CreateComputeImage(
                        ComputePositionByName(inValue.p, inValue.d),
                        inValue.d,
                        InputSampledImage)
                    local ImagePainter = Jkr.CreateCustomImagePainter("cache2/PRO_BLUR.glsl", FilterShaders.BLUR.str)
                    ImagePainter:Store(Engine.i, gwindow)
                    InputComputeImage.RegisterPainter(ImagePainter, 0)
                    Jkr.RegisterCustomPainterImageToCustomPainterImage(Engine.i, InputComputeImage.handle,
                        OutputComputeImage.handle, 1)
                    OutputComputeImage.RegisterPainter(ImagePainter, 1)
                    gwid.c:PushOneTime(Jkr.CreateDispatchable(
                        function()
                            InputSampledImage.CopyToCompute(InputComputeImage)
                        end
                    ), 1)
                    gwid.c:PushOneTime(Jkr.CreateDispatchable(
                        function()
                            -- ImagePainter:Bind(gwindow, Jkr.CmdParam.None)
                            -- ImagePainter:BindImageFromImage(gwindow, InputComputeImage, Jkr.CmdParam.None)
                            -- ImagePainter:Draw(gwindow, inValue.push, math.int(InputSampledImage.mActualSize.x / 16),
                            --     math.int(InputSampledImage.mActualSize.y / 16), 1, Jkr.CmdParam.None)
                            OutputComputeImage.CopyToSampled(OutputSampledImage)
                        end
                    ), 2)
                    ImagePainter:Store(Engine.i, gwindow)
                end
            end
        end
        Images[ElementName] = {
            Sampled = OutputSampledImage
        }
    end

    --
    --
    -- ADD FRAME KEY ELEMENT
    --
    --
    gAddFrameKeyElement(inFrameIndex, {
        {
            "*PRO_IMAGE*",
            handle = Images[ElementName],
            value = inValue,
            name = ElementName
        }
    })
end

ExecuteFunctions["*PRO_IMAGE*"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
    local PreviousElement, inElement = GetPreviousFrameKeyElementD(inPresentation, inElement,
        inFrameIndex, inDirection)
    local new = inElement.value
    if PreviousElement then
        local prev = PreviousElement.value
        local interp = glerp_3f(ComputePositionByName(prev.p, prev.d), ComputePositionByName(new.p, new.d), t)
        local interd = glerp_3f(prev.d, new.d, t)
        inElement.handle.Sampled:Update(interp, interd)
    else
        inElement.handle.Sampled:Update(ComputePositionByName(new.p, new.d), new.d)
    end
end

local Header = function()
    return Engine.Shader()
        .Header(450)
        .CInvocationLayout(16, 16, 1)
        .uImage2D(0) -- "storageImage"
        .ImagePainterPushMatrix2()
        .Append [[
       int KernelSizeX = int(push.a[3].x);
       int KernelSizeY = int(push.a[3].y);
       float Kernel[20 * 20];
       // p4.x < 5 and p4.y < 5
       float GetKernel(int x, int y)
       {
            return Kernel[y * KernelSizeX + x];
       }
       void SetKernel(int x, int y, float value)
       {
            Kernel[y * int(KernelSizeX) + x] = value;
       }
       void SetKernel(float value)
       {
            for(int i = 0; i < KernelSizeX * KernelSizeY; ++i)
            {
                Kernel[i] = value;
            }
       }

       vec4 LoadExtentImage(ivec2 inAt, in ivec2 inImageSize)
       {
            if(inAt.x <= 0) {
                inAt.x = 0;
            }
            if(inAt.y <= 0) {
                inAt.y = 0;
            }
            if (inAt.x >= inImageSize.x)
            {
                inAt.x = inImageSize.x - 1;
            }
            if (inAt.y >= inImageSize.y)
            {
                inAt.x = inImageSize.y - 1;
            }
            return imageLoad(storageImage, inAt);
       }
        ]]
end

--[[
function convolve_image(M::AbstractMatrix, K::AbstractMatrix)
	m_rows, m_columns = size(M)
	k_rows, k_columns = size(K)
	sk_rows, sk_columns = ((k_rows - 1)) ÷ 2, ((k_columns - 1) ÷ 2)
	out_M = copy(M)
	for i in 1:m_rows
		for j in 1:m_columns
			sum = RGBX(0)
			for k in -sk_rows:sk_rows
				for l in -sk_columns:sk_columns
					sum = sum + K[k + sk_rows + 1, l + sk_columns + 1] * extend_mat(M, k + i, j + l)
				end
			end
			out_M[i, j] = sum
		end
	end
	return out_M
end
]]
FilterShaders.BLUR = Header()
    .uImage2D(1, "outputImage")
    .ImagePainterAssistMatrix2()
    .GlslMainBegin().Append [[
    SetKernel(1.0f);
    vec4 sum = vec4(0, 0, 0, 1);
    const int rows = (KernelSizeY - 1) / 2;
    const int columns = (KernelSizeX - 1) / 2;
    int total = 0;
    for(int y = -rows; y < rows; ++y)
    {
        for(int x = -columns; x < columns; ++x)
        {
            //SetKernel(x + columns, y + rows,  1 - );
            sum += GetKernel(x + columns, y + rows) * LoadExtentImage(to_draw_at + ivec2(x, y), image_size); //* imageLoad(storageImage, to_draw_at + ivec2(x, y));
            ++total;
        }
    }
    imageStore(outputImage, to_draw_at, sum / total);


]]
    .GlslMainEnd().Print()
