// ============================================================
// oldskool.SinglePlayer2: duel sp and vortex rikers.... mutator handles the big stuff.....
// ============================================================

class SinglePlayer2 extends UnrealGameInfo;
//tourney tele effects
var float LastTauntTime;
var    int        LastTaunt[4]; //taunt holder.....
var bool spectateallowed;
var bool bloadingsave; //is a save loaded? based on state before player possession
var config bool SpTaunts;   //taunts/headshots?
var config bool Pause; //load save as pausing?
function float PlaySpawnEffect(inventory Inv)              //note to self: save this for co-op.....
{
  spawn( class 'EnhancedReSpawn',Inv,, Inv.Location );
  return 0.3;
}
function bool CanSpectate( pawn Viewer, actor ViewTarget )              //blockz spectating unless cheat is activated...
{
  return (spectateallowed || Viewer.PlayerReplicationInfo.bIsSpectator);
}
function PreCacheReferences()
{
  //never called - here to force precaching of meshes
  spawn(class'olweapons.olautomag');
  spawn(class'olweapons.oldpistol');
  spawn(class'olweapons.oleightball');
  spawn(class'olweapons.olflakcannon');
  spawn(class'olweapons.olrazorjack');
  spawn(class'olweapons.olasmd');
  spawn(class'olweapons.olgesbiorifle');
  spawn(class'olweapons.olrifle');
  spawn(class'olweapons.olminigun');
}
function RegisterDamageMutator(Mutator M) //never change OSA 3 SP oldskool as top mutator.
{
  if (spoldskool(m)!=none)
    damagemutator=m; //always spawned fist.
  else{
    M.NextDamageMutator = Damagemutator.nextDamageMutator;
    Damagemutator.nextDamageMutator = M;
  }
}
function PlayTeleportEffect( actor Incoming, bool bOut, bool bSound)     //Ut tele effect.....
{
   local UTTeleportEffect PTE;

  if ( Incoming.bIsPawn && (Incoming.Mesh != None)&& (Level.DefaultGameType != class'endgame'))
  {
    if ( bSound )
    {
       PTE = Spawn(class'UTTeleportEffect',,, Incoming.Location, Incoming.Rotation);
       PTE.Initialize(Pawn(Incoming), bOut);
      Incoming.PlaySound(sound'Resp2A',, 10.0);
    }
  }
}

function Killed(pawn killer, pawn Other, name damageType)
{
  local inventory scoreholder;
  local int NextTaunt, i;
  local bool bAutoTaunt;
  if ( (damageType == 'Decapitated') && (Killer != Other) && (Killer != None) &&(Killer.isa('playerpawn')) && SpTaunts)       //play headshot thingy :D
    Killer.ReceiveLocalizedMessage( class'DecapitationMessage' );
  super.Killed(killer, Other, damageType);
  bAutoTaunt = (SPTaunts&&Killer.isa('tournamentplayer'));     //stupid auto taunting
  if (bAutoTaunt
    && (Killer != Other) && (DamageType != 'gibbed') && (Killer.Health > 0)
    && (Level.TimeSeconds - LastTauntTime > 3) )
  {
    LastTauntTime = Level.TimeSeconds;
    NextTaunt = Rand(class<ChallengeVoicePack>(Killer.PlayerReplicationInfo.VoiceType).Default.NumTaunts);
    for ( i=0; i<4; i++ )                                   //keeps taunts unique.....
    {
      if ( NextTaunt == LastTaunt[i] )
        NextTaunt = Rand(class<ChallengeVoicePack>(Killer.PlayerReplicationInfo.VoiceType).Default.NumTaunts);
      if ( i > 0 )
        LastTaunt[i-1] = LastTaunt[i];
    }  
    LastTaunt[3] = NextTaunt;
   killer.SendGlobalMessage(None, 'AUTOTAUNT', NextTaunt, 5);
  }
  if ( killer.IsA('PlayerPawn') )
  {
    scoreholder = PlayerPawn(killer).FindInventoryType(class 'scorekeeper');
    scorekeeper(scoreholder).scoreit(Other);
  }
}
   //can't super.  all this does is stop the scorekeeper from being destroyed......
