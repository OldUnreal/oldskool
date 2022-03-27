// ============================================================
//The main oldskool package.
//Holds the mutators, singleplayer game, windows, Unreal I models and mappacks.
//olcreaturecarcass.  The creature carcass for all classes if blood decals mode is on.
// Uses decals and thx to static functions makes use for all creatures.
// used as a decoration, it would screw up.
// ============================================================

class olCreatureCarcass expands CreatureCarcass;
var class<creaturecarcass> realcarcass;
var Decal Pool; //blood pool
var config bool PermaCarcass; //carcass does not auto-destruct?
//permacarcass:
  function PostBeginPlay()
  {
    if ( !bDecorative &&!PermaCarcass)
    {
      DeathZone = Region.Zone;
      DeathZone.NumCarcasses++;
    }
    Super(Carcass).PostBeginPlay();
    if ( Physics == PHYS_None )
      SetCollision(bCollideActors, false, false);
  }

//DEFAULTED CHECKS:
//realcarcass check
function Initfor(actor Other)
  {
    local rotator carcRotation;
    local int i;
    if ( bDecorative)
    {
      DeathZone = Region.Zone;
      DeathZone.NumCarcasses++;
    }
    bDecorative = false;
    bMeshCurvy = Other.bMeshCurvy;  
    bMeshEnviroMap = Other.bMeshEnviroMap;  
    for (i=0;i<8;i++) //NEED THIS!
    multiskins[i]=other.multiskins[i];
    Mesh = Other.Mesh;
    Skin = Other.Skin;
    if (skin!=none)
    skin.lodset=lodset_skin;
    Texture = Other.Texture;
    if (texture!=none)
    texture.lodset=lodset_skin;
    Fatness = Other.Fatness;
    DrawScale = Other.DrawScale;
    SetCollisionSize(Other.CollisionRadius + 4, Other.CollisionHeight);
    if ( !SetLocation(Location) )
      SetCollisionSize(CollisionRadius - 4, CollisionHeight);
    //if (pawn(other).isa('scriptedpawn'))
    realcarcass=class<creaturecarcass>(scriptedpawn(other).default.carcasstype); //use default!
    bgreenblood=realcarcass.default.bgreenblood; //copy.
    bPermanent=realcarcass.default.bPermanent;
    lifespan=realcarcass.default.lifespan;
    DesiredRotation = other.Rotation;
    DesiredRotation.Roll = 0;
    DesiredRotation.Pitch = 0;
    AnimSequence = Other.AnimSequence;
    AnimFrame = Other.AnimFrame;
    AnimRate = Other.AnimRate;
    TweenRate = Other.TweenRate;
    AnimMinRate = Other.AnimMinRate;
    AnimLast = Other.AnimLast;
    bAnimLoop = Other.bAnimLoop;
    SimAnim.X = 10000 * AnimFrame;
    SimAnim.Y = 5000 * AnimRate;
    SimAnim.Z = 1000 * TweenRate;
    SimAnim.W = 10000 * AnimLast;
    bAnimFinished = Other.bAnimFinished;
    Velocity = other.Velocity;
    Mass = Other.Mass;
    if ( Buoyancy < 0.8 * Mass )
      Buoyancy = 0.9 * Mass;
    if ( AnimSequence == 'LeglessDeath' )   //krall
    SetCollision(true, false, false);
  }
  function tick(float delta){
    if (realcarcass==class'KrallCarcass'&&AnimSequence!='LegLessDeath') //fix up stupid krall col-height bug
       bReducedHeight = false; //fix this!
    Disable('tick');
  }

  function CreateReplacement()
  {
    local CreatureChunks carc;
    
    if (bHidden)
      return;
   if (realcarcass==class'NaliCarcass'||realcarcass==class'SkaarjCarcass'||realcarcass==class'TrooperCarcass')
    carc = Spawn(class 'olCreatureChunks');
else if ( realcarcass.default.bodyparts[0] != None )
       carc = Spawn(class 'olCreatureChunks',,, Location + realcarcass.default.ZOffset[0] * CollisionHeight * vect(0,0,1));
    if (carc != None)
    {
      if (realcarcass!=class'NaliCarcass'&&realcarcass!=class'SkaarjCarcass'&&realcarcass!=class'TrooperCarcass'){
      carc.TrailSize = realcarcass.default.Trails[0];
      carc.Mesh = realcarcass.default.bodyparts[0];}
      carc.bMasterChunk = true;
      carc.CarcassClass=realcarcass; //set my static to this.
      carc.Initfor(self);
      carc.Bugs = Bugs;
      if ( Bugs != None )
        Bugs.SetBase(carc);
      Bugs = None;
    }
    else if ( Bugs != None )
      Bugs.Destroy();
  }
  function GibSound()    //statics.
  {
    local float decision;

    decision = FRand();
    if (decision < 0.2)
      PlaySound(realcarcass.default.GibOne, SLOT_Interact, 0.06 * Mass);
    else if ( decision < 0.35 )
      PlaySound(realcarcass.default.GibTwo, SLOT_Interact, 0.06 * Mass);
    else if ( decision < 0.5 )
      PlaySound(sound'Gib3', SLOT_Interact, 0.06 * Mass);
    else if ( decision < 0.8 )
      PlaySound(sound'Gib4', SLOT_Interact, 0.06 * Mass);
    else 
      PlaySound(sound'Gib5', SLOT_Interact, 0.06 * Mass);
  }
  //crap for warlord:
  function AnimEnd()
{
  if (realcarcass!=class'WarlordCarcass'){
  super.animend();
  return;}
  if ( AnimSequence == 'Dead2A' )
  {
    if ( Physics == PHYS_None )
    {
      LieStill();
      PlayAnim('Dead2B', 0.7, 0.07);
    }
    else
      LoopAnim('Fall');
  } 
  else if ( Physics == PHYS_None )
    LieStill();
}
//some blood decal stuff
simulated function Landed(vector HitNormal)
{
  if (role==role_authority){ //I could do 1337 new net stuff, but nah..
  if (realcarcass==class'WarlordCarcass'){
  if ( AnimSequence == 'Fall' )
  {
    LieStill();
    PlayAnim('Dead2B', 0.7, 0.07);
  }
  SetPhysics(PHYS_None);
  }
  else if (realcarcass==class'tentacleCarcass'){
  if ( AnimSequence == 'Dead1')
    PlayAnim('Dead1Land', 1.5);
  SetPhysics(PHYS_None);
  LieStill();  }
  else
  super.landed(hitnormal); }//normal carcass
  if (level.netmode==nm_dedicatedserver||!class'spoldskool'.default.busedecals&&realcarcass==class'tentaclecarcass'||region.zone.bwaterzone)
  return;   //I can not see tentacles or water creatures having blood pools.
  if ( Pool == None){
    if (bGreenBlood)
    Pool = Spawn(class'GreenUTBloodPool2',,,Location, rotator(HitNormal)); //mercs get this :P
    else{
    class'olutBloodpool2'.default.drawscale=0.038*(collisionradius-4);   //change drawscale to match size
    Pool = Spawn(class'olUTBloodPool2',,,Location, rotator(HitNormal));
    class'olutBloodpool2'.default.drawscale=0.68;}} //reset
  else
    Spawn(class'olBloodSplat',,,Location, rotator(HitNormal + 0.5 * VRand()));
}
function LieStill(){
  super.LieStill();
  if (PermaCarcass){
    bdecorative=true;
    bstasis=true; //save mem
  }
}
function Drop(vector newVel) //only ever called on tentacle
{
  Velocity.X = 0;
  Velocity.Y = 0;
  SetPhysics(PHYS_Falling);
}


