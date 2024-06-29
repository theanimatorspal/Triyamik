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
          if inPositionName == "CENTER" then
                    print(inDimension.x / 20, inDimension.y / 20)
                    print(gWindowDimension.x / 20, gWindowDimension.y / 20)
                    return vec3(gWindowDimension.x / 2.0 - inDimension.x / 2.0,
                              gWindowDimension.y / 2.0 - inDimension.y / 2.0,
                              gbaseDepth)
          else
                    return inPositionName
          end
end
