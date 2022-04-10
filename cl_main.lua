QBCore =  exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(0)
	end
end)

local function NearPed(model, coords, heading, gender, animDict, animName, scenario)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
		Wait(1)
	end
	if gender == 'male' then
		genderNum = 4
	elseif gender == 'female' then 
		genderNum = 5
	else
	
	end	
	ped = CreatePed(genderNum, GetHashKey(v.model), coords, heading, false, true)
	SetEntityAlpha(ped, 0, false)
	FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	if animDict and animName then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Wait(1)
		end
		TaskPlayAnim(ped, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
	end
	if scenario then
		TaskStartScenarioInPlace(ped, scenario, 0, true) 
	end
	for i = 0, 255, 51 do
		Wait(50)
		SetEntityAlpha(ped, i, false)
	end
	return ped
end


local peds = {} 

CreateThread(function() 
	while true do
		Wait(500)
		for k = 1, #ConfigPedList.PedList, 1 do
			v = ConfigPedList.PedList[k]
			local playerCoords = GetEntityCoords(PlayerPedId())
			local dist = #(playerCoords - v.coords)
			if dist < 50.0 and not peds[k] then
				local ped = NearPed(v.model, v.coords, v.heading, v.gender, v.animDict, v.animName, v.scenario)
				peds[k] = {ped = ped}
			end
			if dist >= 50.0 and peds[k] then
				for i = 255, 0, -51 do
					Wait(50)
					SetEntityAlpha(peds[k].ped, i, false)
				end
				DeletePed(peds[k].ped)
				peds[k] = nil
			end
		end
	end
end)

RegisterNetEvent('nyam:client:OpenVehiclesList', function()
	QBCore.Functions.TriggerCallback('nyam:server:GetUserVehicles', function(result)
		if result then
			local VehicleList = {
				{
					header = Lang:t('menu.locksmith'),
					isMenuHeader = true
				},
			}
			VehicleList[#VehicleList + 1] = {
				header = Lang:t('info.close_menu'),
				txt = '',
				params = {
					event = 'qb-menu:closeMenu',
				}
			}
			for i, v in pairs(result) do
				local price = 250
				VehicleList[#VehicleList + 1] = {
					header = Lang:t('menu.crafting_keys_for_x', {vehicle = QBCore.Shared.Vehicles[v.vehicle].name}),
					txt = Lang:t('menu.crafting_keys_info', {plate = v.plate, price = price}),
					params = {
						event = 'nyam:client:ServerCreateKey',
						args = {
							model = QBCore.Shared.Vehicles[v.vehicle].brand .. ' - ' .. QBCore.Shared.Vehicles[v.vehicle].name,
							plate = v.plate,
							price = price
						}
					}
				}
			end				
			exports['qb-menu']:openMenu(VehicleList)
		end
	end)
end)

RegisterNetEvent('nyam:client:ServerCreateKey', function(data)

	TriggerServerEvent('nyam:server:CreateVehiclekey', data)
		
end)

RegisterNetEvent('nyam:client:CreateVehiclekey', function(data)

	TriggerServerEvent('nyam_vehiclekeys:CreateKey', data.plate, data.model)
		
end)

exports['qb-target']:AddTargetModel(`s_m_m_highsec_04`, {
    options = {
        {
            event = 'nyam:client:OpenVehiclesList',
            icon = 'fas fa-key',
            label = Lang:t('menu.making_car_keys'),
        }
    },
    distance = 10.0
})