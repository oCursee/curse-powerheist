ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local ox_inventory = exports.ox_inventory

RegisterNetEvent('addCardReader')
AddEventHandler('addCardReader', function ()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.canCarryItem('cardreader', 1) then
        xPlayer.addInventoryItem("cardreader", math.random(0, 1))  
    end 
end)


ESX.RegisterServerCallback('checkItem', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem('advanced-lockpick').count >=1 then
        xPlayer.removeInventoryItem('advanced-lockpick', 1)
        cb(1)
    else
        cb(0)
    end
	
end)


ESX.RegisterServerCallback('checkCardreader', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
    if Config.UseOx then
        local cardreader = ox_inventory:Search(source, 1, {'cardreader'})
        if  cardreader then
            cb(true)
        else
            cb(false)
        end
    elseif not Config.UseOx then
        if xPlayer.getInventoryItem('cardreader').count >=1 then

            cb(true)
        else
            cb(false)
        end

    end
   
end)

RegisterNetEvent('addDecrypt')
AddEventHandler('addDecrypt', function ()
    local xPlayer = ESX.GetPlayerFromId(source)
    local cardreader = ox_inventory:Search(source, 1, {'cardreader'})
    if Config.UseOx and xPlayer.canCarryItem('advdecryptor', 1)  and cardreader then   
            xPlayer.removeInventoryItem("cardreader", 1)  
            xPlayer.addInventoryItem("advdecryptor", 1)  
    
    elseif not Config.UseOx and xPlayer.canCarryItem('advdecryptor', 1)  and xPlayer.getInventoryItem('cardreader').count >= 1 then    
            xPlayer.removeInventoryItem("cardreader", 1)  
            xPlayer.addInventoryItem("advdecryptor", 1)  
    end   
end)
RegisterNetEvent('FinishDecrypt')
AddEventHandler('FinishDecrypt', function ()
    local xPlayer = ESX.GetPlayerFromId(source)
    local advdecryptor = ox_inventory:Search(source, 1, {'advdecryptor'})
    if Config.UseOx and xPlayer.canCarryItem('advdecryptor', 1)  and advdecryptor then
            xPlayer.removeInventoryItem("advdecryptor", 1)  
            xPlayer.addInventoryItem('decryptedchip', 1)
    elseif not Config.UseOx and xPlayer.canCarryItem('advdecryptor', 1)  and xPlayer.getInventoryItem('advdecryptor').count >= 1 then
        xPlayer.removeInventoryItem("advdecryptor", 1)  
        xPlayer.addInventoryItem('decryptedchip', 1)
    end
    
end)


ESX.RegisterServerCallback('checkDecrypt', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
    if Config.UseOx then
        local advdecryptor = ox_inventory:Search(source, 1, {'advdecryptor'})
        if advdecryptor then
            cb(3)
        else
            cb(4)
        end
    elseif not Config.UseOx then
        if xPlayer.getInventoryItem('advdecryptor').count >=1 then
            cb(3)
        else
            cb(4)
        end
    end  
end)
ESX.RegisterServerCallback('checkCracker', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
    if Config.UseOx then
        local cracker = ox_inventory:Search(source, 1, {'net_cracker'})
        if cracker then
            cb(5)
        else
            cb(6)
        end
    elseif not Config.UseOx then
        if xPlayer.getInventoryItem('net_cracker').count >=1 then
            cb(5)
        else
            cb(6)
        end
    end
end)

RegisterNetEvent('removeCracker')
AddEventHandler('removeCracker', function ()
    local xPlayer = ESX.GetPlayerFromId(source)
    if Config.UseOx then
        ox_inventory:RemoveItem(source, 'net_cracker', 1)
    elseif not Config.UseOx then
        xPlayer.removeInventoryItem("net_cracker", 1)  
    end
       
end)

RegisterNetEvent('addLoot')
AddEventHandler('addLoot', function ()
    local xPlayer = ESX.GetPlayerFromId(source)
    if Config.UseOx and xPlayer.canCarryItem('gold', 10)  and xPlayer.canCarryItem('money', 5000) then
        xPlayer.addInventoryItem('gold', math.random(5, 10))
        xPlayer.addInventoryItem('money', math.random(2214, 9465))
    elseif not Config.UseOx and xPlayer.canCarryItem('gold', 10)  and xPlayer.canCarryItem('money', 5000) then
        xPlayer.addInventoryItem('gold', math.random(5, 10))
        xPlayer.addInventoryItem('money', math.random(2214, 9465))
    end
end)

--[[
RegisterNetEvent('db')
AddEventHandler('db', function ()
    print('Debug Test')
end)
--]]
ESX.RegisterServerCallback('checkBuyHack', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
    if Config.UseOx then
        local chip = ox_inventory:Search(source, 1, {'decryptedchip'})
        local money = ox_inventory:Search(source, 11050, {'money'})
        if chip and money then
            cb(7)
        else
            cb(8)
        end
    elseif not Config.UseOx then
        if xPlayer.getInventoryItem('decryptedchip').count >=1 and xPlayer.getInventoryItem('money').count >= 11050 then
            cb(7)
        else
            cb(8)
        end
    end
end)


RegisterNetEvent('buyHack')
AddEventHandler('buyHack', function ()
    local xPlayer = ESX.GetPlayerFromId(source)
    if Config.UseOx then
        local money = ox_inventory:Search(source, 11050, {'money'})
        local chip = ox_inventory:Search(source, 1, {'decryptedchip'})
        if chip and money then
            xPlayer.addInventoryItem('net_cracker', 1)
            ox_inventory:RemoveItem(source, 'decryptedchip', 11050)
            ox_inventory:RemoveItem(source, 'money', 1)
        else
            TriggerClientEvent('esx:showNotification', source, 'You need a Decrypted Chip(1) and $11,050')
        end 
    elseif not Config.UseOx then
        if xPlayer.getInventoryItem('decryptedchip').count >= 1 and xPlayer.getInventoryItem('money').count >= 11050 then
            xPlayer.addInventoryItem('net_cracker', 1)
            xPlayer.removeInventoryItem('money', 11050)
            xPlayer.removeInventoryItem("decryptedchip", 1)
        else
            TriggerClientEvent('esx:showNotification', source, 'You need a Decrypted Chip(1) and $11,050')
        end 
    end 
end)








------------NOT WORKING AS OF RN--------------
RegisterServerEvent('curse-heist:policeBlip')
AddEventHandler('curse-heist:policeBlip', function(cr)
	TriggerClientEvent('Curse-blipPl',-1, cr)
end)