function string:split(delimiter)
  local result = {}
  local from  = 1
  local delim_from, delim_to = string.find( self, delimiter, from  )
  while delim_from do
    table.insert( result, string.sub( self, from , delim_from-1 ) )
    from  = delim_to + 1
    delim_from, delim_to = string.find( self, delimiter, from  )
  end
  table.insert( result, string.sub( self, from  ) )
  return result
end

local DEBUG = true -- Set this to false after setup is completed.
local function log(text)
    if DEBUG then
        print(GetCurrentResourceName() .. ": " .. text)
    end
end

-- We store all the vehicle sets from all the resources
local vehicleSets = {}

AddEventHandler("onResourceStart", function(resourceName)
    -- Get every "boot_vehicle_file" file from resources that start
    local datasets = GetNumResourceMetadata(resourceName, "boot_vehicle_file")
    if datasets > 0 then
        log("Loading boot vehicles from " .. resourceName)
        for i = 0, datasets - 1 do
            -- Now we get the file and load it
            local dataFile = GetResourceMetadata(resourceName, "boot_vehicle_file", i)
            local dataset = LoadResourceFile(resourceName, dataFile)
            if dataset == nil then return end
            log("File #" .. i + 1 .. " (" .. dataFile .. ")")

            local vehicles = {}

            -- Get every line
            local lines = dataset:split("\n")

            -- Iterate over the lines
            for _, line in next, lines do
                if line == nil or line == "" then break end
                table.insert(vehicles, line:split(","))
                log("Vehicle: " .. json.encode(vehicles[#vehicles]))
            end
            -- Save with name index so loading the resource twice (or reloading it) doesn't dupe the vehicles
            log("Vehicle set \"" .. resourceName .. ":" .. i .. "\" with " .. #vehicles .. " entries")
            vehicleSets[resourceName .. ":" .. i] = vehicles
        end
    end
end)

Citizen.CreateThread(function()
    RegisterServerEvent("collectVehicles")
    AddEventHandler("collectVehicles", function()
        local _source = source
        TriggerClientEvent("receivedVehicles", _source, vehicleSets)
    end)
end)

Citizen.CreateThread(function()
  RegisterServerEvent("appendVehicles")
  AddEventHandler("appendVehicles", function(vehicle)
    local _source = source
    local vehicles_file = LoadResourceFile(GetCurrentResourceName(), "vehicle_positions.txt")
    log(vehicle[1] .. "," .. vehicle[2] .. "," .. vehicle[3] .. "," .. vehicle[4] .. "," .. vehicle[5])
    vehicles_file = vehicles_file .. vehicle[1] .. "," .. vehicle[2] .. "," .. vehicle[3] .. "," .. vehicle[4] .. "," .. vehicle[5] .. "\n"
    SaveResourceFile(GetCurrentResourceName(), "vehicle_positions.txt", vehicles_file, -1)
  end)
end)
