-- chat commands --
if (Config.commands.oocCommand) then
  Framework.RegisterCommand('ooc', nil, nil, function(source, args, message, player)
      if (string.len(table.concat(args, " ")) > 0 and player) then 
        local message = "^3^*[OOC] " .. GetPlayerName(source) ..  " [#" .. player.src .. "] ^7 " .. table.concat(args, " ")
        if(Framework.checkWords(message)) then
          TriggerClientEvent("chat:addMessage", source, {template = 
          '<div style="padding: 0.5vw; text-align: center; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><b>{0}</b></div>', 
          args = {"^1SYSTEM:^0 Your message was flagged for containing a blacklisted word."}})
        else 
          TriggerClientEvent('chatMessage', -1, message)
        end
        Framework.discordLog(0000000, "Command used - [OOC]", "**Steam Name:** " .. GetPlayerName(source) .. "\n**Steam Hex:** " ..player.steam.. "\n**Message:** " ..table.concat(args, " ")) 
      end
  end)
end
  
if(Config.commands.doCommand) then
  Framework.RegisterCommand('do', nil, nil, function(source, args, message, player)
    if (string.len(table.concat(args, " ")) > 0 and player) then 
      if(Framework.checkWords(message)) then
          TriggerClientEvent("chat:addMessage", source, {template = 
          '<div style="padding: 0.5vw; text-align: center; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><b>{0}</b></div>', 
          args = {"^1SYSTEM:^0 Your message was flagged for containing a blacklisted word."}})      else 
        TriggerClientEvent("SendProximityMessageDo", -1, source, player.char_name .. " [" .. player.dept .. "]", table.concat(args, " "))
      end
      Framework.discordLog(0000000, "Command used - [DO]", "**Steam Name:** " .. GetPlayerName(source)  .. "\n**Steam Hex:** " ..player.steam.. "\n**Message:** " ..table.concat(args, " ")) 
    end
  end)
end
  
if(Config.commands.meCommand) then
  Framework.RegisterCommand('me', nil, nil, function(source, args, message, player)
    if (string.len(table.concat(args, " ")) > 0 and player) then 
      if(Framework.checkWords(message)) then
        TriggerClientEvent("chat:addMessage", source, {template = 
          '<div style="padding: 0.5vw; text-align: center; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><b>{0}</b></div>', 
          args = {"^1SYSTEM:^0 Your message was flagged for containing a blacklisted word."}})      else 
        TriggerClientEvent("SendProximityMessageMe", -1, source, player.char_name .. " [" .. player.dept .. "]", table.concat(args, " "))
      end
      Framework.discordLog(0000000, "Command used - [ME]", "**Steam Name:** " .. GetPlayerName(source)  .. "\n**Steam Hex:** " ..player.steam.. "\n**Message:** " ..table.concat(args, " "))  
    end
  end)
end
  
if(Config.commands.merCommand) then 
  Framework.RegisterCommand('mer', nil, nil, function(source, args, message, player)
    if (string.len(table.concat(args, " ")) > 0 and player) then 
      if(Framework.checkWords(message)) then
        TriggerClientEvent("chat:addMessage", source, {template = 
          '<div style="padding: 0.5vw; text-align: center; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><b>{0}</b></div>', 
          args = {"^1SYSTEM:^0 Your message was flagged for containing a blacklisted word."}}) 
      else 
        TriggerClientEvent("SendProximityMessageMer", -1, source, player.char_name .. " [" .. player.dept .. "]", table.concat(args, " "))
      end
      Framework.discordLog(0000000, "Command used - [MER]", "**Steam Name:** " .. GetPlayerName(source)  .. "\n**Steam Hex:** " ..player.steam .. "\n**Message:** " ..table.concat(args, " "))  
    end
  end)
end
  
if(Config.commands.dobCommand) then
  Framework.RegisterCommand('dob', nil, nil, function(source, args, message, player)
    TriggerClientEvent("NAT2K15:DOBCOMMAND", source, player.char_name, player.dob)
    Framework.discordLog(0000000, "Command used - [DOB]", "**Steam Name:** " ..GetPlayerName(source).. "\n**Steam Hex:** " ..player.steam.. "\n**Message:** " ..table.concat(args, " "))  
  end)
