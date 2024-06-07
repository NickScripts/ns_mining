local ESX = exports['es_extended']:getSharedObject()
local ox_target = exports.ox_target
local ox_inventory = exports['ox_inventory']

local IsAnimated = false
local smeltStarted = false
local smeltingInputOptions = {}
local smeltStartedClump = false
local smeltingInputOptionsClump = {}
local materialInput = false
local materialsOptions = {}

CreateThread(function()
	local modelHash = 'prop_rock_4_big'

    if not HasModelLoaded(modelHash) then 
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Citizen.Wait(1)
        end
    end

    local obj = {
        CreateObject(modelHash, vector3(2938.24, 2799.15, 39.54), true),
        CreateObject(modelHash, vector3(2963.41, 2795.82, 39.43), true),
        CreateObject(modelHash, vector3(2947.53, 2775.15, 37.80), true),
        CreateObject(modelHash, vector3(2968.39, 2782.04, 37.61), true),
        CreateObject(modelHash, vector3(2948.94, 2795.90, 39.39), true)
    }
    FreezeEntityPosition(obj[1], true)
    FreezeEntityPosition(obj[2], true)
    FreezeEntityPosition(obj[3], true)
    FreezeEntityPosition(obj[4], true) 
    FreezeEntityPosition(obj[5], true) 
end) 

exports['qb-target']:AddTargetModel('prop_rock_4_big',  {
    options = {
      {
        type = 'client',
        event = 'ns_mining:smashrock',
        icon = "fa-solid fa-hammer",
        label = "Use Pickaxe",
        job = Config.JobName,

      },
      {
        type = 'client',
        event = 'ns_mining:drillrock',
        icon = "fa-solid fa-life-ring",
        label = "Use Drill",
        item = 'mining_drill',
        job = Config.JobName,
      },
    },
    distance = 1.5,
})

exports.qtarget:AddBoxZone("SmeltingRaw", vector3(2655.07, 2810.76, 34.15), 4.2, 2.8, {
    name="SmeltingRaw",
    heading=317,
    minZ=25,
    maxZ=27,
    }, {
   options = {
        {
            event = "ns_mining:smelting",
            icon = "fa-brands fa-free-code-camp",
            label = "Raw Smelting",
            job = Config.JobName,
        },
        {
            event = "ns_mining:smeltingclump",
            icon = "fa-brands fa-free-code-camp",
            label = "Clumped Smelting",
            job = Config.JobName,
        },
    }, 
distance = 3
})

exports.qtarget:AddBoxZone("Bench", vector3(2618.20, 2788.36, 32.66), 0.8, 0.8, {
    name="Bench",
    heading=325,
    minZ=25,
    maxZ=27,
    }, {
   options = {
        {
            event = "ns_mining:bench",
            icon = "fa-solid fa-gem",
            label = "Grinding",
            job = Config.JobName,
        },
    }, 
distance = 3
}) 



RegisterNetEvent('ns_mining:drillrock')
AddEventHandler('ns_mining:drillrock', function()
    local PlayerWeight = exports.ox_inventory:GetPlayerWeight()
    local MaxWeight = exports.ox_inventory:GetPlayerMaxWeight()
    if PlayerWeight <= MaxWeight then
        local hasItem = exports.ox_inventory:Search('count', 'mining_drill_bit')
        if hasItem >= 1 then
            local propModel = GetHashKey("hei_prop_heist_drill")
            RequestAnimDict("anim@heists@fleeca_bank@drilling")
                while not HasAnimDictLoaded("anim@heists@fleeca_bank@drilling") do
                    Citizen.Wait(0)
                end
            RequestModel(propModel)
                while not HasModelLoaded(propModel) do
                    Citizen.Wait(0)
                end
            local ped = PlayerPedId()
            local prop = CreateObject(propModel, 0, 0, 0, true, true, true)
            AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 57005), 0.16, 0.0, 0.0, 90.0, 270.0, 180.0, true, true, false, true, 1, true)
            TaskPlayAnim(ped, "anim@heists@fleeca_bank@drilling", "drill_straight_start", 8.0, 1.0, -1, 1, 0, false, false, false)
            local success = lib.skillCheck(Config.DrillSkillDifficulty, Config.SkillCheckKeys)
	        if success then
                lib.progressCircle({
                duration = 10000,
                label = '',
                useWhileDead = false,
                canCancel = false,
                position = "bottom",
                disable = {
                    move = true,
                    car = true,
                    combat = true,
                    mouse = false
                },
                })
                DetachEntity(prop, true, true)
                DeleteEntity(prop)
                ClearPedTasks(ped)
                TriggerServerEvent('ns_mining:drillReward')
                if Config.RemoveDrillBit then
                TriggerServerEvent('ns_mining:removeDrillBit')
                    lib.notify({
                        title = 'Error',
                        description = 'Your drill bit has broke.',
                        position = 'top',
                        type = 'error'
                    })
                end
            else 
                DetachEntity(prop, true, true)
                DeleteEntity(prop)
                ClearPedTasks(ped)
                lib.notify({
                    title = 'Error',
                    description = 'Try again!',
                    position = 'top',
                    type = 'error'
                })
                end
        else 
            lib.notify({
                title = 'Error',
                description = 'You need a drill bit.',
                position = 'top',
                type = 'error'
            })
        end 
    else 
    lib.notify({
        title = 'Error',
        description = 'You cant carry anymore!',
        position = 'top',
        type = 'error'
    })
    end
