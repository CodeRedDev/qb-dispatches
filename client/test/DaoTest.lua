local function TestCreateDispatch()
    local dispatches = 10
    local waitTime = 5000
    print('Testing creation. This can take up to ' .. (dispatches * waitTime / 1000) .. ' seconds...')
    local testSuccess = true
    for i = 1, 10 do
        exports['qb-dispatches']:CreateDispatch(function(success, errorMsg)
            if not success then
                testSuccess = false
            end
        end, { to_fraction = 'Fraction' .. i, message = 'Message' .. i })
        Wait(waitTime)
    end
    return testSuccess
end

local function TestGetDispatches()
    local testSuccess = true
    exports['qb-dispatches']:GetDispatches(function(dispatches)
        print('Dispatches Callback')
        if #dispatches ~= 10 then
            testSuccess = false
        end
    end)
    Wait(2500)
    return testSuccess
end

local function TestGetDispatchesByPlayer()
    local testSuccess = true
    exports['qb-dispatches']:GetDispatchesByPlayer(function(dispatches, errorMsg)
        print('DispatchesByPlayer Callback')
        if dispatches == nil or #dispatches ~= 10 then
            testSuccess = false
        end
    end)
    Wait(2500)
    return testSuccess
end

local function TestGetDispatchesByFraction()
    local testSuccess = false
    exports['qb-dispatches']:GetDispatchesByFraction(function(dispatches)
        print('DispatchesByFraction Callback')
        for k, dispatch in pairs(dispatches) do
            if dispatch.to_fraction == 'Fraction1' then
                testSuccess = true
            end
        end
    end, 'Fraction1')
    Wait(2500)
    return testSuccess
end

local function TestUpdateDispatchStatus()
    local testSuccess = false
    exports['qb-dispatches']:UpdateDispatchStatus(function(updated)
        print('UpdateDispatch Callback')
        if updated > 0 then
            testSuccess = true
        end
    end, 1, 1)
    Wait(2500)
    return testSuccess
end

local function TestDeleteDispatch()
    local testSuccess = false
    exports['qb-dispatches']:DeleteDispatch(function(removed)
        print('DeleteDispatch Callback')
        if removed > 0 then
            testSuccess = true
        end
    end, 1)
    Wait(2500)
    return testSuccess
end

local function TestDeleteDispatchesForFraction()
    local testSuccess = false
    exports['qb-dispatches']:DeleteDispatchesForFraction(function(removed)
        print('DeleteDispatchesForFraction Callback')
        if removed > 0 then
            testSuccess = true
        end
    end, 'Fraction2')
    Wait(2500)
    return testSuccess
end

local function TestDeleteAllDispatches()
    local testSuccess = false
    exports['qb-dispatches']:DeleteAllDispatches(function(removed)
        print('DeleteAllDispatches Callback')
        -- ATTENTION: TRUNCATE TABLE does not return a meaningful value
        -- https://dev.mysql.com/doc/refman/8.0/en/truncate-table.html
        if removed == 0 then
            testSuccess = true
        end
    end, 1)
    Wait(2500)
    return testSuccess
end

local Tests = {
    [1] = { name = 'Create', test = TestCreateDispatch },
    [2] = { name = 'Get', test = TestGetDispatches },
    [3] = { name = 'GetByPlayer', test = TestGetDispatchesByPlayer },
    [4] = { name = 'GetByFraction', test = TestGetDispatchesByFraction },
    [5] = { name = 'UpdateStatus', test = TestUpdateDispatchStatus },
    [6] = { name = 'Delete', test = TestDeleteDispatch },
    [7] = { name = 'DeleteForFraction', test = TestDeleteDispatchesForFraction },
    [8] = { name = 'DeleteAll', test = TestDeleteAllDispatches },
}

RegisterCommand('testDispatchesDao', function()
    CreateThread(function()
        print('Starting DAO test')
        for i = 1, #Tests do
            local test = Tests[i]
            local success = test.test()
            if success then
                print('SUCCESS: ' .. test.name)
            else
                print('FAILED: ' .. test.name)
            end
        end
    end)
end, false)
