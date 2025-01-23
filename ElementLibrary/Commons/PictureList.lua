CPictureList = function(inCPictureList)
    local t = {
        paths = -1,
        p = vec3(100, 100, 1),
        d = vec3(100, 100, 1),
        c = vec4(1),
        index = 1,
    }
    return { CPictureList = Default(inCPictureList, t) }
end

gprocess.CPictureList = function(inPresentation, inValue, inFrameIndex, inElementName)
    local elementName = gUnique(inElementName)
    local paths = inValue.paths
    local index = inValue.i
    local p = inValue.p
    local d = inValue.d
    local c = inValue.c
    if paths ~= -1 then
        for i = 1, #paths do
            local alpha = 0
            if i == index then
                alpha = 1
            end
            gprocess.CPicture(inPresentation, CPicture {
                pic = paths[index],
                p = p,
                d = d,
                c = vec4(c.x, c.y, c.z, c.w * alpha),
                bc = vec4(c.x, c.y, c.z, c.w * alpha)
            }.CPicture, inFrameIndex, elementName .. "__" .. paths)
        end
    end
end
