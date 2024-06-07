local ESX = exports['es_extended']:getSharedObject()
ox_inventory = exports['ox_inventory']

RegisterNetEvent('ns_mining:breakPickaxe')
AddEventHandler('ns_mining:breakPickaxe', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('mining_pickaxe', 1)
end)

RegisterServerEvent('ns_mining:removeDrillBit')
AddEventHandler('ns_mining:removeDrillBit', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	    xPlayer.removeInventoryItem('mining_drill_bit', 1)
end)

RegisterServerEvent('ns_mining:drillReward')
AddEventHandler('ns_mining:drillReward', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local count = math.random(Config.DrillStoneMin, Config.DrillStoneMax)
    local items = {}
    for i = 1, math.random(1, 1) do  
        local item = Config.DrillReward.ItemList[math.random(1, #Config.DrillReward.ItemList)]
        items[#items + 1] = item
    end
	for k,v in pairs(items) do
		xPlayer.addInventoryItem('mining_stone', count)
		xPlayer.addInventoryItem(v, i)
	end
end)

RegisterServerEvent('ns_mining:Reward')
AddEventHandler('ns_mining:Reward', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local count = math.random(Config.PickaxeStoneMin, Config.PickaxeStoneMax)
    local items = {}
    for i = 1, math.random(1, 1) do  
        local item = Config.PickaxeReward.ItemList[math.random(1, #Config.PickaxeReward.ItemList)]
        items[#items + 1] = item
    end
    for k,v in pairs(items) do
		xPlayer.addInventoryItem('mining_stone', count)
		xPlayer.addInventoryItem(v, i)
	end
end)

lib.callback.register('ns_mining:hasItem', function(source, item)
    local hasItem = ox_inventory:Search(source, 'count', item)
    return hasItem
end)

lib.callback.register('ns_mining:rewardSmeltItem', function(source, item, giveItem, quantity)
    local src = source
    local ped = ESX.GetPlayerFromId(src)
    ped.removeInventoryItem(item, quantity)
    ped.addInventoryItem(giveItem, quantity)
end)

lib.callback.register('ns_mining:rewardSmeltItemClump', function(source, item, giveItem, quantity)
    local src = source
    local ped = ESX.GetPlayerFromId(src)
	local count = math.random(quantity * 3,quantity * 5)
    ped.removeInventoryItem(item, quantity)
    ped.addInventoryItem(giveItem, count)
end)

lib.callback.register('ns_mining:rewardMaterial', function(source, item, giveItem, quantity)
    local src = source
    local ped = ESX.GetPlayerFromId(src)
    ped.removeInventoryItem(item, quantity)
    ped.addInventoryItem(giveItem, quantity)
end)