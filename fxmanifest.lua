fx_version 'cerulean'
game 'gta5'

author 'JonttuJT'
description 'Konttiryöstö'
version '1.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

server_script 'sv_main.lua'

client_script 'cl_main.lua'

lua54 'yes'