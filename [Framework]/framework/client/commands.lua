RegisterCommand("fw", function(source, args)
  DoScreenFadeOut(1500)
  local ped = GetPlayerPed(-1)
  local x,y,z = table.unpack(GetEntityCoords(ped))
  local spawnLoc = {x = tonumber(x), y = tonumber(y), z = tonumber(z)}
  TriggerServerEvent('NAT2K15:BLIP:CHANGE', Framework.serverId, false, Framework.getPlayer(Framework.serverId))
  TriggerServerEvent("NAT2K15:GETCHARCTERS", spawnLoc)
end)
  
RegisterCommand("framework", function(source, args)
  DoScreenFadeOut(1500)
  local ped = GetPlayerPed(-1)
  local x,y,z = table.unpack(GetEntityCoords(ped))
  local spawnLoc = {x = tonumber(x), y = tonumber(y), z = tonumber(z)}
  TriggerServerEvent('NAT2K15:BLIP:CHANGE', Framework.serverId, false, Framework.getPlayer(Framework.serverId))
  TriggerServerEvent("NAT2K15:GETCHARCTERS", spawnLoc)
end)
  
if(Config.commands.loadoutCommand) then
  RegisterCommand('loadout', function(source, args, message)
    Framework.removeWeapons()
    Citizen.Wait(5)
    if(Framework.clientInfo and Config.loadoutSystem[Framework.clientInfo[Framework.serverId].level]) then
      Framework.addWeapon(Config.loadoutSystem[Framework.clientInfo[Framework.serverId].level].weapons, Config.loadoutSystem[Framework.clientInfo[Framework.serverId].level].components) 
      Framework.ShowInfo("~g~successfully loaded your loadout")
    else 
      Framework.ShowInfo("~r~Error: Config isnt setup for your level: " .. Framework.clientInfo[Framework.serverId].level)
    end
  end)
end

-- CART RELOAD THANKS TO FAXES --
if(Config.taserScript.enabled) then
    local maxtaser = Config.taserScript.taserCarts;
    Citizen.CreateThread(function()
        while true do
          Citizen.Wait(5)
          local ped = GetPlayerPed(-1)
          local taserModel = GetHashKey("WEAPON_STUNGUN")
          if GetSelectedPedWeapon(ped) == taserModel then
              if IsPedShooting(ped) then
                maxtaser = maxtaser - 1
              end
          end
          if maxtaser <= 0 then
              if GetSelectedPedWeapon(ped) == taserModel then
                SetPlayerCanDoDriveBy(ped, false)
                DisablePlayerFiring(ped, true)
                if IsControlPressed(0, 106) then
                    Framework.ShowInfo("~y~You have no taser cartridges left. please use /reload or /rc")
                end
              end
          end
        end
    end)

    RegisterCommand("reload", function(source, args, rawCommand)
        maxtaser = Config.taserScript.taserCarts;
        Framework.ShowInfo("~g~Taser Cartridges Refilled.")
    end)

    RegisterCommand("rc", function(source, args, rawCommand)
      maxtaser = Config.taserScript.taserCarts;
      Framework.ShowInfo("~g~Taser Cartridges Refilled.")
    end)
end


if(Config.commands.clearWeaponsCommand) then
  RegisterCommand('clear', function(source, args) 
    Framework.removeWeapons()
    Framework.ShowInfo("~g~successfully cleared your weapons")
  end)
end

-- TP COMMAND -- 
if(Config.commands.tpCommand) then
  RegisterNetEvent('NAT2K15:TPADMINTOSOMEONE')
  AddEventHandler('NAT2K15:TPADMINTOSOMEONE', function(id, quickfix) 
    local player = GetPlayerFromServerId(id)
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(player)))
    SetEntityCoords(GetPlayerPed(-1), x, y, z)
    TriggerEvent('chatMessage', "[^2STAFF^0] You have teleported to " .. quickfix)
  end)
end

