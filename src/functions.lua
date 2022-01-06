function SetBlackOut()
	SetArtificialLightsState(true)
	PlaySoundFrontend(-1, "Power_Down", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
end


function DisplayHelpText(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	EndTextCommandDisplayHelp(0, 0, 0, -1)
end
function playAnim(animDict, animName, duration)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
    TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
    RemoveAnimDict(animDict)
end



function startStation()
	playAnim('mp_fbi_heist', 'loop', 120000)
	exports.rprogress:Custom({
        Duration = 120000,
         Label = "Obtaining the information off of the work station",
         DisableControls = {Player = true,},
         onComplete = function(cancelled)
          TriggerServerEvent('addDecrypt', PlayerPedId())
		  ESX.ShowNotification('Use this to decrypt the signal at the powerplant.')
		  canReader = false
        end   
    })     
end


function openVault()
	local PlayerPos = GetEntityCoords(PlayerPedId(), true)
	local VaultDoor = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 100.0, -63539571, 0, 0, 0)
	local CurrentHeading = GetEntityHeading(VaultDoor)
	print(CurrentHeading)
	SetEntityHeading(VaultDoor, 270.24)
end

function grabLoot()
	playAnim('anim@heists@ornate_bank@grab_cash', 'grab', 18000)
	exports.rprogress:Custom({
        Duration = 18000,
         Label = "Grabbing the loot",
         DisableControls = {Player = true,},
         onComplete = function(cancelled)
			TriggerServerEvent("addLoot", PlayerPedId())
		  ESX.ShowNotification('You grabbed the loot, now get the fuck out.')
		  canGrab = false
        end   
    })     
end

local canGrab = false
RegisterNetEvent("startHack")
AddEventHandler("startHack", function()
	ESX.TriggerServerCallback('checkCracker', function(cb) 
		if cb == 5 then
			local animDict = "anim@heists@ornate_bank@hack"
	
		RequestAnimDict(animDict)
		RequestModel("hei_prop_hst_laptop")
		RequestModel("hei_p_m_bag_var22_arm_s")
		RequestModel("hei_prop_heist_card_hack_02")
	
		while not HasAnimDictLoaded(animDict)
			or not HasModelLoaded("hei_prop_hst_laptop")
			or not HasModelLoaded("hei_p_m_bag_var22_arm_s")
			or not HasModelLoaded("hei_prop_heist_card_hack_02") do
			Citizen.Wait(100)
		end
		local ped = PlayerPedId()
		local targetPosition, targetRotation = (vec3(GetEntityCoords(ped))), vec3(GetEntityRotation(ped))
		local animPos = GetAnimInitialOffsetPosition(animDict, "hack_enter", -2956.57, 481.57, 15.29, -2956.57, 481.57, 15.39, 0, 2) -- Animasyon kordinatları, buradan lokasyonu değiştirin // These are fixed locations so if you want to change animation location change here
		local animPos2 = GetAnimInitialOffsetPosition(animDict, "hack_loop",-2956.57, 481.57, 15.29, -2956.57, 481.57, 15.39, 0, 2)
		local animPos3 = GetAnimInitialOffsetPosition(animDict, "hack_exit", -2956.57, 481.57, 15.29, -2956.57, 481.57, 15.39, 0, 2)
		FreezeEntityPosition(ped, true)
		local netScene = NetworkCreateSynchronisedScene(animPos, targetRotation, 2, false, false, 1065353216, 0, 1.3)
		NetworkAddPedToSynchronisedScene(ped, netScene, animDict, "hack_enter", 1.5, -4.0, 1, 16, 1148846080, 0)
		local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), targetPosition, 1, 1, 0)
		NetworkAddEntityToSynchronisedScene(bag, netScene, animDict, "hack_enter_bag", 4.0, -8.0, 1)
		local laptop = CreateObject(GetHashKey("hei_prop_hst_laptop"), targetPosition, 1, 1, 0)
		NetworkAddEntityToSynchronisedScene(laptop, netScene, animDict, "hack_enter_laptop", 4.0, -8.0, 1)
		NetworkAddEntityToSynchronisedScene(card, netScene, animDict, "hack_enter_card", 4.0, -8.0, 1)
		local netScene2 = NetworkCreateSynchronisedScene(animPos2, targetRotation, 2, false, false, 1065353216, 0, 1.3)
		NetworkAddPedToSynchronisedScene(ped, netScene2, animDict, "hack_loop", 1.5, -4.0, 1, 16, 1148846080, 0)
		NetworkAddEntityToSynchronisedScene(bag, netScene2, animDict, "hack_loop_bag", 4.0, -8.0, 1)
		NetworkAddEntityToSynchronisedScene(laptop, netScene2, animDict, "hack_loop_laptop", 4.0, -8.0, 1)
		NetworkAddEntityToSynchronisedScene(card, netScene2, animDict, "hack_loop_card", 4.0, -8.0, 1)
		local netScene3 = NetworkCreateSynchronisedScene(animPos3, targetRotation, 2, false, false, 1065353216, 0, 1.3)
		NetworkAddPedToSynchronisedScene(ped, netScene3, animDict, "hack_exit", 1.5, -4.0, 1, 16, 1148846080, 0)
		NetworkAddEntityToSynchronisedScene(bag, netScene3, animDict, "hack_exit_bag", 4.0, -8.0, 1)
		NetworkAddEntityToSynchronisedScene(laptop, netScene3, animDict, "hack_exit_laptop", 4.0, -8.0, 1)
		NetworkAddEntityToSynchronisedScene(card, netScene3, animDict, "hack_exit_card", 4.0, -8.0, 1)
		TriggerServerEvent('curse-heist:policeBlip', GetEntityCoords(ped))
		exports["memorygame"]:thermiteminigame(10, 3, 3, 10,
   		 function()
        	openVault()
			canGrab = true
			ESX.ShowNotification("You successfully opened the vault")
			TriggerServerEvent('removeCracker', PlayerPedId())
  		end,
   		 function()
			ESX.ShowNotification("You failed")
			canGrab = false
    	end)
		SetPedComponentVariation(ped, 5, 0, 0, 0) 
		SetEntityHeading(ped, 63.60) 
	
		NetworkStartSynchronisedScene(netScene)
		Citizen.Wait(4500) 
		NetworkStopSynchronisedScene(netScene)
	
		NetworkStartSynchronisedScene(netScene2)
		Citizen.Wait(4500)
		NetworkStopSynchronisedScene(netScene2)
	
		NetworkStartSynchronisedScene(netScene3)
		Citizen.Wait(4500)
		NetworkStopSynchronisedScene(netScene3)
	
		DeleteObject(bag)
		DeleteObject(laptop)
		FreezeEntityPosition(ped, false)
		SetPedComponentVariation(ped, 5, 0, 0, 0)
			
		else
			ESX.ShowNotification("You don't have the correct tools")
		end
	end)
