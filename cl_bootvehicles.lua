local DEBUG = true -- Set this to false after setup is completed.

local function log(text)
    if DEBUG then
        print(GetCurrentResourceName() .. ": " .. text)
    end
end

if DEBUG then
  RegisterCommand("gvpos_trigger", function(source, args, raw)
    TriggerServerEvent("collectVehicles")
  end, false)

  RegisterCommand("gvpos", function(source, args, raw)
    local _source = source
    local ped = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(ped)
    local x,y,z = table.unpack(GetEntityCoords(vehicle, false))
    log(GetEntityModel(vehicle) .. " " ..  x .. " " .. y .. " " .. z .. " " .. GetEntityHeading(vehicle))
  end, false)

  RegisterCommand("gvposa", function(source, args, raw)
    local _source = source
    local ped = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(ped)
    local x,y,z = table.unpack(GetEntityCoords(vehicle, false))
    log(GetEntityModel(vehicle) .. " " ..  x .. " " .. y .. " " .. z .. " " .. GetEntityHeading(vehicle))
    local vehicle = {GetEntityModel(vehicle), x, y, z, GetEntityHeading(vehicle)} -- We packin
    TriggerServerEvent("appendVehicles", vehicle)
  end, false)
end

RegisterNetEvent("receivedVehicles")
AddEventHandler("receivedVehicles", function(vehicleSets)
    log("LOOPING THROUGH VEHICLES")
    Citizen.Wait(0)
    for vehicleSetId, vehicles in next, vehicleSets do
        log("Spawning vehicle set " .. vehicleSetId .. " (" .. #vehicles .. " entries)")
        for i, vehicle in ipairs(vehicles) do
            local model = tonumber(vehicle[1])
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(10)
            end
            local spawnedVehicle = CreateVehicle(model, tonumber(vehicle[2]), tonumber(vehicle[3]), tonumber(vehicle[4]), tonumber(vehicle[5]), true, false)
            local id = VehToNet(spawnedVehicle)
            SetVehicleOnGroundProperly(spawnedVehicle)
            SetVehicleNeedsToBeHotwired(spawnedVehicle, false)
            SetNetworkIdExistsOnAllMachines(id, true)
            SetNetworkIdCanMigrate(id, true)
            SetEntityAsMissionEntity(spawnedVehicle, true, false)
            SetModelAsNoLongerNeeded(model)
            log(("Successfully spawned %s, %s #%s"):format(GetLabelText(GetDisplayNameFromVehicleModel(model)), model, i))
        end
    end
end)

AddEventHandler("playerSpawned", function(spawnInfo)
  if GetNumberOfPlayers() == 1 then
    TriggerServerEvent("collectVehicles")
  end
end)
