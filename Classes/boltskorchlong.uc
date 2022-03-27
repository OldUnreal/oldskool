// ============================================================
//boltskorchlong.  a longer lasting bolt skorch (for krallbolts)
// Psychic_313: unchanged
// ============================================================

class boltskorchlong expands EnergyImpact;

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
    MultiDecalLevel=0
    Texture=Texture'botpack.energymark'
    DrawScale=0.20
}
