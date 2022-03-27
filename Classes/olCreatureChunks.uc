// ============================================================
//The main oldskool package.
//Holds the mutators, singleplayer game, windows, Unreal I models and mappacks.
//olcreaturechunks. more decalz
// ============================================================

class olCreatureChunks expands CreatureChunks;
simulated function HitWall(vector HitNormal, actor Wall)
{
  local float speed, decision;
  local BloodSpurt b;

  Velocity = 0.8 * (Velocity - 2 * HitNormal * (Velocity Dot HitNormal));
  Velocity.Z = FMin(Velocity.Z * 0.8, 700);
  speed = VSize(Velocity);
  if ( speed < 250 )
  {
    if ( trail != None )
    {
      if ( Level.bHighDetailMode && !Level.bDropDetail)
        bUnlit = false;
      trail.Destroy();
      trail = None;
    }
    if ( speed < 120 )
    {
      bBounce = false;
      Disable('HitWall');
    }
  }
  else if ( speed > 350 )
  {
    if ( speed > 700 )
      velocity *= 0.8;
    if (  Level.NetMode != NM_DedicatedServer )
    {
      decision = FRand();
      if ( decision < 0.2 )
        PlaySound(sound 'gibP1');
      else if ( decision < 0.4 )
        PlaySound(sound 'gibP3');
      else if ( decision < 0.6 )
        PlaySound(sound 'gibP4');
      else if ( decision < 0.8 )
        PlaySound(sound 'gibP5');
      else 
        PlaySound(sound 'gibP6');
    }
  }
  if (Level.NetMode != NM_DedicatedServer){
    if  (trail == None&& !Level.bDropDetail )
    {
      b = Spawn(class 'Bloodspurt',,,,Rotator(HitNormal));
      if ( bGreenBlood )
        b.GreenBlood();
      b.RemoteRole = ROLE_None;
    }
    if ((!Level.bDropDetail || (FRand() < 0.65)) ){   //from UT
      if (!bGreenBlood)
        Spawn(class'olBloodSplat',,,Location,rotator(HitNormal));
      else
        Spawn(class'GreenBloodSplat',,,Location,rotator(HitNormal));
    }
  }
}
simulated function Landed(vector HitNormal)
{
  local rotator finalRot;
  local BloodSpurt b;

  if ( trail != None )
  {
    if ( Level.bHighDetailMode && !Level.bDropDetail)
      bUnlit = false;
    trail.Destroy();
    trail = None;
  }
  finalRot = Rotation;
  finalRot.Roll = 0;
  finalRot.Pitch = 0;
  setRotation(finalRot);
  if ( Level.NetMode != NM_DedicatedServer && !Level.bDropDetail )
  {
    b = Spawn(class 'Bloodspurt',,,,rot(16384,0,0));
    if ( bGreenBlood )
      b.GreenBlood();    
    b.RemoteRole = ROLE_None;
    if ( !bGreenBlood )
      Spawn(class'olBloodSplat',,,Location,rotator(HitNormal));
    else
      Spawn(class'GreenBloodSplat',,,Location,rotator(HitNormal));
  }
  SetPhysics(PHYS_None);
  SetCollision(true, false, false);
}
function SetAsMaster(Actor Other)  //all
{
  Velocity = Other.Velocity;
  if (carcassclass==class'NaliCarcass'){
  Mesh=LodMesh'UnrealShare.NaliPart';
  TrailSize=0.500000;}
  else if (carcassclass==class'SkaarjCarcass'){
     Mesh=LodMesh'UnrealShare.SkaarjTail';
   TrailSize=0.500000;}
   else if (carcassclass==class'TrooperCarcass'){
   Mesh=None;
   TrailSize=0.500000;}
   else
    CarcLocation = Other.Location;
  CarcassAnim = Other.AnimSequence;
  CarcHeight = Other.CollisionHeight;
}

simulated function ClientExtraChunks(bool bSpawnChunks)
{
  local CreatureChunks carc;
  local bloodpuff Blood;
  local bloodspurt b;
  local int n;

  If ( Level.NetMode == NM_DedicatedServer )
    return;

  bMustSpawnChunks = false;
  b = Spawn(class 'Bloodspurt',,,,rot(16384,0,0));
  if ( bGreenBlood )
    b.GreenBlood();
  b.RemoteRole = ROLE_None;

  if ( !bSpawnChunks || (CarcassClass == None) )
    return;

  n = 1;

  while ( (n<8) && (CarcassClass.Default.bodyparts[n] != none) )
  {
    if ( CarcassClass.Static.AllowChunk(n, CarcassAnim) )
    {
      if ( CarcLocation == vect(0,0,0) ) CarcLocation = Location; 
      carc = Spawn(class 'olCreatureChunks',,, CarcLocation
            + CarcassClass.Default.ZOffset[n] * CarcHeight * vect(0,0,1));
      if (carc != None)
      {
        carc.TrailSize = CarcassClass.Default.Trails[n];
        carc.Mesh = CarcassClass.Default.bodyparts[n];
        carc.Initfor(self);
        carc.RemoteRole = ROLE_None;
      }
    }
    n++;
  }

  if ( Level.bHighDetailMode && !bGreenBlood )
  {
    Blood = spawn(class'BloodPuff',,, CarcLocation);
    Blood.drawscale = 0.2 * CollisionRadius;
    Blood.RemoteRole = ROLE_None;
  }
}

state Dead     //permanent.
{
  function BeginState()
  {
    if ( bDecorative ||class'olCreatureCarcass'.default.PermaCarcass){
      lifespan = 0.0;
      bstasis=true;
    }
    else
      SetTimer(5.0, false);
  }
}
defaultproperties
{
}
