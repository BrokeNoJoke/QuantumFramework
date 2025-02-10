-- Framework functions --
Framework = {}
Framework.clientInfo = {}
Framework.leoBlips = {}
Framework.serverId = nil
Framework.loadedIn = false;
Framework.currentAop = Config.aopSettings.defaultAop 

-- main loop when a player joins! --
Citizen.CreateThread(function()
  Citizen.Wait(500) -- if player cannot see the framework
  if NetworkIsSessionStarted() then
    ShutdownLoadingScreenNui()
    if(Framework.serverId == nil) then
      Framework.serverId = GetPlayerServerId(PlayerId())
    end

    TriggerServerEvent("NAT2K15:GETCHARCTERS", nil)

    if(Config.prioritySettings.enabled) then
      TriggerServerEvent("NAT2K15:UPDATEDAPRIORTY")
    end

    if(Config.aopSettings.enabled) then
      TriggerServerEvent("NAT2K15:UPDATEDUMBAOP")
    end

    if(Config.peacetimeSettings.enabled) then
      TriggerServerEvent("NAT2K15:UPDATEDUMBPEACETIME")
    end

    if(Config.doorLock.enabled) then
      TriggerServerEvent('NAT2K15:getDoorState')
    end
  end
end)



RegisterNetEvent("NAT2K15:UPDATELEOS")
AddEventHandler("NAT2K15:UPDATELEOS", function(active) 
  Framework.clientInfo[Framework.serverId] = active;
end)

 
-- opens the framework --
RegisterNetEvent("NAT2K15:OPENUI")
AddEventHandler("NAT2K15:OPENUI", function(user_chars, setti, perms, stats)
  if (perms == nil) then
    print("^1[ERROR | MYSQL]^0 NAT2K15's Framework has been disabled. This is due to SQL connection not being setup correctly. If you are the customer of this script please watch the videos \non how to set up the framework or use client support for support. ^1Made by NAT2K15^0\ndiscord.gg/RquDVTfDwu\ndiscord.gg/RquDVTfDwu\ndiscord.gg/RquDVTfDwu")
  else 
    Framework.freeze()
    SendNUIMessage({
      action = "framework_open",
      chars = user_chars,
      perms = perms,
      config = Config,
      uiSettings = Config.uiSettings,
      current_aop = Framework.currentAop,
      usersettings = setti,
      stats = stats,
    })
    Framework.loadedIn = false
  end
end)


-- this event will refresh the framework when something happens --
RegisterNetEvent("NAT2K15:RESETUI")
AddEventHandler("NAT2K15:RESETUI", function(characters, stats)
  SendNUIMessage({
    uiSettings = Config.uiSettings,
    action = "refresh_ui",
    players = characters,
    stats = stats,
    config = Config,
  })
  Framework.loadedIn = false
end)


-- chat commands  --

-- DO COMMAND --
RegisterNetEvent('SendProximityMessageDo')
AddEventHandler('SendProximityMessageDo', function(id, fix, message)
  local myID = PlayerId()
  local pID = GetPlayerFromServerId(id)
  local myCoords = GetEntityCoords(GetPlayerPed(myID))
  local targetCoords = GetEntityCoords(GetPlayerPed(pID))
  local distance = GetDistanceBetweenCoords(myCoords, targetCoords, true)
  if pID == myID then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " ^9 ^*[DO] " .. fix .."".."^r (#" .. id .. ")^7: " .. message)
  elseif (distance >= 0.0 and distance < 19.9)  then 
    local send = true
    if(distance == 0.0) then 
      if(GetVehiclePedIsIn(GetPlayerPed(myID), false) == GetVehiclePedIsIn(GetPlayerFromServerId(GetPlayerPed(pID)), false)) then 
        send = true
      end
    end
    if(send) then 
      TriggerEvent('chatMessage', "", {255, 0, 0}, " ^9 ^*[DO] " .. fix .."".." ^r (#" .. id .. ") (" .. math.ceil(distance) .."m)^7: " .. message)
    end
  end
end)


