-- NUI callback for deleting a user --
RegisterNUICallback("DeleteCharacter", function(data)
    TriggerServerEvent("NAT2K15:DELETEUSER", data)
end)
  
-- NUI callback for the refresh button --
RegisterNUICallback("Refresh", function(data)
    TriggerServerEvent("NAT2K15:UIREFRESH", Framework.serverId)
end)
  
-- NUI callback for nui create character
RegisterNUICallback("CreateCharacter", function(data)
    TriggerServerEvent("NAT2K15:CREATECHARCTER", data.first_name, data.last_name, data.twt, data.gender, data.dob, data.dept, data)
end)
  
-- Disconnct button -- 
RegisterNUICallback("Disconnct", function(data)
    TriggerServerEvent("NAT2K15:DISCONNECTBUTTON")
end)
  
  
-- NUI callabacks to edit the player --
RegisterNUICallback("EditCharacter", function(data) 
    TriggerServerEvent("NAT2K15:EDITCHARCTER", data.first_name, data.last_name,  data.twt, data.gender, data.dob, data.chid, data.dept, data.old_first, data.old_last, data)
end)
  
  -- NUI callback play as a player --
RegisterNUICallback("PlayCharacter", function(data, tel)
    DoScreenFadeIn(0)
    Framework.loadedIn = true
    local playerCoords = GetEntityCoords(GetPlayerPed(-1))
    local spawns = {x = data.spawn.x, y = data.spawn.y, z = data.spawn.z, h = data.spawn.h}
    data.lastSpawn = playerCoords
    Framework.freeze()
    unfreeze(data.cloud, data.gender, data.dept, data.telp, spawns)
    Citizen.Wait(1000)
    if(Config.characterSettings.onPlayMessageSize) then
        TriggerEvent("chat:addMessage", {template = '<div style="padding: 0.5vw; text-align: center; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><b>{0}</b></div>', args = {"You are now playing as " .. data.first_name .. " " .. data.last_name .. " (" .. data.dept .. ")"}})
    else 
        TriggerEvent('chat:addMessage', {
        template = '<div id="message"><b> ^7You are now playing as {0} ({1})</div>',
        args = { data.first_name .. " " .. data.last_name, data.dept }
        })
    end
    TriggerServerEvent('NAT2K15:CHECKSQL', data.steamid, data.discord, data.first_name, data.last_name, data.twt, data.dept, data.dob, data.gender, data, Framework)

    Framework.removeWeapons()
    Citizen.Wait(1000)
    if(Config.loadoutSystem[data.level]) then
        if(Config.loadoutSystem[data.level].weapons) then
            Framework.addWeapon(Config.loadoutSystem[data.level].weapons, Config.loadoutSystem[data.level].components) 
        end
    end
    Framework.setHealth(200)
    Framework.setArmor(200)
end)
  
-- NUI callback for the admin panel --
RegisterNUICallback('DeleteFromAdminPanel', function(data)
    TriggerServerEvent('NAT2K15:DELETEFROMADMINPANEL', data.id)
end)
  
-- NUI for saving the config -- 
RegisterNUICallback('SaveConfig', function(data) 
    TriggerServerEvent('NAT2K15:SAVECONFIG', data)
end)

-- Event when a config is saved -- 
RegisterNetEvent('NAT2K15:HANDLEUIUPDATE')
AddEventHandler('NAT2K15:HANDLEUIUPDATE', function(newConfig) 
    Config = newConfig
end)