end)

RegisterNetEvent('ns_mining:smashrock')
AddEventHandler('ns_mining:smashrock', function()
    local PlayerWeight = exports.ox_inventory:GetPlayerWeight()
    local MaxWeight = exports.ox_inventory:GetPlayerMaxWeight()
    if PlayerWeight <= MaxWeight then
        local hasItem = exports.ox_inventory:Search('count', 'mining_pickaxe')
        if hasItem >= 1 then
            local success = lib.skillCheck(Config.PickAxeSkillDifficulty, Config.SkillCheckKeys)
            if success then
                lib.progressCircle({
                duration = 5000,
                label = '',
                useWhileDead = false,
                canCancel = false,
                position = "bottom",
                disable = {
                    move = true,
                    car = true,
                    combat = true,
                    mouse = false
                },
                anim = {dict = 'amb@world_human_hammering@male@base', clip = 'base'},
                prop = {bone = 57005, model = 'prop_tool_pickaxe', pos = vec3(0.09, -0.53, -0.22), rot = vec3(252.0, 180.0, 0.0)}    
                })
                TriggerServerEvent('ns_mining:Reward')
                if Config.BreakPickaxe then
                local chance = math.random(1, 100)
                if chance <= Config.BreakPickaxeChance then
                    TriggerServerEvent('ns_mining:breakPickaxe', cache.serverId)
                    lib.notify({
                        title = 'Error',
                        description = 'Pickaxe Broke.',
                        position = 'top',
                        type = 'error'
                    })
                end
                else
                end
            else
                lib.notify({
                    title = 'Error',
                    description = 'Try again.',
                    position = 'top',
                    type = 'error'
                })
            end
        else
            lib.notify({
                title = 'Error',
                description = 'You dont have a pickaxe.',
                position = 'top',
                type = 'error'
            })
        end
    else 
        lib.notify({
            title = 'Error',
            description = 'You cant carry anymore!',
            position = 'top',
            type = 'error'
        })
    end
end)

for k, v in pairs(Config.SmeltingOptions) do
    table.insert(smeltingInputOptions, {value = k, label = v.label})
end 

RegisterNetEvent('ns_mining:smelting')
AddEventHandler('ns_mining:smelting', function()
    local smeltInput = lib.inputDialog('Material', {
        {type = 'select', label = 'Raw material', description = 'What do you want to smelt?', icon = 'fa-solid fa-list', options = smeltingInputOptions},
        {type = 'checkbox', label = 'Are you sure?'}
    })
    if smeltInput == nil then 
        smeltStarted = false
    else
        if smeltInput[2] then 
            local hasItem = exports.ox_inventory:Search('count', smeltInput[1])
            if hasItem >= 1 then
                local removeItem = nil
                local giveItem = nil
                local duration = nil
                for k, v in pairs(Config.SmeltingOptions) do 
                    if k == smeltInput[1] then 
                        removeItem = k
                        giveItem = k
                        duration = v.duration
                    end
                end
                if duration == nil then 
                    smeltStarted = false
                    return 
                else
                    lib.progressCircle({
                        duration = duration * hasItem,
                        label = 'Smelting...',
                        useWhileDead = false,
                        canCancel = false,
                        position = "bottom",
                        disable = {
                            move = true,
                            car = true,
                            combat = true,
                            mouse = false
                        },
                        anim = {dict = 'amb@world_human_stand_fire@male@idle_a', clip = 'idle_a'},
                    })
                    giveItem = giveItem:gsub("raw_", "")
                    lib.callback('ns_mining:rewardSmeltItem', source, cb, removeItem, giveItem, hasItem)
                    smeltStarted = false
                end
            else
                lib.notify({
                    title = 'Error',
                    description = 'You dont have enough items.',
                    position = 'top',
                    type = 'error'
                })
                smeltStarted = false
            end
        else
            local hasItem = exports.ox_inventory:Search('count', smeltInput[1])
            if hasItem >= smeltInput[3] then
                local removeItem = nil
                local giveItem = nil
                local duration = nil
                for k, v in pairs(Config.SmeltingOptions) do 
                    if k == smeltInput[1] then 
                        removeItem = k
                        giveItem = k
                        duration = v.duration
                    end
                end
                if duration == nil then 
                    smeltStarted = false
                    return 
                else
                    lib.progressCircle({
                        duration = duration * smeltInput[3],
                        label = 'Smelting...',
                        useWhileDead = false,
                        canCancel = false,
                        position = "bottom",
                        disable = {
                            move = true,
                            car = true,
                            combat = true,
                            mouse = false
                        },
                        anim = {dict = 'amb@world_human_stand_fire@male@idle_a', clip = 'idle_a'},
                    })
                    giveItem = giveItem:gsub("raw_", "")
                    lib.callback('ns_mining:rewardSmeltItem', source, cb, removeItem, giveItem, smeltInput[3])
                    smeltStarted = false
                end
            else
                lib.notify({
                    title = 'Error',
                    description = 'You dont have enough items.',
                    position = 'top',
                    type = 'error'
                })
                smeltStarted = false
            end
        end
    end 
end)

