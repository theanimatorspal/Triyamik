require "Present.Present"

CTest = function(inCPictureTable)
          local t = {
          }
          return { CTest = Default(inCPictureTable, t) }
end


local test_cube
local test_plane
local test_plane_shadow
local test_cube_shadow
gprocess.CTest = function(inPresentation, inValue, inFrameIndex, inElementName)
          local ElementName       = gUnique(inElementName)
          ---@note Upto here this is test for text on object
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

          test_plane_shadow                     = Jkr.Object3D()
          test_plane_shadow.mAssociatedSimple3D = 0 --This should be shadowing
          test_plane_shadow.mId                 = test_cubeid
          test_plane_shadow.mMatrix             = Jmath.Scale(test_plane_shadow.mMatrix, vec3(1, 0.1, 1))

          test_cube_shadow                      = Jkr.Object3D()
          test_cube_shadow.mAssociatedSimple3D  = 0 --
          test_cube_shadow.mId                  = test_cubeid

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
          -- gshadowobjects3d:add(test_plane)
          gobjects3d:add(test_cube)
end