function DiscardInventory(Pawn Other)
{
  local actor dropped;
  local inventory Inv;
  local weapon weap;
  local float speed;

  if ( Other.Weapon != None )
    Other.Weapon.PickupViewScale *= 0.7;
  if( Other.DropWhenKilled != None )
  {
    dropped = Spawn(Other.DropWhenKilled,,,Other.Location);
    Inv = Inventory(dropped);
    if ( Inv != None )
    { 
      Inv.RespawnTime = 0.0; //don't respawn
      Inv.BecomePickup();    
    }
    if ( dropped != None )
    {
      dropped.RemoteRole = ROLE_DumbProxy;
      dropped.SetPhysics(PHYS_Falling);
      dropped.bCollideWorld = true;
      dropped.Velocity = Other.Velocity + VRand() * 280;
    }
    if ( Inv != None )
      Inv.GotoState('PickUp', 'Dropped');
  }          
  if( (Other.Weapon!=None) && (Other.Weapon.Class!=Level.Game.BaseMutator.MutatedDefaultWeapon()) 
    && Other.Weapon.bCanThrow )
  {
    speed = VSize(Other.Velocity);
    weap = Other.Weapon;
    if (speed != 0)
      weap.Velocity = Normal(Other.Velocity/speed + 0.5 * VRand()) * (speed + 280);
    else {
      weap.Velocity.X = 0;
      weap.Velocity.Y = 0;
      weap.Velocity.Z = 0;
    }
    Other.TossWeapon();
    if ( weap.PickupAmmoCount == 0 )
      weap.PickupAmmoCount = 1;
  }
  Other.Weapon = None;
  Other.SelectedItem = None;  
  for( Inv=Other.Inventory; Inv!=None; Inv=Inv.Inventory )
    {
    if ( !Inv.IsA('scorekeeper') )
    Inv.Destroy();}

}

