fx_version 'cerulean'
game 'gta5'

description 'QB-Dispatches'
version '0.1.0'

shared_scripts {
    'config.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
	'server/DispatchDao.lua',
    'server/ControlCenter.lua',
}

client_scripts {
    'client/DispatchDaoProxy.lua',
    -- 'test/DaoTest.lua',
    'client/ControlCenter.lua',
}

dependency 'oxmysql'

lua54 'yes'