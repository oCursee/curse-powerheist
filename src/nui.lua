

local display = false
local display2 = false


RegisterNetEvent('showPasswordBox')
AddEventHandler('showPasswordBox', function ()
    showDisplay(not display)
end)
RegisterNetEvent('showDecryptBox')
AddEventHandler('showDecryptBox', function ()
    ESX.TriggerServerCallback("checkDecrypt", function(cb) 
        if cb ==3 then
            showDisplay2(not display2)
        else
            ESX.ShowNotification("You do not have the correct tools for the job.")
        end
    end)
    
end)

--[[
RegisterCommand("d1", function ()
    showDisplay(not display)
end)

RegisterCommand("d2", function ()
    showDisplay2(not display2)
end)
--]]



RegisterNUICallback("exit", function()
    showDisplay(false)
end)
RegisterNUICallback("exit2", function()
    showDisplay2(false)
end)

RegisterNUICallback("slideCorrect", function()
    ESX.ShowNotification("Correct Password")
    TriggerServerEvent('FinishDecrypt', PlayerPedId())
    SetBlackOut()
    showDisplay2(false)
end)




RegisterNUICallback("main", function()
    showDisplay(false)
end)

RegisterNUICallback("submit", function()
    showDisplay(false)
end)

RegisterNUICallback("startExtract", function()
    ESX.ShowNotification("Correct Password, the process will begin shortly")
    Wait(1000)
    startStation()
     showDisplay(false)
end)

RegisterNUICallback("wrongPassword", function()
    ESX.ShowNotification("Incorrect Password")
     showDisplay(false)
end)



Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        
        DisableControlAction(0, 1, display)
        DisableControlAction(0, 2, display) 
        DisableControlAction(0, 142, display) 
        DisableControlAction(0, 18, display) 
        DisableControlAction(0, 322, display) 
        DisableControlAction(0, 106, display) 
    end
end)

Citizen.CreateThread(function()
    while display2 do
        Citizen.Wait(0)
        
        DisableControlAction(0, 1, display2)
        DisableControlAction(0, 2, display2) 
        DisableControlAction(0, 142, display2) 
        DisableControlAction(0, 18, display2) 
        DisableControlAction(0, 322, display2) 
        DisableControlAction(0, 106, display2) 
    end
end)


function showDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end
function showDisplay2(bool)
    display2 = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui2",
        status = bool,
    })
end





