net = Engine.net
net.Server()

function Start()
          net.BroadCast(
                    function()
                              Jkr.ShowToastNotification("Server has seen you")
                    end
          )
end