end)
    


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2)
		local ped = PlayerPedId()
  		local pCrds = GetEntityCoords(ped)
	  	local dist = #(pCrds - vector3(-2954.85, 484.36, 15.67))
		if canGrab and dist<= 3 then
			DrawText3D(-2954.85, 484.36, 15.67, '[E]Grab the loot')
			if IsControlJustPressed(1, 38) and dist<=2 then
				grabLoot()
				canGrab = false
			end
		end
	end
end)
local canBuild = true
function buildHackingtool()
	ESX.TriggerServerCallback('checkBuyHack', function(cb) 
		if cb == 7  and canBuild then
			canBuild = false
			playAnim('mini@repair',"fixing_a_ped", 10000)
		exports.rprogress:Custom({
			Duration = 10000,
			 Label = "Working magic",
			 DisableControls = {Player = true,},
			 onComplete = function(cancelled)
				TriggerServerEvent("buyHack", PlayerPedId())
			  ESX.ShowNotification('You have built an Advanced Hacking tool')
			  canGrab = false
			  canBuild = true
			end   
		})     
		else
			ESX.ShowNotification("You need a Decrypted Chip(1) and $11,050")
		end		
	end)	
	
end

RegisterNetEvent('Curse-blipPl')
AddEventHandler('Curse-blipPl', function (coords)
	if ESX.PlayerData.job == 'police' then
		
		local bankBlip = AddBlipForCoord(coords.x,coords.y,coords.z)
		SetBlipSprite(bankBlip, 161)
		SetBlipScale(bankBlip, 2.0)
		SetBlipColour(bankBlip, 3)
		PulseBlip(bankBlip)
		Wait(60000)
		RemoveBlip(bankBlip)
	end
end)

DrawText3D = function(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local p = GetGameplayCamCoords()
	local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
	local scale = (1 / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov
	if onScreen then
		  SetTextScale(0.35, 0.35)
		  SetTextFont(4)
		  SetTextProportional(1)
		  SetTextColour(255, 255, 255, 215)
		  SetTextEntry("STRING")
		  SetTextCentre(1)
		  AddTextComponentString(text)
		  DrawText(_x,_y)
		  local factor = (string.len(text)) / 370
		  DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
	  end
  end

  local nvg = false
RegisterNetEvent('Curse-nvg')
AddEventHandler('Curse-nvg', function ()
	if not nvg then
		playAnim('mp_masks@standard_car@ds@', 'put_on_mask', 2000)
		Wait(2000)
		SetPedComponentVariation(PlayerPedId(), 1, 132, 0, 0)
		SetNightvision(true)
		nvg = true
	elseif nvg then
		playAnim('missheist_agency2ahelmet', 'take_off_helmet_stand', 2000)
		Wait(2000)
		SetNightvision(false)
		SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0)	
		nvg = false
	end
	
end)
