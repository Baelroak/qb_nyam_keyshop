QBCore =  exports['qb-core']:GetCoreObject()


QBCore.Functions.CreateCallback('nyam:server:GetUserVehicles', function(source, cb) -- Get a list of vehicles in the garage
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE citizenid = ?',
		{
			Player.PlayerData.citizenid
		}, function(result)
		if result[1] ~= nil then
			cb(result)
		else
			cb(nil)
		end
	end)
end)


RegisterNetEvent('nyam:server:CreateVehiclekey', function(data)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local cash = Player.PlayerData.money['cash']
    local bank = Player.PlayerData.money['bank']
	if cash >= data.price then
		TriggerClientEvent('nyam:client:CreateVehiclekey', src, data)
		TriggerClientEvent('QBCore:Notify', src, Lang:t('success.purchased_key_plate', {plate = data.plate}), 'success')
		TriggerClientEvent('QBCore:Notify', src, Lang:t('success.purchase_keys', {vehicle = data.model}), 'success')
		Player.Functions.RemoveMoney('cash', data.price, 'Create Vehicle key')
	elseif bank >= data.price then
		TriggerClientEvent('nyam:client:CreateVehiclekey', src, data)
		TriggerClientEvent('QBCore:Notify', src, Lang:t('success.purchased_key_plate', {plate = data.plate}), 'success')
		TriggerClientEvent('QBCore:Notify', src, Lang:t('success.purchase_keys', {vehicle = data.model}), 'success')
		Player.Functions.RemoveMoney('bank', data.price, 'Create Vehicle key')
	else
		TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_enough_money'), 'error')
	end
end)

RegisterNetEvent('nyam:server:DeleteVehicleKey', function(plate)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
		local items = Player.Functions.GetItemsByName('keys')
		if items then	
			for _, v in pairs(items) do
				if v.info.vehicleplate == plate then
				local ItemData = Player.Functions.GetItemBySlot(v.slot)
					Player.Functions.RemoveItem(v.name, ItemData.amount, v.slot)
					TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[v.name], 'remove')
				end
			end
		end
    end
end)

