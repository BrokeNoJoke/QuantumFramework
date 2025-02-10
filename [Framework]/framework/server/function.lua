Framework.createRandomString = function(length) 
  local upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  local lowerCase = "abcdefghijklmnopqrstuvwxyz"
  local numbers = "0123456789"
  local characterSet = upperCase .. lowerCase .. numbers
  local output = ""
  for	i = 1, tonumber(length) do
    local rand = math.random(#characterSet)
    output = output .. string.sub(characterSet, rand, rand)
  end
  return output
end


Framework.getSonoranChars = function(steam, cb)
  local data = {
    ["id"] = Config_s.sonorancad_id,
    ["key"] = Config_s.sonorancad_apiKey,
    ["type"] = "GET_CHARACTERS",
    ["data"]=  {
      {
        ["apiId"] = steam
      }
    }  
  }
  
  PerformHttpRequest(Config_s.sonoranLink .. "civilian/get_characters", function(errorCode, resultData, resultHeaders)
    errorCode = tostring(errorCode)
    if(errorCode == "200") then
      resultData = json.decode(resultData)
      if(not resultData[1])then 
        return cb(nil)
      else
        return cb(resultData[1].id)
      end
    else 
      return cb(nil)
    end
  end, "POST", json.encode(data))
end

-- Framework stuff --
Framework.RegisterCommand = function(name, restrict, blacklist, callback)
  RegisterCommand(name, function(source, args, raw)
    local src = source
    local player = Framework.getPlayer(src)
    if(player) then
      if(Framework.checkAdmin(source)) then
        callback(source, args, raw, player)
      else 
        local muteCheck = Framework.getMutedPlayer(src)
        local stillAllowed = false;
        if(muteCheck) then
          local currentTimestamp = os.time()
          local diffSeconds = math.floor(os.difftime(muteCheck.endtime, currentTimestamp))
          if(diffSeconds <= 0) then
            Framework.unmutePlayer("Auto Unmute", src)
            stillAllowed = true
          else 
            stillAllowed = false
          end
        else 
          stillAllowed = true
        end
        if(stillAllowed) then
          if(restrict) then
            if(player.level == restrict) then
              callback(source, args, raw, player)
            else 
              TriggerClientEvent("chat:addMessage", source, {template = '<div style="padding: 0.5vw; text-align: center; margin: 0.5vw; background-color: rgba(235, 21, 46, 0.6); border-radius: 3px;"><b>{0}</b></div>', args = {"Access Denied!"}})
            end
          elseif(blacklist) then
            if(blacklist == player.level) then
              TriggerClientEvent("chat:addMessage", source, {template = '<div style="padding: 0.5vw; text-align: center; margin: 0.5vw; background-color: rgba(235, 21, 46, 0.6); border-radius: 3px;"><b>{0}</b></div>', args = {"Access Denied!"}})
            else 
              callback(source, args, raw, player)
            end
          else 
            callback(source, args, raw, player)
          end
        else 
          TriggerClientEvent("chat:addMessage", source, {template = '<div style="padding: 0.5vw; text-align: center; margin: 0.5vw; background-color: rgba(235, 21, 46, 0.6); border-radius: 3px;"><b>{0}</b></div>', args = {"You are muted. You cannot send any message for another " .. Framework.timeUntil(muteCheck.endtime) .. "."}})
        end
      end
    else 
      TriggerClientEvent("chat:addMessage", source, {template = '<div style="padding: 0.5vw; text-align: center; margin: 0.5vw; background-color: rgba(235, 21, 46, 0.6); border-radius: 3px;"><b>{0}</b></div>', args = {"Access Denied!"}})
    end
  end)
end

Framework.checkWords = function(str)
  if(Config.chatBlocker.enabled) then
    for badword in ipairs(Config.chatBlocker.blacklistWords) do
      if string.match(string.lower(str), Config.chatBlocker.blacklistWords[badword]) then
        return true
      end
    end
    return false
  else 
    return false
  end
end

Framework.checkLength = function(str)
  if(Config.enable_chat_length) then
    if(#str > Config.max_chat_length) then
      return false
    else
      return true
    end
  else
    return true
  end
end

Framework.getDiscord = function(id)
  for k,v in ipairs(GetPlayerIdentifiers(id)) do
		if string.match(v, 'discord:') then
      return string.sub(v, 9)
		end
	end  
  return nil
end

Framework.getSteam = function(id)
  return GetPlayerIdentifier(id, 0)
end


Framework.formatDiscordId =  function(discord) 
  if(discord) then
    local discordFixed = "<@" ..discord .. "> (" .. discord .. ")"
    return discordFixed
  else 
    return false
  end
end

Framework.discordLog = function(color, name, message)
  local embed = {
    {
      ["color"] = color,
      ["title"] = "**".. name .."**",
      ["description"] = message,
      ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%S'),
      ["footer"] = {
        ["text"] = "MADE BY NAT2K15#2951", -- do not remove
      },
    }
  }

  PerformHttpRequest(Config_s.webhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed, avatar_url = Config_s.avatar_url}), { ['Content-Type'] = 'application/json' })
