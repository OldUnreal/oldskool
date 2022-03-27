// ============================================================
// oldskool.sktrooper: da skaarj
// Psychic_313: DEPRECATED. DON'T USE ME.
// ============================================================

class SkTrooper expands skinsetclass;
//OMG!!!!!  The only converted model with CODE!!!!!!!!! :)
//sets the collision size to the Human one...

function prebeginplay(){               //sets the skaarj more humanlike
if (!(class'oldskool.skinconfiguration'.default.skaarjprop)&&Role == ROLE_Authority){
default.Drawscale=0.75;
default.jumpz=325.000000;
default.health=100;
default.Buoyancy=99.0;
default.baseeyeheight=27.000000;
default.EyeHeight=27.000000;
Drawscale=0.75;
jumpz=325.000000;
health=100;
Buoyancy=99.0;
baseeyeheight=27.000000;
EyeHeight=27.000000;
Setcollisionsize(17,39);
}
Super.PrebeginPlay();
}
simulated function WalkStep()
{
  local sound step;
  local float decision;
  
 /* if ( Role < ROLE_Authority )
    return;  */
  if ( FootRegion.Zone.bWaterZone )
  {
    PlaySound(sound 'LSplash', SLOT_Interact, 1, false, 1000.0, 1.0);
    return;
  }

  PlaySound(Footstep1, SLOT_Interact, 0.1, false, 800.0, 1.0);
}

simulated function RunStep()
{
  local sound step;
  local float decision;

  /*if ( Role < ROLE_Authority )
    return;  */
  if ( FootRegion.Zone.bWaterZone )
  {
    PlaySound(sound 'LSplash', SLOT_Interact, 1, false, 1000.0, 1.0);
    return;
  }

  PlaySound(Footstep1, SLOT_Interact, 0.7, false, 800.0, 1.0);
}

//-----------------------------------------------------------------------------
// Animation functions

function PlayDodge(eDodgeDir DodgeMove)
{
  Velocity.Z = 210;
  if ( DodgeMove == DODGE_Left )
    PlayAnim('LeftDodge', 1.35, 0.06);
  else if ( DodgeMove == DODGE_Right )
    PlayAnim('RightDodge', 1.35, 0.06);
  else if ( DodgeMove == DODGE_Forward )
    PlayAnim('Lunge', 1.2, 0.06);
  else
    PlayDuck();
}
    
function PlayTurning()
{
  BaseEyeHeight = Default.BaseEyeHeight;
  PlayAnim('Turn', 0.3, 0.3);
}

function TweenToWalking(float tweentime)
{
  BaseEyeHeight = Default.BaseEyeHeight;
  if (Weapon == None)
    TweenAnim('Walk', tweentime);
  else if ( Weapon.bPointing || (CarriedDecoration != None) ) 
    TweenAnim('WalkFire', tweentime);
  else
    TweenAnim('Walk', tweentime);
}

function TweenToRunning(float tweentime)
{
local vector X,Y,Z, Dir;
GetAxes(Rotation, X,Y,Z);
  Dir = Normal(Acceleration);
  BaseEyeHeight = Default.BaseEyeHeight;
  if (bIsWalking)
    TweenToWalking(0.1);
  else if (Weapon == None)
    PlayAnim('Jog', 1, tweentime);
  else if ( Weapon.bPointing ) 
    PlayAnim('JogFire', 1, tweentime);
  else
    PlayAnim('Jog', 1, tweentime);
if ( (Dir Dot X < 0.75) && (Dir != vect(0,0,0)) )
  {
    // strafing
    
    if ( Dir Dot X < -0.75 ){
       if ( Weapon.bPointing ) 
        LoopAnim('JogFire',1);
         if (!Weapon.bPointing)
        LoopAnim('Jog',1);}
    else if ( Dir Dot Y > 0 ){
      if ( Weapon.bPointing)
      PlayAnim('StrafeRightfr', 1.75, tweentime);
      else
      PlayAnim('StrafeRight', 1.75, tweentime);}
    else{
      if ( Weapon.bPointing)
      PlayAnim('StrafeLeftfr', 1.75, tweentime);
      else
      PlayAnim('StrafeLeft', 1.75, tweentime);}
  }
}

