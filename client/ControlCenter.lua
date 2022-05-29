function IsNumberControlCenterRegistered(phoneNumber)
    for _, num in pairs(Config.ControlCenterPhoneNumbers) do
        if num == phoneNumber then
            return true
        end
    end
    return false
end

exports('IsNumberControlCenterRegistered', IsNumberControlCenterRegistered)