end

Framework.checkAdmin = function(id)
  local player = Framework.getPlayer(id)
  if(player) then
    if(player.admin or player.level == 'admin_level') then
      return true
    end
  end
  return false
end

Framework.getChars = function(id, cb)
  local steamid = Framework.getSteam(id)
  if(steamid) then
    MySQL.Async.fetchAll("SELECT * FROM characters WHERE steamid=@steamid", {["@steamid"] = steamid}, function(data)
      cb(data)
    end)
  else 
    cb({})
  end
end


Framework.getPlayers = function()
  return Framework.serverPlayers
end

Framework.getPlayer = function(id)
  if(Framework.serverPlayers[id]) then
    return Framework.serverPlayers[id]
  else 
    return nil
  end
end


Framework.getName = function(id) 
  if(id) then
    if(Framework.serverPlayers[id]) then
      return Framework.serverPlayers[id].char_name
    end
  end
  return nil
end

Framework.getSettings = function(id, cb) 
  local steamid = Framework.getSteam(id)
  local discord = Framework.getDiscord(id)
  if(steamid) then
    MySQL.Async.fetchAll("SELECT * FROM characters_settings WHERE steamid=@steamid", {["@steamid"] = steamid}, function(data)
      if(not data[1]) then
        MySQL.Async.execute("INSERT INTO characters_settings (discord, steamid) VALUES (@discord, @steamid)", {["@discord"] = discord, ["@steamid"] = steamid})
        cb({dark_mode = "1", cloud_spawning = "1", slideshow = "0", character_gardient = "#DDADF3|#582185", refresh_gardien = "#3E3BDF|#6529C5", settings_gardient = "#1792DA|#49C06D", disconnect_gardient = "#FF0000|#EB7F27", framework_side = "left", framework_background = nil, framework_hud = nil})
      else 
        cb({dark_mode = data[1].dark_mode, cloud_spawning = data[1].cloud_spawning, slideshow = data[1].image_slideshow, character_gardient = data[1].character_gardient_color, refresh_gardien = data[1].refresh_gardient_color, settings_gardient = data[1].settings_gardient_color, disconnect_gardient = data[1].disconnect_gardient_color, framework_side = data[1].framework_side, framework_background = data[1].framework_background, framework_hud = data[1].framework_hud})
      end
    end)
  else 
    cb({})
  end
end

Framework.insertIntoHamzCad = function(id, dept, postLink)
  if(Config_s.use_hamz_cad) then
    if(Config_s.Only_insert_if_civ) then
      if(dept == Config.deptInfo["civ_level"].name) then
        PerformHttpRequest(postLink, value, 'POST')
      end
    else 
      PerformHttpRequest(postLink, value, 'POST')
    end
  end
end


Framework.addPlayer = function(id, info, clientFramework) 
  if(id and info) then
    Framework.serverPlayers[id] = info
    TriggerClientEvent("NAT2K15:UPDATELEOS", id, info)
    if(Config.blipSystem.enabled and Config.blipSystem.blipSetting.autoenable) then 
      TriggerEvent('NAT2K15:BLIP:CHANGE', id, info.leoPerms, info, true)
    end
    return true
  else 
    return false
  end