end
  
  
if(Config.commands.twitterCommand) then
  Framework.RegisterCommand('twitter', nil, nil, function(source, args, message, player)
    if(player) then    
      if (string.len(table.concat(args, " ")) > 0) then 
        if(Framework.checkWords(message)) then
          TriggerClientEvent("chat:addMessage", source, {template = 
          '<div style="padding: 0.5vw; text-align: center; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><b>{0}</b></div>', 
          args = {"^1SYSTEM:^0 Your message was flagged for containing a blacklisted word."}})        else 
          TriggerClientEvent('chatMessage', -1, "^4^*[Twitter] @" .. player.twitter_name .. " (#" .. source .. ")^7 ", {30, 144, 255}, table.concat(args, " "))
        end
      end
      Framework.discordLog(0000000, "Command used - [twitter]", "**Steam Name:** " ..GetPlayerName(source) .. "\n**Steam Hex:** " ..player.steam.. "\n**Message:** " ..table.concat(args, " ")) 
    else 
      TriggerClientEvent('chatMessage', source, "^1 Access Denied")
    end
  end)
end
  
if(Config.commands.gMeCommand) then
  Framework.RegisterCommand('gme', nil, nil, function(source, args, message, player)
    if (string.len(table.concat(args, " ")) > 0) then 
      if(Framework.checkWords(message)) then
        TriggerClientEvent("chat:addMessage", source, {template = 
          '<div style="padding: 0.5vw; text-align: center; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><b>{0}</b></div>', 
          args = {"^1SYSTEM:^0 Your message was flagged for containing a blacklisted word."}})      else 
        TriggerClientEvent('chatMessage', -1, "^8 " .. player.char_name .. " [" .. player.dept .. "] (#" .. source .. ")^7" , {30, 144, 255}, table.concat(args, " "))
      end
      Framework.discordLog(0000000, "Command used - [GME]", "**Steam Name:** " ..GetPlayerName(source) .. "\n**Steam Hex:** " ..player.steam.."\n**Message:** " ..table.concat(args, " ")) 
    end
  end)
