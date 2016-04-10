local M = {
    pinConfig = {
        m1a=8,
        m1b=7,
        m1e=3,
        m2a=4,
        m2b=6,
        m2e=5,
        aux=0
    },
    port=6666,
    blinkC=0
}

function M.drive(m1, m2)
    if m1>0 then
        gpio.write(M.pinConfig.m1a,gpio.HIGH)
        gpio.write(M.pinConfig.m1b,gpio.LOW)
        pwm.setduty(M.pinConfig.m1e, m1)
    elseif m1<0 then
        gpio.write(M.pinConfig.m1a,gpio.LOW)
        gpio.write(M.pinConfig.m1b,gpio.HIGH)
        pwm.setduty(M.pinConfig.m1e, -m1)
    else
        gpio.write(M.pinConfig.m1a,gpio.HIGH)
        gpio.write(M.pinConfig.m1b,gpio.HIGH)
        pwm.setduty(M.pinConfig.m1e, 0)
    end

    if m2>0 then
        gpio.write(M.pinConfig.m2a,gpio.HIGH)
        gpio.write(M.pinConfig.m2b,gpio.LOW)
        pwm.setduty(M.pinConfig.m2e, m2)
    elseif m2<0 then
        gpio.write(M.pinConfig.m2a,gpio.LOW)
        gpio.write(M.pinConfig.m2b,gpio.HIGH)
        pwm.setduty(M.pinConfig.m2e, -m2)
    else
        gpio.write(M.pinConfig.m2a,gpio.HIGH)
        gpio.write(M.pinConfig.m2b,gpio.HIGH)
        pwm.setduty(M.pinConfig.m2e, 0)
    end
end

function M.aux(on)
    if on then
        gpio.write(M.pinConfig.aux, gpio.HIGH)
    else
        gpio.write(M.pinConfig.aux, gpio.LOW)
    end
end

function M.stop()
    if M.server then
        M.server:close()
        M.server = nil
    end
end

function M.blink(count, delay)
    M.blinkC = count
    if count>0 then
        M.aux(true)
        tmr.alarm(2,delay,tmr.ALARM_SINGLE, function()
            M.aux(false)
            tmr.alarm(3,delay,tmr.ALARM_SINGLE, function ()
                M.blink(count-1, delay)
            end)
        end)
    end
end

function M.start()
    M.stop()
    
    for k,v in pairs(M.pinConfig) do
        gpio.mode(v, gpio.OUTPUT)
        gpio.write(v, gpio.LOW)
    end

    pwm.setup(M.pinConfig.m1e, 100, 0)
    pwm.setup(M.pinConfig.m2e, 100, 0)

    M.server = net.createServer(net.UDP)
    M.server:on("receive", function(srv, pl)
        local m1,m2,aux = pl:match("^A([0-9A-F][0-9A-F][0-9A-F])([0-9A-F][0-9A-F][0-9A-F])(%d)$")
        if m1 == nil then
            return
        end

        m1 = tonumber(m1, 16)
        m2 = tonumber(m2, 16)
        aux = tonumber(aux)

        if m1>2046 then m1=1023 else m1=m1-1023 end
        if m2>2046 then m2=1023 else m2=m2-1023 end

        M.drive(m1,m2)
        if M.blinkC == 0 then
            M.aux(aux ~= 0)
        end
    end)
    M.server:listen(M.port)
end

return M
