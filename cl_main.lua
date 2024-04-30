local targets = {}

AddEventHandler("onClientResourceStart", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    TriggerServerEvent('esx_containerrob:onStart')
end)

Citizen.CreateThread(function()
    while true do
        local objects = ESX.Game.GetObjects()
        for _, object in pairs(objects) do
            local model = GetEntityModel(object)
            if GetHashKey("ex_prop_door_lowbank_roof") == model then
                local doorcoords = GetEntityCoords(object)
                local targetcoords = GetOffsetFromEntityInWorldCoords(object, 1.1, 0.0, 0.0)
                local heading = GetEntityHeading(object)
                local cabinets = {}
                cabinets[1] = {coords = GetOffsetFromEntityInWorldCoords(object, 1.75, 3.0, 0.1), size = vec3(1.2, 0.3, 1.0), taken = false, skillcheck = math.random(100)}
                cabinets[2] = {coords = GetOffsetFromEntityInWorldCoords(object, 0.1, 3.1, -0.3), size = vec3(0.9, 0.4, 0.5), taken = false, skillcheck = math.random(100)}
                cabinets[3] = {coords = GetOffsetFromEntityInWorldCoords(object, 3.45, 3.1, -0.3), size = vec3(0.9, 0.4, 0.5), taken = false, skillcheck = math.random(100)}
                cabinets[4] = {coords = GetOffsetFromEntityInWorldCoords(object, 6.3, 1.8, -0.6), size = vec3(0.5, 2.0, 1.5), taken = false, skillcheck = math.random(100)}
                cabinets[5] = {coords = GetOffsetFromEntityInWorldCoords(object, -2.8, 1.8, -0.6), size = vec3(0.5, 2.0, 1.5), taken = false, skillcheck = math.random(100)}
                local data = {
                    doorcoords = doorcoords,
                    targetcoords = targetcoords,
                    heading = heading,
                    cabinets = cabinets,
                    status = true
                }
                TriggerServerEvent('esx_containerrob:saveCoords', data)
            end
        end
        Citizen.Wait(4000)
    end
end)

RegisterNetEvent('esx_containerrob:setDoors')
AddEventHandler('esx_containerrob:setDoors', function(data)
    for k, v in pairs(data) do
        if not DoorSystemFindExistingDoor(v.doorcoords.x, v.doorcoords.y, v.doorcoords.z, GetHashKey("ex_prop_door_lowbank_roof")) then
            AddDoorToSystem(k, GetHashKey("ex_prop_door_lowbank_roof"), v.doorcoords, false)
        end
        DoorSystemSetDoorState(k, v.status and 1 or 0)
    end
end)

