require("JkrGUIv2.Engine.Engine")
require("JkrGUIv2.Widgets.Basic")
require("JkrGUIv2.Widgets.General")

---@diagnostic disable: lowercase-global
--
-- General Stuffs
gwindow = nil
gnwindow = nil
gwid = nil
gassets = {}
gliterals = {}
gscreenElements = {}
gFontMap = {}
gCurrentKey = 1
gWindowDimension = vec2(0)
gFrameKeys = {}
gFrameKeysCompute = {}
gbaseDepth = 50
gFrameCount = 0
gPresentationUseArrowToSwitchSlides = true
gFrameDimension = vec2(1920 / 2, 1080 / 2)
gNFrameDimension = vec2(1920 / 2, 1080 / 2)
gCurrentScissorsTobeDrawn = Jkr.Table(100, 0)

-- 3d Stuffs
gworld3dS = {}
gworld3dS["default"] = {}
gworld3d = nil
gshaper3d = nil
gobjects3d = nil
gcamera3d = nil

-- 3d stuffs for nowindow
gnworld3d = nil
gnshaper3d = nil
gnobjects3d = nil
gncamera3d = nil

--[============================================================[
          MAINLOOP FUNCTIONS
]============================================================]
MainLoop = function(w, e, shouldRun, inDontRunWindowLoop, Update, Dispatch, Draw, MultiThreadedDraws,
                    MultiThreadedExecute)
end


--[============================================================[
          UTILITY FUNCTIONS
]============================================================]

glogError = function(inStr)
          print("=======ERROR======")
          print(inStr)
          print("==================")
end

gSetInterpolationType = function(inType)
          if inType == "QUADLINEAR" then
                    glerp = function(a, b, t)
                              return (a * (1 - t) + t * b) * (1 - t) + b * t
                    end

                    glerp_2f = function(a, b, t)
                              return vec2(glerp(a.x, b.x, t), glerp(a.y, b.y, t))
                    end

                    glerp_3f = function(a, b, t)
                              return vec3(glerp(a.x, b.x, t), glerp(a.y, b.y, t), glerp(a.z, b.z, t))
                    end

                    glerp_4f = function(a, b, t)
                              return vec4(glerp(a.x, b.x, t), glerp(a.y, b.y, t), glerp(a.z, b.z, t), glerp(a.w, b.w, t))
                    end
          elseif inType == "LINEAR" then
                    glerp = function(a, b, t)
                              return a * (1 - t) + t * b
                    end

                    glerp_2f = function(a, b, t)
                              return vec2(glerp(a.x, b.x, t), glerp(a.y, b.y, t))
                    end

                    glerp_3f = function(a, b, t)
                              return vec3(glerp(a.x, b.x, t), glerp(a.y, b.y, t), glerp(a.z, b.z, t))
                    end

                    glerp_4f = function(a, b, t)
                              return vec4(glerp(a.x, b.x, t), glerp(a.y, b.y, t), glerp(a.z, b.z, t), glerp(a.w, b.w, t))
                    end
          end
end

gSetInterpolationType("QUADLINEAR")


-- -- Test for performance
-- glerp = Jmath.Lerp
-- glerp_2f = Jmath.Lerp
-- glerp_3f = Jmath.Lerp
-- glerp_4f = Jmath.Lerp

ComputePositionByName = function(inPositionName, inDimension)
          -- --tracy.ZoneBeginN("ComputePositionByName")
          if type(inPositionName) ~= "string" then
                    return inPositionName
          end

          local upDown, leftRight = inPositionName:match("([^_]+)_([^_]+)")

          local xPos, yPos
          if upDown == "TOP" then
                    yPos = 0
          elseif upDown == "CENTER" then
                    yPos = gFrameDimension.y / 2.0 - inDimension.y / 2.0
          elseif upDown == "BOTTOM" then
                    yPos = gFrameDimension.y - inDimension.y
          elseif upDown == "OUT" then
                    yPos = gFrameDimension.y * 2
          else
                    print("Unsupported UPDOWN Type")
          end

          if leftRight == "LEFT" then
                    xPos = 0
          elseif leftRight == "CENTER" then
                    xPos = gFrameDimension.x / 2.0 - inDimension.x / 2.0
          elseif leftRight == "RIGHT" then
                    xPos = gFrameDimension.x - inDimension.x
          elseif leftRight == "OUT" then
                    xPos = gFrameDimension.x * 2
          else
                    print("Unsupported LEFTRIGHT Type")
          end

          -- --tracy.ZoneEnd()
          return vec3(xPos, yPos, gbaseDepth)
end


function IterateEachFrame(inPresentation, infunc_int_val)
          local frameindex = 1
          for _, elements in ipairs(inPresentation) do
                    for __, value in pairs(elements) do
                              if (__ == "Frame") then
                                        infunc_int_val(frameindex, value)
                                        frameindex = frameindex + 1
                              end
                    end
          end
          gFrameCount = frameindex
end
