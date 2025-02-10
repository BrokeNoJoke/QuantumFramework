-- NOTIFY -- 
Framework.ShowInfo = function(text)
    if(text) then
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandThefeedPostTicker(true, false)
        return true
    else 
        return false
    end  
end
  
-- NOTIFY
Framework.DisplayHelpText = function(text)
    if(text) then
        SetTextComponentFormat("STRING")
        AddTextComponentString(text)
        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
        return true
    else 
        return false
    end
end
  

-- BUTTONS BELOW --
if (Config.richPresence.enabled) then
    RegisterNetEvent('NAT2K15:UPDATEPLAYERCOUNT')
    AddEventHandler('NAT2K15:UPDATEPLAYERCOUNT', function(num) 
        SetDiscordAppId(Config.richPresence.clientid)
        SetDiscordRichPresenceAsset(Config.richPresence.icons.big.icon)
        SetDiscordRichPresenceAssetText(Config.richPresence.icons.big.text)
        SetDiscordRichPresenceAssetSmall(Config.richPresence.icons.small.icon)
        SetDiscordRichPresenceAssetSmallText(Config.richPresence.icons.small.text)
        if(Config.richPresence.displayPlayingAs) then
            local player = Framework.getPlayer(Framework.serverId)
            if(player) then
                SetRichPresence(string.format(Config.richPresence.displayPlayingAs, player.char_name, player.dept)) 
                Citizen.Wait(12500)
                SetRichPresence('Players: ' .. num)
            else 
                SetRichPresence('Players: ' .. num)
            end
        else 
            SetRichPresence('Players: ' .. num)
        end
        if(Config.richPresence.discordButtons.enabled) then
            SetDiscordRichPresenceAction(0, Config.richPresence.discordButtons.button1.label, Config.richPresence.discordButtons.button1.url)
            if(Config.richPresence.discordButtons.button2.enabled) then
                SetDiscordRichPresenceAction(1, Config.richPresence.discordButtons.button2.label, Config.richPresence.discordButtons.button2.url)
            end
        end
    end)
    
    Citizen.CreateThread(function() 
        while true do 
            TriggerServerEvent('NAT2K15:GETPLAYERCOUNT')
            Citizen.Wait(25000)
        end
    end)
end

-- Door script -- 
if(Config.doorLock.enabled) then
    function Draw3DText(x, y, z, textInput)
        z = z + 2
        local onScreen, _x, _y = World3dToScreen2d(x, y, z)
        local factor = #textInput / 370
      
        if onScreen then
          SetTextScale(0.35, 0.35)
          SetTextFont(4)
          SetTextColour(255, 255, 255, 255)
          SetTextDropshadow(0, 0, 0, 0, 255)
          SetTextOutline()
          SetTextEntry('STRING')
          SetTextCentre(1)
      
          AddTextComponentString(textInput)
          DrawText(_x, _y)
          DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 120)
        end
    end	

    function round(n)
        return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
    end 
end


function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do        
        Citizen.Wait(100)
    end
end

Framework.freeze = function()
    local ped = GetPlayerPed(-1)
    DisplayHud(false)
    DisplayRadar(false)
    SetNuiFocus(true, true)
    SetPlayerInvincible(PlayerId(), true)
    if IsEntityVisible(ped) then
      SetEntityVisible(ped, false)
    end
    FreezeEntityPosition(ped, true)
end

function unfreeze(state, gender, dept, telpe, daplace)
    local ped = PlayerPedId()

    if state == true then
        SwitchOutPlayer(ped, 0, 1)
    end
  
    if telpe == true then
        local groundFound, z = GetGroundZFor_3dCoord(daplace.x, daplace.y, daplace.z, 1)

        if not groundFound then
            RequestCollisionAtCoord(daplace.x, daplace.y, daplace.z)
            while not HasCollisionLoadedAroundEntity(ped) do
                Citizen.Wait(0)
            end
        end

        SetEntityCoords(ped, daplace.x, daplace.y, groundFound and z or daplace.z)
        SetEntityHeading(ped, daplace.h)
    end

    SetNuiFocus(false, false)
    SetEntityVisible(ped, true)
    SetPlayerInvincible(PlayerId(), false)
    RenderScriptCams(false, true, 1000, true, true)
    FreezeEntityPosition(ped, false)
    SetTimecycleModifier('default')
    DisplayHud(true)
    DisplayRadar(true)

    if state == true then
        SwitchInPlayer(ped)
    end
end



Framework.addWeapon = function(weaponArray, weaponComp)
    local ped = GetPlayerPed(-1)
    if (weaponArray) then
        for i, v in ipairs(weaponArray) do
            GiveWeaponToPed(ped, GetHashKey(v), 300, false)
            if(weaponComp and weaponComp[v]) then
                for k, comp in ipairs(weaponComp[v]) do
                    GiveWeaponComponentToPed(ped, GetHashKey(v), GetHashKey(comp))
                end
            end
        end
    end
end

Framework.setHealth = function(health)
    if(health) then
        SetEntityHealth(PlayerPedId(), health)
        return true
    else 
        return false
    end
end

Framework.setArmor = function(armor)
    if(armor) then
        SetPedArmour(PlayerPedId(), armor)
        return true
    else 
        return false
    end
end


Framework.removeWeapons = function()
    RemoveAllPedWeapons(PlayerPedId(), true)
    return true
end

Framework.disablePeacetimeKeybinds = function()
    local ped = GetPlayerPed(-1)
    SetPlayerCanDoDriveBy(ped, false)
    DisablePlayerFiring(ped, true)
    DisableControlAction(0, 140)
    DisableControlAction(0, 37)
end


Framework.getPlayer = function(id)
    if(Framework.clientInfo[id]) then
        return Framework.clientInfo[id]
    end
    return false
end


Framework.checkLevels = function(id, levels)
    local player = Framework.getPlayer(id)
    if(player) then
        for k, v in ipairs(levels) do
            if(player.level == v or player.admin or player.level == "admin_level") then
                return true
            end
        end
    end
    return false
end

Framework.convertGTAColorToCss = function(color)
    local mainString = color
    mainString = string.gsub(mainString, "~r~", "<span style='color:red'>")
    mainString = string.gsub(mainString, "~b~", "<span style='color:blue'>")
    mainString = string.gsub(mainString, "~g~", "<span style='color:green'>")
    mainString = string.gsub(mainString, "~y~", "<span style='color:yellow'>")
    mainString = string.gsub(mainString, "~p~", "<span style='color:purple'>")
    mainString = string.gsub(mainString, "~c~", "<span style='color:grey'>")
    mainString = string.gsub(mainString, "~m~", "<span style='color:darkgrey'>")
    mainString = string.gsub(mainString, "~u~", "<span style='color:black'>")
    mainString = string.gsub(mainString, "~o~", "<span style='color:orange'>")
    mainString = string.gsub(mainString, "~w~", '<span style="color:white">')
    return mainString
end

Framework.getHeading = function()
    local heading = GetEntityHeading(PlayerPedId());

    local directions = {N = 360, 0, NE = 315, E = 270, SE = 225, S = 180, SW = 135, W = 90, NW = 45}
    for k, v in pairs(directions) do
        if (math.abs(heading - v) < 22.5) then
          heading = k;
          if (heading == 1) then
            heading = 'N';
            break;
          end
  
          break;
        end
    end
    return heading;
end

Framework.isPlayerLoadedIn = function()
    return Framework.loadedIn
end

Framework.getCurrentAop = function()
    if(Config.aopSettings.enabled) then
        return Framework.aop
    else 
        return nil
    end
end