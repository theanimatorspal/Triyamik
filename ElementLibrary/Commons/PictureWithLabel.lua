require "Present.Present"

CPictureWithLabel = function(inCaptionPictureTable)
          local t = {
                    path = -1,
                    p    = vec3(100, 100, gbaseDepth),
                    d    = vec3(400, 300, 1),
                    tl   = "",
                    f    = "Normal",
                    ic   = vec4(1),
                    tc   = vec4(0, 0, 0, 1),
          }
          return { CPictureWithLabel = Default(inCaptionPictureTable, t) }
end

gprocess.CPictureWithLabel = function(inPresentation, inValue, inFrameIndex, inElementName)
          local font_y = gFontMap[inValue.f]:GetTextDimension("Y").y

          local text_dimen = gFontMap[inValue.f]:GetTextDimension(inValue.tl)
          local text_x = (inValue.p.x + (inValue.d.x - text_dimen.x) / 2.0)
          local pic_dimen = vec3(inValue.d.x, inValue.d.y - text_dimen.y, gbaseDepth)
          local pictureElementName = gUnique(inElementName .. "_Picture")
          gprocess.CPicture(inPresentation,
                    CPicture({ pic = inValue.path, p = inValue.p, d = pic_dimen, c = inValue.ic, bc = inValue.ic })
                    .CPicture,
                    inFrameIndex, pictureElementName)
          local textElementName = gUnique(inElementName .. "_Label")
          local text_pos = vec3(text_x, inValue.p.y + pic_dimen.y + font_y / 2, gbaseDepth)
          gprocess.CText(inPresentation, CText({ t = inValue.tl, p = text_pos, c = inValue.tc }).CText, inFrameIndex,
                    textElementName)
end