function PlayWalking()
{
  BaseEyeHeight = Default.BaseEyeHeight;
  if (Weapon == None)
    LoopAnim('Walk',1.1);
  else if ( Weapon.bPointing || (CarriedDecoration != None) ) 
    LoopAnim('WalkFire',1.1);
  else
    LoopAnim('Walk',1.1);
}

function PlayRunning()
{
local vector X,Y,Z, Dir;
  BaseEyeHeight = Default.BaseEyeHeight;
  GetAxes(Rotation, X,Y,Z);
  Dir = Normal(Acceleration);

   if ( Weapon.bPointing ) 
    LoopAnim('JogFire',1.1);
   else
    LoopAnim('Jog',1.1);
if ( (Dir Dot X < 0.75) && (Dir != vect(0,0,0)) )
  {
    // strafing 
    if ( Dir Dot X < -0.75 ){
    if ( Weapon.bPointing ) 
      LoopAnim('JogFire',-1.0/GroundSpeed,, 0.5);
       if (!Weapon.bPointing)
      LoopAnim('Jog',-1.0/GroundSpeed,, 0.5);}
    else if ( Dir Dot Y > 0 ){
      if ( Weapon.bPointing)
      LoopAnim('StrafeRightfr',-2.5/GroundSpeed,0.1, 1.0);
      else
      LoopAnim('StrafeRight',-2.5/GroundSpeed,0.1, 1.0);}
    else{
      if ( Weapon.bPointing)
      LoopAnim('StrafeLeftfr',-2.5/GroundSpeed,0.1, 1.0);
      else
      LoopAnim('StrafeLeft',-2.5/GroundSpeed,0.1, 1.0);}
  }
}

function PlayRising()
{
  BaseEyeHeight = 0.4 * Default.BaseEyeHeight;
  PlayAnim('Getup', 0.7, 0.1);
}

function PlayFeignDeath()
{
  BaseEyeHeight = 0;
  PlayAnim('Death2',0.7);
}

function PlayDying(name DamageType, vector HitLoc)
{
  local carcass carc;
  local vector X,Y,Z, HitVec, HitVec2D;
  local float dotp;

  BaseEyeHeight = Default.BaseEyeHeight;
  PlayDyingSound();
      
  if ( FRand() < 0.15 )
  {
    PlayAnim('Death',0.7,0.1);
    return;
  }

  // check for big hit
  if ( (Velocity.Z > 250) && (FRand() < 0.7) )
  {
    PlayAnim('Death2', 0.7, 0.1);
    carc = Spawn(class 'CreatureChunks',,, Location + CollisionHeight * vect(0,0,0.8), Rotation + rot(3000,0,16384) );
    if (carc != None)
    {
      carc.Mesh = mesh'SkaarjHead';
      carc.Initfor(self);
      carc.Velocity = Velocity + VSize(Velocity) * VRand();
      carc.Velocity.Z = FMax(carc.Velocity.Z, Velocity.Z);
      ViewTarget = carc;
    }
    return;
    
  }

  // check for head hit
  if ( ((DamageType == 'Decapitated') || (HitLoc.Z - Location.Z > 0.6 * CollisionHeight) )&& !Level.Game.bVeryLowGore )
  {
    DamageType = 'Decapitated';
    PlayAnim('Death5', 0.7, 0.1);
    carc = Spawn(class 'CreatureChunks',,, Location + CollisionHeight * vect(0,0,0.8), Rotation + rot(3000,0,16384) );
    if (carc != None)
    {
      carc.Mesh = mesh'SkaarjHead';
      carc.Initfor(self);
      carc.Velocity = Velocity + VSize(Velocity) * VRand();
      carc.Velocity.Z = FMax(carc.Velocity.Z, Velocity.Z);
      ViewTarget = carc;
    }
    return;
  }

  
  if ( FRand() < 0.15)
  {
    PlayAnim('Death3', 0.7, 0.1);
    return;
  }

  GetAxes(Rotation,X,Y,Z);
  X.Z = 0;
  HitVec = Normal(HitLoc - Location);
  HitVec2D= HitVec;
  HitVec2D.Z = 0;
  dotp = HitVec2D dot X;
  
  if (Abs(dotp) > 0.71) //then hit in front or back
    PlayAnim('Death3', 0.7, 0.1);
  else
  {
    dotp = HitVec dot Y;
    if (dotp > 0.0)
      PlayAnim('Death', 0.7, 0.1);
    else
      PlayAnim('Death4', 0.7, 0.1);
  }
}

