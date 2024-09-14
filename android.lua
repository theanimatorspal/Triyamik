net = Engine.net
net.Server()

function Start()
          net.BroadCast(
                    function()
                              Jkr.ShowToastNotification("Server has seen you, Detaching...")
                              gwr = Jkr.CreateGeneralWidgetsRenderer(nil, Engine.i, w, e)
                    end
          )
end

function Stop()
end
