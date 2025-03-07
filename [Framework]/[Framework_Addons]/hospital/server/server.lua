RegisterNetEvent('NAT2K15:GETSICKPEOPLE')
AddEventHandler('NAT2K15:GETSICKPEOPLE', function(src) 
    local allplayers = {}
    local num = 0
    for _, player in ipairs(GetPlayers()) do
        player = tonumber(player)
        local playerdata = exports[Config.framework_name]:getdept(player)
        if(playerdata ~= nil) then
            allplayers[num] = {name = GetPlayerName(player), userid = player, char_name = playerdata[player].char_name}
            num = num + 1
        end
    end
    Citizen.Wait(10)
    TriggerClientEvent('NAT2K15:OPENDAHOSTLUI', src, allplayers)
end)


RegisterNetEvent("NAT2K15:HOSPITALUSERCHECK")
AddEventHandler("NAT2K15:HOSPITALUSERCHECK", function(id, length)
    length = tonumber(length)
    if(length > Config.maxtime or length <= 0) then length = Config.maxtime end
    local src = source
    id = tonumber(id)
    local playerstuff = exports[Config.framework_name]:getdept(id)
    if(playerstuff == nil) then return end

    for _, player in ipairs(GetPlayers()) do
        player = tonumber(player)
        local user = id;
        if(player == id) then
            local name = GetPlayerName(player); 
            TriggerClientEvent("NAT2K15:GETHOSPITAL", player, id, length)
            TriggerClientEvent('chatMessage', -1, '^1[DOCTOR]^7', { 0, 0, 0 }, " has Hospitalized " .. name .. " for " .. length .. " seconds")
            exports[Config.framework_name]:sendtothediscord(000000, GetPlayerName(src) .. " [#" .. src .. "]", "Has Hospitalized " .. GetPlayerName(id) .. " [#" .. id .. "] for " .. length .. " seconds!")
        end
    end
end)
