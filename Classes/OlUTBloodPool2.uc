// ============================================================
//The main oldskool package.
//Holds the mutators, singleplayer game, windows, Unreal I models and mappacks.
// ============================================================

class OlUTBloodPool2 expands UTBloodPool2;
simulated function AttachToSurface()    //fog zone hack (note that this code cannot be compiled normaly)
{
  local bool oldfog;
  oldfog=region.zone.bfogzone;
  region.zone.bfogzone=false; //ignore fog zone when attaching. (decals don't work in fogzones)
  if(AttachDecal(100) == None)  // trace 100 units ahead in direction of current rotation
    Destroy();
  region.zone.bfogzone=oldfog;
}
defaultproperties
{
}
