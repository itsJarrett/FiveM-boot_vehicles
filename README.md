**Boot Vehicles**

This resource will spawn configured vehicles when the first player joins on your server. This allows the vehicles to be networked for all players to see! This resource adds roleplay when configuring vehicles to be at police stations, fire stations, etc. Just simply spawn a vehicle, drive it where you want, append it to the configuration via a command and you're done!

Share vehicle files easily, just slap the locations text file in, and add it to the meta!

Save locations/sets easily by just renaming the file and adding it to the meta, so they can keep stuff separated and organized!

The following is a showcase of the resource in action:

https://www.youtube.com/watch?v=V5jG9oEFoMA

**Developers:**
You can add a boot_vehicles list as a file in your own resource.
Simply add  `boot_vehicle_file 'filename.txt'`  to your resource meta.
More files can also be added directly to the main resource instead of via an external resource.

**Commands**
gvposa - _Appends the current vehicle the player is in to the vehicle_positions.txt file inside the resource._
gvpos - _Prints current vehicle model hash, X, Y, Z, and heading_ (Use for debug purposes)
gvpos_trigger - _Manually triggers the vehicles to spawn._

**Configuration**
The vehicle locations text file is located in the same location as the resource, this file is called _vehicle_locations.txt_.

**Included are a couple example vehicle sets, you can add and remove these files in the resource meta to your liking.**

**After you are done setting vehicle locations please change the DEBUG variable in the cl_bootvehicles.lua to false**

**Big shoutout to @glitchdetector for contributing; a lot of the recent additions are all thanks to him!**
