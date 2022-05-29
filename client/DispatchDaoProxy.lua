local QBCore = exports['qb-core']:GetCoreObject()

function CreateDispatch(cb, DispatchData)
    QBCore.Functions.TriggerCallback('qb-dispatches:server:CreateDispatch', cb, DispatchData)
end

function GetDispatches(cb)
    QBCore.Functions.TriggerCallback('qb-dispatches:server:GetDispatches', cb)
end

function GetDispatchesByPlayer(cb)
    QBCore.Functions.TriggerCallback('qb-dispatches:server:GetDispatchesByPlayer', cb)
end

function GetDispatchesByFraction(cb, fractionName)
    QBCore.Functions.TriggerCallback('qb-dispatches:server:GetDispatchesByFraction', cb, fractionName)
end

function UpdateDispatchStatus(cb, DispatchId, DispatchStatus)
    QBCore.Functions.TriggerCallback('qb-dispatches:server:UpdateDispatchStatus', cb, DispatchId, DispatchStatus)
end

function DeleteDispatch(cb, DispatchId)
    QBCore.Functions.TriggerCallback('qb-dispatches:server:DeleteDispatch', cb, DispatchId)
end

function DeleteDispatchesForFraction(cb, fractionName)
    QBCore.Functions.TriggerCallback('qb-dispatches:server:DeleteDispatchesForFraction', cb, fractionName)
end

function DeleteAllDispatches(cb)
    QBCore.Functions.TriggerCallback('qb-dispatches:server:DeleteAllDispatches', cb)
end

exports('CreateDispatch', CreateDispatch)
exports('GetDispatches', GetDispatches)
exports('GetDispatchesByPlayer', GetDispatchesByPlayer)
exports('GetDispatchesByFraction', GetDispatchesByFraction)
exports('UpdateDispatchStatus', UpdateDispatchStatus)
exports('DeleteDispatch', DeleteDispatch)
exports('DeleteDispatchesForFraction', DeleteDispatchesForFraction)
exports('DeleteAllDispatches', DeleteAllDispatches)