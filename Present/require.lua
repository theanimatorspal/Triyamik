require("JkrGUIv2.Engine.Engine")
require("JkrGUIv2.WidgetsRefactor")

---@diagnostic disable: lowercase-global
gwindow = {}
gwid = {}
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

glerp = function(a, b, t)
          return (a * (1 - t) + t * b) * (1 - t) + b * t
end

glerp_3f = function(a, b, t)
          return vec3(glerp(a.x, b.x, t), glerp(a.y, b.y, t), glerp(a.z, b.z, t))
end

ComputePositionByName = function(inPositionName, inDimension)
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
          end

          if leftRight == "LEFT" then
                    xPos = 0
          elseif leftRight == "CENTER" then
                    xPos = gWindowDimension.x / 2.0 - inDimension.x / 2.0
          elseif leftRight == "RIGHT" then
                    xPos = gWindowDimension.x - inDimension.x
          end

          return vec3(xPos, yPos, gbaseDepth)
end
