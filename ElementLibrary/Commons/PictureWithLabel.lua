require "Present.Present"

CPictureWithLabel = function(inCaptionPictureTable)
          local t = {
                    f    = "Normal",
                    path = -1,
                    p    = vec3(100, 100, 1),
                    d    = vec3(300, 300, 1),
                    tl   = "",
          }
          return { CPictureWithLabel = Default(inCaptionPictureTable, t) }
end

gprocess.CPictureWithLabel = function(inPresentation, inValue, inFrameIndex, inElementName)
          -- Process the picture part
          local text_dimen = gFontMap[inValue.f]:GetTextDimension(inValue.tl)
          local text_x = (inValue.p.x + (inValue.d.x - text_dimen.x) / 2)
          local pic_dimen = vec3(inValue.p.x, inValue.d.y - text_dimen.y, gbaseDepth)
          local pictureElementName = gUnique(inElementName .. "_Picture")
          gprocess.CPicture(inPresentation, CPicture({ pic = inValue.path, p = inValue.p, d = pic_dimen }).CPicture,
                    inFrameIndex, pictureElementName)
          local textElementName = gUnique(inElementName .. "_Label")
          local text_pos = vec3(text_x, inValue.p.y + pic_dimen.y, gbaseDepth)
          gprocess.CText(inPresentation, CText({ t = inValue.tl, p = text_pos }).CText, inFrameIndex, textElementName)
end
