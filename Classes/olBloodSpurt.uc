// ============================================================
//The main oldskool package.
//Holds the mutators, singleplayer game, windows, Unreal I models and mappacks.
//olbloodspurt. Decal support
// ============================================================

class olBloodSpurt expands BloodSpurt;
Auto State StartUp
{
  simulated function Tick(float DeltaTime)
  {
    local vector WallHit, WallNormal;
    local Actor WallActor;

    if ( Level.NetMode != NM_DedicatedServer&&class'spoldskool'.default.busedecals)
    {
      WallActor = Trace(WallHit, WallNormal, Location + 300 * vector(Rotation), Location, false);
      if ( WallActor != None ){
        if (Texture == texture'BloodSGrn')
          spawn(class'GreenBloodSplat',,,WallHit + 20 * (WallNormal + VRand()), rotator(WallNormal));
        else
           spawn(class'olBloodSplat',,,WallHit + 20 * (WallNormal + VRand()), rotator(WallNormal));
      }
    }
    Disable('Tick');
  }

}
 simulated function PreBeginPlay()    //gore stuff for client
  {
  if( class'GameInfo'.Default.bVeryLowGore )
    GreenBlood();
  }
defaultproperties
{
}
