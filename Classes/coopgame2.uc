// ============================================================
// coopgame2.the new co-operative mode....
// Psychic_313: changed login to be a little less hard-coded
// (checks mesh name and bSinglePlayer instead of requiring
// that SkTrooper is still in OldSkool.u, which it isn't)
// [yes, I know it's still there... shhh]
// ============================================================

class coopgame2 expands UnrealGameInfo;

var() config float  friendlyfirescale;    //changed the no friendly fire to this....
var bool  bSpecialFallDamage;
var float LastTauntTime;
var    int        LastTaunt[4]; //taunt holder.....
var config bool baddiespectate;

function PostBeginPlay()
{
  Super.PostBeginPlay();

  bClassicDeathMessages = True;
}
function bool CanSpectate( pawn Viewer, actor ViewTarget ){
if ( ViewTarget.bIsPawn && (Pawn(ViewTarget).PlayerReplicationInfo != None)
    && Pawn(ViewTarget).PlayerReplicationInfo.bIsSpectator )
    return false;
if (viewtarget.bIsPawn && !Pawn(Viewtarget).bisplayer )      //only spectate baddies if server allows this...
  return baddiespectate;
if (Viewtarget.bispawn)
  return true;
return false;
}
function bool IsRelevant(actor Other)
{
  // hide all playerpawns     (these are incoming ones...)

  if ( Other.IsA('PlayerPawn') && !Other.IsA('Spectator') )
  {
    Other.SetCollision(false,false,false);
    Other.bHidden = true;
  }
  return Super.IsRelevant(Other);
}