-- ME COMMAND --
RegisterNetEvent('SendProximityMessageMe')
AddEventHandler('SendProximityMessageMe', function(id, fix, message)
  local myID = PlayerId()
  local pID = GetPlayerFromServerId(id)
  local myCoords = GetEntityCoords(GetPlayerPed(myID))
  local targetCoords = GetEntityCoords(GetPlayerPed(pID))
  local distance = GetDistanceBetweenCoords(myCoords, targetCoords, true)

  if pID == myID then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 ^*[ME] " .. fix .."^r (#" .. id .. ")^7: " .. message)
  elseif distance >= 0.0 and distance < 19.999 then
    local send = true
    if(distance == 0.0) then 
      if(GetVehiclePedIsIn(GetPlayerPed(myID), false) == GetVehiclePedIsIn(GetPlayerFromServerId(GetPlayerPed(pID)), false)) then 
        send = true
      end
    end
    if(send) then 
      TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 ^*[ME] " .. fix .." ^r (#" .. id .. ") (" .. math.ceil(distance) .."m)^7: " .. message)
    end
  end
end)


-- MER COMMAND -- 
RegisterNetEvent("SendProximityMessageMer")
AddEventHandler("SendProximityMessageMer", function(id, fix, message) 
  local myID = PlayerId()
  local pID = GetPlayerFromServerId(id)
  local myCoords = GetEntityCoords(GetPlayerPed(myID))
  local targetCoords = GetEntityCoords(GetPlayerPed(pID))
  local distance = GetDistanceBetweenCoords(myCoords, targetCoords, true)
  if pID == myID then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 ^*[ME] " .. fix .."".."^r (#" .. id .. "):^*^1 " .. message)
  elseif distance >= 0.0 and distance < 19.999 then
    local send = true
    if(distance == 0.0) then 
      if(GetVehiclePedIsIn(GetPlayerPed(myID), false) == GetVehiclePedIsIn(GetPlayerFromServerId(GetPlayerPed(pID)), false)) then 
        send = true
      end
    end
    if(send) then 
      TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 ^*[ME] " .. fix .."".." ^r (#" .. id .. ") (" .. math.ceil(distance) .."m):^*^1 " .. message)
    end
  end
end)

-- DOB COMMAND -- 
RegisterNetEvent('NAT2K15:DOBCOMMAND')
AddEventHandler('NAT2K15:DOBCOMMAND', function(char_name, dob)
  Framework.ShowInfo("~r~" .. char_name .. " ~w~Date of birth: " .. dob)
end)

-- 911 COMMAND --
local showing_911_blip = false
RegisterNetEvent("NAT2K15:911CALL")
AddEventHandler("NAT2K15:911CALL", function(id, message) 
  local playerIdx = GetPlayerFromServerId(id)
  local ped = GetPlayerPed(playerIdx)
  local pos = GetEntityCoords(ped)
  local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
  TriggerEvent("chat:addMessage", {
    template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px; text: center;"><b><i class="fas fa-window-close" style="color: #ff0000;"></i><b>{0}</b></div>', 
    args = {"^1911 We have received a 911 call near " .. GetStreetNameFromHashKey(var1) .. " " .. GetStreetNameFromHashKey(var2) .. ":^*^7 " .. message}})
  if(showing_911_blip) then return end
  showing_911_blip = true
  local blip = AddBlipForRadius(pos.x, pos.y, pos.z, 250.0)
  SetBlipSprite(blip, 161)
  SetBlipColour(blip, 1)
  SetBlipAsShortRange(blip, 0)
  Citizen.Wait(20000)
  RemoveBlip(blip)
  showing_911_blip = false
end)

-- PRIORITY -- 
if(Config.prioritySettings.enabled) then
  local cooldown = 0
  local priorty_status = false
  local hold_status = false
  local active_player = "";
  local inactive_time = 0;
  local show_pri = true
  local uiDisaplyed = true;

  RegisterNetEvent("NAT2K15:UPDATEPR")
  AddEventHandler("NAT2K15:UPDATEPR", function(time) 
    inactive_time = time;
  end)

  RegisterNetEvent("NAT2K15:UPDATEVARSPRI")
  AddEventHandler("NAT2K15:UPDATEVARSPRI", function(value1, value2, value3, value4, value5) 
    cooldown = value1;
    priorty_status = value2;
    hold_status = value3;
    inactive_time = value4;
    active_player = value5;
  end)

  RegisterNetEvent('NAT2K15:UPDATECOOLDOWN')
  AddEventHandler('NAT2K15:UPDATECOOLDOWN', function(length)
    cooldown = length
  end)
  
  RegisterNetEvent('NAT2K15:UPDATEPRIORTY')
  AddEventHandler('NAT2K15:UPDATEPRIORTY', function(status, name)
      priorty_status = status
      active_player = name
  end)
  
  RegisterNetEvent('NAT2K15:HOLDPRIORTY')
  AddEventHandler('NAT2K15:HOLDPRIORTY', function(newishold)
    hold_status = newishold
  end)

  
  Citizen.CreateThread(function() 
    while true do
      Citizen.Wait(500)
      if(Framework.loadedIn) then
        local player = Framework.getPlayer(Framework.serverId)
        if(player) then
          if(show_pri) then
            if(Config.prioritySettings.visibility.leo or player.level == "civ_level") then
              local text;
              if hold_status then
                text = "~w~Priority Status: ~b~Priorities Are On Hold"
              elseif not priorty_status then
                if(cooldown > 0) then
                  text = "~w~Priority Status: ~r~Cooldown ~c~(".. cooldown .."m remaining)"
                else 
                  text  = "~w~Priority Status: ~g~Inactive ~c~(".. inactive_time .."m)"
                end
              elseif priorty_status then
                text = "~w~Priority Status: ~g~Priority In Progress ~w~( " .. active_player .. ")"
              end
              text = Framework.convertGTAColorToCss(text)
              local htmlCode = "<b>" .. Config.prioritySettings.htmlCode.icon .. "&nbsp;" .. text .. "</b>"
              uiDisaplyed = true;
              SendNuiMessage(json.encode({action = "showhud", priority = {enabled = show_pri, html = htmlCode}}))
            end
          else 
            if(uiDisaplyed) then
              SendNuiMessage(json.encode({action = "showhud", priority = {enabled = false}}))
              uiDisaplyed = false;
            end
          end
        else 
          if(uiDisaplyed) then
            SendNuiMessage(json.encode({action = "showhud", priority = {enabled = false}}))
            uiDisaplyed = false;
          end
        end
      else 
        if(uiDisaplyed) then
          SendNuiMessage(json.encode({action = "showhud", priority = {enabled = false}}))
          uiDisaplyed = false;
        end
      end
    end
  end)

  RegisterCommand("phud", function(source, args, message)
    show_pri = not show_pri
  end)
end

if Config.streetLabel.enabled then
  local streetShow = true
  local uiDisplayed = true

  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(500)
      if Framework.loadedIn and streetShow then
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        if (Config.streetLabel.onlyDisplayWhenInVehicle and vehicle > 0) or not Config.streetLabel.onlyDisplayWhenInVehicle then
          local coords = GetEntityCoords(ped)
          local streetName, crossing = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
          streetName = GetStreetNameFromHashKey(streetName)
          crossing = GetStreetNameFromHashKey(crossing)
          local heading = Framework.getHeading()
          local text = string.format("<b>%s %s | %s", Config.streetLabel.htmlCode.icon, heading, streetName)

          if crossing and crossing ~= "" then
            text = string.format("%s / %s", text, crossing)
          end

          if Config.postalSystem.enabled then
            text = string.format("%s (%s)</b>", text, exports[Config.postalSystem.postalScript]:getPostal())
          else
            text = string.format("%s</b>", text)
          end

          SendNUIMessage({ action = "showhud", street = { enabled = streetShow, html = text } })
          uiDisplayed = true
        elseif uiDisplayed then
          uiDisplayed = false
          SendNUIMessage({ action = "showhud", street = { enabled = false } })
        end
      elseif uiDisplayed then
        uiDisplayed = false
        SendNUIMessage({ action = "showhud", street = { enabled = false } })
      end
    end
  end)

  RegisterCommand('streethud', function()
    streetShow = not streetShow
  end)
end


-- AOP -- 
if Config.aopSettings.enabled then
  local show_aop = true
  local oldAop = nil
  local fix = false
  local uiDisplayed = true

  RegisterNetEvent("NAT2K15:AOPCHANGE")
  AddEventHandler("NAT2K15:AOPCHANGE", function(aop)
    Framework.currentAop = aop
  end)

  RegisterNetEvent("NAT2K15:AOPNOT")
  AddEventHandler("NAT2K15:AOPNOT", function(text)
    Framework.DisplayHelpText(text)
  end)

  Citizen.CreateThread(function() 
    while true do 
      Citizen.Wait(500)
      if Framework.loadedIn and show_aop then
        local player = Framework.getPlayer(Framework.serverId)
        if player then
          if Config.aopSettings.visibility.leo or player.level == "civ_level" then
            if oldAop ~= Framework.currentAop or fix then
              local text = Framework.convertGTAColorToCss(Framework.currentAop)
              local htmlCode = Config.aopSettings.htmlCode.icon .. "&nbsp;<b>Current AOP: " .. text .. "</b>"
              SendNUIMessage({ action = "showhud", aop = { enabled = show_aop, html = htmlCode } })
              oldAop = Framework.currentAop
              fix = false
              uiDisplayed = true
            end
          elseif uiDisplayed then
            fix = true
            SendNUIMessage({ action = "showhud", aop = { enabled = false } })
            uiDisplayed = false
            Citizen.Wait(1000)
          end
        elseif uiDisplayed then
          fix = true
          SendNUIMessage({ action = "showhud", aop = { enabled = false } })
          uiDisplayed = false
          Citizen.Wait(1000)
        end
      elseif uiDisplayed then
        fix = true
        SendNUIMessage({ action = "showhud", aop = { enabled = false } })
        uiDisplayed = false
        Citizen.Wait(1000)
      end
    end
  end)

  RegisterCommand('aophud', function(source, args, message) 
    show_aop = not show_aop
  end)
end


-- PEACTIME -- 
if(Config.peacetimeSettings.enabled) then
  local peacetime = false;
  local show_peacetime = true
  local oldPeacetime = nil;
  local uiDisplayed = true;

  RegisterNetEvent("NAT2K15:CHANGEPT")
  AddEventHandler("NAT2K15:CHANGEPT", function(status)
    peacetime = status
  end)

  RegisterNetEvent("NAT2K15:PEACETIMENOT")
  AddEventHandler("NAT2K15:PEACETIMENOT", function(text)
    Framework.DisplayHelpText(text)
  end)

  Citizen.CreateThread(function() 
    while true do 
      Citizen.Wait(500)
      if(Framework.loadedIn) then
        local player = Framework.getPlayer(Framework.serverId)
        if(player) then
          if(show_peacetime) then
            if(Config.peacetimeSettings.leoVision or player.level == "civ_level") then
              if(oldPeacetime ~= peacetime) then
                local color;
                local text = "Disabled"
                if(peacetime) then
                  color = Config.peacetimeSettings.htmlCode.color.active
                  text = '<b style="color: ' .. Config.peacetimeSettings.htmlCode.color.active .. '">Enabled</b>'
                else 
                  color = Config.peacetimeSettings.htmlCode.color.disabled
                  text = '<b style="color: ' .. Config.peacetimeSettings.htmlCode.color.disabled .. '">Disabled</b>'
                end
                local htmlCode = string.format(Config.peacetimeSettings.htmlCode.icon, color) .. "&nbsp;<b>Peacetime:</b>&nbsp;" ..  text
                SendNuiMessage(json.encode({action = "showhud", peacetime = {enabled = show_peacetime, html = htmlCode}}))
                uiDisplayed = true;
              end
            end
          else 
            if(uiDisplayed) then
              SendNuiMessage(json.encode({action = "showhud", peacetime = {enabled = false}}))
              uiDisplayed = false;
            end
          end 
        end
      else 
        if(uiDisplayed) then
          SendNuiMessage(json.encode({action = "showhud", peacetime = {enabled = false}}))
          uiDisplayed = false;
        end
      end
    end
  end)

  -- main loop for peacetime -- 
  Citizen.CreateThread(function()
    local affectLeo = Config.peacetimeSettings.affectLeo
    local affectAdmins = Config.peacetimeSettings.affectAdmins
  
    while true do
      Citizen.Wait(1)  
      if peacetime then
        if affectLeo and (affectAdmins or not (Framework.clientInfo[Framework.serverId] and Framework.clientInfo[Framework.serverId].admin)) then
          if IsControlPressed(0, 106) then
            Framework.ShowInfo("~r~Peacetime is enabled. ~n~~s~You cannot cause violence.")
          end
          Framework.disablePeacetimeKeybinds()
        elseif not affectLeo and Framework.clientInfo[Framework.serverId] and Framework.clientInfo[Framework.serverId].level == "civ_level" and not Framework.clientInfo[Framework.serverId].admin then
          if IsControlPressed(0, 106) then
            Framework.ShowInfo("~r~Peacetime is enabled. ~n~~s~You cannot cause violence.")
          end
          Framework.disablePeacetimeKeybinds()
        end
      end
    end
  end)

  RegisterCommand("pthud", function(source, args, message)
    show_peacetime = not show_peacetime
  end)
  

end

-- PANIC SYSTEM -- 
local panicBlip = nil
RegisterNetEvent('NAT2K15:PANICPRESSED')
AddEventHandler('NAT2K15:PANICPRESSED', function(area, msg) 
  local var1, var2 = GetStreetNameAtCoord(tonumber(area.x), tonumber(area.y), tonumber(area.z), Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
  local hash1 = GetStreetNameFromHashKey(var1);
  local hash2 = GetStreetNameFromHashKey(var2);
  TriggerEvent('chatMessage', msg .. " has pressed their panic button. There last known location was ^3" .. hash1 .. " " .. hash2)
  
  if(Config.panicSystem.useSound) then
    SendNUIMessage({action = 'playSound', link = Config.panicSystem.soundLink, volume = Config.panicSystem.volume})
  end

  if(Config.panicSystem.blipSystem.enabled) then
    if(panicBlip) then
      RemoveBlip(panicBlip)
    end
    panicBlip = AddBlipForRadius(area.x, area.y, area.z, Config.panicSystem.blipSystem.radius)
    SetBlipSprite(panicBlip, 161)
    SetBlipColour(panicBlip, 1)
    SetBlipAsShortRange(panicBlip, false)
    Citizen.Wait(Config.panicSystem.blipSystem.waitBeforeDelete * 1000)
    RemoveBlip(panicBlip)
  end
end)


if(Config.doorLock.enabled) then
  RegisterNetEvent('NAT2K15:returnDoorState')
  AddEventHandler('NAT2K15:returnDoorState', function(states) 
    Config_doors.DoorList = states
  end)

  
  Citizen.CreateThread(function()
    while true do
      if(Framework.serverId) then
        local coords = GetEntityCoords(PlayerPedId())
        for k, v in ipairs(Config_doors.DoorList) do
          v.distanceToPlayer = nil
          
          if v.doors then
            for k2, v2 in ipairs(v.doors) do
              if v2.object and DoesEntityExist(v2.object) then
                if k2 == 1 then
                  v.distanceToPlayer = #(coords - GetEntityCoords(v2.object))
                end
      
                if v.locked and v2.objHeading and round(GetEntityHeading(v2.object)) ~= v2.objHeading then
                  SetEntityHeading(v2.object, v2.objHeading)
                end
              else
                v2.object = GetClosestObjectOfType(v2.objCoords, 1.0, v2.objHash, false, false, false)
              end
            end
          else
            if v.object and DoesEntityExist(v.object) then
              local objectCoors = GetEntityCoords(v.object)
              v.distanceToPlayer = #(coords - objectCoors)
              if v.locked and v.objHeading and round(GetEntityHeading(v.object)) ~= v.objHeading then
                SetEntityHeading(v.object, v.objHeading)
              end
            else
              v.object = GetClosestObjectOfType(v.objCoords, 1.0, v.objHash, false, false, false)
            end
          end
        end
      end

      Citizen.Wait(500)
    end
  end)
  

  Citizen.CreateThread(function()
    local showed = {}
    while true do
      Citizen.Wait(0)
      if Framework.loadedIn then
        for k, v in ipairs(Config_doors.DoorList) do
          local door = Config_doors.DoorList[k]
          local near = false
          if door and door.distanceToPlayer and door.distanceToPlayer <= v.maxDistance then
            if v.doors then
              for k2, v2 in ipairs(v.doors) do
                  FreezeEntityPosition(v2.object, v.locked)
              end
            else
              FreezeEntityPosition(v.object, v.locked)
            end

            local displayText = Config.doorLock.text.unlock
            if not v.locked then
              displayText = Config.doorLock.text.lock
            end

            local check = Framework.checkLevels(Framework.serverId, v.authorizedLevels)
            if check then
              near = true
              local x, y, z = table.unpack(door.textCoords)
              if not showed[k] and Framework.loadedIn then
                SendNUIMessage({ action = "showlock", html = displayText })
                showed[k] = true
              end
              if IsControlJustPressed(0, 38) then
                Config_doors.DoorList[k].locked = not v.locked
                showed[k] = false
                TriggerServerEvent('NAT2K15:CheckPermsDoor', k, not v.locked)
                loadAnimDict("anim@heists@keycard@")
                TaskPlayAnim(PlayerPedId(), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0)
                if Config.doorLock.sound.enabled then
                  local soundLink = Config.doorLock.sound.locked.link
                  if not v.locked then
                    soundLink = Config.doorLock.sound.unlocked.link
                  end
                  SendNUIMessage({ action = 'playSound', link = soundLink, volume = Config.doorLock.sound.volume })
                end
           
                Citizen.Wait(400)
                ClearPedTasks(PlayerPedId())
              end
            end
          else
            if not near and showed[k] then
              SendNUIMessage({ action = "hidelock" })
              showed[k] = false
            end
          end
        end
      else 
        SendNUIMessage({ action = "hidelock" })
        Citizen.Wait(1000)
      end
    end
  end)

end


-- ShotSpotter -- 
if(Config.shotSpotter.enabled) then
  local onCooldown = false
  local blipCreated = false

  Citizen.CreateThread(function()
    local allBlacklistedWeapons = {}  
    for k, v in ipairs(Config.shotSpotter.blacklistWeapons) do
      allBlacklistedWeapons[GetHashKey(v)] = true
    end
    while true do
      Citizen.Wait(1)
      if(Framework.loadedIn) then
        index = 0;
        local player = Framework.getPlayer(Framework.serverId)
        if(player and not player.leoPerms) then
          local ped = PlayerPedId()
          if(IsPedShooting(ped) and not onCooldown) then
            local currentWeapon = GetSelectedPedWeapon(ped)
            if(not allBlacklistedWeapons[currentWeapon]) then
              local coords = GetEntityCoords(ped)
              local streetName, crossing = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
              local streetName = GetStreetNameFromHashKey(streetName)
              local crossing = GetStreetNameFromHashKey(crossing)
              local msg;
  
              if(crossing == nil or crossing == "") then
                msg = "^2[DISPATCH]^0 Shots fired at " .. streetName
              else 
                msg = "^2[DISPATCH]^0 Shots fired at " .. streetName .. " and " .. crossing .. " "
              end
  
              if(Config.postalSystem.enabled) then
                msg = msg .. "Postal Code: " .. exports[Config.postalSystem.postalScript]:getPostal()
              end
              TriggerServerEvent('NAT2K15:SHOTSPOTTER:ShotFired', {message = msg, x = coords.x, y = coords.y, z = coords.z})
              shotSpotterCooldown()
            end
          end
        end
      else 
        Citizen.Wait(1000)
      end
    end
  end)

  RegisterNetEvent('NAT2K15:NOTIFYCOPS:CLIENT')
  AddEventHandler('NAT2K15:NOTIFYCOPS:CLIENT', function(info) 
    if(not blipCreated) then
      TriggerEvent("chat:addMessage", {template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><b>{0}</b></div>', args = {info.message}})
      PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
      local blip = AddBlipForRadius(info.x, info.y, info.z, 100.0);
      SetBlipColour(blip, 40)
      SetBlipAlpha(blip, 80)
      SetBlipSprite(blip, 9)
      blipCreated = true
      Citizen.Wait(1000 * Config.shotSpotter.blipDeletionTime)
      RemoveBlip(blip)
      blipCreated = false
    end
  end)

  function shotSpotterCooldown()
    onCooldown = true
    Citizen.Wait(Config.shotSpotter.cooldown * 1000)
    onCooldown = false
  end
end

-- blip system --
if(Config.blipSystem.enabled) then 
  local allBlips = {}
  local display = false;
  RegisterNetEvent('NAT2K15:BLIP:CLIENTCHANGE')
  AddEventHandler('NAT2K15:BLIP:CLIENTCHANGE', function(newInfo) 
    display = false
    Framework.leoBlips = newInfo
    for k, v in pairs(Framework.leoBlips) do
      if(v.src == Framework.serverId) then 
        display = true
        break
      end
    end
  end)
  RegisterNetEvent('NAT2K15:REMOVE:BLIP')
  AddEventHandler('NAT2K15:REMOVE:BLIP', function(id) 
    local player = GetPlayerFromServerId(id)
    local ped = GetPlayerPed(player)
    local blip = GetBlipFromEntity(ped)
    if(blip) then 
      for k, v in pairs(Framework.leoBlips) do
        if(v.src ~= id) then 
          local secondBlip = GetBlipFromEntity(v.ped)
          if(secondBlip) then 
            RemoveBlip(secondBlip)
          end
        end
      end
      RemoveBlip(blip)
    end
  end)

  Citizen.CreateThread(function() 
    while true do
      Citizen.Wait(Config.blipSystem.blipSetting.timeout)
      local player = Framework.getPlayer(Framework.serverId)
      if(display) then 
        if(player and player.leoPerms) then 
        local myCoords = GetEntityCoords(GetPlayerPed(PlayerId()))
          for k, v in pairs(Framework.leoBlips) do
            if(v.src ~= Framework.serverId) then 
              local playerCoords = GetEntityCoords(Framework.leoBlips[k].ped)
              local blip = GetBlipFromEntity(Framework.leoBlips[k].ped)
              local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, myCoords.x, myCoords.y, myCoords.z)
              if(blip < 1) then
                Framework.leoBlips[k].blip = AddBlipForEntity(Framework.leoBlips[k].ped)
                AddTextEntry(tostring(Framework.leoBlips[k].blip), v.player.char_name .. " (" .. v.player.dept .. ")" )
              end
              if(v.insideVehicle) then 
                if(Config.blipSystem.blipSetting.showWhenOnFoot) then
                  if(Framework.leoBlips[k].vehicleclass == 13) then 
                    SetBlipSprite(Framework.leoBlips[k].blip, 348)
                  elseif(Framework.leoBlips[k].vehicleclass == 14) then 
                    SetBlipSprite(Framework.leoBlips[k].blip, 427)
                  elseif(Framework.leoBlips[k].vehicleclass == 15) then
                    SetBlipSprite(Framework.leoBlips[k].blip, 64)
                  elseif(Framework.leoBlips[k].vehicleclass == 16) then
                    SetBlipSprite(Framework.leoBlips[k].blip, 307)
                  elseif(Framework.leoBlips[k].vehicleclass == 19) then
                    SetBlipSprite(Framework.leoBlips[k].blip, 421)
                  else 
                    SetBlipSprite(Framework.leoBlips[k].blip, 225)
                  end
                  ShowHeadingIndicatorOnBlip(Framework.leoBlips[k].blip, 0) -- gotte be above for some stupid reason
                  SetBlipRotation(Framework.leoBlips[k].blip, math.ceil(GetEntityHeading(Framework.leoBlips[k].ped)))
                end
              else 
                SetBlipSprite(Framework.leoBlips[k].blip, 1)
                SetBlipAsFriendly(Framework.leoBlips[k].blip, Config.blipSystem.blipDept.enabled)
                SetBlipColour(Framework.leoBlips[k].blip, v.color)
                ShowHeadingIndicatorOnBlip(Framework.leoBlips[k].blip, 1)
                SetBlipRotation(Framework.leoBlips[k].blip, math.ceil(GetEntityHeading(Framework.leoBlips[k].ped)))
              end
              BeginTextCommandSetBlipName(tostring(Framework.leoBlips[k].blip))
              AddTextComponentSubstringPlayerName('me')
              EndTextCommandSetBlipName(Framework.leoBlips[k].blip)
            else 
              if(blip and blip > 0) then 
                RemoveBlip(Framework.leoBlips[k].blip)
              end
            end
          end
        end
      else 
        TriggerEvent('NAT2K15:REMOVE:BLIP', Framework.serverId)
      end
    end
  end)

  Citizen.CreateThread(function() 
    while true do
      Citizen.Wait(500)
      for k, v in ipairs(Framework.leoBlips) do
        local playerIdx = GetPlayerFromServerId(v.src)
        local ped = GetPlayerPed(playerIdx)

        Framework.leoBlips[k].playerIdx = playerIdx
        Framework.leoBlips[k].ped = ped
        if IsPedInAnyVehicle(ped, false) then
          Framework.leoBlips[k].insideVehicle = true
          Framework.leoBlips[k].vehicle = GetVehiclePedIsIn(ped, false)
          Framework.leoBlips[k].vehicleclass = GetVehicleClass(Framework.leoBlips[k].vehicle)
        else 
          Framework.leoBlips[k].insideVehicle = nil
          Framework.leoBlips[k].vehicle = nil
          Framework.leoBlips[k].vehicleclass = nil
        end
      end
    end
  end)
end



-- exports -- 
exports('getclientdept', function(id) 
  if(Framework.clientInfo[id]) then
    return Framework.clientInfo
  else 
    return nil
  end
end) 

exports('getClientFunctions', function()
  return Framework
end)