end
  
  
  if(Config.commands.radioCommand) then
    Framework.RegisterCommand('radiochat', nil, "civ_level", function(source, args, message, playerSrc)
      if (string.len(table.concat(args, " ")) > 0 and playerSrc) then 
        if(Framework.checkWords(message)) then
            TriggerClientEvent("chat:addMessage", source, {template = 
          '<div style="padding: 0.5vw; text-align: center; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><b>{0}</b></div>', 
          args = {"^1SYSTEM:^0 Your message was flagged for containing a blacklisted word."}})          else
              if(playerSrc.leoPerms) then
                for _, player in pairs(Framework.getPlayers()) do
                  if(player.leoPerms) then
                    TriggerClientEvent('chatMessage', player.src, "^2[Radio] ".. playerSrc.char_name .. " [" .. playerSrc.dept .. "] (#" .. source .. ")", {255,255,255}, table.concat(args, " "))
                  end
                end
              end
          end
          Framework.discordLog(0000000, "Command used - [radiochat]", "**Steam Name:** " ..GetPlayerName(source) .. "\n**Steam Hex:** " ..playerSrc.steam.."\n**Message:** " ..table.concat(args, " ")) 

        end
    end)
  end
  
  if(Config.commands.emsCommand) then
    Framework.RegisterCommand('ems', nil, "civ_level", function(source, args, message, player)
      if (string.len(table.concat(args, " ")) > 0 and player) then 
        if(Framework.checkWords(message)) then
          TriggerClientEvent("chat:addMessage", source, {template = 
          '<div style="padding: 0.5vw; text-align: center; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><b>{0}</b></div>', 
          args = {"^1SYSTEM:^0 Your message was flagged for containing a blacklisted word."}})        else 
          if(player.leoPerms) then
            local fix = "^1[EMS] ".. player.char_name .. " [" .. player.dept .. "] (#" .. source .. ")"
            for _, players in pairs(Framework.getPlayers()) do
              if(players.leoPerms) then
                TriggerClientEvent('chatMessage', players.src, fix, {255,255,255}, table.concat(args, " "))
              end
            end
          else  
            TriggerClientEvent('chatMessage', source, "^1 Access Denied")
          end
          Framework.discordLog(0000000, "Command used - [ems]", "**Steam Name:** " ..GetPlayerName(source) .. "\n**Steam Hex:** " ..player.steam.."\n**Message:** " ..table.concat(args, " ")) 

        end
      end
    end)
  end
  
  if(Config.commands.darkWebCommand) then
    Framework.RegisterCommand('darkweb', "civ_level", nil, function(source, args, message, player)
      if(tostring(table.concat(args, " ")) == nil) then return end
      if (string.len(tostring(table.concat(args, " "))) > 0) then 
        if(Framework.checkWords(message)) then
          TriggerClientEvent("chat:addMessage", source, {template = 
          '<div style="padding: 0.5vw; text-align: center; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><b>{0}</b></div>', 
          args = {"^1SYSTEM:^0 Your message was flagged for containing a blacklisted word."}})        else 
          if(player and player.leoPerms) then 
            TriggerClientEvent('chatMessage', source, "^1 Access Denied")
          else 
            local value = Framework.createRandomString(4) .. source;
            Citizen.Wait(2)  
            for _, players in pairs(Framework.getPlayers()) do
              if(players.leoPerms) then
                TriggerClientEvent('chatMessage', players.src, "^*^9[Dark Web] " .. value, {255,255,255}, table.concat(args, " "))
              end
            end
          end
          Framework.discordLog(0000000, "Command used - [darkweb]", "**Steam Name:** " ..GetPlayerName(source) .. "\n**Steam Hex:** " ..player.steam.."\n**Message:** " ..table.concat(args, " ")) 

        end
      end
    end)
  end
  
if(Config.commands.whoamiCommand) then
  Framework.RegisterCommand('whoami', nil, nil, function(source, args, message, player)
    if(player and player.leoPerms) then
      TriggerClientEvent('chatMessage', source, "^0^*You are playing as ^3" .. player.char_name.. " ^0Current Department: ^3" .. player.dept)
    else 
      TriggerClientEvent('chatMessage', source, "^0^*You are playing as ^3" .. player.char_name)
    end
    Framework.discordLog(0000000, "Command used - [WHOAMI]", "**Steam Name:** " ..GetPlayerName(source) .. "\n**Steam Hex:** " ..player.steam.."\n**Message:** " ..table.concat(args, " ")) 
  end)
end
  
if(Config.commands.Command_911) then
  Framework.RegisterCommand('911', "civ_level", nil, function(source, args, message, player)
    if (string.len(table.concat(args, " ")) > 0) then 
      if(Framework.checkWords(message)) then
        TriggerClientEvent("chat:addMessage", source, {template = 
          '<div style="padding: 0.5vw; text-align: center; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><b>{0}</b></div>', 
          args = {"^1SYSTEM:^0 Your message was flagged for containing a blacklisted word."}})      
        else 
          if(player) then
          Framework.discordLog(0000000, "Command used - [911]", "**Steam Name:** " .. GetPlayerName(source) .. "\n**Steam Hex:** " ..player.steam.. "\n**Message:** " .. table.concat(args, " ")) 
          for _, players in pairs(Framework.getPlayers()) do
            if(players.leoPerms or Framework.checkAdmin(players)) then
              TriggerClientEvent("NAT2K15:911CALL", players.src, source, table.concat(args, " "))
            end
          end
          TriggerClientEvent("chat:addMessage", source, {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><b><i class="fas fa-window-close" style="color: #ff0000;"></i><b>{0}</b></div>', 
            args = {"^3DISPATCH^0: We have notified dispatch regarding your 911 call!"}
          })
          Framework.discordLog(000000, GetPlayerName(source) .. " [#" .. source .. "]", "(911 call made) `" .. table.concat(args, " ") .. "`")
        end
      end
    end
  end)
