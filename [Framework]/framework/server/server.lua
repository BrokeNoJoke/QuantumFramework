-- MADE BY NAT2K15 -- 

--############-- 

Framework = {}
Framework.serverPlayers = {}
Framework.adminPlayers = {}
Framework.mutedPlayers = {}
Framework.leoBlips = {}
Framework.aop = {enabled = Config.aopSettings.enabled, aop = Config.aopSettings.defaultAop };
Framework.peacetime = {enabled = Config.peacetimeSettings.enabled, peacetime = false};
Framework.priority = {enabled = Config.prioritySettings.enabled, currentName = "", maxTime = Config.prioritySettings.time.maxTime, defaultTime = Config.prioritySettings.time.defaultTime, hold = false, start = false}

--############-- 

-- GETS USERS CHARCTERS -- 
RegisterNetEvent("NAT2K15:GETCHARCTERS")
AddEventHandler("NAT2K15:GETCHARCTERS", function(loc, id)
  local src = source

  if(id) then
    src = id
  end
  if(loc) then
    local player = Framework.getPlayer(src)
    if(player) then 
      MySQL.Async.execute("UPDATE characters SET lastLoc = @loc WHERE id = @id", {["@loc"] = "x=" .. Framework.getDecimals(loc.x, 4) .. "|y=" .. Framework.getDecimals(loc.y, 4) .. "|z=" .. Framework.getDecimals(loc.z, 4), ["@id"] = player.charid})
    end
  end

  local steamid = Framework.getSteam(src)
  local discord = Framework.getDiscord(src)
  local admin = false
  local adminPanel = false
  local perms = {}
  local MembeRoles = nil


  if(Config.use_discord) then
    MembeRoles = Framework.getRoles(discord)
    admin = Framework.checkMultipeRoles(MembeRoles, Config.deptInfo["admin_level"].permissions.allowedPerms)
    adminPanel = Framework.checkMultipeRoles(MembeRoles, Config.uiSettings.adminPanel.allowedRoles)
  else 
    admin = Framework.checkMultipeAces(src, Config.deptInfo["admin_level"].permissions.allowedPerms)
    adminPanel = Framework.checkMultipeAces(src, Config.uiSettings.adminPanel.allowedRoles)
  end
  
  for level, v in pairs(Config.deptInfo) do
    if(Config.deptInfo[level]) then
      perms[level] = {discord = discord, id = level, name = v.name, spawns = v.spawns, perms = false, level_name = level, admin = false, adminPanel = adminPanel}
      if(admin) then 
        perms[level].admin = true
        if(Config.adminPermissions.GiveAllDepartments) then
          perms[level].perms = true
        end
      end
      if(perms[level].perms == false) then
        if(Config.deptInfo[level].permissions.enabledEveryone) then
          perms[level].perms = true
        else 
          if(Config.use_discord) then
            perms[level].perms = Framework.checkMultipeRoles(MembeRoles, v.permissions.allowedPerms)
          else 
            perms[level].perms = Framework.checkMultipeAces(src, v.permissions.allowedPerms)
          end
        end
      end
    end
  end

  Framework.adminPlayers[discord] = {roles = MembeRoles, admin = admin, adminPanel = adminPanel, perms = perms, steamid = steamid, discord = discord, src = src}
  Framework.prepareStats(adminPanel, function(stats) 
    Framework.getSettings(src, function(settings)
      Framework.getChars(src, function(chars)
        if(Config.characterSettings.checkOldCharacter and not admin) then
          for i, v in pairs(chars) do
            local level = Framework.convertDeptIntoLevel(v.dept)
            for k, value in pairs(perms) do
              if(perms[level] and not perms[level].perms) then
                Citizen.Wait(5)
                MySQL.Async.execute("DELETE FROM characters WHERE steamid = @steam AND dept = @dept AND first_name = @first AND last_name = @last", {["@steam"] = steamid, ["@dept"] = v.dept, ["@first"] = v.first_name, ["@last"] = v.last_name})
                Framework.discordLog(0000000, "Auto Character Removal", "**Steam Hex:** " ..steamid.. "\n**Discord ID:** " ..Framework.formatDiscordId(discord).. "\n**Character Name:** " .. v.first_name .. " " .. v.last_name ..  "\n**Twitter Name:** " ..v.twitter_name.. "\n**Gender:** " ..v.gender.. "\n**Data of birth:** " ..v.dob.. "\n**Department:** " ..v.dept.. "\nThis Character was removed due to the user not having access to the role in the discord anymore.")
                print("\nDeleting!\n**Character Name:** " .. v.first_name .. " " .. v.last_name ..  "\n**Twitter Name:** " ..v.twitter_name.. "\n**Gender:** " ..v.gender.. "\n**Data of birth:** " ..v.dob.. "\n**Department:** " ..v.dept.. "")
                break
              end
            end
          end
          Framework.getChars(src, function(fixedChars)
            TriggerClientEvent("NAT2K15:OPENUI", src, fixedChars, settings, perms, stats)
          end)
        else 
          TriggerClientEvent("NAT2K15:OPENUI", src, chars, settings, perms, stats)
        end
      end)
    end)
  end)
end)