-- CHAT SUGGESTIONS -- 
Citizen.CreateThread(function()
  if(Config.commands.oocCommand) then
    TriggerEvent('chat:addSuggestion', '/ooc', 'Out Of Character chat Message. (Global Chat)')
  end

  if(Config.commands.meCommand) then
    TriggerEvent('chat:addSuggestion', '/me', 'Send message in the third person. (Proximity Chat)')
  end

  if(Config.commands.merCommand) then
    TriggerEvent('chat:addSuggestion', '/mer', 'Send message in red text. (Proximity Chat)')
  end

  if(Config.commands.gMeCommand) then
    TriggerEvent('chat:addSuggestion', '/gme', 'Send message in the third person. (Global Chat)')
  end

  if(Config.commands.doCommand) then
    TriggerEvent('chat:addSuggestion', '/do', 'Send action message. (Proximity Chat)')
  end

  if(Config.commands.twitterCommand) then
    TriggerEvent('chat:addSuggestion', '/twitter', 'Send a Twitter in game. (Global Chat)')
  end

  if(Config.commands.darkWebCommand) then
    TriggerEvent('chat:addSuggestion', '/darkweb', 'Send a anonymous message. (Global Chat)')
  end

  if(Config.commands.radioCommand) then
    TriggerEvent('chat:addSuggestion', '/radiochat', 'Send a radio message to all on duty LEOS. (Department Chat)')
  end
 
  if(Config.commands.dobCommand) then
    TriggerEvent('chat:addSuggestion', '/dob', 'Displays your characters date of birth')
  end

  if(Config.commands.whoamiCommand) then
    TriggerEvent('chat:addSuggestion', '/whoami', 'Displays your characters name and department')
  end

  if(Config.taserScript.enabled) then 
    TriggerEvent('chat:addSuggestion', '/reload', 'Reloads your taser cart')
    TriggerEvent('chat:addSuggestion', '/rc', 'Reloads your taser cart')
  end
  
  if(Config.commands.loadoutCommand) then
    TriggerEvent('chat:addSuggestion', '/loadout', 'Gives LEO their loadout')
  end

  if(Config.commands.emsCommand) then
    TriggerEvent('chat:addSuggestion', '/ems', 'Out Of Character chat Message. (Global Chat)')
  end
 
  if(Config.commands.Command_911) then
    TriggerEvent('chat:addSuggestion', '/911', 'Make a phone call to 911')
  end

  if(Config.prioritySettings.enabled) then
    TriggerEvent('chat:addSuggestion', '/pstart', 'starts a priorty')

    TriggerEvent('chat:addSuggestion', '/pend', 'ends a priorty')

    TriggerEvent('chat:addSuggestion', '/phold', 'holds a priorty')

    TriggerEvent('chat:addSuggestion', '/phud', 'Shows/disables the hud')
  end
  if(Config.commands.clearWeaponsCommand) then
    TriggerEvent('chat:addSuggestion', '/clear', 'Clears your weapons')
  end
  if(Config.aopSettings.enabled) then
    TriggerEvent('chat:addSuggestion', '/aop', 'Changes AOP')
    TriggerEvent('chat:addSuggestion', '/checkaop', 'Checks aop')
    TriggerEvent('chat:addSuggestion', '/aophud', 'Disables/Enables AOP HUD')
  end

  if(Config.peacetimeSettings.enabled) then
    TriggerEvent('chat:addSuggestion', '/pt', 'Enables/disables peacetime')
    TriggerEvent('chat:addSuggestion', '/pthud', 'Enables/disables peacetime hud.')
  end

  if(Config.commands.chatClearCommand) then
    TriggerEvent('chat:addSuggestion', '/clearchat', 'Clears chat')
  end

  if(Config.commands.adminChatCommand) then
    TriggerEvent('chat:addSuggestion', '/adminchat', 'Admin Chat')
  end

  if(Config.commands.callAdminCommand) then
    TriggerEvent('chat:addSuggestion', '/calladmin', 'Call an admin!')
  end

  if(Config.commands.telpCommand) then
    TriggerEvent('chat:addSuggestion', '/telp', 'TP to a player')
  end

  if(Config.muteSystem.enabled) then
    TriggerEvent('chat:addSuggestion', '/mute', 'Mutes a player')

    TriggerEvent('chat:addSuggestion', '/unmute', 'Unmutes a player')
  end
end)