//FIXME - add death first frames as alternate takehit anims!!!

function PlayGutHit(float tweentime)
{
  if ( AnimSequence == 'GutHit' )
  {
    if (FRand() < 0.5)
      TweenAnim('LeftHit', tweentime);
    else
      TweenAnim('RightHit', tweentime);
  }
  else
    TweenAnim('GutHit', tweentime);
}

function PlayHeadHit(float tweentime)
{
  if ( AnimSequence == 'HeadHit' )
    TweenAnim('GutHit', tweentime);
  else
    TweenAnim('HeadHit', tweentime);
}

function PlayLeftHit(float tweentime)
{
  if ( AnimSequence == 'LeftHit' )
    TweenAnim('GutHit', tweentime);
  else
    TweenAnim('LeftHit', tweentime);
}

function PlayRightHit(float tweentime)
{
  if ( AnimSequence == 'RightHit' )
    TweenAnim('GutHit', tweentime);
  else
    TweenAnim('RightHit', tweentime);
}
  
function PlayLanded(float impactVel)
  {  
    impactVel = impactVel/JumpZ;
    impactVel = 0.1 * impactVel * impactVel;
    BaseEyeHeight = Default.BaseEyeHeight;

    if ( Role == ROLE_Authority )
    {
      if ( impactVel > 0.17 )
        PlaySound(LandGrunt, SLOT_Talk, FMin(5, 5 * impactVel),false,1200,FRand()*0.4+0.8);
      if ( !FootRegion.Zone.bWaterZone && (impactVel > 0.01) )
        PlaySound(Land, SLOT_Interact, FClamp(4.5 * impactVel,0.5,6), false, 1000, 1.0);
    }

    if ( (GetAnimGroup(AnimSequence) == 'Dodge') && IsAnimating() )
      return;
    if ( (impactVel > 0.06) || (GetAnimGroup(AnimSequence) == 'Jumping') )
      TweenAnim('Land', 0.12);
    else if ( !IsAnimating() )
    {
      if ( GetAnimGroup(AnimSequence) == 'TakeHit' )
        AnimEnd();
      else
        TweenAnim('Land', 0.12);
    }
  }
  
function PlayInAir()
{
  BaseEyeHeight =  Default.BaseEyeHeight;
  TweenAnim('InAir', 0.4);
}

function PlayDuck()
{
  BaseEyeHeight = 0;
  TweenAnim('Duck', 0.25);
}

function PlayCrawling()
{
  BaseEyeHeight = 0;
  LoopAnim('DuckWalk');
}

function TweenToWaiting(float tweentime)
{
  if( IsInState('PlayerSwimming') || Physics==PHYS_Swimming )
  {
    BaseEyeHeight = 0.7 * Default.BaseEyeHeight;
    TweenAnim('Swim', tweentime);
  }
  else
  {
    BaseEyeHeight = Default.BaseEyeHeight;
    TweenAnim('Firing', tweentime);
  }
}
  
function PlayWaiting()
{
  local name newAnim;

if ( bIsTyping )
  {
    PlayChatting();
    return;
  }
  if( IsInState('PlayerSwimming') || (Physics==PHYS_Swimming) )
  {
    BaseEyeHeight = 0.7 * Default.BaseEyeHeight;
    LoopAnim('Swim');
  }
  else
  {  
    BaseEyeHeight = Default.BaseEyeHeight;
    if ( (Weapon != None) && Weapon.bPointing )
      TweenAnim('Firing', 0.3);
    else
    {
      if ( FRand() < 0.2 )
        newAnim = 'Breath';
      else
        newAnim = 'Breath2';
      
      if ( AnimSequence == newAnim )
        LoopAnim(newAnim, 0.3 + 0.7 * FRand());
      else
        PlayAnim(newAnim, 0.3 + 0.7 * FRand(), 0.25);
    }
  }


}  

