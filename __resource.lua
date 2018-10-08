resource_manifest_version '679-996150c95a1d251a5c0c7841ab2f0276878334f7'
description 'Boot Vehicles'

boot_vehicle_file 'vehicle_positions.txt'

-- Add more files in your "vehicles" file and add them here
-- You can remove the default examples by commenting them out (adding -- at the start)
-- boot_vehicle_file 'vehicles/secret.txt'
boot_vehicle_file 'vehicles/mission_row.txt'
boot_vehicle_file 'vehicles/merryweather.txt'
boot_vehicle_file 'vehicles/noose.txt'

server_scripts {
  'sv_bootvehicles.lua'
}
client_scripts {
  'cl_bootvehicles.lua'
}
