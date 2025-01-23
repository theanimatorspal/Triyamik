CPictureList = function(inCPictureList)
    local t = {
        path = -1,
        p = vec3(100, 100, 1),
        d = vec3(100, 100, 1),
        i = 1,
    }
    return { CPictureList = Default(inCPictureList, t) }
end

gprocess.CPictureList = function(inPresentation, inValue, inFrameIndex, inElementName)
    local pictureElementName = gUnique(inElementName)
          
          end

