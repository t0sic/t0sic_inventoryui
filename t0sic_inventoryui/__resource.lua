resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

ui_page 'assets/index.html'

client_script 'client/main.lua'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua'
}

files {
    'assets/index.html',
    'assets/css/main.css',
    'assets/css/items.css',
    'assets/js/main.js',
    'assets/img/arrow.svg',
    'assets/img/inventorySVG.svg'
}