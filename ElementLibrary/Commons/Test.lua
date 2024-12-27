require "Present.Present"

CTest = function(inCPictureTable)
          local t = {
          }
          return { CTest = Default(inCPictureTable, t) }
end


local test_cubeid
local test_cube
local test_plane
local test_plane_shadow
local test_cube_shadow
gprocess.CTest = function(inPresentation, inValue, inFrameIndex, inElementName)
          local ElementName       = gUnique(inElementName)
          local Gen               = Jkr.Generator(Jkr.Shapes.Cube3D, vec3(1, 1, 1))
          local test_cubeid       = gshaper3d:Add(Gen, vec3(0, 0, 0))
          ---@FromHere Test for shadowing

          local vshader, fshader  = Engine.GetAppropriateShader("CASCADED_SHADOW_DEPTH_PASS")
          local shadow_depth_s3di = gworld3d:AddSimple3D(Engine.i, gwindow)
          local shadow_depth_s3d  = gworld3d:GetSimple3D(shadow_depth_s3di)
          -- Jkr.DebugBreak()
          shadow_depth_s3d:CompileEXT(
                    Engine.i,
                    gwindow,
                    "cache/test_shadow_depth_pass_s3d.glsl",
                    vshader.Print().str,
                    fshader.Print().str,
                    "",
                    false,
                    Jkr.CompileContext.ShadowPass
          )

          -- test_cube.mAssociatedSimple3D  = 0 -- This should be Shadower

          test_plane_shadow                     = Jkr.Object3D()
          test_plane_shadow.mAssociatedSimple3D = shadow_depth_s3di --This should be shadowing
          test_plane_shadow.mId                 = test_cubeid
          test_plane_shadow.mMatrix             = Jmath.Scale(test_plane_shadow.mMatrix, vec3(1, 0.1, 1))
          test_cube_shadow                      = Jkr.Object3D()
          test_cube_shadow.mAssociatedSimple3D  = shadow_depth_s3di --
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
          gshadowobjects3d:add(test_cube_shadow)
          gshadowobjects3d:add(test_plane_shadow)
          -- gobjects3d:add(test_cube)
end
