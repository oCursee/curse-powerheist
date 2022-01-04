ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterUsableItem('nvg_black', function(source)
    TriggerClientEvent('Curse-nvg', source)
end)