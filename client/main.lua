local QBCore = exports['qb-core']:GetCoreObject()
local bikeMenu = {}
local currentStore = nil

CreateThread(function()
    for k,v in pairs(Config.Shops) do
        exports['qb-target']:SpawnPed({
            model = v.model,
            coords = v.coords, 
            minusOne = true, 
            freeze = true, 
            invincible = true, 
            blockevents = true,
            scenario = v.scenario,
            target = { 
                options = {
                    {
                        type="client",
                        event = "moe-bikeshop:client:openMenu",
                        icon = "fas fa-bicycle",
                        label = "Buy Bikes"
                    }
                },
              distance = 2.5,
            },
        })
    end
    while true do
        local ped = PlayerPedId()
        for k, v in pairs(Config.Shops) do
            local dist = #(GetEntityCoords(ped) - vector3(v.coords.x, v.coords.y, v.coords.z))
            if dist <= 5 then
                currentStore = k
                Wait(100)
            end
            Wait(100)
        end
        Wait(100)
    end
end)
RegisterNetEvent("moe-bikeshop:client:sendEventToServer", function(bike)
TriggerServerEvent("moe-bikeshop:server:buyBike", bike.buyBike)
end)
RegisterNetEvent('moe-bikeshop:client:buyBike', function(bike, plate)
    QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
        local veh = NetToVeh(netId)
        exports['ps-fuel']:SetFuel(veh, 100)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, Config.Shops[currentStore]["VehicleSpawn"].w)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        TriggerServerEvent("qb-vehicletuning:server:SaveVehicleProps", QBCore.Functions.GetVehicleProperties(veh))
    end, bike, Config.Shops[currentStore]["VehicleSpawn"], true)
end)

RegisterNetEvent("moe-bikeshop:client:openMenu", function()
    bikeMenu = {}
    bikeMenu[#bikeMenu+1] = {isMenuHeader = true, header = "Bike Shop", txt = "Buy some bikes!!"}

    for k, v in pairs(Config.Bikes) do
    bikeMenu[#bikeMenu+1] = {header = QBCore.Shared.Vehicles[v.name]['name'], txt = "Buy " .. QBCore.Shared.Vehicles[v.name]['name'] .. " for " .. v.price .. "?", params = { event = "moe-bikeshop:client:sendEventToServer", args = {buyBike = v.name} } }
    end

    bikeMenu[#bikeMenu+1] = { icon = "fas fa-circle-xmark", header = "", txt = "Close ❌ ", params = { event = "moe-bikeshop:client:closemenu"}, }
    
    exports['qb-menu']:openMenu(bikeMenu)
end)

RegisterNetEvent("moe-bikeshop:client:closemenu", function()
    exports['qb-menu']:closeMenu()
    bikeMenu = {}
end)