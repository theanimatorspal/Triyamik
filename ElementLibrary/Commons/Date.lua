CDate = function(inTable)
          local t = {
                    p = vec3(100, 100, 1),
                    year = 2070,
                    month = 1,
                    day = 1,
                    c = vec4(gcolors.red, 1),
                    f = "Normal"
          }
          return { CDate = Default(inTable, t) }
end


gprocess.CDate = function(inPresentation, inValue, inFrameIndex, inElementName)
          local elementName = gUnique(inElementName)
          local months = { "Baishakh", "Jestha", "Ashadh", "Shrawan", "Bhadra", "Ashwin",
                    "Kartik", "Mangsir", "Poush", "Magh", "Falgun", "Chaitra" }

          local years = {}
          for y = 2070, 2090 do table.insert(years, tostring(y)) end

          local days = {}
          for d = 1, 32 do table.insert(days, tostring(d)) end

          local yearIndex = inValue.year - 2070 + 1
          local monthIndex = inValue.month
          local dayIndex = inValue.day
          local yearPos = vec3(inValue.p.x, inValue.p.y, inValue.p.z)
          local monthPos = vec3(inValue.p.x + 150, inValue.p.y, inValue.p.z)
          local dayPos = vec3(inValue.p.x + 300, inValue.p.y, inValue.p.z)

          gprocess.CTextList(inPresentation, CTextList {
                    index = yearIndex,
                    type = "HORIZONTAL",
                    texts = years,
                    p = yearPos,
                    c = inValue.c,
          }.CTextList, inFrameIndex, elementName .. "_year")

          gprocess.CTextList(inPresentation, CTextList {
                    index = monthIndex,
                    type = "VERTICAL",
                    texts = months,
                    p = monthPos,
                    c = inValue.c,
          }.CTextList, inFrameIndex, elementName .. "_month")

          gprocess.CTextList(inPresentation, CTextList {
                    index = dayIndex,
                    type = "HORIZONTAL",
                    texts = days,
                    p = dayPos,
                    c = inValue.c,
          }.CTextList, inFrameIndex, elementName .. "_day")
end
