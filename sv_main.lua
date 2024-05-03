local savedData = {}

local function isDataSaved(data)
    for _, savedDataItem in ipairs(savedData) do
        if savedDataItem.doorcoords == data.doorcoords then
            return true
        end
    end
    return false
end

RegisterServerEvent('esx_containerrob:saveCoords')
AddEventHandler('esx_containerrob:saveCoords', function(data)
    if not isDataSaved(data) then
        local index = nil
        index = #savedData + 1
        table.insert(savedData, data)
        TriggerClientEvent('esx_containerrob:setTargets', -1, data, index)
        TriggerClientEvent('esx_containerrob:setDoors', -1, savedData)
    end
end)

RegisterServerEvent('esx_containerrob:server:notifyPolice')
AddEventHandler('esx_containerrob:server:notifyPolice', function(coords)
    TriggerClientEvent('esx_containerrob:client:notifyPolice', -1, coords)
end)

RegisterServerEvent('esx_containerrob:updateStatus')
AddEventHandler('esx_containerrob:updateStatus', function(index, newStatus)
    if savedData[index] then
        if newStatus == true then
            for k,v in pairs(savedData[index].cabinets) do
                v.taken = false
            end
        end
        savedData[index].status = newStatus
    end
end)

RegisterServerEvent('esx_containerrob:giveLoot')
AddEventHandler('esx_containerrob:giveLoot', function(containerindex, cabinetindex)
    local ped = GetPlayerPed(source)
    local position = GetEntityCoords(ped)

    if #(position - savedData[containerindex].doorcoords) >= 20 then --
        return print('Do something about this modder! ID: '..source) -- Add a better mod check if you want. I'm not going to
    end                                                              -- 

    local totalAmountofLoot = 0
    local rarity = Config.Loot.Common

    if math.random(100) <= Config.Loot.ChanceOfRare then
        rarity = Config.Loot.Rare
    end

    if rarity.AllowMoney and math.random(100) <= rarity.Money.chance then
        local moneyAmount = math.random(rarity.Money.min, rarity.Money.max)
        exports.ox_inventory:AddItem(source, 'money', moneyAmount)
        totalAmountofLoot = totalAmountofLoot + 1
    end

    if rarity.AllowItems then
        local totalItems = math.random(rarity.Item.min, rarity.Item.max)
        for i = 1, totalItems do
            for _, item in ipairs(rarity.Items) do
                if math.random(100) <= item.chance then
                    local itemQuantity = math.random(item.minQuantity, item.maxQuantity)
                    exports.ox_inventory:AddItem(source, item.name, itemQuantity)
                    totalAmountofLoot = totalAmountofLoot + 1
                end
            end
        end
    end

    if totalAmountofLoot == 0 then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Konttiryöstö',
            description = Config.Locales['NothingFound'],
            type = 'error'
        })
    end

    savedData[containerindex].cabinets[cabinetindex].taken = true
end)

RegisterServerEvent('esx_containerrob:onStart')
AddEventHandler('esx_containerrob:onStart', function()
    for k, v in pairs(savedData) do
        TriggerClientEvent('esx_containerrob:setTargets', -1, v, k)
    end
    TriggerClientEvent('esx_containerrob:setDoors', -1, savedData)
end)

ESX.RegisterServerCallback('esx_containerrob:checkData', function(source, cb)
    cb(savedData)
end)
