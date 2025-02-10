Citizen.CreateThread(function()
  print("^1 Starting NAT2K15 Framework. Thank you for your purchase. https://store.nat2k15.xyz")
  print('^0███████╗██████╗  █████╗ ███╗   ███╗███████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗')
  print('^0██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝')
  print('^0█████╗  ██████╔╝███████║██╔████╔██║█████╗  ██║ █╗ ██║██║   ██║██████╔╝█████╔╝ ')
  print('^0██╔══╝  ██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝  ██║███╗██║██║   ██║██╔══██╗██╔═██╗ ')
  print('^0██║     ██║  ██║██║  ██║██║ ╚═╝ ██║███████╗╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗')
  print('^0╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝')                                                                                                           
  if(Config ~= nil and Config.use_discord ~= false) then
    Framework.print('info', 'Discord Permission System is enabled. Checking discord bot token...')
    local guild = DiscordRequest("guilds/"..Config.server_id)
    if guild.code == 200 then
        local data = json.decode(guild.data)
        Framework.print("success", "Permission system guild set to: "..data.name.." ("..data.id..")")
    else
        if(guild.code == 401) then
            Framework.print("danger", "An error occured, please check your config and ensure everything is correct (Discord bot token. Ensure you have a valid token in config/config_server.lua). Error: "..(guild.data or guild.code))   
        elseif guild.code == 400 then
            Framework.print("danger", "An error occured, please check your config and ensure everything is correct (Discord Server ID. Ensure you have a valid guild id in config/config_server.lua and the bot is in your guild.). Error: "..(guild.data or guild.code))
        else 
            Framework.print("danger", "An error occured, please check your config and ensure everything is correct (Discord bot token). Error: "..(guild.data or guild.code))
        end
    end
  end
  if MySQL ~= nil then
    MySQL.ready(function()
      local filepath = GetResourcePath(GetCurrentResourceName())
      local file = io.open(filepath .. "/sql.sql", "r")
      if(file) then
      local sql = file:read("*all")
      file:close()     
      -- Extract create table queries from the SQL file
      local create_table_characters = sql:match("CREATE TABLE IF NOT EXISTS characters %b();")
      local create_table_characters_settings = sql:match("CREATE TABLE IF NOT EXISTS characters_settings %b();")
      
      -- Check the tables and create them if they don't exist
      Framework.print("info", "Checking all the tables required...")
      MySQL.execute(create_table_characters, {}, function(result)
        if result then
          Framework.print("success", "characters table checked/created successfully")
        else
          Framework.print("danger", "Error while checking/creating characters table")
        end
      end)
      
      MySQL.execute(create_table_characters_settings, {}, function(result)
        if result then
          Framework.print("success", "characters_settings table checked/created successfully")
        else
          Framework.print("danger", "Error while checking/creating characters_settings table")
        end
      end)
      
      --  Framework v2.1 Update. Altering the characters_settings table to add the framework_hud column. Altering the characters table to add a level column.
      Citizen.Wait(1000)
      local firstQuery = [[
          SELECT COUNT(*) AS count
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE TABLE_NAME = 'characters' AND COLUMN_NAME = 'level'
      ]]
      MySQL.query(firstQuery, {}, function(result)
        if result and result[1] and result[1].count > 0 then
          Framework.print("success", "characters table already altered for the 2.1 version. (level column exists). ")
        else
          -- ALTER TABLE characters ADD level TEXT DEFAULT NULL
          MySQL.execute("ALTER TABLE characters ADD level TEXT DEFAULT NULL;", {}, function(result)
            if result then
              Framework.print("success", "characters table has been successfully altered for the 2.1 version. (level column added)")
              Framework.print("info", "Starting to convert everyone department in the database to level. This may take a little while if you have a lot of characters. (This is a one time operation)")
              MySQL.query("SELECT * FROM characters", {}, function(result)
                  if(result[1]) then 
                    for k,v in pairs(result) do
                      local level = Framework.convertDeptIntoLevel(v.dept)
                      if(level) then 
                        MySQL.execute("UPDATE characters SET level = @level WHERE id = @charid", {['@level'] = level, ['@charid'] = v.id})
                      end
                    end
                    Framework.print("success", "All departments have been successfully converted to levels. (characters table updated successfully)")
                  end
              end)
            else
              Framework.print("danger", "Error while altering characters table")
            end
          end)
        end
      end)
    
      local thirdQuery = [[
          SELECT COUNT(*) AS count
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE TABLE_NAME = 'characters_settings' AND COLUMN_NAME = 'framework_hud'
      ]]
      
      MySQL.query(thirdQuery, {}, function(result)
        if result and result[1] and result[1].count > 0 then
          Framework.print("success", "characters_settings table already altered for the 2.1 version. (framework_hud column exists). ")
        else
          MySQL.execute("ALTER TABLE characters_settings ADD framework_hud TEXT DEFAULT '[]'", {}, function(result)
              if result then
                Framework.print("success", "characters_settings table has been successfully altered for the 2.1 version. (framework_hud column added)")
              else
                Framework.print("danger", "Error while altering characters_settings table")
              end
          end)
        end
      end)
      else
        Citizen.CreateThread(function()
            while true do
              Citizen.Wait(1000)
              Framework.print("danger", "sql.sql file not found. Please ensure you have the sql.sql file in the root of your framework folder. This file is required for the framework to work.")
            end
        end) 
      end
    end)
  else
    Framework.print("danger", "oxmysql is not installed. Please install it to use the framework. If installed ensure it's started before the framework.")
  end


  Framework.print("info",  "Checking to see if the config file needs to be updated to the latest version.")
  -- Version 2.2 Update
  -- Changing the config to add the server id for html 
  if Config ~= nil then
    if(Config.versionSettings.version < "2.2.2") then
      Framework.print("info", "Updating the config file to version 2.2.2")
      local fixedConfig = nil
      if(Config.adminPermissions == nil) then
        fixedConfig = [[
  -- Admin Permissions
Config.adminPermissions = {
    GiveAllDepartments = true
}]]
      end

      TriggerEvent('NAT2K15:UpdateConfig', fixedConfig, Config.versionSettings.version, "2.2.2", function(error, newconfig)
        if(error) then
          Framework.print("danger", "Error while updating the config file to version 2.2.2 Please update it manually.")
        else 
          Framework.print("success", "Config file updated to version 2.2.2")
          Framework.print("info", "Auto Fixing the vars across all the files.")
          local loadConfig = load(newconfig)
          if(loadConfig) then
            loadConfig()
            TriggerClientEvent('NAT2K15:HANDLEUIUPDATE', -1, Config)
            Framework.print("success", "Config file loaded successfully.")
          end 
        end
        
      end)
    end
  end 
end)
