require "Present.Present"

CTest = function(inCPictureTable)
          local t = {
          }
          return { CTest = Default(inCPictureTable, t) }
end


local test_cube
local test_plane
gprocess.CTest = function(inPresentation, inValue, inFrameIndex, inElementName)
          local ElementName = gUnique(inElementName)
          local Gen = Jkr.Generator(Jkr.Shapes.Cube3D, vec3(1, 1, 1))
          local test_cubeid = gshaper3d:Add(Gen, vec3(0, 0, 0))
          local vshader, fshader = Engine.GetAppropriateShader("CONSTANT_COLOR", Jkr.CompileContext.Default, nil, nil,
                    nil, nil, { baseColorTexture = true })
          local simple3did = gworld3d:AddSimple3D(Engine.i, gwindow)
          local simple3d = gworld3d:GetSimple3D(simple3did)
          local uniform3did = gworld3d:AddUniform3D(Engine.i, gwindow)
          local uniform3d = gworld3d:GetUniform3D(uniform3did)
          local text3d = gwid.CreateTextLabel(
                    vec3(math.huge, math.huge, gbaseDepth),
                    vec3(1),
                    gFontMap.Normal,
                    "Label Render")
          print("text3d.mId:", text3d.mId)

          simple3d:CompileEXT(
                    Engine.i,
                    gwindow,
                    "cache/test_shader.glsl",
                    vshader.Print().str,
                    fshader.Print().str,
                    "",
                    false,
                    Jkr.CompileContext.Default
          )

          -- uniform3d:Build(simple3d, )
          test_cube                     = Jkr.Object3D()
          test_cube.mAssociatedSimple3D = simple3did
          test_cube.mId                 = test_cubeid


          ---@note Upto here this is test for text on object
          ---@
          ---@
          ---@
          ---@
          ---@FromHere Test for shadowing
          ---@
          ---@

          local vshader, fshader  = Engine.GetAppropriateShader("CASCADED_SHADOW_DEPTH_PASS")
          local shadow_depth_s3di = gworld3d:AddSimple3D(Engine.i, gwindow)
          local shadow_depth_s3d  = gworld3d:GetSimple3D(shadow_depth_s3di)
          shadow_depth_s3d:CompileEXT(
                    Engine.i,
                    gwindow,
                    "cache/test_shadow_depth_pass_s3d.glsl",
                    vshader.str,
                    fshader.str,
                    "",
                    false,
                    Jkr.CompileContext.ShadowPass
          )

          -- test_cube.mAssociatedSimple3D  = 0 -- This should be Shadower

          test_plane         = Jkr.Object3D()
          -- test_plane.mAssociatedSimple3D = 0 --This should be shadowing
          test_plane.mId     = test_cubeid
          test_plane.mMatrix = Jmath.Scale(test_plane.mMatrix, vec3(1, 0.1, 1))

          gAddFrameKeyElement(inFrameIndex, {
                    {
                              "CTest",
                              handle = gscreenElements[ElementName],
                              value = inValue,
                              name = ElementName
                    }
          })
end

ExecuteFunctions["CTest"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
          gobjects3d:add(test_cube)
end
