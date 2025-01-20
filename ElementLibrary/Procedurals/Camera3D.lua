require "ElementLibrary.Procedurals.Require"

PRO.Camera3D = function(inText3DTable)
          local t = {
                    t = vec3(0),
                    e = vec3(0, 0, -2),
                    fov = 45.0,
                    aspect = 16 / 9,
                    near = 0.001,
                    far = 1000,
                    projection = mat4(0.0),
                    view = mat4(0.0)
          }
          return { PRO_Camera3D = Default(inText3DTable, t) }
end


local camera3d = nil
local camera3did = nil
gprocess.PRO_Camera3D = function(inPresentation, inValue, inFrameIndex, inElementName)
          if not camera3d then
                    camera3did = gworld3d:AddCamera(Jkr.Camera3D())
                    camera3d = gworld3d:GetCamera3D(camera3did)
                    gworld3d:SetCurrentCamera(camera3did)
          end
          local t = inValue.t
          local e = inValue.e
          local d = Jmath.Normalize(t - e)
          local u = vec3(0, 1, 0)
          local r = Jmath.Normalize(Jmath.Cross(u, d))
          local cu = Jmath.Normalize(Jmath.Cross(d, r))
          inValue.view = Jmath.LookAt(e, e + d, cu)
          inValue.projection = Jmath.Perspective(inValue.fov * 180.0 / math.pi, inValue.aspect, inValue.near, inValue
                    .far)
          gAddFrameKeyElement(inFrameIndex, {
                    {
                              "PRO_Camera3D",
                              handle = gcamera3d,
                              value = inValue,
                              name = inElementName
                    }
          })
end

ExecuteFunctions["PRO_Camera3D"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
          gworld3d:SetCurrentCamera(camera3did)
          local PreviousElement, inElement = GetPreviousFrameKeyElementD(inPresentation, inElement,
                    inFrameIndex, inDirection)
          local new = inElement.value
          if PreviousElement then
                    local prev             = PreviousElement.value
                    local inter_projection = glerp_mat4f(prev.projection, new.projection, t)
                    local inter_view       = glerp_mat4f(prev.view, new.view, t)
                    camera3d:SetProjectionMatrix(inter_projection)
                    camera3d:SetViewMatrix(inter_view)
          else
                    camera3d:SetProjectionMatrix(new.projection)
                    camera3d:SetViewMatrix(new.view)
          end
end
