local hasRan = false

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

Citizen.CreateThread(function()
  RegisterServerEvent("triggerVehicles")
  AddEventHandler("triggerVehicles", function()
    local _source = source
    local vehicles_file = io.open("sh_pos.txt", "r")
    local vehicles = {}
    for line in vehicles_file:lines() do
      if line == nil or line == "" then return end
      table.insert(vehicles, line:split(","))
    end
    for _, veh in ipairs(vehicles[1]) do print(veh) end
    TriggerClientEvent("receivedVehicles", _source, vehicles)
    print("TRIGGERED CLIENT SPAWN EVENT")
  end)
end)

Citizen.CreateThread(function()
  RegisterServerEvent("collectVehicles")
  AddEventHandler("collectVehicles", function()
    local _source = source
    if hasRan then return end
    local vehicles_file = io.open("sh_pos.txt", "r")
    local vehicles = {}
    for line in vehicles_file:lines() do
      if line == nil or line == "" then return end
      table.insert(vehicles, line:split(","))
    end
    for _, veh in ipairs(vehicles[1]) do print(veh) end
    TriggerClientEvent("receivedVehicles", _source, vehicles)
    print("TRIGGERED CLIENT SPAWN EVENT")
    hasRan = true
  end)
end)

Citizen.CreateThread(function()
  RegisterServerEvent("appendVehicles")
  AddEventHandler("appendVehicles", function(vehicle)
    local vehicles_file = io.open("sh_pos.txt", "a")
    print(vehicle[1] .. "," .. vehicle[2] .. "," .. vehicle[3] .. "," .. vehicle[4] .. "," .. vehicle[5])
    vehicles_file:write(vehicle[1] .. "," .. vehicle[2] .. "," .. vehicle[3] .. "," .. vehicle[4] .. "," .. vehicle[5], "\n")
    vehicles_file:close()
  end)
end)

Citizen.CreateThread(function()
	while true do
		Wait(1000)
    if GetNumPlayerIndices() == 0 then
      hasRan = false
    end
	end
end)
