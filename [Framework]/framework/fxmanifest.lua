fx_version 'adamant'
game 'gta5'
author 'NAT2K15'

files {
  'html/index.html',
  'html/css/style.css',
  'html/js/**.js',
}

ui_page 'html/index.html'

shared_scripts {
  'config/config.lua',
  'config/config_doors.lua',
}

client_scripts {
  'client/client.lua',
  'client/callback.lua',
  'client/function.lua',
  'client/commands.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'config/config_server.lua',
  'server/server.lua',
  'dependencies/discord.lua',
  'server/function.lua',
  'server/commands.lua',
  'server/version_checker.lua',
  'server/configHandler.js'
}

client_exports {
  'getclientdept',
  'getClientFunctions'
}

server_export {
  'getdept',
  'geteverything',
  'getconfig',
  'getaop',
  'getServerFunctions'
}
