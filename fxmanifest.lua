fx_version 'cerulean'
game 'gta5'

author 'Code Lab'
description 'Sistema de Recompensas por Tempo de Jogo'
version '1.0.0'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/css/styles.css',
    'ui/js/app.js'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server/server.lua'
}