state Dead 
{
  function BeginState()
  {
   if ( bDecorative || bPermanent||PermaCarcass )
      lifespan = 0.0;
    else
    {
      if (realcarcass==class'WarlordCarcass')
        return;
      if ( Mover(Base) != None )
      {
        ExistTime = FMax(12.0, 30.0 - 2 * DeathZone.NumCarcasses);
        SetTimer(3.0, true);
      }
      else
        SetTimer(FMax(12.0, 30.0 - 2 * DeathZone.NumCarcasses), false); 
    }
  }
}

//BLOODDECALS:
function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, 
              Vector Momentum, name DamageType)
  {  
    local BloodSpurt b;
  
    b = Spawn(class'olBloodSpurt',,,HitLocation,rotator(Momentum));    //options can change.
    if ( bGreenBlood )
      b.GreenBlood();    
    if ( !bPermanent )
    {
      if ( (DamageType == 'Corroded') && (Damage >= 100) )
      {
        bCorroding = true;
        GotoState('Corroding');
      }
      else
        Super.TakeDamage(Damage, instigatedBy, HitLocation, Momentum, DamageType);
    }
  }

  simulated event destroyed(){
  if (pool!=none)
    pool.destroy();
  if ( !bDecorative&&!PermaCarcass )
      DeathZone.NumCarcasses--;
  super(Carcass).destroyed();
  }
defaultproperties
{
    PermaCarcass=True
}
