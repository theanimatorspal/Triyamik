require "ElementLibrary.Commons.Require"

CGrid = function(inTable)
    local t = {
        should_mark = false,
        mark_size = 1,
        mark_list = { vec2(5, 3) },
        mark_color = vec4(gcolors.red, 1),
        mark_line_color = vec4(gcolors.blue, 1),
        p = vec3(100, 100, gbaseDepth),
        d = vec3(100, 100, 1),
        cd = vec3(100, 100, 1),
        x_count = 20,
        y_count = 20,
        c = vec4(1, 0, 0, 1),
        t = 2,
    }
    return { CGrid = Default(inTable, t) }
end

gprocess.CGrid = function(inPresentation, inValue, inFrameIndex, inElementName)
    local elementName = gUnique(inElementName)
    local p = inValue.p
    local d = inValue.d
    local x_count = inValue.x_count
    local y_count = inValue.y_count
    local c = inValue.c
    local cd = inValue.cd
    local mark_list = inValue.mark_list
    local mark_color = inValue.mark_color
    local mark_size = inValue.mark_size
    local mark_line_color = inValue.mark_line_color

    gprocess.CComputeImage(inPresentation, CComputeImage {
        p = p,
        d = d,
        cd = cd,
        mat1 = mat4(
            vec4(x_count, y_count, inValue.t, 1),
            vec4(c),
            vec4(0),
            vec4(0)
        ),
        mat2 = Jmath.GetIdentityMatrix4x4(),
        mark_list = mark_list,
    }.CComputeImage, inFrameIndex, elementName)

    local computeImages, computePainters = CComputeImagesGet()
    local cmd = Jkr.CmdParam.None
    local element = computeImages[elementName]

    element[1] = function(mat1, mat2, X, Y, Z, prev, new, t_)
        local shader = computePainters["CLEAR"]
        shader:Bind(gwindow, cmd)
        element.cimage.BindPainter(shader)
        shader:Draw(gwindow, PC_Mats(
            mat4(0.0),
            mat4(0.0)
        ), X, Y, Z, cmd)

        local shader = computePainters["LINE2D"]
        shader:Bind(gwindow, cmd)
        element.cimage.BindPainter(shader)

        local x_count          = mat1[1].x
        local y_count          = mat1[1].y
        local c                = mat1[2]
        local t                = mat1[1].z
        local del_y            = cd.y / y_count
        local del_x            = cd.x / x_count
        local mark             = vec2(math.floor(mat1[3].x), math.floor(mat1[3].y))
        local offsetx, offsety = del_x / 2, del_y / 2
        local x                = offsetx
        local y                = offsety
        local prev_mark_list   = prev.mark_list
        local new_mark_list    = new.mark_list
        local min_len          = 0
        if inValue.should_mark then
            if #prev_mark_list <= #new_mark_list then
                min_len = #prev_mark_list
            else
                min_len = #new_mark_list
            end

            -- local inter_c = glerp_4f(prev.c, new.c, t_)
            -- local inter_t = glerp(prev.t, new.t, t_)
            for i = 1, min_len do
                local mark1      = prev_mark_list[i]
                local mark2      = new_mark_list[i]
                local inter_mark = glerp_2f(mark1, mark2, t_)
                inter_mark.x     = math.floor(inter_mark.x)
                inter_mark.y     = math.floor(inter_mark.y)
                local mark_vec4  =
                    vec4(x + del_x * (inter_mark.x - 1) + offsetx,
                        y + del_y * (inter_mark.y - 1) + offsety,
                        x + del_x * (inter_mark.x - 1) + offsetx,
                        y + del_y * (inter_mark.y - 1) + offsety)
                shader:Draw(gwindow, PC_Mats(
                    mat4(mark_vec4,
                        mark_color, vec4(del_x * mark_size),
                        vec4(0)),
                    mat2
                ), X, Y, Z, cmd)
            end
            --   shader:Draw(gwindow, PC_Mats(mat4(inter_line, inter_c, vec4(inter_t), vec4(0)), mat2), X, Y,
            --             Z,
            --             cmd)
        end
        x = offsetx
        y = offsety
        for i = 1, x_count do
            local color = vec4(c)
            if i == mark.x and inValue.should_mark then
                color = mark_line_color
            end

            shader:Draw(gwindow, PC_Mats(
                mat4(vec4(x, 0, x, cd.y), color, vec4(t), vec4(0)),
                mat2
            ), X, Y, Z, cmd)

            x = x + del_x
        end

        for i = 1, y_count do
            local color = vec4(c)
            if i == mark.y and inValue.should_mark then
                color = mark_line_color
            end
            shader:Draw(gwindow, PC_Mats(
                mat4(vec4(0, y, cd.x, y), color, vec4(t), vec4(0)),
                mat2
            ), X, Y, Z, cmd)
            y = y + del_y
        end


        element.cimage.handle:SyncAfter(gwindow, cmd)
        element.cimage.CopyToSampled(element.sampled_image)
    end
end
