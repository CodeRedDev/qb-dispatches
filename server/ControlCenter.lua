local QBCore = exports['qb-core']:GetCoreObject()

local ControlCenter = {}

local function IsJobInConfig(jobName)
    for confJob, _  in pairs(Config.ControlCenterPhoneNumbers) do
        if confJob == jobName then
            return true
        end
    end
    return false
end

RegisterNetEvent('qb-dispatches:server:ControlCenterLogout', function()
    local PlayerData = QBCore.Functions.GetPlayer(source).PlayerData

    for k,v in pairs(ControlCenter) do
        if v.phoneNumber == PlayerData.charinfo.phone then
            ControlCenter[k] = nil
        end
    end
end)

-- Callbacks

QBCore.Functions.CreateCallback('qb-dispatches:server:GetControlCenterPhonePair', function(_, cb, CallNumber)
    local PhonePair = { number = CallNumber }

    for job, num in pairs(Config.ControlCenterPhoneNumbers) do
        if num == CallNumber and ControlCenter[job] then
            PhonePair.ControlCenterNumber = ControlCenter[job].phoneNumber
        end
    end
    
    cb(PhonePair)
end)

-- Commands

QBCore.Commands.Add('controlcenter', "Enter/Exit the control center role (ES only)", {}, false, function(source)
    local PlayerData = QBCore.Functions.GetPlayer(source).PlayerData
    if IsJobInConfig(PlayerData.job.name) and PlayerData.job.onduty then
        local ccData = ControlCenter[PlayerData.job.name]

        if ccData then
            -- control center already taken
            if ccData.phoneNumber == PlayerData.charinfo.phone then
                -- logout of control center
                ControlCenter[PlayerData.job.name] = nil
                TriggerClientEvent('QBCore:Notify', source, 'You logged out of Control Center', 'error')
            else
                TriggerClientEvent('QBCore:Notify', source, 'Control Center taken by '..ccData.name, 'error')
            end
        else
            -- control center free
            ControlCenter[PlayerData.job.name] = {
                name = PlayerData.charinfo.firstname .. ' ' .. PlayerData.charinfo.lastname,
                phoneNumber = PlayerData.charinfo.phone,
            }

            TriggerClientEvent('QBCore:Notify', source, 'You sucessfully signed into Control Center', 'success')
        end
    end
end)

QBCore.Commands.Add('clearcontrolcenter', 'Log everyone out of Control Center (Admin/Boss only)', {{name = 'job', help = 'Job to clear Control Center'}}, true, function(source, args)
    local PlayerData = QBCore.Functions.GetPlayer(source).PlayerData
    local hasJobBoss = PlayerData.job.name == args[1] and PlayerData.job.isboss
    if QBCore.Functions.HasPermission(source, 'command.clearControlCenter') or hasJobBoss then
        ControlCenter[args[1]] = nil
    end
end)