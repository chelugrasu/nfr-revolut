fx_version "adamant"
game "gta5"
dependency "vrp"
author "NFR#1824"
description "NFR_Banking - A banking system inspired by Revolut. Made for vRP."
shared_script "config.lua"

client_scripts {
    "client/*.lua"
}

server_scripts {
    "@vrp/lib/utils.lua",
    "server/*.lua"
}
ui_page {
    "html/index.html"
}

files {
    "html/*.*"
}
escrow_ignore {
    'config.lua',
}

lua54 "yes"