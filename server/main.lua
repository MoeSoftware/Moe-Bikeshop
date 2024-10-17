local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("moe-bikeshop:server:buyBike", function(bike)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    local actualBike = bike
    local vehiclePrice = QBCore.Shared.Vehicles[actualBike]['price']
    for k, v in pairs(Config.Bikes) do
        if v.name == actualBike then
            vehiclePrice = v.price
        end
    end
    
    local cid = pData.PlayerData.citizenid
    local cash = pData.PlayerData.money['cash']
    local bank = pData.PlayerData.money['bank']
    local plate = GeneratePlate()
    local moneyType = ""
    if cash >= tonumber(vehiclePrice) then
        moneyType = "cash"
    elseif bank >= tonumber(vehiclePrice) then
        moneyType = "bank"
    else
        TriggerClientEvent('QBCore:Notify', src, "You don't have enough money...", 'error')
        return
    end
        MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
            pData.PlayerData.license,
            cid,
            actualBike,
            GetHashKey(actualBike),
            '{}',
            plate,
            'pillboxgarage',
            0
        })
        pData.Functions.RemoveMoney(moneyType, vehiclePrice, 'vehicle-bought-in-showroom')
        TriggerClientEvent('QBCore:Notify', src, "You bought a bike!!", 'success')
        TriggerClientEvent('moe-bikeshop:client:buyBike', src, actualBike, plate)
end)


function GeneratePlate()
    local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return GeneratePlate()
    else
        return plate:upper()
    end
end