end


-- PANIC SYSTEM --
if(Config.panicSystem.enabled) then
  Framework.RegisterCommand('panic', nil, "civ_level", function(source, args, message, player) 
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    for _, player in ipairs(Framework.getPlayers()) do
      if(player.leoPerms) then
        TriggerClientEvent('NAT2K15:PANICPRESSED', player.src, coords, "^1[PANIC] ^0" .. player.char_name .. " [" .. player.dept .. "]")
      end
    end
    Framework.discordLog(0000000, "Command used - [panic]", "**Steam Name:** " ..GetPlayerName(source) .. "\n**Steam Hex:** " ..player.steam.."\n**Message:** " ..table.concat(args, " ")) 

  end)
end

if(Config.commands.adminChatCommand) then
    Framework.RegisterCommand('adminchat', "admin_level", nil, function(source, args, message, player) 
      if(args[1] == nil) then return end
      for _, players in pairs(Framework.getPlayers()) do
        if(Framework.checkAdmin(players.src)) then 
          TriggerClientEvent('chatMessage', players.src, '[^6ADMIN^0] ^3' .. GetPlayerName(source) .. ":^0 " .. table.concat(args, " "))
        end
      end
      Framework.discordLog(0000000, "Command used - [adminchat]", "**Steam Name:** " ..GetPlayerName(source) .. "\n**Steam Hex:** " .. player.steam.."\n**Message:** " ..table.concat(args, " ")) 

    end)
end


if(Config.commands.callAdminCommand) then
    Framework.RegisterCommand('calladmin', nil, nil, function(source, args, message, player) 
      TriggerClientEvent("chat:addMessage", source, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgb(36, 36, 36); text-align: center; border-radius: 3px;"><b><i class="fas fa-window-close" style="color: #ff0000;"></i> {0}</b></div>', 
        args = {"^3You have successfully called an admin!"}
      })
      local message = table.concat(args, " ")
      if(message == "") then 
        message = "No message provided"
      end
      for _, players in pairs(Framework.getPlayers()) do
        if(Framework.checkAdmin(players.src)) then
          TriggerClientEvent("chat:addMessage", players.src, {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><b><i class="fas fa-window-close" style="color: #ff0000;"></i> {0}</b><br><b>{1}</b></br></div>', 
            args = {"[^1STAFF^0] " .. GetPlayerName(source) .. " [#" .. source .. "] has called an admin for " .. message, "To respond to this call use /telp ".. player.src}
          })
        end
      end
      Framework.discordLog(00000, GetPlayerName(source) .. " [#" .. source .. "]", "Has called an admin!")
    end)
end

if(Config.commands.tpCommand) then
  Framework.RegisterCommand('telp', "admin_level", nil, function(source, args, message, player)
    local src = source
    if(args[1] == nil or tonumber(args[1]) == nil) then
      TriggerClientEvent('chatMessage', src, "[^3SYSTEM^0] Please provide an ID to teleport to.")
    else 
      local player = tonumber(args[1])
      local testname = GetPlayerName(player)
      if(testname == nil) then
        TriggerClientEvent('chatMessage', src, "^1You have entred an invalid player!")
      else 
        if(player == src) then
          TriggerClientEvent('chatMessage', src, "[^1STAFF^0] You cannot teleport to your self!")
        else 
          local fix = GetPlayerName(player) .. " [#" .. player .. "]"
          TriggerClientEvent("NAT2K15:TPADMINTOSOMEONE", src, player, fix)
        end
      end
    end
    Framework.discordLog(0000000, "Command used - [telp]", "**Steam Name:** " ..GetPlayerName(source) .. "\n**Steam Hex:** " ..player.steam.."\n**Message:** " ..table.concat(args, " ")) 

  end)
end

