require "ElementLibrary.Procedurals.Require"

PRO.Shape = function(inTable)
    local t = {
        type = "CUBE3D", -- "GLTF" | "SPHERE3D"
        compute_texture = -1,
        p = vec3(0),
        d = vec3(1),
        r = vec4(1, 1, 1, 1),
        -- renderer_parameter = mat4(0),
        renderer_parameter = mat4(vec4(1, 1, 1, 1), vec4(0), vec4(0), vec4(0)),
        sidedness = "FOURSIDED"
    }
    return { PRO_Shape = Default(inTable, t) }
end

gprocess.PRO_Shape = function(inPresentation, inValue, inFrameIndex, inElementName)
    PRO.CompileShaders()

    local elementName = gUnique(inElementName)
    local p = inValue.p
    local d = inValue.d
    local r = inValue.r
    local compute_texture = inValue.compute_texture
    local renderer_parameter = inValue.renderer_parameter
    if inValue.type == "CUBE3D" then
        if compute_texture ~= -1 then
            local computeImages, computePainters = CComputeImagesGet()
            local element = computeImages[compute_texture]
            gprocess.Cobj(inPresentation, Cobj {
                load = function()
                    local uniform3did = gworld3d:AddUniform3D(Engine.i, gwindow)
                    local uniform3d = gworld3d:GetUniform3D(uniform3did)
                    uniform3d:Build(PRO.cube_ShowImageShader.simple3d)

                    Jkr.RegisterShape2DImageToUniform3D(
                        gwid.s.handle,
                        uniform3d,
                        element.sampled_image.mId,
                        3
                    )
                    -- Jkr.RegisterShape2DImageToUniform3D(gwid.st.handle,
                    --           uniform3d,
                    --           texts[i].mId.mImgId,
                    --           3)

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
                r = r,
                camera_control = "EDITOR_MOUSE",
            }.Cobj, inFrameIndex, elementName)
        end
    end
end