-- UI refresh --
RegisterNetEvent("NAT2K15:UIREFRESH")
AddEventHandler("NAT2K15:UIREFRESH", function(id)
  local src = id
  local perms = Framework.adminPanelAccess(Framework.getDiscord(src))
  Framework.prepareStats(perms, function(stats) 
    Framework.getChars(src, function(data)
      Citizen.Wait(100)
      TriggerClientEvent("NAT2K15:RESETUI", src, data, stats)
    end)
  end)
end)

-- CREATE USER --
RegisterNetEvent("NAT2K15:CREATECHARCTER")
AddEventHandler("NAT2K15:CREATECHARCTER", function(first, last, twt, gender, dob, dept, data)
  local src = source
  local discord = Framework.getDiscord(src);
  local steamid = Framework.getSteam(src) 
  MySQL.Async.execute("INSERT INTO characters (discord, steamid, first_name, last_name, twitter_name, gender, level, dob, dept) VALUES (@discord, @steamid, @first_name, @last_name, @twitter_name, @gender, @level, @dob, @dept)", {["@discord"] = discord, ["@steamid"] = steamid, ["@first_name"] = first, ["@last_name"] = last, ["@twitter_name"] = twt, ["@dob"] = dob, ["@gender"] = gender,  ["@level"] = data.level, ["@dept"] = dept}, function()end)
  Framework.insertIntoHamzCad(src, dept, Config_s.website_url .. "api/createcharacter/?discordid=" .. discord .. "&name=" .. first .. "%20" .. last .. "&dob=" .. dob .. "&gender=" .. gender .. "&secret=" .. Config_s.secret_key)

  if(Config_s.use_sonorancad) then
    if(dept == Config.deptInfo["civ_level"].name) then

    end
    local fixedGender = "M"
    if(gender == "Male") then
      fixedGender = "M"
    else 
      fixedGender = "F"
    end
    local year, month, day = dob:match("(%d+)-(%d+)-(%d+)")
    year, month, day = tonumber(year), tonumber(month), tonumber(day)
    local todayYear, todayMonth, todayDay = 2024, 4, 4
    local age = todayYear - year
    if todayMonth < month or (todayMonth == month and todayDay < day) then
      if(age == 0) then
        age = 0
      else 
        age = age - 1
      end
    end



    local data = {
      ["id"] = Config_s.sonorancad_id,
      ["key"] = Config_s.sonorancad_apiKey,
      ["type"] = "NEW_CHARACTER",
      ["data"] = {
        {
          ["user"] = string.gsub(steamid, "steam:", ""),
          ["useDictionary"] = true,
          ["recordTypeId"] = 7,
          ["replaceValues"] = {
              ["first"] = first,
              ["last"] = last,
              ["dob"] = dob,
              ["sex"] = fixedGender,
              ["age"] = tostring(age)
          }
        }
      
      }
    }
    if(Config_s.sonorancad_OnlyInsertIfCiv) then
      if(dept == Config.deptInfo["civ_level"].name) then
        PerformHttpRequest(Config_s.sonoranLink .. "civilian/new_character", function(errorCode, resultData, resultHeaders)
          errorCode = tostring(errorCode)
          if(errorCode ~= "200") then
            print("There was an error executing an API call to sonoran. Error code: " .. errorCode)
          end
        end, "POST", json.encode(data))
      end
    else 
      PerformHttpRequest(Config_s.sonoranLink .. "civilian/new_character", function(errorCode, resultData, resultHeaders)
        errorCode = tostring(errorCode)
        if(errorCode ~= "200") then
          print("There was an error executing an API call to sonoran [CREATE]. Error code: " .. errorCode)
        end
      end, "POST", json.encode(data))
    end

  end

  Citizen.Wait(100)
  TriggerEvent("NAT2K15:UIREFRESH", src)
  Framework.discordLog(0000000, "Character creation", "**Steam Hex:** " ..steamid.. "\n**Discord ID:** " ..Framework.formatDiscordId(discord).. "\n**Character Name:** " ..first.. " " .. last ..  "\n**Twitter Name:** " ..twt.. "\n**Gender:** " ..gender.. "\n**Data of birth:** " ..dob.. "\n**Department:** " ..dept)
end)

