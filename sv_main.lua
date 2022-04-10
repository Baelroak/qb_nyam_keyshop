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