function Playchatting (){

Loopanim ('shield');
}




function PlayFiring()
{
  // switch animation sequence mid-stream if needed
  if (AnimSequence == 'Jog')
    AnimSequence = 'JogFire';
  else if (AnimSequence == 'Walk')
    AnimSequence = 'WalkFire';
  else if ( AnimSequence == 'InAir' )
    TweenAnim('JogFire', 0.03);
  else if ( (GetAnimGroup(AnimSequence) != 'Attack')
      && (GetAnimGroup(AnimSequence) != 'MovingAttack') 
      && (GetAnimGroup(AnimSequence) != 'Dodge')
      && (AnimSequence != 'Swim') )
    TweenAnim('Firing', 0.02);
}

function PlayWeaponSwitch(Weapon NewWeapon)
{
}

function PlaySwimming()
{
  BaseEyeHeight = 0.7 * Default.BaseEyeHeight;
  LoopAnim('Swim');
}

function TweenToSwimming(float tweentime)
{
  BaseEyeHeight = 0.7 * Default.BaseEyeHeight;
  TweenAnim('Swim',tweentime);
}

function SwimAnimUpdate(bool bNotForward)
{
  if ( !bAnimTransition && (GetAnimGroup(AnimSequence) != 'Gesture') && (AnimSequence != 'Swim') )
    TweenToSwimming(0.1);
}

defaultproperties
{
    DefaultTalkTexture="sktrooperskiny.skar5"
    TeamSkin="sktrooperskiny.skaa1"
    bpartialteam=True
    altpackage="sktrooperskins."
    Deaths(2)=Sound'UnrealI.Skaarj.SKPDeath2'
    Deaths(3)=Sound'UnrealI.Skaarj.SKPDeath3'
    Deaths(4)=Sound'UnrealI.Skaarj.SKPDeath3'
    DefaultSkinName="sktrooperskiny.skaarj"
    DefaultPackage="sktrooperskiny."
    drown=Sound'UnrealI.Skaarj.SKPDrown1'
    breathagain=Sound'UnrealI.Skaarj.SKPGasp1'
    Footstep1=Sound'UnrealShare.Cow.walkC'
    Footstep2=Sound'UnrealShare.Cow.walkC'
    Footstep3=Sound'UnrealShare.Cow.walkC'
    HitSound3=Sound'UnrealI.Skaarj.SKPInjur3'
    HitSound4=Sound'UnrealI.Skaarj.SKPInjur4'
    GaspSound=Sound'UnrealI.Skaarj.SKPGasp1'
    UWHit1=Sound'UnrealShare.Male.MUWHit1'
    UWHit2=Sound'UnrealShare.Male.MUWHit2'
    LandGrunt=Sound'UnrealI.Skaarj.Land1SK'
    VoicePackMetaClass="BotPack.VoiceMale"
    CarcassType=Class'troopercarcass2'
    JumpSound=Sound'UnrealI.Skaarj.SKPJump1'
    JumpZ=360.00
    BaseEyeHeight=24.75
    EyeHeight=24.75
    Health=130
    SelectionMesh="UnrealI.sktrooper"
    SpecialMesh="Botpack.TrophyBoss"
    HitSound1=Sound'UnrealI.Skaarj.SKPInjur1'
    HitSound2=Sound'UnrealI.Skaarj.SKPInjur2'
    Die=Sound'UnrealI.Skaarj.SKPDeath1'
    MenuName="SkTrooper"
    VoiceType="multimesh.skaarjvoice"
    Mesh=LodMesh'UnrealI.sktrooper'
    CollisionRadius=32.00
    CollisionHeight=42.00
    Buoyancy=118.80
}
