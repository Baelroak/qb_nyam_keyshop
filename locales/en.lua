local Translations = {

    error = {
        you_dont_have_enough_money = 'You don\'t have enough money',
    },
	
	success = {
        purchase_keys = 'Purchased keys for %{vehicle}!',
		purchased_key_plate = 'Plate %{plate}!',
    },

    info = {
        close_menu = '❌| Close',
    },


	menu = {
        ['locksmith'] = 'locksmith',
        ['crafting_keys_for_x'] = 'Crafting keys for %{vehicle}:',
		['crafting_keys_info'] = 'Plate: %{plate}<br>Price: $%{price}',
        ['making_car_keys'] = 'Making Car Keys',
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})