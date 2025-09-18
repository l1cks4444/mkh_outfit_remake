fx_version 'cerulean'
game 'gta5'

author 'Matti'
description 'Mkh outfit remake'
version '1.0.0'

shared_script '@es_extended/imports.lua'

server_scripts { 
    'server/main.lua',
    'config.lua'
}

client_script 'client/main.lua'

dependency 'es_extended'
dependency 'esx_skin'
dependency 'skinchanger'
