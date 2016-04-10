if wifi.getmode() ~= wifi.SOFTAP then
    wifi.ap.config({ssid="Auto!",pwd="jedemjedem",max=1})
    wifi.setmode(wifi.SOFTAP)
end

local auto = require("auto")
auto.start()

wifi.eventmon.register(wifi.eventmon.AP_STACONNECTED, function(T)
  print("Connected "..T.MAC)

  auto.blink(3,100)
end)

wifi.eventmon.register(wifi.eventmon.AP_STADISCONNECTED, function(T) 
  print("Disconnected "..T.MAC)
  
  auto.drive(0,0)
  auto.aux(false)
end)
