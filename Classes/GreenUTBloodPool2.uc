// ============================================================
//The main oldskool package.
//Holds the mutators, singleplayer game, windows, Unreal I models and mappacks.
//GreenUTBloodPool2. simply uses bio textures.
// ============================================================

class GreenUTBloodPool2 expands UTBloodPool2;
/*simulated function BeginPlay()
{
  if ( class'GameInfo'.Default.bveryLowGore )   //its green :P
  {
    destroy();
    return;
  }
  if ( !Level.bDropDetail&&frand()<0.5 )   //well, 2 textures only!
    Texture = Texture'botpack.biosplat2';
} */
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
    Splats(0)=Texture'GreenSplat7'
    Splats(1)=Texture'GreenSplat5'
    Splats(2)=Texture'GreenSplat1'
    Splats(3)=Texture'GreenSplat3'
    Splats(4)=Texture'GreenSplat4'
    Texture=Texture'GreenSplat1'
}
