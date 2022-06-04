fx_version 'cerulean'
game 'gta5'

description 'QB-Dispatches'
version '0.2.0'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/DispatchDao.lua',
}

client_scripts {
    'client/DispatchDaoProxy.lua',
    -- 'test/DaoTest.lua',
}

dependency 'oxmysql'

lua54 'yes'