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
        for v = 1, #Config.Jobs do
            if xPlayer.job.name == Config.Jobs[v] then
                return true
            end
        end
    end

    print(xPlayer.job.name)
end)