if(Config.aopSettings.enabled) then
  Framework.RegisterCommand('aop', "admin_level", nil, function(source, args, message, player)
    if (string.len(table.concat(args, " ")) > 0) then
        Framework.discordLog(000000, GetPlayerName(source) .. " [#" .. source .. "]", "Aop switched to `" .. table.concat(args, " ") .. "`")
        Framework.setAop(table.concat(args, " "))
        TriggerClientEvent("NAT2K15:AOPCHANGE", -1, table.concat(args, " "))
        TriggerClientEvent("NAT2K15:AOPNOT", -1, "Aop switched to ~b~" .. table.concat(args, " "))
        Framework.discordLog(0000000, "Command used - [aop]", "**Steam Name:** " ..GetPlayerName(source) .. "\n**Steam Hex:** " ..player.steam.."\n**Message:** " ..table.concat(args, " ")) 

      end
  end)

  Framework.RegisterCommand("checkaop", nil, nil, function(source, args, message, player)
    TriggerClientEvent("chatMessage", source, "Current server AOP is: ^3" .. Framework.getAop())
    Framework.discordLog(0000000, "Command used - [checkaop]", "**Steam Name:** " ..GetPlayerName(source) .. "\n**Steam Hex:** " ..player.steam.."\n**Message:** " ..table.concat(args, " ")) 

  end)
end

if(Config.peacetimeSettings.enabled) then
  Framework.RegisterCommand('pt', "admin_level", nil, function(source, args, message, player)
    local peacetime = Framework.getPeacetime()
    if(peacetime) then
      Framework.setPeacetime(not peacetime)
      TriggerClientEvent("NAT2K15:CHANGEPT", -1, false)
      TriggerClientEvent("NAT2K15:PEACETIMENOT", -1, "Peace time has been ~g~Disabled")
      Framework.discordLog(000000, GetPlayerName(source) .. " [#" .. source .. "]", "has disabled peacetime!")
    else
      Framework.setPeacetime(not peacetime)
      TriggerClientEvent("NAT2K15:CHANGEPT", -1, true)
      TriggerClientEvent("NAT2K15:PEACETIMENOT", -1, "Peace time has been ~r~Enabled")
      Framework.discordLog(000000, GetPlayerName(source) .. " [#" .. source .. "]",  "has enabled peacetime!")
    end
  end)
end

if(Config.prioritySettings.enabled) then
  Framework.RegisterCommand('pstart', nil, nil, function(source, args, message, player)
    local allowed = false
    if(Config.prioritySettings.permissions.everyone) then
      allowed = true
    elseif(Config.prioritySettings.permissions.leo) then
      if(player and player.leoPerms) then
        allowed = true
      end
    elseif(config.prioritySettings.permissions.civ) then
      if(player and player.leoPerms) then
        allowed = true
      end
    elseif(Framework.checkAdmin(source)) then
      allowed = true
    end
    if(allowed) then
      Framework.priority.currentName = GetPlayerName(source)
      TriggerClientEvent("NAT2K15:UPDATEPRIORTY", -1, true, Framework.priority.currentName)
      Framework.priority.start = true
      Framework.priority.hold = false
    else 
      TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "You are not allowed to use this command!")
    end
    Framework.discordLog(0000000, "Command used - [pstart]", "**Steam Name:** " ..GetPlayerName(source) .. "\n**Steam Hex:** " ..player.steam.."\n**Message:** " ..table.concat(args, " ")) 

  end)

  Framework.RegisterCommand('phold', nil, nil, function(source, args, message, player)
    local allowed = false
    if(Config.prioritySettings.permissions.everyone) then
      allowed = true
    elseif(Config.prioritySettings.permissions.leo) then
      if(player and player.leoPerms) then
        allowed = true
      end
    elseif(config.prioritySettings.permissions.civ) then
      if(player and player.leoPerms) then
        allowed = true
      end
    elseif(Framework.checkAdmin(source)) then
      allowed = true
    end
    if(allowed) then
      TriggerClientEvent('NAT2K15:HOLDPRIORTY', -1, true)
      Framework.priority.start = false
      Framework.priority.hold = true
    else 
      TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "You are not allowed to use this command!")
    end
    Framework.discordLog(0000000, "Command used - [phold]", "**Steam Name:** " ..GetPlayerName(source) .. "\n**Steam Hex:** " ..player.steam.."\n**Message:** " ..table.concat(args, " ")) 

  end)

  Framework.RegisterCommand('pend', nil, nil, function(source, args, message, player)
    local allowed = false
    if(Config.prioritySettings.permissions.everyone) then
      allowed = true
    elseif(Config.prioritySettings.permissions.leo) then
      if(player and player.leoPerms) then
        allowed = true
      end
    elseif(config.prioritySettings.permissions.civ) then
      if(player and player.leoPerms) then
        allowed = true
      end
    elseif(Framework.checkAdmin(source)) then
      allowed = true
    end
    if(allowed) then
      local length = args[1];
      if(not length or not tonumber(length)) then length = 20 end;
      if(tonumber(length) > Framework.priority.maxTime) then length = Framework.priority.defaultTime end;
      TriggerEvent("NAT2K15:UPDATEPRIORTYS", tonumber(length));
    else 
      TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "You are not allowed to use this command!")
    end
    Framework.discordLog(0000000, "Command used - [pend]", "**Steam Name:** " ..GetPlayerName(source) .. "\n**Steam Hex:** " ..player.steam.."\n**Message:** " ..table.concat(args, " ")) 

  end)
