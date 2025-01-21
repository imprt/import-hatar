lib.callback.register('ls:removemoney', function(remove)
    exports.ox_inventory:RemoveItem(source, 'money', Config.Price)
end)

lib.callback.register('ls:removemoneybank', function(removebank)
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeAccountMoney('bank', Config.Price, removebank)

    print(xPlayer)
end)

lib.callback.register('ls:checkjob', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        for _, job in ipairs(Config.Jobs) do
            if xPlayer.job.name == job then
                return true
            end
        end
    end

    print(xPlayer.job.name)
end)