for k, v in pairs(Config.SmeltingOptionsClump) do
    table.insert(smeltingInputOptionsClump, {value = k, label = v.label})
end 

RegisterNetEvent('ns_mining:smeltingclump')
AddEventHandler('ns_mining:smeltingclump', function()
    local smeltInputClump = lib.inputDialog('Material', {
        {type = 'select', label = 'Material', description = 'What do you want to smelt?', icon = 'fa-solid fa-list', options = smeltingInputOptionsClump},
        {type = 'checkbox', label = 'Are you sure?'}
    })
    if smeltInputClump == nil then 
        smeltStartedClump = false
    else
        if smeltInputClump[2] then 
            local hasItem = exports.ox_inventory:Search('count', smeltInputClump[1])
            if hasItem >= 1 then
                local removeItem = nil
                local giveItem = nil
                local duration = nil
                for k, v in pairs(Config.SmeltingOptionsClump) do 
                    if k == smeltInputClump[1] then 
                        removeItem = k
                        giveItem = k
                        duration = v.duration
                    end
                end
                if duration == nil then 
                    smeltStartedClump = false
                    return 
                else
                    lib.progressCircle({
                        duration = duration * hasItem,
                        label = 'Smelting...',
                        useWhileDead = false,
                        canCancel = false,
                        position = "bottom",
                        disable = {
                            move = true,
                            car = true,
                            combat = true,
                            mouse = false
                        },
                        anim = {dict = 'amb@world_human_stand_fire@male@idle_a', clip = 'idle_a'},
                    })
                    giveItem = giveItem:gsub("clump_", "")
                    lib.callback('ns_mining:rewardSmeltItemClump', source, cb, removeItem, giveItem, hasItem)
                    smeltStartedClump = false
                end
            else
                lib.notify({
                    title = 'Error',
                    description = 'You dont have enough items.',
                    position = 'top',
                    type = 'error'
                })
                smeltStartedClump = false
            end
        else 
            local hasItem = exports.ox_inventory:Search('count', smeltInputClump[1])
            if hasItem >= smeltInputClump[3] then
                local removeItem = nil
                local giveItem = nil
                local duration = nil
                for k, v in pairs(Config.SmeltingOptionsClump) do 
                    if k == smeltInputClump[1] then 
                        removeItem = k
                        giveItem = k
                        duration = v.duration
                    end
                end
                if duration == nil then 
                    smeltStartedClump = false
                    return 
                else
                    lib.progressCircle({
                        duration = duration * smeltInputClump[3],
                        label = 'Smelting...',
                        useWhileDead = false,
                        canCancel = false,
                        position = "bottom",
                        disable = {
                            move = true,
                            car = true,
                            combat = true,
                            mouse = false
                        },
                        anim = {dict = 'amb@world_human_stand_fire@male@idle_a', clip = 'idle_a'},
                    })
                    giveItem = giveItem:gsub("clump_", "")
                    lib.callback('ns_mining:rewardSmeltItemClump', source, cb, removeItem, giveItem, smeltInputClump[3])
                    smeltStartedClump = false  
                end 
            else
                lib.notify({
                    title = 'Error',
                    description = 'You dont have enough items.',
                    position = 'top',
                    type = 'error'
                })
                smeltStartedClump = false
            end
        end
    end
end)

