---------- For support, scripts, and more ----------
----------- https://discord.gg/kipxscript -----------
----------------------------------------------------

fx_version "cerulean"
game "gta5"

description 'Kipx Grant License'
author 'Kipx Script'
version '1.1.0'
lua54 'yes'

shared_scripts{
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    '@es_extended/locale.lua',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

client_scripts {
    'client/*.lua'
}

dependencies {
    'oxmysql',
    'ox_lib',
    'es_extended'
}