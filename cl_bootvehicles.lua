local allowedToUse = false

Citizen.CreateThread(function()
    TriggerServerEvent("bootvehicles.getIsAllowed")
end)

RegisterNetEvent("bootvehicles.getIsAllowed")
AddEventHandler("bootvehicles.getIsAllowed", function(isAllowed)
    allowedToUse = isAllowed
end)

RegisterNetEvent("receivedVehicles")
AddEventHandler("receivedVehicles", function(vehicles)
  print("LOOPING THROUGH VEHICLES")
  Citizen.Wait(0)
  for i, vehicle in ipairs(vehicles) do
    local model = tonumber(vehicle[1])
    RequestModel(model)
    print(GetLabelText(GetDisplayNameFromVehicleModel(model)))
    print(model)
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
    print(i .. " Successfully Spawned.")
  end
end)

RegisterCommand("gvpos_trigger", function(source, args, raw)
  local _source = source
  if not allowedToUse then return end
  TriggerServerEvent("triggerVehicles")
end, false)

RegisterCommand("gvpos", function(source, args, raw)
  local _source = source
  if not allowedToUse then return end
  local ped = GetPlayerPed(-1)
  local vehicle = GetVehiclePedIsIn(ped)
  local x,y,z = table.unpack(GetEntityCoords(vehicle, false))
  print(GetEntityModel(vehicle) .. " " ..  x .. " " .. y .. " " .. z .. " " .. GetEntityHeading(vehicle))
end, false)

RegisterCommand("gvposa", function(source, args, raw)
  local _source = source
  if not allowedToUse then return end
  local ped = GetPlayerPed(-1)
  local vehicle = GetVehiclePedIsIn(ped)
  local x,y,z = table.unpack(GetEntityCoords(vehicle, false))
  local vehicle = {GetEntityModel(vehicle), x, y, z, GetEntityHeading(vehicle)} -- We packin
  TriggerServerEvent("appendVehicles", vehicle)
end, false)

AddEventHandler("playerSpawned", function(spawnInfo)
  TriggerServerEvent("collectVehicles")
end)
