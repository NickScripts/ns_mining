fx_version "cerulean"
game "gta5"
author "Nicks Scripts"
description "ESX Mining Script"
version "1.0"

shared_scripts {
	'@ox_lib/init.lua',
	'@es_extended/imports.lua'
}

client_script {
	'config/main.lua',
	"client/main.lua",
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/CircleZone.lua'
}
server_script {
	"config/main.lua",
	"server/main.lua"
}
  
lua54 'yes'