end

if(Config.commands.chatClearCommand) then
  Framework.RegisterCommand('clearchat', "admin_level", nil, function(source, args, message, player)
    TriggerClientEvent("chat:clear", -1)
    Citizen.Wait(100)
    TriggerClientEvent('chatMessage', -1, 'SYSTEM', {255, 0, 0}, "Chat has been cleared by " .. GetPlayerName(source))
    Framework.discordLog(0000000, "Command used - [clearchat]", "**Steam Name:** " ..GetPlayerName(source) .. "\n**Steam Hex:** " ..player.steam.."\n**Message:** " ..table.concat(args, " ")) 

  end)
end

if(Config.muteSystem.enabled) then
  Framework.RegisterCommand(Config.muteSystem.command, 'admin_level', nil, function(source, args, message, player) 
    local mutePlayer = tonumber(args[1])
    if(mutePlayer) then
      if(mutePlayer == source) then -- dont forget to change
                TriggerClientEvent("chat:addMessage", source, {
          template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><b><i class="fas fa-window-close" style="color: #ff0000;"></i> {0}</b></div>', 
          args = {"You cannot mute your self."}
        })
      else 
        local muteName = GetPlayerName(mutePlayer)
        if(muteName) then
          local getPlayer = Framework.getMutedPlayer(mutePlayer)
          if(getPlayer) then
                    TriggerClientEvent("chat:addMessage", source, {
              template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><i class="fas fa-window-close" style="color: #ff0000;"></i> <b>{0}</b></div>', 
              args = {"The user is already muted. If you wish to unmute them use /" .. Config.muteSystem.unmuteCommand ..  " <id>."}
            })
          else
            local time = args[2]
            if(time) then
              if (Framework.endsWith(time, "s") or Framework.endsWith(time, "m") or Framework.endsWith(time, "h") or Framework.endsWith(time, "d")) then
                local fixedTime = Framework.convertTimeFromMS(time)
                Framework.mutePlayer(source, mutePlayer, fixedTime)
                        TriggerClientEvent("chat:addMessage", source, {
                  template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><i class="fas fa-check-square" style="color: #0ba800;"></i> <b>{0}</b></div>', 
                  args = {"^3You have successfully muted " .. muteName .. " for " .. Framework.timeUntil(fixedTime) .. "."}
                })
              else
                        TriggerClientEvent("chat:addMessage", source, {
                  template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><i class="fas fa-window-close" style="color: #ff0000;"></i> <b>{0}</b></div>', 
                  args = {"Input is invalid. Please use 's' for seconds, 'm' for minutes, 'h' for hours, or 'd' for days."}
                })
              end
            else 
              local fixedTime = Framework.convertTimeFromMS(Config.muteSystem.defaultTime)
              Framework.mutePlayer(source, mutePlayer, fixedTime)
                      TriggerClientEvent("chat:addMessage", source, {
                template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><i class="fas fa-check-square" style="color: #0ba800;"></i> <b>{0}</b></div>', 
                args = {"^3You have successfully muted " .. muteName .. " for " .. Framework.timeUntil(fixedTime) .. "."}
              })
            end
          end
        else 
                  TriggerClientEvent("chat:addMessage", source, {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><i class="fas fa-window-close" style="color: #ff0000;"></i> <b>{0}</b></div>', 
            args = {"The player you mentioned was not found within the server."}
          })
        end
      end
    else 
              TriggerClientEvent("chat:addMessage", source, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><b><i class="fas fa-window-close" style="color: #ff0000;"></i> {0}</b></div>', 
        args = {"The player you mentioned was not found within the server."}
      })
    end
    Framework.discordLog(0000000, "Command used - [mute]", "**Steam Name:** " ..GetPlayerName(source) .. "\n**Steam Hex:** " ..player.steam.."\n**Message:** " ..table.concat(args, " ")) 

  end)

  Framework.RegisterCommand(Config.muteSystem.unmuteCommand, 'admin_level', nil, function(source, args, message, player) 
    local unmutePlayer = tonumber(args[1])
    if(unmutePlayer) then
      local mutedPlayer = Framework.getMutedPlayer(unmutePlayer)
      if(mutedPlayer) then
        Framework.unmutePlayer(GetPlayerName(source) .. " #" .. source, unmutePlayer)
                TriggerClientEvent("chat:addMessage", source, {
          template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><i class="fas fa-check-square" style="color: #0ba800;"></i> <b>{0}</b></div>', 
          args = {"^3You have successfully Unmuted " .. GetPlayerName(unmutePlayer) .. " #" .. unmutePlayer .. "."}
        })
      else 
                TriggerClientEvent("chat:addMessage", source, {
          template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><i class="fas fa-window-close" style="color: #ff0000;"></i> <b>{0}</b></div>', 
          args = {"The user is not muted."}
        })
      end
    else 
              TriggerClientEvent("chat:addMessage", source, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px;"><b><i class="fas fa-window-close" style="color: #ff0000;"></i> {0}</b></div>', 
        args = {"The player you mentioned was not found within the server."}
      })
    end
    Framework.discordLog(0000000, "Command used - [unmute]", "**Steam Name:** " ..GetPlayerName(source) .. "\n**Steam Hex:** " ..player.steam.."\n**Message:** " ..table.concat(args, " ")) 

  end)