-- EDIT USER --
RegisterNetEvent("NAT2K15:EDITCHARCTER")
AddEventHandler("NAT2K15:EDITCHARCTER", function(first, last, twt, gender, dob, charid, dept, oldfirst, oldlast, data)
  local src = source
  local discord = Framework.getDiscord(src);
  local steamid = Framework.getSteam(src) 

  MySQL.Async.execute("UPDATE characters SET first_name = @first_name, last_name = @last_name, twitter_name = @twotter_name, gender = @gender, dob = @dob, level = @level, dept = @dept WHERE id = @id", {["@first_name"] = first, ["@last_name"] = last, ["@twotter_name"] = twt, ["@gender"] = gender, ["@dob"] = dob, ["@level"] = data.level, ["@dept"] = dept, ["@id"] = charid})
  Framework.insertIntoHamzCad(Config_s.website_url .. "api/updatecharacter/?discordid=" .. discord .. "&oldname=" .. oldfirst .. "%20" .. oldlast .. "&newname=" .. first .. "%20" .. last .. "&dob=" .. dob .. "&gender=" .. gender .. "&secret=" .. Config_s.secret_key)

  if(Config_s.use_sonorancad) then
    Framework.getSonoranChars(steamid, function(id) 
      if(id == nil) then
        print("There was an error executing an API call to sonoran [EDIT]. ID: unknown. The account was not found in the API")
      else 
        local fixedGender = "M"
        if(gender == "Male") then
          fixedGender = "M"
        else 
          fixedGender = "F"
        end
      
        local data = {
          ["id"] = Config_s.sonorancad_id,
          ["key"] = Config_s.sonorancad_apiKey,
          ["type"] = "EDIT_CHARACTER",
          ["data"] = {
            {
              ["user"] = string.gsub(steamid, "steam:", ""),
              ["useDictionary"] = true,
              ["recordTypeId"] = 7,
              ["recordId"] = tonumber(id),
              ["replaceValues"] = {
                  ["first"] = first,
                  ["last"] = last,
                  ["dob"] = dob,
                  ["sex"] = fixedGender
              }
            }
          }
        }
    
        if(Config_s.sonorancad_OnlyInsertIfCiv) then
          if(dept == Config.deptInfo["civ_level"].name) then
            PerformHttpRequest(Config_s.sonoranLink .. "civilian/edit_character", function(errorCode, resultData, resultHeaders)
              errorCode = tostring(errorCode)
              if(errorCode ~= "200") then
                print("There was an error executing an API call to sonoran [EDIT]. Error code: " .. errorCode)
              end
            end, "POST", json.encode(data))
          end
        else 
          PerformHttpRequest(Config_s.sonoranLink .. "civilian/edit_character", function(errorCode, resultData, resultHeaders)
            errorCode = tostring(errorCode)
            if(errorCode ~= "200") then
              print("There was an error executing an API call to sonoran [EDIT]. Error code: " .. errorCode)
            end
          end, "POST", json.encode(data))
        end
      end
    end)
    
  end
  Citizen.Wait(50)
  TriggerEvent("NAT2K15:UIREFRESH", src)
end)


