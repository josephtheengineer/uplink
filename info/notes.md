- Refactor function eden_world_decoder::load_world()
Into two functions
load_compressed(vars) maybe load_gunp_world()
load_uncompressed(vars)
These two setup the world file so that it's in Uplink Binary Format (.ubf)
So that in can be read by get_metadata()

- Get uncompressed file size in header of file