function AddDefaultInventory(pawn PlayerPawn )
{
// @@@ Psychic_313: be kind and give them a translator too?
// I've commented it out here
// (copied from CoOpGame2)

  local Translator newTranslator;

local scorekeeper scoreholder;
if ( Level.DefaultGameType != class'VRikersGame' )
Super.AddDefaultInventory(PlayerPawn);       //add the pistol if not vrkersgame....
if ( playerpawn.IsA('Spectator')
    || playerpawn.FindInventoryType(class'scorekeeper') != None )
    return;
  scoreholder = Spawn(class'scorekeeper',,, Location);
  scoreholder.bHeldItem = true;
  scoreholder.GiveTo(playerpawn);
/* Psychic_313: add this?
  // Spawn translator.
  if( PlayerPawn.IsA('Spectator') || PlayerPawn.FindInventoryType(class'Translator') != None )
    return;
  newTranslator = Spawn(class'Translator',,, Location);
  if( newTranslator != None )
  {
    newTranslator.bHeldItem = true;
    newTranslator.GiveTo( PlayerPawn );
    PlayerPawn.SelectedItem = newTranslator;
    newTranslator.PickupFunction(PlayerPawn);
  }
*/
}
event playerpawn Login
(
  string Portal,
  string Options,
  out string Error,
  class<playerpawn> SpawnClass
)
{
  local PlayerPawn NewPlayer;
  local string InVoice;
  if ( ClassIsChildOf(SpawnClass, class'Spectator') )
    {
      if ( !ClassIsChildOf( SpawnClass, class'chSpectator')&&!classischildof(spawnclass,class'messagingspectator' ))    //force unreal spectator....   (fix me!)
        SpawnClass = class'chSpectator';
    }
/* Psychic_313: changed to remove potential OldModels dependency
  else if ( !ClassIsChildOf(SpawnClass, class'TournamentPlayer') || Left(string(spawnclass),6) ~= "u4etc."|| ClassIsChildOf(SpawnClass, class'oldskool.sktrooper'))         //don't allow U4E or sktrooperz*/
  else if ( !ClassIsChildOf(SpawnClass, class'TournamentPlayer') || ((Left(string(spawnclass),6) ~= "u4etc."|| SpawnClass.default.Mesh==LodMesh'UnrealI.sktrooper')&&bhumansonly) || !SpawnClass.default.bSinglePlayer)         //don't allow U4E or sktrooperz, unless hacked so bhumansonly=false
  SpawnClass = DefaultPlayerClass;

  NewPlayer = Super.Login(Portal, Options, Error, SpawnClass);
  //if (!newplayer.isinstate('invalidstate'))
  //bLoadingSave=true;
  //HUD loadcheck.
  bloadingsave=(newplayer.myhud!=none);
  if ( NewPlayer != None )
  {
    if ( !NewPlayer.IsA('Spectator') )
    {
      InVoice = ParseOption ( Options, "Voice" );
      if ( InVoice != "" )
        NewPlayer.PlayerReplicationInfo.VoiceType = class<VoicePack>(DynamicLoadObject(InVoice, class'Class'));
      if ( NewPlayer.PlayerReplicationInfo.VoiceType == None )
        NewPlayer.PlayerReplicationInfo.VoiceType = class<VoicePack>(DynamicLoadObject(NewPlayer.VoiceType, class'Class'));
      if ( NewPlayer.PlayerReplicationInfo.VoiceType == None )
        NewPlayer.PlayerReplicationInfo.VoiceType = class<VoicePack>(DynamicLoadObject("Botpack.VoiceMaleOne", class'Class'));
    }
    else if (newplayer.isa('chspectator')){ //we have to swap the spectator's HUD
    newplayer.hudtype=class'oldskool.oldskoolspectatorhud';
    If (newplayer.myhud!=None) //if it is then the hudtype swap will fix it anyway :D
    newplayer.myhud.destroy();
     }
  }
  if ( (NewPlayer != None && Level.DefaultGameType == class'VRikersGame')
    && (NewPlayer.Health == NewPlayer.Default.Health)  )
  
{    NewPlayer.PlayerRestartState = 'PlayerWaking';
    NewPlayer.ViewRotation.Pitch = 16384;
    if (!bLoadingSave)  //save h4ck
    NewPlayer.Health = 12;
  }

  return NewPlayer;
}

