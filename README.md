boot_vehicles

When a player connects to the server and no one else is on, this script triggers spawning in vehicles from the sh_pos.txt to add immersion to the enviorment. 

FiveM does not keep track of entities thus the script runs every time a player connects and they are the only one on.

For Commands to work, you must be inside a vehicle.

Commands:
gvpos - print current vehicle Model, X, Y, Z, and Heading
gvposa - append vehicle to sh_pos.txt located in the same directory as the server.cfg.
