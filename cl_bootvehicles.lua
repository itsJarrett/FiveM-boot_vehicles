local DEBUG = true -- Set this to false after setup is completed.
local firstSpawn = true

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
    local extras = {}
    local plate = GetVehicleNumberPlateText(vehicle)
	local livery = GetVehicleLivery(vehicle) -- ##GameCanPlay Livery update
    for i = 1, 14 do -- Max Extras is 14
      if IsVehicleExtraTurnedOn(vehicle, i) then
        table.insert(extras, 0)
      else
        table.insert(extras, 1)
      end
    end
    log(GetEntityModel(vehicle) .. " " ..  x .. " " .. y .. " " .. z .. " " .. GetEntityHeading(vehicle))
    local vehicle_append = {GetEntityModel(vehicle), x, y, z, GetEntityHeading(vehicle), extras, livery} -- We packin ##GameCanPlay Livery Update
    TriggerServerEvent("appendVehicles", vehicle_append)
  end, false)
end

RegisterNetEvent("receivedVehicles")
AddEventHandler("receivedVehicles", function(vehicleSets)
    log("LOOPING THROUGH VEHICLES")
    Citizen.Wait(0)
    for vehicleSetId, vehicles in next, vehicleSets do
        log("Spawning vehicle set " .. vehicleSetId .. " (" .. #vehicles .. " entries)")
			for _, vehicle in ipairs(vehicles) do
				local chance = math.random(0,1) -- ##GameCanPlay there is a 50% chance to spawn a vehicle in. Change the second number to make the percentage differ
				if chance == 0 then
					local model = tonumber(vehicle[1])
					local livery = tonumber(vehicle[20])
					RequestModel(model)
					while not HasModelLoaded(model) do
						Citizen.Wait(10)
					end
					local spawnedVehicle = CreateVehicle(model, tonumber(vehicle[2]), tonumber(vehicle[3]), tonumber(vehicle[4]), tonumber(vehicle[5]), true, false)
					local id = NetworkGetNetworkIdFromEntity(spawnedVehicle)
					for i = 6, 20 do -- Max Extras is 14
					  local extra = tonumber(vehicle[i])
					  if extra ~= nil then
						local q = i - 5 -- Cool math trix. (Stay in school kids) ##GameCanPlay Changed i - 5 from i - 6 to fix extra issues
						if extra == 1 then
						  SetVehicleExtra(spawnedVehicle, q, 1)
						elseif extra == 0 then
						  SetVehicleExtra(spawnedVehicle, q, 0)
						end
					  end
					end
					SetVehicleDirtLevel(spawnedVehicle, 0) -- ##GameCanPlay To stop vehicles from spawning in dirty 
					SetVehicleLivery(spawnedVehicle, livery) -- ##GameCanPlay Livery Update
					SetVehicleOnGroundProperly(spawnedVehicle)
					SetVehicleNeedsToBeHotwired(spawnedVehicle, false)
					SetNetworkIdExistsOnAllMachines(id, true)
					SetNetworkIdCanMigrate(id, true)
					SetVehicleHasBeenOwnedByPlayer(spawnedvehicle, true)
					SetModelAsNoLongerNeeded(model)
					log(("Successfully spawned %s, %s #%s"):format(GetLabelText(GetDisplayNameFromVehicleModel(model)), model, i))
			end
		end
    end
end)

AddEventHandler("playerSpawned", function(spawnInfo)
  if firstSpawn and GetNumberOfPlayers() == 1 then
    TriggerServerEvent("collectVehicles")
			
    -- do not trigger on respawn after death
    firstSpawn = false
  end
end)