-- SQL CHECKING TO SYNC WITH COMMANDS --
RegisterNetEvent("NAT2K15:CHECKSQL")
AddEventHandler("NAT2K15:CHECKSQL", function(steam, discord, first_name, last_name, twt, dept, dob, gender, data, clientFramework)
  local src = source
  local player = Framework.getPlayer(src)
  if(player) then 
    MySQL.Async.execute("UPDATE characters SET lastLoc = @loc WHERE id = @id", {["@loc"] = "x=" .. Framework.getDecimals(data.lastSpawn.x, 4) .. "|y=" ..Framework.getDecimals(data.lastSpawn.y, 4) .. "|z=" .. Framework.getDecimals(data.lastSpawn.z, 4), ["@id"] = data.char_id})
  end
  MySQL.Async.execute("UPDATE characters_settings SET dark_mode = @darkmode, cloud_spawning = @cloud, image_slideshow = @slideshow, character_gardient_color = @firstcolor, refresh_gardient_color = @secondcolor, settings_gardient_color = @thirdcolor, disconnect_gardient_color = @forthcolor, framework_side = @frameworkside, framework_background = @frameworkbackground, framework_hud = @framework_hud WHERE discord = @discord AND steamid = @steamid", {["@darkmode"] = data.dark_mode, ["@cloud"]  = data.cloud, ["slideshow"] = data.img_slideshow, ["@firstcolor"] = data.char_color, ["@secondcolor"] = data.refresh_color, ["@thirdcolor"] = data.settings_color, ["@forthcolor"] = data.disconnect_color, ["@frameworkside"] = data.frameworkside, ["@frameworkbackground"] = data.framework_background, ["@framework_hud"] = json.encode(data.frameworkhud), ["@discord"] = discord, ["@steamid"] = steam})
  Framework.addPlayer(src, {src = src, discord = discord, discordObject = Framework.getDiscordObject(discord), steam = steam, timejoined = os.date("%Y-%m-%d %H:%M:%S"), first = first_name, last = last_name, char_name = first_name .. " " .. last_name, twitter_name = twt, dob = dob, gender = gender, dept = dept, level = data.level,  admin = data.adminperms, x = 0, y = 0, z = 0, charid = data.char_id, leoPerms = Framework.checkLeoPermissions(data.level)}, clientFramework)
end)

AddEventHandler("playerDropped", function()
  local src = source
  local player = Framework.getPlayer(src)
  if player then
    TriggerEvent('NAT2K15:BLIP:CHANGE', src, false, player)
    local ped = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(ped)
    MySQL.Async.execute("UPDATE characters SET lastLoc = @loc WHERE id = @id", {["@loc"] = "x=" .. Framework.getDecimals(playerCoords.x, 4) .. "|y=" ..Framework.getDecimals(playerCoords.y, 4) .. "|z=" .. Framework.getDecimals(playerCoords.z, 4), ["@id"] = player.charid})
    Framework.removePlayer(src)
  end
end)

