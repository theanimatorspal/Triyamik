require "ElementLibrary.Commons.Commons"
do
          local runApp = false
          local bc = vec4(1, 0.5, 0, 0.5)
          local c = vec4(0, 0, 0, 1)
          local Configuration = DefaultPresentation()
          local Validation = true
          Configuration.Config.FullScreen = false
          gPresentation(Configuration, Validation, true)

          local index = 1
          local Pages = { { Frame { CLayout { layout = V({ U(), H({
                    U {
                              t = "Create New",
                              f = "Huge",
                              bc = bc,
                              en = "CreateNewButton",
                              onclick = function()
                                        CButtonUpdate("CreateNewButton", nil, nil, "Hello",
                                                  nil, c, bc)
                              end,
                    },
                    U { t = "Open Existing",
                              f = "Huge",
                              bc = bc,
                              en = "OpenExistingButton",
                              onclick = function()
                                        gEndPresentation()
                                        runApp = false
                              end }
          }, { 0.5, 0.5 }), U() }, { 0.25, 0.5, 0.25 }), } } } }
          -- while runApp do
          gPresentation(Pages[index], Validation, false)
          -- end
end
