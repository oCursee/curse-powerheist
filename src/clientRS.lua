Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)
local cam = nil
local atm = {
	GetHashKey('prop_atm_02'),
	GetHashKey('prop_atm_03'),
	GetHashKey('prop_fleeca_atm'),
}
local canReader = false




exports['qtarget']:AddBoxZone("boss", vector3(-2227.31, 349.67, 173.60), 2.45, 1.35, {
	name="boss",
	heading=303.77,
	debugPoly=false,
	minZ=170.38834,
	maxZ=178.38834,
	}, {
		options = {
			{
				event = "curse-startConversation",
				icon = "far fa-angry",
				label = "Have a conversation",
			
			},
            {
				event = "GiveItemLester",
				icon = "fas fa-lock",
				label = "I have the Card Reader",
			
			},
		},
       
		distance = 3.5
})
exports['qtarget']:AddBoxZone("decrypt", vector3(2836.25, 1515.93, 24.72), 2.45, 1.35, {
	name="decrypt",
	heading=303.77,
	debugPoly=false,
	minZ=23.38834,
	maxZ=27.38834,
	}, {
		options = {
            {
				event = "showDecryptBox",
				icon = "fas fa-signal",
				label = "Decrypt the signal",
			
			},
		},
       
		distance = 3.5
})


RegisterCommand('blk', function ()
    SetBlackOut()
end)

RegisterCommand("pos", function ()
    local pos = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
    local str = "X = " ..pos.x.. "Y = " ..pos.y.. "Z = " ..pos.z.."| Heading " ..heading
    print(str)
end)


Citizen.CreateThread(function ()
    local ped_hash = GetHashKey("cs_lestercrest")
    RequestModel(ped_hash)
    while not HasModelLoaded(ped_hash) do
        Citizen.Wait(1)
    end
      him = CreatePed(1, ped_hash, -2227.31, 349.67, 173.60, 295.25, false, false)
      SetBlockingOfNonTemporaryEvents(him, true)
      SetPedDiesWhenInjured(him, false)
      SetPedCanPlayAmbientAnims(him, true)
      SetPedCanRagdollFromPlayerImpact(him, false)
      SetEntityInvincible(him, true)
      FreezeEntityPosition(him, true)
  end)
  


AddEventHandler("curse-startConversation", function ()
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(cam, true)
	RenderScriptCams(true, true, 3, true, true)
	SetCamCoord(cam, -2238.08, 345.94, 174.60)
	PointCamAtCoord(cam, -1802.70, 539.22, 156.37)
    DisplayHelpText("Go and grab a Card Reader(1) and come back.")
    Wait(8000)
    SetCamActive(cam, false)
    RenderScriptCams(false, false, 0, true, true)

    cam = nil
end)


exports['qtarget']:AddTargetModel(atm, {
	options = {
		{
			event = "onClickAtm",
			icon = "fas fa-cut",
			label = "Rob the atm",
		},
	},
	job = {"all"},
	distance = 3.0
})




RegisterNetEvent("onClickAtm")
AddEventHandler("onClickAtm", function ()
	ESX.TriggerServerCallback('checkItem', function(cb) 
		if cb == 1 then
			playAnim('mp_common', 'givetake1_a', 5000)
			local CustomSettings = {
				settings = {
					handleEnd = true;  --Send a result message if true and callback when message closed or callback immediately without showing the message
					speed = 2; --pixels / second
					scoreWin = 1000; --Score to win
					scoreLose = -100; --Lose if this score is reached
					maxTime = 60000; --sec
					maxMistake = 2; --How many missed keys can there be before losing
					speedIncrement = 1; --How much should the speed increase when a key hit was successful
				},
				keys = {"a", "w", "d", "s", "g"}; --You can hash this out if you want to use default keys in the java side.
			}
			local atmHit = exports['cd_keymaster']:StartKeyMaster(CustomSettings)
			if atmHit then
				local ped = PlayerPedId()
				TriggerServerEvent('addCardReader', ped)
			else
				ESX.ShowNotification("You really aren't that good")
			end
		else
			ESX.ShowNotification("You don't have the proper tools.")
		end		
    end)	
end)


RegisterNetEvent("GiveItemLester")
AddEventHandler("GiveItemLester", function ()
	ESX.TriggerServerCallback('checkCardreader', function(cb) 
		if cb then
			DisplayHelpText('Go down to my work station, and use the passcode "1513212812" to activate the card reader.')
			canReader = true
		else
			ESX.ShowNotification("You don't have what I asked for.")
		end
    end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2)
		local ped = PlayerPedId()
  		local pCrds = GetEntityCoords(ped)
	  	local dist = #(pCrds - vector3(1275.67, -1710.49, 54.77))
		if canReader and dist<= 3 then
			DrawText3D(1275.67, -1710.49, 54.77, '[E]Access the workstation')
			if IsControlJustPressed(1, 38) and dist<=2 then
				print('Pressed')
				canReader = false
				TriggerEvent('showPasswordBox')
			end
		end
	end
end)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2)
		local ped = PlayerPedId()
  		local pCrds = GetEntityCoords(ped)
	  	local dist = #(pCrds - vector3(1272.42, -1710.99, 55.27))
		if dist<= 3 then
			DrawText3D(1272.42, -1710.99, 54.77, '[E]Build/Buy an Advanced Hacking Tool')
			if IsControlJustPressed(1, 38) and dist<=2 then
				buildHackingtool()
			end
		end
	end
end)
exports['qtarget']:AddBoxZone("crackVault", vector3(-2956.62, 481.74, 15.69), 1.45, 0.45, {
	name="crackVault",
	heading=334.42,
	debugPoly=false,
	minZ=13.38834,
	maxZ=19.38834,
	}, {
		options = {
            {
				event = "startHack",
				icon = "fas fa-university",
				label = "Crack the vault",
			
			},
		},
       
		distance = 2.5
})