-- DELETE USER --
RegisterNetEvent("NAT2K15:DELETEUSER")
AddEventHandler("NAT2K15:DELETEUSER", function(data)
  local src = source
  local discord = Framework.getDiscord(src); 
  local steamid = Framework.getSteam(src)
  Framework.insertIntoHamzCad(src, data.dept, Config_s.website_url .. "api/deletecharacter/?discordid=" .. discord .. "&name=" .. data.first_name .. "%20" .. data.last_name .. "&secret=" .. Config_s.secret_key)

  if(Config_s.use_sonorancad) then
    Framework.getSonoranChars(steamid, function(id) 
      if(id == nil) then
        print("There was an error executing an API call to sonoran [DELETE]. ID: unknown. Account not found in the API")
      else 
        local data = {
          ["id"] = Config_s.sonorancad_id,
          ["key"] = Config_s.sonorancad_apiKey,
          ["type"] = "REMOVE_CHARACTER",
          ["data"] = {
            {
              ["id"] =  id
            }
          }
          }
        PerformHttpRequest(Config_s.sonoranLink .. "civilian/remove_character", function(errorCode, resultData, resultHeaders)
          errorCode = tostring(errorCode)
          if(errorCode ~= "200") then
            print("There was an error executing an API call to sonoran. Error code: " .. errorCode)
          end
        end, "POST", json.encode(data))
      end
    end)
    
  end
  MySQL.Async.execute("DELETE FROM characters WHERE id = @id AND steamid=@steamid", {["@steamid"] = steamid, ["@id"] = data.char_id}, function()end)
  Citizen.Wait(50)
  TriggerEvent("NAT2K15:UIREFRESH", src)
  Framework.discordLog(0000000, "Character Deleted", "**Character ID:** " .. data.char_id .."\n**Steam Hex:** " .. steamid.. "\n**Discord ID:** " .. Framework.formatDiscordId(data.discord).. "\n**Character Name:** " .. data.first_name .. " ".. data.last_name)
end)

RegisterNetEvent('NAT2K15:DELETEFROMADMINPANEL')
AddEventHandler('NAT2K15:DELETEFROMADMINPANEL', function(id) 
  local src = source;
  local discord = Framework.getDiscord(src);
  MySQL.Async.execute("DELETE FROM characters WHERE id = @id", {["@id"] = id}, function()end)
  for k, v in pairs(Framework.getPlayers()) do
    if(v.charid == id) then
      Framework.removePlayer(k)
      TriggerEvent("NAT2K15:GETCHARCTERS", nil, v.src)
      break
    end
  end
  TriggerEvent("NAT2K15:GETCHARCTERS", nil, src)
end)

-- SAVE CONFIG -- 
RegisterNetEvent('NAT2K15:SAVECONFIG')
AddEventHandler('NAT2K15:SAVECONFIG', function(data) 
  local src = source;
  local discord = Framework.getDiscord(src);
  if(not Framework.adminPlayers[discord].adminPanel) then
    return Framework.discordLog(00000, GetPlayerName(src) .. " tried to save config. [FAILED]", "**Discord ID:** " .. Framework.formatDiscordId(discord) .. "\n**Steam Hex:** " .. Framework.getSteam(src) .. "\n**IP:** " .. GetPlayerEndpoint(src) .. "\n**Reason:** Not an admin")
  else 
    local loadConfig = load(data.config)
    if(loadConfig) then
      loadConfig()
      TriggerClientEvent('NAT2K15:HANDLEUIUPDATE', -1, Config)
    end

    -- convert data.config which is a one big string to an object
    TriggerEvent('NAT2K15:SAVECONFIGPASSED', data)  
    Framework.discordLog(00000, GetPlayerName(src) .. " saved the config.", "**Discord ID:** " .. Framework.formatDiscordId(discord) .. "\n**Steam Hex:** " .. Framework.getSteam(src) .. "\n**IP:** " .. GetPlayerEndpoint(src) .. "\n**Reason:** Passed the check!")
  end 
end)


-- DISCONNECT
RegisterNetEvent("NAT2K15:DISCONNECTBUTTON")
AddEventHandler("NAT2K15:DISCONNECTBUTTON", function() 
  DropPlayer(source, "Disconnect from the server via framework.")
end)