end

Framework.removePlayer = function(id)
  if(id) then
    Framework.serverPlayers[id] = nil
    return true
  else 
    return false
  end
end

Framework.checkLeoPermissions = function(checkLevel) 
  for level, v in pairs(Config.deptInfo) do
    if(level == checkLevel) then
      return Config.deptInfo[level].permissions.leoPermissions
    end
  end
  return false
end

Framework.getAop = function()
  if(Framework.aop.enabled) then
    return Framework.aop.aop
  else 
    return false
  end
end

Framework.setAop = function(aop)
  if(Framework.aop.enabled and aop) then
    Framework.aop.aop = aop
    SetMapName(aop)
  else 
    return false
  end
end

Framework.getPeacetime = function()
  if(Framework.peacetime.enabled) then
    return Framework.peacetime.peacetime
  else
    return nil 
  end
end

Framework.setPeacetime = function(value)
  local peacetime = Framework.getPeacetime()
  Framework.peacetime.peacetime = value
end


Framework.checkMultipeRoles = function(userRoles, checkRoles)
  for k, v in pairs(userRoles) do
    for i, value in ipairs(checkRoles) do
      if(v == value) then
        return true
      end
    end
  end
  return false
end

Framework.checkMultipeAces = function(src, aces)
  local player = src
  for src, ace in ipairs(aces) do
    if IsPlayerAceAllowed(player, ace) then
      return true
    end
  end
  return false
end


Framework.getAllChars = function(callback)
  MySQL.Async.fetchAll("SELECT * FROM characters", {}, function(data)
    callback(data)
  end)
end

Framework.prepareStats = function(access, cb)
  if(access) then
    Framework.getAllChars(function(data)
      TriggerEvent('NAT2K15:PREPARECONFIG', function(config)
        cb({playerOnline = GetNumPlayerIndices(), playerArray = Framework.serverPlayers, config = config, characters = data, allowed = true})
      end)
    end)
  else 
    cb({allowed = nil})
  end
end

Framework.convertDeptIntoLevel = function(dept)
  for i, v in pairs(Config.deptInfo) do
    if(v.name == dept) then
      return i
    end
  end
  return nil
end

Framework.adminPanelAccess = function(discord)
  if(Framework.adminPlayers[discord] and Framework.adminPlayers[discord].adminPanel) then
    return true
  else 
    return false
  end
end

Framework.extractIdentifier = function(src)
  local identifiers = {}

  for i = 0, GetNumPlayerIdentifiers(src) - 1 do
      local id = GetPlayerIdentifier(src, i)
      if string.find(id, "steam:") then
          identifiers['steam'] = id
      elseif string.find(id, "ip:") then
          identifiers['ip'] = id
      elseif string.find(id, "discord:") then
          identifiers['discord'] = id
      elseif string.find(id, "license:") then
          identifiers['license'] = id
      elseif string.find(id, "license2:") then
          identifiers['license2'] = id
      elseif string.find(id, "xbl:") then
          identifiers['xbl'] = id
      elseif string.find(id, "live:") then
          identifiers['live'] = id
      elseif string.find(id, "fivem:") then
          identifiers['fivem'] = id
      end
  end

  return identifiers
end


Framework.checkAllPossibleIdentifiers = function(src, check)
  if(src) then
    for i, v in pairs(Framework.extractIdentifier(src)) do
      if(v == check) then
        return true      
      end
    end
  end
  return nil
end


Framework.print = function(case, msg) 
  if(case == "error") then
    print("^1[ERROR] ^0" .. msg)
  elseif(case == "warning") then
    print("^3[WARNING] ^0" .. msg)
  elseif(case == "success") then
    print("^2[SUCCESS] ^0" .. msg)
  elseif(case == "info") then
    print("^5[INFO] ^0" .. msg)
  elseif(case == "debug") then
    print("^6[DEBUG] ^0" .. msg)
  else 
    print("^7[LOG] ^0" .. msg)
  end
end


