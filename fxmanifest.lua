----------------------------------
--<!>-- TRUST | DEVELOPMENT --<!>--
----------------------------------

fx_version 'cerulean'

game 'gta5'

author 'Moe Software'

description 'Bike Shop'

version '1.1.0'

lua54 'yes'

shared_scripts {
    'shared/*',
}

client_scripts{
    'client/*',
}

server_scripts{
    '@oxmysql/lib/MySQL.lua',
    'server/*',
}