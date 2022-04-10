fx_version "cerulean";
games {"gta5"};
lua54 "yes";

description 'Keyshop for Nyam_vehicleKeys by Baelroak'

shared_scripts {
    'config.lua',
    '@qb-core/shared/locale.lua',
    'locales/en.lua' -- Change this to your preferred language
}


client_scripts {
    '@PolyZone/client.lua',
	'cl_main.lua'
}


server_script {
	'@oxmysql/lib/MySQL.lua',
    'sv_main.lua'
}


