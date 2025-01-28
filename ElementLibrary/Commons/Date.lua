CDate = function(inTable)
          local t = {
                    p = vec3(100, 100, 1), -- Starting position
                    year = 2000,
                    month = 1,
                    day = 1,
                    c = vec4(gcolors.electricblue, 1), -- Text color
                    f = "Normal"                       -- Font
          }
          return { CDate = Default(inTable, t) }
end


gprocess.CDate = function(inPresentation, inValue, inFrameIndex, inElementName)
          local elementName = gUnique(inElementName)
          local months = { "Baishakh", "Jestha", "Ashadh", "Shrawan", "Bhadra", "Ashwin",
                    "Kartik", "Mangsir", "Poush", "Magh", "Falgun", "Chaitra" } -- Nepali months

          local years = {}
          for y = 2070, 2090 do table.insert(years, tostring(y)) end

          local days = {}
          for d = 1, 32 do table.insert(days, tostring(d)) end

          local yearIndex = inValue.year - 2070 + 1
          local monthIndex = inValue.month -- Month index (1 to 12)
          local dayIndex = inValue.day     -- Day index

          local yearPos = vec3(inValue.p.x, inValue.p.y, inValue.p.z)
          local monthPos = vec3(inValue.p.x + 150, inValue.p.y, inValue.p.z) -- Offset right
          local dayPos = vec3(inValue.p.x + 300, inValue.p.y, inValue.p.z)   -- Further right

          gprocess.CTextList(inPresentation, {
                    type = "HORIZONTAL",
                    texts = years,
                    index = yearIndex,
                    p = yearPos,
                    c = inValue.c,
          }, inFrameIndex, elementName .. "_year")

          gprocess.CTextList(inPresentation, {
                    type = "VERTICAL",
                    texts = months,
                    index = monthIndex,
                    p = monthPos,
                    c = inValue.c,
          }, inFrameIndex, elementName .. "_month")

          gprocess.CTextList(inPresentation, {
                    type = "HORIZONTAL",
                    texts = days,
                    index = dayIndex,
                    p = dayPos,
                    c = inValue.c,
          }, inFrameIndex, elementName .. "_day")
end