if(Config.aopSettings.enabled) then
  local numaop = nil
  local timereset = 0
  SetMapName(Config.aopSettings.defaultAop)


  RegisterNetEvent("NAT2K15:UPDATEDUMBAOP")
  AddEventHandler("NAT2K15:UPDATEDUMBAOP", function()
    local src = source;

    TriggerClientEvent('NAT2K15:AOPCHANGE', src, Framework.getAop())
  end)

  if(Config.aopSettings.autoSwitcher) then
    Citizen.CreateThread(function()
      while true do
        Citizen.Wait(1000 * 60 * timereset)
        if(numaop == nil) then
          numaop = 0
          timereset = Config.aopSettings.autoSwitcherSettings[numaop].time
          Framework.setAop(Config.aopSettings.autoSwitcherSettings[numaop].aop)
        else
          numaop = numaop + 1
          if(Config.aopSettings.autoSwitcherSettings[numaop] ~= nil) then
            timereset = Config.aopSettings.autoSwitcherSettings[numaop].time
            Framework.setAop(Config.aopSettings.autoSwitcherSettings[numaop].aop)
          else 
            numaop = 0
            timereset = Config.aopSettings.autoSwitcherSettings[numaop].time
            Framework.setAop(Config.aopSettings.autoSwitcherSettings[numaop].aop)
          end
        end
        TriggerClientEvent("NAT2K15:AOPCHANGE", -1, Framework.getAop())
        TriggerClientEvent("NAT2K15:AOPNOT", -1, "Aop switched to ~b~" .. Framework.getAop())
        Framework.discordLog(000000, "Automatic system", "Aop switched to `" .. Framework.getAop() .. "`")
        end
    end)
  end
end

-- PRIORTY --
if(Config.prioritySettings.enabled) then
  local cooldown = 0
  local inactive = 0;


  RegisterNetEvent("NAT2K15:UPDATEPRIORTYS")
  AddEventHandler("NAT2K15:UPDATEPRIORTYS", function(time)   
    if Framework.priority.start then
      Framework.priority.start = false
      TriggerClientEvent('NAT2K15:UPDATEPRIORTY', -1, Framework.priority.start)
    end
    if Framework.priority.hold then
      Framework.priority.hold = false
      TriggerClientEvent('NAT2K15:HOLDPRIORTY', -1, Framework.priority.hold)
    end
    cooldown = time + 1;
    update()
  end)

  function update() 
    Citizen.CreateThread(function()
      while true do
        Citizen.Wait(0)
        if(cooldown > 0) then
          cooldown = cooldown - 1;
          TriggerClientEvent("NAT2K15:UPDATECOOLDOWN", -1, cooldown)
          Citizen.Wait(60000)
        end
      end
    end)
  end


  Citizen.CreateThread(function() 
    while true do 
      Citizen.Wait(60000)
      if (cooldown == 0) then
        inactive = inactive + 1;
        TriggerClientEvent("NAT2K15:UPDATEPR", -1, inactive)
      else 
        inactive = 0;
        TriggerClientEvent("NAT2K15:UPDATEPR", -1, inactive)
      end
    end 
  end)

  RegisterNetEvent("NAT2K15:UPDATEDAPRIORTY")
  AddEventHandler("NAT2K15:UPDATEDAPRIORTY", function() 
    local src = source;
    TriggerClientEvent("NAT2K15:UPDATEVARSPRI", src, cooldown, Framework.priority.start, Framework.priority.hold, inactive, Framework.priority.currentName)
  end)
end


-- PEACETIME -- 
if(Config.peacetimeSettings.enabled) then
  RegisterNetEvent("NAT2K15:UPDATEDUMBPEACETIME")
  AddEventHandler("NAT2K15:UPDATEDUMBPEACETIME", function()
    local src = source;
    TriggerClientEvent('NAT2K15:CHANGEPT', src, Framework.getPeacetime())
  end)
end


-- DOOR LOCK -- 
if(Config.doorLock.enabled) then
  RegisterNetEvent('NAT2K15:getDoorState')
  AddEventHandler('NAT2K15:getDoorState', function() 
    TriggerClientEvent('NAT2K15:returnDoorState', -1, Config_doors.DoorList)
  end)

  RegisterNetEvent('NAT2K15:CheckPermsDoor')
  AddEventHandler('NAT2K15:CheckPermsDoor', function(doorV, state)
    Config_doors.DoorList[doorV].locked = not Config_doors.DoorList[doorV].locked
    TriggerClientEvent('NAT2K15:returnDoorState', -1, Config_doors.DoorList)
  end)