for k, v in pairs(Config.materialsOptions) do
    table.insert(materialsOptions, {value = k, label = v.label})
end 

RegisterNetEvent('ns_mining:bench')
AddEventHandler('ns_mining:bench', function()
    local materialInput = lib.inputDialog('Material', {
        {type = 'select', label = 'Material', description = 'What do you want to grind?', icon = 'fa-solid fa-list', options = materialsOptions},
        {type = 'checkbox', label = 'Are you sure?'}
    })
    if materialInput == nil then 
        materialInput = false
    else
        if materialInput[2] then 
            local hasItem2 = exports.ox_inventory:Search('count', materialInput[1])
            if hasItem2 >= 1 then
                local removeItem = nil
                local giveItem = nil
                local duration = nil
                for k, v in pairs(Config.materialsOptions) do 
                    if k == materialInput[1] then 
                        removeItem = k
                        giveItem = k
                        duration = v.duration
                    end
                end
                if duration == nil then 
                    materialInput = false
                    return 
                else
                    lib.progressCircle({
                        duration = duration * hasItem2,
                        label = 'Grinding...',
                        useWhileDead = false,
                        canCancel = false,
                        position = "bottom",
                        disable = {
                            move = true,
                            car = true,
                            combat = true,
                            mouse = false
                        },
                        anim = {dict = 'amb@world_human_stand_fire@male@idle_a', clip = 'idle_a'},
                    })
                    giveItem = giveItem:gsub("raw_", "")
                    lib.callback('ns_mining:rewardMaterial', source, cb, removeItem, giveItem, hasItem2)
                    materialInput = false
                end
            else
                lib.notify({
                    title = 'Error',
                    description = 'You dont have enough items.',
                    position = 'top',
                    type = 'error'
                })
                materialInput = false 
            end 
        else
            local hasItem3 = exports.ox_inventory:Search('count', materialInput[1])
            if hasItem3 >= materialInput[3] then
                print(hasItem3)
                local removeItem = nil
                local giveItem = nil
                local duration = nil
                for k, v in pairs(Config.materialsOptions) do 
                    if k == materialInput[1] then 
                        removeItem = k
                        giveItem = k
                        duration = v.duration
                    end
                end
                if duration == nil then 
                    materialInput = false
                    return 
                else
                    print('test')
                    lib.progressCircle({
                        duration = duration * materialInput[3],
                        label = 'Grinding...',
                        useWhileDead = false,
                        canCancel = false,
                        position = "bottom",
                        disable = {
                            move = true,
                            car = true,
                            combat = true,
                            mouse = false
                        },
                        anim = {dict = 'amb@world_human_stand_fire@male@idle_a', clip = 'idle_a'},
                        })
                    giveItem = giveItem:gsub("raw_", "")
                    lib.callback('ns_mining:rewardMaterial', source, cb, removeItem, giveItem, materialInput[3])
                    materialInput = false 
                end 
            else
                lib.notify({
                    title = 'Error',
                    description = 'You dont have enough items.',
                    position = 'top',
                    type = 'error'
                })
                materialInput = false
            end
        end
    end 
end)

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

function GetPed() return PlayerPedId() end


if Config.BlipSmelt then 
    local smeltBlip = AddBlipForCoord(2655.01, 2810.32, 34.41)
    SetBlipSprite(smeltBlip, 648)
    SetBlipColour(smeltBlip, 17)
    SetBlipScale(smeltBlip, 0.80)
    SetBlipAsShortRange(smeltBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Smelting')
    EndTextCommandSetBlipName(smeltBlip)
end

if Config.BlipMining then
    local miningBlip = AddBlipForCoord(2959.02, 2744.29, 43.55)
    SetBlipSprite(miningBlip, 622)
    SetBlipColour(miningBlip, 64)
    SetBlipScale(miningBlip, 1.1)
    SetBlipAsShortRange(miningBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Mining')
    EndTextCommandSetBlipName(miningBlip)
end 

if Config.BlipGrind then
    local grindBlip = AddBlipForCoord(2618.20, 2788.36, 32.66)
    SetBlipSprite(grindBlip, 617)
    SetBlipColour(grindBlip, 64)
    SetBlipScale(grindBlip, 0.80)
    SetBlipAsShortRange(grindBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Grinding')
    EndTextCommandSetBlipName(grindBlip)
end  