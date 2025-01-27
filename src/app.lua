require "ElementLibrary.Commons.Commons"
do
    local runApp = true
    local bc = vec4(1, 0.5, 0, 0.5)
    local c = vec4(0, 0, 0, 1)
    local Configuration = gGetPresentationWithDefaultConfiguration()
    local Validation = true
    local CurrentLoopType = "GeneralLoop"
    Configuration.Config.FullScreen = false
    gPresentation(Configuration, Validation, "NoLoop")

    local Lay = function(layout)
        return CLayout { layout = layout }
    end
    local ButtonBarString = function(to, ts, tu, co, cs, cu)
        return string.format("[o, s, u] -> Total [%d, %d, %d], Current [%d, %d, %d]", to, ts, tu, co, cs, cu)
    end
    local ExitElement = function()
        return
            Lay(V({
                H({
                    U(),
                    U { t = "Exit", f = "Huge",
                        p = "RIGHT_TOP", c = c,
                        bc = bc, en = "ExitButton",
                        onclick = function()
                            gEndPresentation(true)
                            runApp = false
                        end
                    }
                }, { 0.8, 0.2 }),
                U()
            }, { 0.1, 0.8, 0.1 }))
    end

    local index = "Start"
    local function CreateNew()
        gEndPresentation(true)
        index = "CreateNew"
    end

    Pages = {
        Start = { Frame {
            Lay(V({ U(), H({
                U {
                    t = "Create New",
                    f = "Huge",
                    bc = bc,
                    en = "CreateNewButton",
                    onclick = CreateNew,
                },
                U { t = "Open Existing",
                    f = "Huge",
                    bc = bc,
                    en = "OpenExistingButton",
                    onclick = function()
                        gEndPresentation()
                        runApp = false
                    end }
            }, { 0.5, 0.5 }), U() }, { 0.25, 0.5, 0.25 })) } },
        CreateNew = {
            Frame {
                ExitElement(),
                Lay(V({}, { 0.1, 0.9 })),
                Lay(V({ U(), H(
                    { U { t = ButtonBarString(0, 0, 0, 0, 0, 0), f = "Small", bc = bc, en = "ButtomBarButton" } }, { 1.0 }
                ) }, { 0.9, 0.1 }))
            }
        }
    }

    while runApp do
        gPresentation(Pages[index], Validation, CurrentLoopType)
    end
end