RegisterNetEvent('esx_containerrob:setTargets')
AddEventHandler('esx_containerrob:setTargets', function(data, index)
    if targets[index] == true then return end
    targets[index] = true
    exports.ox_target:addBoxZone({
        coords = data.targetcoords,
        size = vec3(0.5, 0.3, 0.5),
        rotation = data.heading,
        debug = Config.Debug,
        options = {
            {
                icon = 'fa-solid fa-screwdriver',
                label = Config.Locales['LockpickDoor'],
                canInteract = function()
                    return DoorSystemGetDoorState(index) == 1 and exports.ox_inventory:GetItemCount(Config.Containers.LockpickItem) > 0
                end,
                onSelect = function()
                    ExecuteCommand('e picklock')
                    local result = exports['lockpick']:startLockpick()

                    if not result then
                        lib.notify({
                            title = Config.Locales['ContainerRobbery'],
                            description = Config.Locales['YouFailed'],
                            type = 'error'
                        })
                        ExecuteCommand('emotecancel')
                    else
                        DoorSystemSetDoorState(index, 0)
                        TriggerServerEvent('esx_containerrob:updateStatus', index, false)
                        lib.notify({
                            title = Config.Locales['ContainerRobbery'],
                            description = Config.Locales['DoorOpened'],
                            type = 'success'
                        })
                        ExecuteCommand('emotecancel')
                        exports['aty_dispatch']:SendDispatch(Config.Locales['ContainerRobbery'], '10-26', 40, {'police'})
                    end
                end
            },
            {
                icon = 'fa-solid fa-screwdriver',
                label = Config.Locales['BreakDoor'],
                canInteract = function()
                    return DoorSystemGetDoorState(index) == 1 and exports.ox_inventory:GetItemCount(Config.Containers.BreakDoorItem) > 0
                end,
                onSelect = function()
                    if lib.progressCircle({
                        label = Config.Locales['Breaking'],
                        duration = 10000,
                        position = 'bottom',
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                            move = true
                        },
                        anim = {
                            dict = "missfbi3_toothpull", 
                            clip = "pull_tooth_loop_weak_player"
                        },
                    }) then
                        DoorSystemSetDoorState(index, 0)
                        TriggerServerEvent('esx_containerrob:updateStatus', index, false)
                        lib.notify({
                            title = Config.Locales['ContainerRobbery'],
                            description = Config.Locales['DoorOpened'],
                            type = 'success'
                        })
                        exports['aty_dispatch']:SendDispatch(Config.Locales['ContainerRobbery'], '10-26', 40, {'police'})
                    else
                        lib.notify({
                            title = Config.Locales['ContainerRobbery'],
                            description = Config.Locales['Canceled'],
                            type = 'error'
                        })
                    end
                end
            },
            {
                icon = 'fa-solid fa-laptop',
                label = Config.Locales['HackDoor'],
                canInteract = function()
                    return DoorSystemGetDoorState(index) == 1 and exports.ox_inventory:GetItemCount(Config.Containers.HackingItem) > 0
                end,
                onSelect = function()
                    local dict = 'anim@heists@ornate_bank@hack'
                    local clip = 'hack_loop'
                    RequestAnimDict(dict)
                    while not HasAnimDictLoaded(dict) do
                        Wait(10)
                    end
                    TaskPlayAnim(PlayerPedId(), dict, clip, 8.0, 8.0, -1, 1)
                    local laptop = CreateObject(GetHashKey('hei_prop_hst_laptop'), 0, 0, 0, true, true, true)
                    AttachEntityToEntity(laptop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.18, 0.03, 0.03, -180.0, 0.0, -270.0, true, true, false, true, 1, true)
                    if lib.progressCircle({
                        label = Config.Locales['HackConnecting'],
                        duration = 5000,
                        position = 'bottom',
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                        }
                    }) then
                        local result = exports['numbers']:StartNumbersGame()
                    
                        if not result then
                            ClearPedTasksImmediately(PlayerPedId())
                            DeleteObject(laptop)
                            lib.notify({
                                title = Config.Locales['ContainerRobbery'],
                                description = Config.Locales['YouFailed'],
                                type = 'error'
                            })
                        else
                            ClearPedTasksImmediately(PlayerPedId())
                            DeleteObject(laptop)
                            DoorSystemSetDoorState(index, 0)
                            TriggerServerEvent('esx_containerrob:updateStatus', index, false)
                            lib.notify({
                                title = Config.Locales['ContainerRobbery'],
                                description = Config.Locales['DoorOpened'],
                                type = 'success'
                            })
                            exports['aty_dispatch']:SendDispatch(Config.Locales['ContainerRobbery'], '10-26', 40, {'police'})
                        end
                    else
                        lib.notify({
                            title = Config.Locales['ContainerRobbery'],
                            description = Config.Locales['Canceled'],
                            type = 'error'
                        })
                    end
                end
            },
            {
                icon = 'fa-solid fa-lock',
                label = Config.Locales['LockDoor'],
                groups = 'police',
                canInteract = function()
                    return DoorSystemGetDoorState(index) == 0
                end,
                onSelect = function()
                    if lib.progressCircle({
                        duration = 5000,
                        position = 'bottom',
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                            move = true
                        },
                        anim = {
                            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                            clip = 'machinic_loop_mechandplayer'
                        },
                    }) then
                        DoorSystemSetDoorState(index, 1)
                        TriggerServerEvent('esx_containerrob:updateStatus', index, true)
                        lib.notify({
                            title = Config.Locales['ContainerRobbery'],
                            description = Config.Locales['DoorLocked'],
                            type = 'success'
                        })
                    else
                        lib.notify({
                            title = Config.Locales['ContainerRobbery'],
                            description = Config.Locales['Canceled'],
                            type = 'error'
                        })
                    end
                end
            }
        }
    })
    for k, v in pairs(data.cabinets) do
        exports.ox_target:addBoxZone({
            coords = v.coords,
            size = v.size,
            rotation = data.heading,
            debug = Config.Debug,
            options = {
                {
                    icon = 'fa-solid fa-magnifying-glass',
                    label = Config.Locales['SearchCabinet'],
                    distance = 1,
                    canInteract = function()
                        return DoorSystemGetDoorState(index) == 0
                    end,
                    onSelect = function()
                        ESX.TriggerServerCallback('esx_containerrob:checkData', function(savedData)
                            if savedData[index].cabinets[k].taken then
                                lib.notify({
                                    title = Config.Locales['ContainerRobbery'],
                                    description = Config.Locales['CabinetSearched'],
                                    type = 'error'
                                })
                            else
                                if v.skillcheck <= Config.Containers.Cabinets.ChanceOfSkillcheck then
                                    local success = lib.skillCheck({'easy', 'medium', 'hard', 'hard'}, {'1', '2', '3'})
                                    if not success then
                                        lib.notify({
                                            title = Config.Locales['ContainerRobbery'],
                                            description = Config.Locales['YouFailed'],
                                            type = 'error'
                                        })
                                        return
                                    end
                                end
                                if lib.progressCircle({
                                    label = Config.Locales['CabinetSearching'],
                                    duration = 5000,
                                    position = 'bottom',
                                    useWhileDead = false,
                                    canCancel = true,
                                    disable = {
                                        car = true,
                                    },
                                    anim = {
                                        dict = "missexile3", 
						                clip = "ex03_dingy_search_case_base_michael"
                                    },
                                }) then
                                    TriggerServerEvent('esx_containerrob:giveLoot', index, k) 
                                else 
                                    lib.notify({
                                        title = Config.Locales['ContainerRobbery'],
                                        description = Config.Locales['Canceled'],
                                        type = 'error'
                                    }) 
                                end
                            end
                        end)
                    end
                }
            }
        })
    end
end)