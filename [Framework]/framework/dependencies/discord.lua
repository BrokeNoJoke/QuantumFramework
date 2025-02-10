if(Config.use_discord) then
    function DiscordRequest(endpoint)
        local data = nil
        PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
            data = {data= resultData, code = errorCode, headers = resultHeaders}
        end, "GET", "", {["Content-Type"] = "application/json", ["Authorization"] = "Bot "..Config_s.bot_token})
    
        while data == nil do
            Citizen.Wait(0)
        end

        return data    
    end
end