Framework.getRoles = function(discord)
  if discord then
    local endpoint = ("guilds/%s/members/%s"):format(Config.server_id, discord)
    local member = DiscordRequest(endpoint)
    if member.code == 200 then
        local data = json.decode(member.data)
        local roles = data.roles
        return roles
    end
  end
  return {}
end

Framework.getDiscordObject = function(discord)
  if discord and Config.use_discord then
    local endpoint = ("guilds/%s/members/%s"):format(Config.server_id, discord)
    local member = DiscordRequest(endpoint)
    if member.code == 200 then
        local data = json.decode(member.data)
        return data
    end
  end
  return {}
end

Framework.checkRole = function(userRoles, role)
  if(userRoles) then
    for i=1, #userRoles do
        if userRoles[i] == role then
            return true
        end
    end    
  end
  return false;
end

Framework.checkLevels = function(id, levels)
  local player = Framework.getPlayer(id)
  if(player) then
    for k, v in ipairs(levels) do
      if(player.level == v) then
        return true
      end
    end
  end
  return false
end

Framework.mutePlayer = function(src, id, time)
  if(Framework.mutedPlayers[id]) then
    Framework.mutedPlayers[id].endtime = time
    Framework.discordLog(0000, GetPlayerName(src) .. " #" .. src .. " Muted #" .. id, "Muted player " .. GetPlayerName(id) .. " until <t:" .. time .. ">")
  else 
    Framework.mutedPlayers[id] = {src = id, endtime = time, staff = src, dateMuted = os.time()}
    Framework.discordLog(0000, GetPlayerName(src) .. " #" .. src .. " Muted #" .. id, "Muted player " .. GetPlayerName(id) .. " until <t:" .. time .. ">")
  end
end

Framework.unmutePlayer = function(src, id)
  if(Framework.mutedPlayers[id]) then
    Framework.mutedPlayers[id] = nil
    Framework.discordLog(0000, src .. " Unmuted #" .. id, "unmuted player " .. GetPlayerName(id))
    return true
  else 
    return false
  end  
end

Framework.getMutedPlayer = function(id)
  if(Framework.mutedPlayers[id]) then
    return Framework.mutedPlayers[id]
  else 
    return nil
  end
end

Framework.convertTimeFromMS = function(time)
  local currentTime = os.time()
  local convertedTime = currentTime
  
  local unit = string.sub(time, -1) -- Get the last character of the input (e.g., 's', 'm', 'h', 'd')
  local value = tonumber(string.sub(time, 1, -2))
  
  if unit == 's' then
    convertedTime = convertedTime + value
  elseif unit == 'm' then
    convertedTime = convertedTime + value * 60
  elseif unit == 'h' then
    convertedTime = convertedTime + value * 60 * 60
  elseif unit == 'd' then
    convertedTime = convertedTime + value * 24 * 60 * 60
  else
    Framework.print("error", "Invalid time unit. Please use 's' for seconds, 'm' for minutes, 'h' for hours, or 'd' for days.")
    return currentTime
  end
  return convertedTime
end

Framework.timeUntil = function(unixTime)
  local currentTimestamp = os.time()
  local diffSeconds = math.floor(os.difftime(unixTime, currentTimestamp))

  if diffSeconds < 0 then
    return "In the past"
  elseif diffSeconds == 0 then
    return "Now"
  elseif diffSeconds < 60 then
    return diffSeconds .. " Seconds"
  elseif diffSeconds < 3600 then
    local diffMinutes = math.floor(diffSeconds / 60)
    return diffMinutes .. " Minutes"
  elseif diffSeconds < 86400 then
    local diffHours = math.floor(diffSeconds / 3600)
    return diffHours .. " hours"
  else
    local diffDays = math.floor(diffSeconds / 86400)
    return diffDays .. " days"
  end
end

Framework.endsWith = function(input, suffix)
  return string.sub(input, -string.len(suffix)) == suffix
end

Framework.getDecimals = function(number, decimalPoints)
  local formatString = string.format("%%.%df", decimalPoints)
  return string.format(formatString, number)
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

Framework.convertDeptIntoLevel = function(dept)
  if(dept) then   
    for i, v in pairs(Config.deptInfo) do
      if(v.name == dept) then
        return i
      end
    end
  end
  return nil
end