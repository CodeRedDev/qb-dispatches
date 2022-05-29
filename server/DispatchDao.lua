local QBCore = exports['qb-core']:GetCoreObject()

-- CREATE Callbacks

-- @param source        Player who wants to create the dispatch
-- @param DispatchData  Extra data for the dispatch containing: to_fraction and message
-- @cb-params {success, errorMsg}
QBCore.Functions.CreateCallback('qb-dispatches:server:CreateDispatch', function(source, cb, DispatchData)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player ~= nil then
        MySQL.insert(
            'INSERT INTO dispatches (`citizenid`, `phone_number`, `to_fraction`, `message`) VALUES (?, ?, ?, ?)', 
            {Player.PlayerData.citizenid, Player.PlayerData.charinfo.phone, DispatchData.to_fraction, DispatchData.message}
        )
        cb(true)
    else
        cb(false, 'Player not found!')
    end
end)

-- READ Callbacks

QBCore.Functions.CreateCallback('qb-dispatches:server:GetDispatches', function(_, cb)
    local dispatches = MySQL.query.await('SELECT * FROM dispatches ORDER BY time ASC', {})
    cb(dispatches)
end)

-- @param source Player identifier to search dispatches for
-- @cb-params {dispatches, errorMsg}
QBCore.Functions.CreateCallback('qb-dispatches:server:GetDispatchesByPlayer', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player ~= nil then
        local dispatches = MySQL.query.await(
            'SELECT * FROM dispatches WHERE citizenid = ? ORDER BY time ASC', 
            {Player.PlayerData.citizenid}
        )
        cb(dispatches)
    else
        cb(nil, 'Player not found!')
    end
end)

QBCore.Functions.CreateCallback('qb-dispatches:server:GetDispatchesByFraction', function(_, cb, fractionName)
    local dispatches = MySQL.query.await('SELECT * FROM dispatches WHERE to_fraction = ? ORDER BY time ASC', {fractionName})
    cb(dispatches)
end)

-- UPDATE Callbacks

-- @param DispatchId        Identifier of the dispatch to update
-- @param DispatchStatus    New status for the dispatch (0 = new; 1 = accepted; 2 = declined)
QBCore.Functions.CreateCallback('qb-dispatches:server:UpdateDispatchStatus', function(_, cb, DispatchId, DispatchStatus)
    local updated = MySQL.update.await('UPDATE dispatches SET status = ? WHERE id = ?', {DispatchStatus, DispatchId})
    cb(updated)
end)

-- DELETE Callbacks

-- @param DispatchId    Identifier of the dispatch to delete
-- @cb-params {removedDispatchesCount}
QBCore.Functions.CreateCallback('qb-dispatches:server:DeleteDispatch', function(_, cb, DispatchId)
    local removed = MySQL.Sync.execute('DELETE FROM dispatches WHERE id = ?', {DispatchId})
    cb(removed)
end)

QBCore.Functions.CreateCallback('qb-dispatches:server:DeleteDispatchesForFraction', function(_, cb, fractionName)
    local removed = MySQL.Sync.execute('DELETE FROM dispatches WHERE to_fraction = ?', {fractionName})
    cb(removed)
end)

QBCore.Functions.CreateCallback('qb-dispatches:server:DeleteAllDispatches', function(_, cb)
    local removed = MySQL.Sync.execute('TRUNCATE TABLE dispatches', {})
    cb(removed)
end)