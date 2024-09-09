require("JkrGUIv2.Engine.Engine")
require("JkrGUIv2.Widgets.Basic")

---@diagnostic disable: lowercase-global
gwindow = nil
gwid = nil
gassets = {}
gliterals = {}
gscreenElements = {}
gFontMap = {}
gCurrentKey = 1
gWindowDimension = vec2(0)
gFrameKeys = {}
gbaseDepth = 50


--[============================================================[
          UTILITY FUNCTIONS
]============================================================]

glogError = function(inStr)
          print("=======ERROR======")
          print(inStr)
          print("==================")
end

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

ComputePositionByName = function(inPositionName, inDimension)
          tracy.ZoneBeginN("ComputePositionByName")
          if type(inPositionName) ~= "string" then
                    return inPositionName
          end

          local upDown, leftRight = inPositionName:match("([^_]+)_([^_]+)")

          local xPos, yPos
          if upDown == "TOP" then
                    yPos = 0
          elseif upDown == "CENTER" then
                    yPos = gWindowDimension.y / 2.0 - inDimension.y / 2.0
          elseif upDown == "BOTTOM" then
                    yPos = gWindowDimension.y - inDimension.y
          elseif upDown == "OUT" then
                    yPos = gWindowDimension.y * 2
          else
                    print("Unsupported UPDOWN Type")
          end

          if leftRight == "LEFT" then
                    xPos = 0
          elseif leftRight == "CENTER" then
                    xPos = gWindowDimension.x / 2.0 - inDimension.x / 2.0
          elseif leftRight == "RIGHT" then
                    xPos = gWindowDimension.x - inDimension.x
          elseif leftRight == "OUT" then
                    xPos = gWindowDimension.x * 2
          else
                    print("Unsupported LEFTRIGHT Type")
          end

          tracy.ZoneEnd()
          return vec3(xPos, yPos, gbaseDepth)
end