event AcceptInventory(pawn PlayerPawn)       //allow mutator to analyze.......
{
  //default accept all inventory except default weapon (spawned explicitly)

  local inventory inv;
  local byte useless;

  if (level.title~="Ending Sequence"){//accept no inventory in this case
   for ( Inv=PlayerPawn.Inventory; Inv!=None; Inv=Inv.Inventory )
   if (!inv.isa('scorekeeper'))
    Inv.Destroy(); 
    return;
    }
  // Initialize the inventory.
  AddDefaultInventory( PlayerPawn );
  // analize........
  if (basemutator.isa('spoldskool')){
    spoldskool(BaseMutator).PropSetup=true;
    for ( Inv=PlayerPawn.Inventory; Inv!=None; Inv=Inv.Inventory )
      BaseMutator.IsRelevant(inv, useless);
    spoldskool(BaseMutator).PropSetup=false;
  }
  log( "All inventory from" @ PlayerPawn.PlayerReplicationInfo.PlayerName @ "is accepted" );
}
event PostLogin( playerpawn NewPlayer ){
//local PlayerPawn NewPlayer;
local Pawn P;
local spoldskool SP;
local mutator m;
local scorch d;
//save fix:
if (NewPlayer.player.IsA('WINDOWSVIEWPORT')){
  if (!(NewPlayer.ConsoleCommand("get core.system savepath")~="..\\save"))
     NewPlayer.ConsoleCommand("set core.system savepath ..\\Save");
}
else if (NewPlayer.player.IsA('MACVIEWPORT')){
  if (!(NewPlayer.ConsoleCommand("get core.system savepath")~=":save"))
     NewPlayer.ConsoleCommand("set core.system savepath :Save");
}


  if (class'spoldskool'.default.unair&&!(string(class)~="legacy.LegacySP")&&!IsA('tvsp')) //2.3 stuff
    NewPlayer.Aircontrol=class'pawn'.default.aircontrol;
  if (bloadingsave){  //do NOT set music when loading a save. (it is already set :P) only set fade to swap
    newplayer.Transition=MTRAN_FastFade;
  //saving property hacks to prevent messing up of options from saves (resets defaults).
    for (m=basemutator;m!=none;m=m.nextmutator)
      if (m.isa('spoldskool')){
        SP=Spoldskool(M);
        break;
      }
     NewPlayer.SetPause(Pause); //new in 2.3
     if (SP==none){
      log ("WARNING: no SP mutator!");
      return;
     }
    if (class'spoldskool'.default.PermaDecals) //find and reattach decals!
        foreach AllActors(class'scorch',D){
          D.Disable('destroyed'); //crash bug.
          if (D.IsA('directionalblast'))
            D.destroy(); //impossible to reattach
          else {
            D.attachtosurface();
            D.Enable('destroyed');
          }
         }
    if (!SP.NewVersion){ //old save. update options.
      SP.SetupCurrent();
      return;
    }
    SP.bBioRifle=SP.oBiorifle;
    SP.bASMD=SP.oASMD;
    SP.bStingy=SP.ostingy;
    SP.bRazor=SP.oRazor;
    SP.bFlak=SP.oFlak;
    SP.bmini=SP.omini;
    SP.bEball=SP.oEball;
    SP.bRifle=SP.oRifle;
    SP.bdamage=SP.odamage;
    SP.bpad=SP.opad;
    SP.barmor=SP.oarmor;
    SP.bmag=SP.omag;
    SP.bshield=SP.oshield;
    SP.SaveConfig();
    return;
  }
  // Start player's music.
  else If (Level.Song!=None)
    NewPlayer.ClientSetMusic( Level.Song, Level.SongSection, Level.CdTrack, MTRAN_Fade );
  else
    NewPlayer.ClientSetMusic( Music'olroot.null', 0, 0, MTRAN_Fade );

}

//OSA 2.25: redefault options on leaving level. (again changing levels in game would get b0rked.):
function SendPlayer( PlayerPawn aPlayer, string URL ){
local spoldskool SP;
local mutator m;
for (m=basemutator;m!=none;m=m.nextmutator)
  if (m.isa('spoldskool')){
     SP=Spoldskool(M);
     break;
   }
 if (SP==none)
   return;
  class'spoldskool'.default.bBioRifle=SP.oBiorifle;
  class'spoldskool'.default.bASMD=SP.oASMD;
   class'spoldskool'.default.bStingy=SP.ostingy;
   class'spoldskool'.default.bRazor=SP.oRazor;
   class'spoldskool'.default.bFlak=SP.oFlak;
   class'spoldskool'.default.bmini=SP.omini;
  class'spoldskool'.default.bEball=SP.oEball;
   class'spoldskool'.default.bRifle=SP.oRifle;
   class'spoldskool'.default.bdamage=SP.odamage;
   class'spoldskool'.default.bpad=SP.opad;
    class'spoldskool'.default.barmor=SP.oarmor;
   class'spoldskool'.default.bmag=SP.omag;
   class'spoldskool'.default.bshield=SP.oshield;
   class'spoldskool'.static.staticsaveconfig();
   aPlayer.ClientTravel( URL, TRAVEL_Relative, true );
}


//Psychic_313: changed default.DefaultPlayerClass to Tournament guy
//so players lacking OldModels aren't left out. Sorry, Dante fans :-)

defaultproperties
{
    SpTaunts=True
    Pause=True
    bHumansOnly=True
    DefaultPlayerClass=Class'botpack.TMale2'
    DefaultWeapon=Class'olweapons.OLDpistol'
    ScoreBoardType=Class'OldSkoolScoreBoard'
    MultiplayerUMenuType="UTMenu.UTMultiplayerMenu"
    HUDType=Class'oldskoolhud'
    GameName="Single Player"
    MutatorClass=Class'spoldskool'
}
