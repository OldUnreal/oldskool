// ============================================================
// DEPRECATED: here for compatibility only
// Will only appear when loaded from old saves
// -- Psychic_313
// ============================================================

class OSWeaponPowerUp expands tournamentpickup;
var float idletime;                //unused now
var oldskool mastermutator;    //unused now, this never appears in DM
var bool doswap;
var Sound PowerUpSounds[4];
/*wipe from here!
function prebeginplay(){
super.prebeginplay();
if ( class'oldskool.oldskool'.default.poweruptime==0)
disable('tick'); //don't tick or it'll crash :D
}

function Destroyed()
{
  if (Level.Game.Isa('deathmatchplus')&&(Mastermutator != None)&&(mastermutator.bpowerups)&&doswap){ //verify that we do want to call the function....
    mastermutator.Spawnpowerup(0);
   }
   Super.Destroyed();
}

function Tick(float deltatime)                 //only actually set from the mutator so nothing to worry about here......
{
 if (Owner == None&&mastermutator!=none&&mastermutator.poweruptime!=0&&doswap)
  {
    IdleTime += deltatime;
    if ( IdleTime >= mastermutator.poweruptime )
    {
      IdleTime = 0;
      Spawn(class'osringexplosion2', self,, self.Location, self.Rotation); //uses asmd blast..
      Destroy();
    }
  }
}
//to here
               */
event float BotDesireability( pawn Bot )
{
  local OLDPistol D;

  D = OlDPistol(Bot.FindInventoryType(class'olDPistol'));
  if ( (D == None) || (D.PowerLevel >=4) )
    return -1;
  else 
    return Super.BotDesireability(Bot);
}

auto state Pickup
{
  function BeginState()
  {
    BecomePickup();
    SetOwner(None);
    LoopAnim('AnimEnergy',0.4);
    bCollideWorld = true;   
    //check that no idle stuff....
  }
  function Touch( actor Other )
  {
    local olDPistol d;
    local Inventory Copy;

    if ( Pawn(Other)!=None && Pawn(Other).bIsPlayer)
    {
       d = olDPistol(Pawn(Other).FindInventoryType(class'olDPistol'));
      if ( (d != None) && (d.PowerLevel < 4) ){
      Disable('tick');
      IdleTime = 0;
      ActivateSound = PowerUpSounds[d.PowerLevel];
   Level.Game.PickupQuery(Pawn(Other), Self);
        if (Level.Game.LocalLog != None)
        Level.Game.LocalLog.LogPickup(Self, Pawn(Other));
      if (Level.Game.WorldLog != None)
        Level.Game.WorldLog.LogPickup(Self, Pawn(Other));
      if ( PickupMessageClass == None)
        Pawn(Other).ClientMessage(PickupMessage, 'Pickup');
      else
        Pawn(Other).ReceiveLocalizedMessage( PickupMessageClass, 0, None, None, Self.Class );
        }
    }
  }

}

defaultproperties
{
    PowerUpSounds(0)=Sound'UnrealShare.Dispersion.number1'
    PowerUpSounds(1)=Sound'UnrealShare.Dispersion.number2'
    PowerUpSounds(2)=Sound'UnrealShare.Dispersion.number3'
    PowerUpSounds(3)=Sound'UnrealShare.Dispersion.number4'
    PickupMessage="You got the Dispersion Pistol Powerup"
    RespawnTime=30.00
    PickupViewMesh=Mesh'UnrealShare.WeaponPowerUpMesh'
    AnimSequence=AnimEnergy
    Mesh=Mesh'UnrealShare.WeaponPowerUpMesh'
    CollisionRadius=12.00
}