end

-- Player Counter -- 
RegisterNetEvent('NAT2K15:GETPLAYERCOUNT')
AddEventHandler('NAT2K15:GETPLAYERCOUNT', function() 
  TriggerClientEvent('NAT2K15:UPDATEPLAYERCOUNT', -1, GetNumPlayerIndices())
end)

-- Shot Spotter -- 
RegisterNetEvent('NAT2K15:SHOTSPOTTER:ShotFired')
AddEventHandler('NAT2K15:SHOTSPOTTER:ShotFired', function(message) 
  local src = source;
  local player = Framework.getPlayer(src)
  if(player) then
    Citizen.Wait(Config.shotSpotter.cooldownBeforeDispatched * 1000)
    for _, players in pairs(Framework.getPlayers()) do
      if(players.leoPerms) then
        TriggerClientEvent('NAT2K15:NOTIFYCOPS:CLIENT', players.src, message)
      end
    end
  end
end)

-- Blip System -- 
if(Config.blipSystem.enabled) then 
  RegisterNetEvent('NAT2K15:BLIP:CHANGE')
  AddEventHandler('NAT2K15:BLIP:CHANGE', function(id, state, player) 
    for k, v in ipairs(Framework.leoBlips) do
      if v.src == id then
        table.remove(Framework.leoBlips, k)
        if(not state) then 
          TriggerClientEvent('NAT2K15:BLIP:CLIENTCHANGE', -1, Framework.leoBlips)
          TriggerClientEvent('NAT2K15:REMOVE:BLIP', -1, v.src)
        end
        break
      end
    end
    if state then
      if player and player.leoPerms then
        local info = {src = id, player = player, blip = nil, insideVehicle = false, playerIdx = false, ped = false, vehicle = false, vehicleclass = false, color = 1, friendly = false}
        if(Config.blipSystem.blipDept.enabled) then 
          for k, v in pairs(Config.blipSystem.blipDept.blips) do
            if(k == player.dept) then 
              info.color = v.color
              info.friendly = true;
              break
            end
          end
        end
        table.insert(Framework.leoBlips, info)
        TriggerClientEvent('NAT2K15:BLIP:CLIENTCHANGE', -1, Framework.leoBlips)
      end
    end
  end)
end




AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
  local src = source
  local discord = Framework.getDiscord(src)
  local steamid = Framework.getSteam(src)
  deferrals.defer();
  deferrals.update("Checking Discord Permissions...")
  local whitelist = false;

  if(Config.whitelistSettings.enabled) then
    if (Config.use_discord) then
      deferrals.update("Checking Whitelist Permissions...")
      whitelist = Framework.checkMultipeRoles(Framework.getRoles(discord), Config.whitelistSettings.whitelistRoles)
    else 
      whitelist = Framework.checkMultipeAces(src, Config.whitelistSettings.whitelistRoles)
    end
  else 
    whitelist = true
  end
  Citizen.Wait(500)
  deferrals.update("Checking to see if you are whitelisted...")
  if(whitelist) then
    deferrals.done()
  else 
    deferrals.done(Config.whitelistSettings.unauthorizedMessage)
    Framework.discordLog(0000000, "Player connection rejected", "**Steam Hex:** " ..steamid.. "\n**Discord ID:** " ..Framework.formatDiscordId(discord).. "\n**Reason:**\n Not whitelisted")
  end
end)


-- exports for the other scripts to work--
exports('getdept', function(id) 
  if(Framework.serverPlayers[id]) then
    return Framework.serverPlayers
  else 
    return nil
  end
end)

exports('geteverything', function() 
  return Framework.serverPlayers
end)

exports('getconfig', function() 
  return Config
end)

exports('sendtothediscord', function(color, name, message) 
  Framework.discordLog(color, name, message)
end)


exports('getaop', function() 
  return Framework.getAop()
end)

exports('getServerFunctions', function()
  return Framework
end)