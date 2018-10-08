boot_vehicles
<br><br>
When a player connects to the server and no one else is on, this script triggers spawning in vehicles from the sh_pos.txt to add immersion to the enviorment.
<br><br>
FiveM does not keep track of entities thus the script runs every time a player connects and they are the only one on.
<br><br>
For Commands to work, you must be inside a vehicle.
<br><br>
Commands:
<br>
gvpos - print current vehicle Model, X, Y, Z, and Heading
<br>
gvposa - appends the current vehicle the player is in to vehicle_positions.txt located in the vehicles folder of the resource.
<br>
gvpos_trigger - trigger the vehicles to spawn manually.
<br><br>
Included is a couple example vehicle sets, you can add and remove these files in the resource meta
<br><br>
For developers:
<br>
You can add a boot_vehicles list as a file in your own resource.
<br>
Simply add `boot_vehicle_file 'filename.txt'` to your resource meta.
<br>
More files can also be added directly to the main resource instead of via an external resource.
