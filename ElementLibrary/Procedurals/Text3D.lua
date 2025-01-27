require "ElementLibrary.Procedurals.Require"

PRO.Text3D = function(inText3DTable)
    local t = {
        t = "001",
        p = vec3(0),
        d = vec3(1, 1, 0.01),
        color = vec4(0, 0, 0, 1),
        mode = "SEPARATED", -- "COMBINED"
        sidedness = "TWOSIDED",
        background_color = vec4(0),
        callback_foreachchar = nil
    }
    return { PRO_Text3D = Default(inText3DTable, t) }
end

PRO.Text3D_group = function(inText3DTable)
    local t = {
        type = "GRID2D", -- "UNIFIED"
        texts = { "JkrGUIv2" },
        p = vec3(0),     --position of the grid (Grid Center)
        offset = 0,
        radius = 3,
        each_d = vec3(0.1),
        each_color = vec4(0, 0, 0, 1),
        each_padding = vec3(2),
        background_color = vec4(0),
        each_mode = "COMBINED"
    }
    return { PRO_Text3D_group = Default(inText3DTable, t) }
end

local Text3D_group_elements = {}
gprocess.PRO_Text3D_group = function(inPresentation, inValue, inFrameIndex, inElementName)
    local elementName = gUnique(inElementName)
    local background_color = inValue.background_color
    if not Text3D_group_elements[elementName] then
        Text3D_group_elements[elementName] = { inValue, inFrameIndex }
    else
        if #inValue.texts == 1 and inValue.texts[1] == "JkrGUIv2" then
            inValue.texts = Text3D_group_elements[elementName][1].texts
        end
    end
    if inValue.type == "GRID2D" then
        local colcount = math.ceil(math.sqrt(#inValue.texts))
        local rowcount = math.ceil(#inValue.texts / (colcount * 1.0))
        local start_x = inValue.p.x + (colcount) * (inValue.each_padding.x) / 4.0
        local start_y = inValue.p.y + (rowcount) * (inValue.each_padding.y) / 4.0

        local index = 1
        local row = 1
        while index <= #inValue.texts do
            for col = 1, colcount do
                if index <= #inValue.texts then
                    gprocess.PRO_Text3D(inPresentation, PRO.Text3D {
                        t = inValue.texts[index],
                        d = inValue.each_d,
                        p = vec3(
                            start_x - (col - 1) * (inValue.each_padding.x) / 2.0,
                            start_y - (row - 1) * (inValue.each_padding.x) / 2.0,
                            inValue.p.z
                        ),
                        mode = inValue.each_mode,
                        background_color = background_color,
                        color = inValue.each_color
                    }.PRO_Text3D, inFrameIndex, elementName .. "__" .. index)
                    index = index + 1
                end
            end
            row = row + 1
        end
    elseif inValue.type == "UNIFIED" then
        local index = 1
        while index <= #inValue.texts do
            gprocess.PRO_Text3D(inPresentation, PRO.Text3D {
                t = inValue.texts[index],
                d = inValue.each_d,
                p = inValue.p,
                mode = inValue.each_mode,
                background_color = background_color,
                color = inValue.each_color
            }.PRO_Text3D, inFrameIndex, elementName .. "__" .. index)
            index = index + 1
        end
    elseif inValue.type == "CIRCLE2D" then
        local index = 1
        local offset = inValue.offset
        local r = inValue.radius
        local sin = math.sin
        local cos = math.cos
        local del_theta = 2 * math.pi / #inValue.texts
        local theta = (offset - 1) * del_theta
        while index <= #inValue.texts do
            gprocess.PRO_Text3D(inPresentation, PRO.Text3D {
                t = inValue.texts[index],
                d = inValue.each_d,
                p = vec3(
                    r * sin(theta),
                    r * cos(theta),
                    inValue.p.z
                ),
                mode = inValue.each_mode,
                background_color = background_color,
                color = inValue.each_color
            }.PRO_Text3D, inFrameIndex, elementName .. "__" .. index)
            theta = theta + del_theta
            index = index + 1
        end
    end
end

local text3ds = {}
gprocess.PRO_Text3D = function(inPresentation, inValue, inFrameIndex, inElementName)
    local elementName = gUnique(inElementName)
    local c = inValue.color
    local background_color = inValue.background_color
    if not text3ds[elementName] then
        local elementName_ = elementName .. 0
        text3ds[elementName] = { { inValue, inFrameIndex, elementName_ } }

        inValue.renderer_parameter = mat4(vec4(c.x, c.y, c.z, 1 * c.w), background_color, vec4(0), vec4(0))
        gprocess.PRO_Text3Dbase(inPresentation, inValue, inFrameIndex, elementName_)
    else
        if text3ds[elementName][#text3ds[elementName]][1].t ~= inValue.t then
            text3ds[elementName][#text3ds[elementName]][1].t = inValue.t

            inValue.renderer_parameter = mat4(vec4(c.x, c.y, c.z, 1 * c.w), background_color, vec4(0.0),
                vec4(0.0))

            -- Here, interpolate
            -- Create a Text3Dbase element (different elementName_)
            local elementName_ = elementName .. #text3ds[elementName]
            text3ds[elementName][#text3ds[elementName] + 1] = { inValue, inFrameIndex, elementName_ }

            -- new text at current frame (opacity 1)
            -- new text at previous frame (opacity 0.0)
            inValue.renderer_parameter = mat4(vec4(c.x, c.y, c.z, 1 * c.w), background_color, vec4(0.0),
                vec4(0.0))
            gprocess.PRO_Text3Dbase(inPresentation, inValue, inFrameIndex, elementName_)
            inValue.renderer_parameter = mat4(vec4(c.x, c.y, c.z, 0 * c.w), background_color, vec4(0.0),
                vec4(0.0))
            inValue.r = vec4(0, 1, 0, 360)
            gprocess.PRO_Text3Dbase(inPresentation, inValue, inFrameIndex - 1, elementName_)

            -- old text at current frame (opacity 0.0)
            local eN = text3ds[elementName][#text3ds[elementName] - 1]
            eN[1].renderer_parameter = mat4(vec4(c.x, c.y, c.z, 0 * c.w), background_color, vec4(0.0),
                vec4(0.0))
            eN[1].r = vec4(0, 1, 0, 360)
            gprocess.PRO_Text3Dbase(inPresentation, eN[1], inFrameIndex, eN[3])
        else
            inValue.renderer_parameter = mat4(vec4(c.x, c.y, c.z, 1 * c.w), background_color, vec4(0.0),
                vec4(0.0))
            local elementName_ = elementName .. (#text3ds[elementName] - 1)
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


gprocess.PRO_Text3Dbase = function(inPresentation, inValue, inFrameIndex, inElementName)
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
    -- if not PRO.Text3D_textShader then
    --           local vshader, fshader = Engine.GetAppropriateShader("NORMAL",
    --                     Jkr.CompileContext.Default, nil, nil,
    --                     nil, nil, { baseColorTexture = true })
    --           local simple3did = gworld3d:AddSimple3D(Engine.i, gwindow)
    --           local simple3d = gworld3d:GetSimple3D(simple3did)
    --           simple3d:CompileEXT(
    --                     Engine.i,
    --                     gwindow,
    --                     "cache/test_shader.glsl",
    --                     vshader.str,
    --                     fshader.str,
    --                     "",
    --                     false,
    --                     Jkr.CompileContext.Default
    --           )
    --           Local.Text3D_textShader = {}
    --           Local.Text3D_textShader.simple3did = simple3did
    --           Local.Text3D_textShader.simple3d = simple3d
    -- end
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
                    uniform3d:Build(PRO.cube_ShowImageShader.simple3d)
                    Jkr.RegisterShape2DImageToUniform3D(gwid.st.handle,
                        uniform3d,
                        texts[i].mId.mImgId,
                        3)
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
                uniform3d:Build(PRO.cube_ShowImageShader.simple3d)
                Jkr.RegisterShape2DImageToUniform3D(gwid.st.handle,
                    uniform3d,
                    texts.mId.mImgId,
                    3)
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
            p = inValue.p,
            d = inValue.d,
            r = inValue.r,
            renderer_parameter = inValue.renderer_parameter
        }.Cobj, inFrameIndex, ElementName .. "threed")
    end
end
