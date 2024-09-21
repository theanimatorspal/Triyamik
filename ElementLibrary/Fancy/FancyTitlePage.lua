require "ElementLibrary.Fancy.FancyRequire"

FancyTitlePage = function(inTitlePage)
          local t = {
                    t = "JkrGUIv2",
                    st = "shitty bull",
                    names = {
                              "Name A",
                              "Name B",
                              "Name C"
                    },
                    left = "", -- OR "filepath"
                    act = "add",
                    logo = -1,
          }
          return { FancyTitlePage = Default(inTitlePage, t) }
end

gTitlePageData = {}
gTitle = ""
gprocess["FancyTitlePage"] = function(inPresentation, inValue, inFrameIndex, inElementName)
          if inValue.act == "add" then
                    gTitle = inValue.t
                    local Push = PC(
                              vec4(0.0, 0.0, 0.5, 0.5),
                              vec4(1),
                              vec4(0.8, 0.5, 0.5, 0.0),
                              vec4(0)
                    )
                    local background = {
                              t = " ",
                              p = vec3(0, 0, gbaseDepth),
                              d = vec3(gFrameDimension.x + 80, gFrameDimension.y + 80, 1),
                              bc = background_color,
                              _push_constant = FullPC
                    }
                    gprocess.FancyButton(inPresentation, FancyButton(background).FancyButton, inFrameIndex,
                              "__fancy__background")
                    local t = U({
                              f = "Huge",
                              t = inValue.t,
                              _push_constant = Push,
                              bc = transparent_color,
                    })
                    local st = U({
                              f = "Large",
                              t = inValue.st,
                              _push_constant = Push,
                              bc = transparent_color,
                    })
                    local names = { U() }
                    for _, value in pairs(inValue.names) do
                              names[#names + 1] = U({
                                        t = value,
                                        bc = transparent_color,
                                        _push_constant = StrechedPC
                              })
                    end
                    local namesratio = { 0.3, UPK(CR(names, 1 - 0.3)) }

                    local logo = U({
                              pic = inValue.logo
                    })

                    V():Add({
                              U(),
                              t,
                              st,
                              H():Add({
                                                  logo, -- esma logo halne ho
                                                  V():Add(names, namesratio),
                                        },
                                        { 0.5, 0.5 }),
                              U()
                    }, { 0.1, 0.2, 0.1, 0.4, 0.1 }
                    ):Update(vec3(0, 0, gbaseDepth), vec3(gFrameDimension.x, gFrameDimension.y, 1))

                    if logo.pic == -1 then
                              logo.pic = nil
                    end

                    gprocess.FancyPicture(inPresentation, FancyPicture(logo).FancyPicture, inFrameIndex,
                              "__fancy_titlepage_logo")

                    gprocess.FancyButton(inPresentation, FancyButton(t).FancyButton, inFrameIndex,
                              "__fancy_titlepage_title")
                    gprocess.FancyButton(inPresentation, FancyButton(st).FancyButton, inFrameIndex,
                              "__fancy_titlepage_sub_title")

                    for i = 1, #names - 1, 1 do
                              gprocess.FancyButton(inPresentation, FancyButton(names[i + 1]).FancyButton, inFrameIndex,
                                        "__fancy__name__" .. i)
                    end
                    gTitlePageData.names = Copy(names)
                    gTitlePageData.t = Copy(t)
                    gTitlePageData.st = Copy(st)
          elseif inValue.act == "remove" then
                    gTitlePageData.t.p = "CENTER_OUT"
                    gTitlePageData.st.p = "CENTER_OUT"
                    gprocess.FancyButton(inPresentation, FancyButton(gTitlePageData.t).FancyButton, inFrameIndex,
                              "__fancy_titlepage_title")
                    gprocess.FancyButton(inPresentation, FancyButton(gTitlePageData.st).FancyButton, inFrameIndex,
                              "__fancy_titlepage_sub_title")

                    for i = 1, #gTitlePageData.names - 1, 1 do
                              gTitlePageData.names[i + 1].p = "OUT_CENTER"
                              gprocess.FancyButton(inPresentation, FancyButton(gTitlePageData.names[i + 1]).FancyButton,
                                        inFrameIndex,
                                        "__fancy__name__" .. i)
                    end
          elseif inValue.act == "structure" then
                    local t = U(Copy(gTitlePageData.t))
                    local st = U(Copy(gTitlePageData.st))
                    local names = Copy(gTitlePageData.names)
                    table.remove(names, 1)
                    t.f = "Small"
                    t.bc = very_transparent_color
                    st.p = "OUT_OUT"
                    t.p = "OUT_OUT"
                    for i = 1, #names, 1 do
                              names[i].f = "Small"
                              names[i].bc = very_transparent_color
                    end
                    for i = 1, #names, 1 do
                              names[i] = U(names[i])
                    end

                    local namesratio = CR(#names, 1 - 0.3)
                    local logo = U({})

                    V():Add({
                              U(),
                              H():Add(names, namesratio),
                    }, { 0.93, 0.07 }):Update(
                              vec3(0, 0, gbaseDepth),
                              vec3(gFrameDimension.x, gFrameDimension.y, 1)
                    )
                    logo.d = vec3(100, 100, 1)
                    logo.p = ComputePositionByName("BOTTOM_RIGHT", logo.d)
                    logo.c = vec4(0.1)
                    logo.bc = vec4(0.4)

                    gprocess.FancyPicture(inPresentation, FancyPicture(logo).FancyPicture, inFrameIndex,
                              "__fancy_titlepage_logo")

                    gprocess.FancyButton(inPresentation,
                              FancyButton(t).FancyButton,
                              inFrameIndex,
                              "__fancy_titlepage_title")
                    gprocess.FancyButton(inPresentation,
                              FancyButton(st).FancyButton,
                              inFrameIndex,
                              "__fancy_titlepage_sub_title")



                    for i = 1, #names, 1 do
                              gprocess.FancyButton(inPresentation,
                                        FancyButton(names[i]).FancyButton,
                                        inFrameIndex,
                                        "__fancy__name__" .. i)
                    end
          end
end