end

if(Config.blipSystem.enabled) then 
  Framework.RegisterCommand('leoblips', nil, 'civ_level', function(source, args, message, player) 
    if(player.leoPerms) then 
      local enabled = true;
      for k, v in ipairs(Framework.leoBlips) do
        if v.src == player.src then
          enabled = false
          TriggerClientEvent("chat:addMessage", source, {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px; text: center;"><b><i class="fas fa-window-close" style="color: #ff0000;"></i> {0}</b></div>', 
            args = {"❌ You have disabled your leo blips, your location is now hidden from all other active LEO."}})
          TriggerEvent('NAT2K15:BLIP:CHANGE', player.src, false, Framework.leoBlips)
          break
        end
      end
      if(enabled) then 
        TriggerClientEvent("chat:addMessage", source, {
          template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgb(36, 36, 36); border-radius: 3px; text: center;"><b><i class="fas fa-window-close" style="color: #ff0000;"></i> {0}</b></div>', 
          args = {"✔ You have enabled your leo blips, your location is now visible to all other active LEO."}})
          TriggerEvent('NAT2K15:BLIP:CHANGE', player.src, true, player)
      end
    else 
      TriggerClientEvent("chat:addMessage", source, {template = '<div style="padding: 0.5vw; text-align: center; margin: 0.5vw; background-color: rgba(235, 21, 46, 0.6); border-radius: 3px;"><b>{0}</b></div>', args = {"Access Denied!"}})
    end
    Framework.discordLog(0000000, "Command used - [leoblips]", "**Steam Name:** " ..GetPlayerName(source) .. "\n**Steam Hex:** " ..player.steam.."\n**Message:** " ..table.concat(args, " ")) 

  end)
end