event PostLogin( playerpawn NewPlayer ){
//local PlayerPawn NewPlayer;
local Pawn P;
  // Start player's music.
  If (Level.Song!=None)
  NewPlayer.ClientSetMusic( Level.Song, Level.SongSection, Level.CdTrack, MTRAN_Fade );
  else {
  NewPlayer.ClientSetMusic( Music'olroot.null', 0, 0, MTRAN_Fade );   }      //no music.....
  if (class'spoldskool'.default.unair&&string(class)!="olextras.tvcoop")
    NewPlayer.Aircontrol=class'pawn'.default.aircontrol;
}
function float PlaySpawnEffect(inventory Inv)
{
  Playsound(sound'RespawnSound');
  if ( !bCoopWeaponMode || !Inv.IsA('Weapon') )
  {
    spawn( class 'ReSpawn',,, Inv.Location );
    return 0.3;
  }
  return 0.0;
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

function PlayTeleportEffect( actor Incoming, bool bOut, bool bSound)     //Ut tele effect.....
{
   local UTTeleportEffect PTE;

  if ( Incoming.bIsPawn && (Incoming.Mesh != None) )
  {
    if ( bSound )
    {
       PTE = Spawn(class'UTTeleportEffect',,, Incoming.Location, Incoming.Rotation);
       PTE.Initialize(Pawn(Incoming), bOut);
      Incoming.PlaySound(sound'Resp2A',, 10.0);
    }
  }
}
event playerpawn Login
(
  string Portal,
  string Options,
  out string Error,
  class<playerpawn> SpawnClass
)
{
  local PlayerPawn      NewPlayer;
  local string InVoice;
  local string          InName, InPassword;
  local pawn        aPawn;
  if ( ClassIsChildOf(SpawnClass, class'Spectator') )
    {
      if ( !ClassIsChildOf( SpawnClass, class'unrealSpectator') )    //force unreal spectator....
        SpawnClass = class'unrealSpectator';
    }
/*Psychic_313  else if ( !ClassIsChildOf(SpawnClass, class'TournamentPlayer') || Left(string(spawnclass),6) ~= "u4etc."|| ClassIsChildOf(SpawnClass, class'oldskool.sktrooper'))*/         
  else if ( !ClassIsChildOf(SpawnClass, class'TournamentPlayer') || Left(string(spawnclass),6) ~= "u4etc."|| SpawnClass.default.Mesh==LodMesh'UnrealI.SkTrooper' || !SpawnClass.default.bSinglePlayer )
//taken from tournamentgameinfo
  SpawnClass = DefaultPlayerClass;
  NewPlayer =  Super.Login(Portal, Options, Error, SpawnClass);
  if ( NewPlayer != None )
  {
    if ( !NewPlayer.IsA('Spectator') )
    {
      NewPlayer.bHidden = false;
      NewPlayer.SetCollision(true,true,true);
      InVoice = ParseOption ( Options, "Voice" );
      if ( InVoice != "" )
        NewPlayer.PlayerReplicationInfo.VoiceType = class<VoicePack>(DynamicLoadObject(InVoice, class'Class'));
      if ( NewPlayer.PlayerReplicationInfo.VoiceType == None )
        NewPlayer.PlayerReplicationInfo.VoiceType = class<VoicePack>(DynamicLoadObject(NewPlayer.VoiceType, class'Class'));
      if ( NewPlayer.PlayerReplicationInfo.VoiceType == None )
        NewPlayer.PlayerReplicationInfo.VoiceType = class<VoicePack>(DynamicLoadObject("Botpack.VoiceMaleOne", class'Class'));
    }
        else{ //we have to swap the spectator's HUD
    newplayer.hudtype=class'oldskool.oldskoolspectatorhud';
    If (newplayer.myhud!=None) //if it is none then the hudtype swap will fix it anyway :D
    newplayer.myhud.destroy();
    newplayer.myhud=none; }
    log("Logging in to "$Level.Title);
    if ( Level.Title ~= "The Source Antechamber" )          //level h4ck...
    {
      bSpecialFallDamage = true;
      log("reduce fall damage");
    }
  }
  return NewPlayer;
}
  
function NavigationPoint FindPlayerStart( Pawn Player, optional byte InTeam, optional string incomingName )
{
  local PlayerStart Dest, Candidate[8], Best;
  local float Score[8], BestScore, NextDist;
  local pawn OtherPlayer;
  local int i, num;
  local Teleporter Tel;

  num = 0;
  //choose candidates  
  foreach AllActors( class 'PlayerStart', Dest )
  {
    if ( (Dest.bSinglePlayerStart || Dest.bCoopStart) && !Dest.Region.Zone.bWaterZone )
    {
      if (num<4)
        Candidate[num] = Dest;
      else if (Rand(num) < 4)
        Candidate[Rand(4)] = Dest;
      num++;
    }
  }
  
  if (num>4) num = 4;
  else if (num == 0)
    return None;
    
  //assess candidates
  for (i=0;i<num;i++)
    Score[i] = 4000 * FRand(); //randomize
    
  foreach AllActors( class 'Pawn', OtherPlayer )
  {
    if (OtherPlayer.bIsPlayer)
    {
      for (i=0;i<num;i++)
      {
        NextDist = VSize(OtherPlayer.Location - Candidate[i].Location);
        Score[i] += NextDist;
        if (NextDist < OtherPlayer.CollisionRadius + OtherPlayer.CollisionHeight)
          Score[i] -= 1000000.0;
      }
    }
  }
  
  BestScore = Score[0];
  Best = Candidate[0];
  for (i=1;i<num;i++)
  {
    if (Score[i] > BestScore)
    {
      BestScore = Score[i];
      Best = Candidate[i];
    }
  }      
        
  return Best;
}

function int ReduceDamage(int Damage, name DamageType, pawn injured, pawn instigatedBy)
{
if( injured.Region.Zone.bNeutralZone )
    return 0;
     
   if ( instigatedBy == None )
    return Damage;

  if ( instigatedBy.bIsPlayer && injured.bIsPlayer && (instigatedBy != injured) )
    return Damage*friendlyfirescale;

  if ( (DamageType == 'Fell') && bSpecialFallDamage )
    return Min(Damage, 5);

  return Damage;
}

function bool ShouldRespawn(Actor Other)
{
  if ( Other.IsA('Weapon') && !Weapon(Other).bHeldItem && (Weapon(Other).ReSpawnTime != 0) )
  {
    Inventory(Other).ReSpawnTime = 1.0;
    return true;
  }
  return false;
}

function SendPlayer( PlayerPawn aPlayer, string URL )
{
  // hack to skip end game in coop play
  if ( left(URL,7) ~= "endgame")
  {
    Level.ServerTravel( "Vortex2", false);
    return;
  }

  Level.ServerTravel( URL, true );
}

function ScoreKill(pawn Killer, pawn Other)    //make use of sp rules....
{
  local int points, intlevel;
  Other.DieCount++;
  if( (killer == Other) || (killer == None) )
    Other.PlayerReplicationInfo.Score -= 79;
  else if ( killer != None )
  {
    switch (Other.intelligence){               //AI figure-outer.....
    Case Brains_None:
    intlevel=0;
    break;
    Case Brains_Reptile:
    intlevel=1;
    break;
    Case Brains_Mammal:
    intlevel=2;
    break;
    Case Brains_Human:
    intlevel=3;
    break;  }
    points = int(10*((other.skill/2) + 1)*(other.default.health/150)+intlevel/1.5); //calculated by difficulty (major), health (slightly less important) and AI (tiny difference)
    If (points<8) points=8; //force to at least give 8 points.
    If (Other.bIsPlayer)
    Points=-84; //idiot.....
    else if (Other.IsA('Nali'))
    Points=-32;
    else if (Other.IsA('nalirabbit'))  points= -4;
    else if (Other.IsA('bird1'))  points= -7;
    else if (Other.IsA('cow')) points= -10;
    if (Other.IsA('ScriptedPawn'))
      if (ScriptedPawn(Other).bIsBoss) points *=3;
    killer.killCount++;
    if ( killer.PlayerReplicationInfo != None )
      killer.PlayerReplicationInfo.Score += points;
  }

  BaseMutator.ScoreKill(Killer, Other);
}
function Killed(pawn killer, pawn Other, name damageType)      //taunts....
{
  local int NextTaunt, i;
  local bool bAutoTaunt;
  if ( (damageType == 'Decapitated') && (Killer != Other) && (Killer != None) &&(TournamentPlayer(Killer) != None) && TournamentPlayer(Killer).bAutoTaunt)       //play headshot thingy :D
  Killer.ReceiveLocalizedMessage( class'DecapitationMessage' );
  super.Killed(killer, Other, damageType);
  bAutoTaunt = ((TournamentPlayer(Killer) != None) && TournamentPlayer(Killer).bAutoTaunt);     //stupid auto taunting
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
}

function AddDefaultInventory( pawn PlayerPawn )
{
  local Translator newTranslator;

  if ( Level.DefaultGameType != class'VRikersGame' ) 
    Super.AddDefaultInventory(PlayerPawn);

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
}


//Psychic_313: changed default.DefaultPlayerClass to Tournament guy
//so players lacking OldModels aren't left out. Sorry, Dante fans :-)

defaultproperties
{
    bHumansOnly=True
    bRestartLevel=False
    bPauseable=False
    bCoopWeaponMode=True
    DefaultPlayerClass=Class'botpack.TMale2'
    DefaultWeapon=Class'olweapons.OLDpistol'
    ScoreBoardType=Class'UnrealShare.UnrealScoreBoard'
    GameMenuType=Class'UnrealShare.UnrealCoopGameOptions'
    RulesMenuType="UMenu.UMenuCoopGameRulesSClient"
    SettingsMenuType="UMenu.UMenuCoopGameRulesSClient"
    MultiplayerUMenuType="UTMenu.UTMultiplayerMenu"
    HUDType=Class'coopHUD'
    BeaconName="Coop"
    GameName="Coop Game"
    MutatorClass=Class'spoldskool'
}
