// ============================================================
// oldskool.spoldskool: base mutator for singleplayer2
// Psychic_313: mostly unchanged
// ============================================================

class spoldskool expands mutator
config(Oldskool);
//da pulse icon......
#exec TEXTURE IMPORT NAME=pulseicon FILE=Textures\pulseicon.pcx

var bool PropSetup; //no replacement
var config bool               //yawn....
    bmed,
    bBioRifle,
    bASMD,
    bStingy,
    bRazor,
    bFlak,
    bmini,
    bEball,
    bRifle,
    bjump,
    bdamage,
    bpad,
    bmegahealth,
    barmor,
    bmag,
    bshield,
    bUseDecals, //more specifically blood decals :P
    PermaDecals; //permanent decals.
//non-config options (for save game hack):
var bool   oBioRifle,
    oASMD,
    oStingy,
    oRazor,
    oFlak,
    omini,
    oEball,
    oRifle,
    odamage,
    opad,
    oarmor,
    omag,
    oshield;
var config bool UnAir; //U1 aircontrol
var bool NewVersion; //a hack. :D
var localized string spymessage[2];

function SetUpCurrent(){
  if (level.netmode!=NM_standalone||bUseDecals)   //in co-op, always spawn the notify to allow effect swapping client-side.
  spawn(class'bloodnotify');
  if (level.netmode!=NM_standalone||PermaDecals)
  spawn(class'decalnotify');
  if (level.netmode!=NM_standalone){
    spawn(class'EveryThingNotify');
    return;
  }
  oASMD=basmd; //old options
  ostingy=bstingy;
  oRazor=brazor;
  oFlak=bflak;
  omini=bmini;
  oEball=beball;
  oRifle=brifle;
  odamage=bdamage;
  opad=bpad;
  oarmor=barmor;
  omag=bmag;
  oshield=bshield;
  NewVersion=true; //OSA 2.25+ save
}
function postbeginplay(){
SetupCurrent();
level.game.registerdamagemutator(Self);     //OSA 3: damage mutator for skaarj voice thing
//decals spawnnotify:
//log ("OldSkool Amp'd: SPOldSkool Postbeginplay called");
}
function FixContents(out class<inventory> conts){  //mag, minigun, armor and kev not swapped do ro replacewith stuff
  if (conts==none)
    return;
  if (conts==class'ShieldBelt'){
    if (bshield)
      conts=class'osUT_ShieldBelt';
    else
      conts=class'osShieldBelt';
   }
  else if (conts==class'powershield'){
    if (bshield)
      conts=class'olweapons.shieldBeltpower';
    else
     conts=class'olweapons.ospowershield';
  }
  else if (conts==class'superhealth'&&bmegahealth)
    conts=class'healthpack';
  else if (conts==class'health'&&bmed)
    conts=class'medbox';
  else if (conts==class'weaponpowerup')
    conts=class'osDispersionpowerup';
  else if (conts==class'amplifier'&&!bdamage) //do to modifications in replacewith, cannot swap damage
    conts=class'osamplifier';
  else if (conts==class'jumpboots'&&bjump)
    conts=class'UT_jumpboots';
  else if (conts==class'sludge'&&bBioRifle)
    conts=class'bioammo';
  else if (conts==class'ASMDAmmo'&&basmd )
    conts=class'ShockCore';
  else if (conts==class'RocketCan'&&beball)
    conts=class'botpack.RocketPack';
  else if (conts==class'StingerAmmo'&&bstingy)
    conts=class'botpack.PAmmo';
  else if (conts==class'RazorAmmo'&&brazor)
    conts=class'botpack.BladeHopper';
  else if (conts==class'RifleRound' &&brifle)
    conts=class'botpack.RifleShell';
  else if (conts==class'RifleAmmo'&&brifle)
    conts=class'botpack.bulletbox';
  else if (conts==class'FlakBox'&&bflak)
    conts=class'botpack.FlakAmmo';
  else if (conts==class'flakshellammo'&&bflak)
    conts=class'olweapons.OSFlakshellAmmo';
  else if (conts==class'ShellBox'&&bmag)
    conts=class'botpack.MiniAmmo';
  else if (conts==class'Clip'&&bmag)
    conts=class'botpack.EClip';
  else if (conts==class'pulsegun')                            //set up UT: SP stuff for old new maps.....
    conts=class'olweapons.OSPulseGun';
  else if (conts==class'shockrifle')
    conts=class'olweapons.osShockRifle';
  else if ( conts==class'Stinger')                             //set up decal/network weapons.....
    {
    if (bstingy)
      conts=class'olweapons.OSPulseGun';
    else
      conts=class'olweapons.olstinger';
    }
  else if ( conts==class'Rifle')
    {
    if (brifle)
    conts=class'botpack.SniperRifle';
    else
    conts=class'olweapons.olRifle';
    }
  else if ( conts==class'Razorjack' )
    {
    if (brazor)
    conts=class'botpack.ripper';
    else
    conts=class'olweapons.olrazorjack';
    }
  else if (conts==class'quadshot') //some maps had this?
      conts=class'olweapons.olquadshot';
  else if ( conts==class'Eightball')
    {
    if (beball)
    conts=class'botpack.UT_Eightball';
    else
    conts=class'olweapons.olEightball';
    }
  else if (conts==class'FlakCannon')
    {
    if (bflak)
    conts=class'botpack.UT_flakcannon';
    else
    conts=class'olweapons.olFlakCannon';
    }
  else if (conts==class'ASMD')
  {
    if (basmd)
    conts=class'olweapons.osShockRifle';
    else
    conts=class'olweapons.olasmd';
    }
  else if (conts==class'GesBioRifle')  {
    if (bbiorifle)
    conts=class'botpack.UT_BioRifle' ;
    else
    conts=class'olweapons.olgesBioRifle';
    }
    else if (conts==class'dispersionpistol' )
      conts=class'olweapons.oldpistol';
}


//main mutator logic:
function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
  local Inventory Inv;
local transhack hack;  //OSA 2.2 Illumination hack fix
  // replace Unreal I inventory actors by their Unreal Tournament equivalents
  // set bSuperRelevant to false if want the gameinfo's super.IsRelevant() function called
  // to check on relevancy of this actor.

  //weaps...
if (other.isa('transporter')){   //OSA 2.2 transport fix.
hack=spawn(class'transhack',,other.tag,other.location);
hack.Offset=transporter(other).Offset;
other.disable('trigger'); //my version is better :P
return true; //keep its navigation properties.  With trigger disabled it can't do anything and the hack manages it.
}
if (other.isa('decoration')){    //fix content (falling stuff)
  if (other.isa('tree')||left(getitemname(string(other.class)),5)~="plant")
    other.style=STY_MASKED; //fix up mask bug in D3D?
  fixcontents(decoration(other).Contents);
  fixcontents(decoration(other).Content2);
  fixcontents(decoration(other).Content3);
}
if (other.isa('musicevent')&&musicevent(other).Song==none&&level.song==none){ //need to set to null
  musicevent(other).song=music'olroot.null';
  return true;
}
if (other.style==STY_NORMAL&&other.isa('pawn')&&(other.isa('skaarjwarrior')||other.isa('krall')||other.isa('warlord')||other.isa('bird1')||other.isa('Slith')||other.isa('manta')))
  other.style=STY_MASKED; //fix up masking bug on pawns
if (other.IsA('inventory')) //so pickup messages work......
  Inventory(other).PickupMessageClass = None;
//here we swap baddie projectiles around.... (neither a spawn notify nor mutator would affect the projectiles so I had to do it the hard way :(
else if (other.isa('scriptedpawn')){
if (class'olweapons.uiweapons'.default.busedecals){
//if (other.isa('skaarjtrooper'))
//scriptedpawn(other).Shadow = Spawn(class'PlayerShadow',other,,other.location);
//else //what is the difference?  update(actor l) only works if a pawn has a weapon. thus I use olpawnshadow.  playershadow works for troopers though, so might was well be used.
if (!other.isa('tentacle'))     //no decal for them.
  scriptedpawn(other).Shadow = Spawn(class'olpawnShadow',other,,other.location);
if (scriptedpawn(other).RangedProjectile==Class'UnrealShare.BruteProjectile')
scriptedpawn(other).RangedProjectile=Class'oldskool.olBruteProjectile';
if (scriptedpawn(other).RangedProjectile==Class'Unreali.mercrocket')
scriptedpawn(other).RangedProjectile=Class'oldskool.olmercrocket';
else if (scriptedpawn(other).RangedProjectile==Class'UnrealI.GasBagBelch')
scriptedpawn(other).RangedProjectile=Class'oldskool.olGasBagBelch';
else if (scriptedpawn(other).RangedProjectile==Class'UnrealI.KraalBolt')
scriptedpawn(other).RangedProjectile=Class'oldskool.olkraalbolt';
else if (scriptedpawn(other).RangedProjectile==Class'UnrealI.EliteKrallBolt')
scriptedpawn(other).RangedProjectile=Class'oldskool.ol1337krallbolt';
else if (scriptedpawn(other).RangedProjectile==Class'Unrealshare.skaarjprojectile')           //no slith thankz to the hitwall not being simulated (and me too lazy to redo it ;)
scriptedpawn(other).RangedProjectile=Class'oldskool.olskaarjprojectile';
else if (scriptedpawn(other).RangedProjectile==Class'Unreali.queenprojectile')
scriptedpawn(other).RangedProjectile=Class'oldskool.olqueenprojectile';
else if (scriptedpawn(other).RangedProjectile==Class'Unrealshare.tentacleprojectile')
scriptedpawn(other).RangedProjectile=Class'oldskool.oltentacleprojectile';
else if (scriptedpawn(other).RangedProjectile==Class'SlithProjectile')
scriptedpawn(other).RangedProjectile=Class'olSlithProjectile';
else if (scriptedpawn(other).RangedProjectile==Class'Unreali.warlordrocket')
scriptedpawn(other).RangedProjectile=Class'oldskool.olwarlordrocket';  }
//if (busedecals||level.netmode!=nm_standalone)
scriptedpawn(other).carcasstype=class'olCreatureCarcass';
//get those skaarjy right.....                   i.e sets weapons so won't screw up player.  Warning: this makes the skaarj even deadlier ;)

if ( Other.IsA('skaarjtrooper')){
    if (skaarjtrooper(Other).weapontype==Class'unreali.Stinger')
    {
    if (bstingy)
    skaarjtrooper(Other).weapontype=Class'olweapons.osPulseGun';
    else
    skaarjtrooper(Other).weapontype=Class'olweapons.olstinger';
    }
    if ( skaarjtrooper(Other).weapontype==Class'unreali.Rifle')
    {
    if (brifle)
    skaarjtrooper(Other).weapontype=Class'botpack.SniperRifle';
    else
    skaarjtrooper(Other).weapontype=Class'olweapons.olRifle';
    }
    if (skaarjtrooper(Other).weapontype==Class'unreali.Razorjack')
    {
    if (brazor)
    skaarjtrooper(Other).weapontype=Class'botpack.ripper';
    else
    skaarjtrooper(Other).weapontype=Class'olweapons.olrazorjack';
    }
    if ( skaarjtrooper(Other).weapontype==Class'unreali.Minigun')
    {
    if (bmini)
    skaarjtrooper(Other).weapontype=Class'botpack.Minigun2';
    else
    skaarjtrooper(Other).weapontype=Class'olweapons.olMinigun';
    }
    if ( skaarjtrooper(Other).weapontype==Class'unreali.automag')                         //no special mags allowed in SP......
    {
    if (bmag)
    skaarjtrooper(Other).weapontype=Class'botpack.Enforcer';
    else
    skaarjtrooper(Other).weapontype=Class'olweapons.olautomag';
    }
    if ( skaarjtrooper(Other).weapontype==Class'Eightball')
    {
    if (beball)
    skaarjtrooper(Other).weapontype=Class'botpack.UT_Eightball';
    else
    skaarjtrooper(Other).weapontype=Class'olweapons.olEightball';
    }
    if (skaarjtrooper(Other).weapontype==Class'FlakCannon')
    {
    if (bflak)
    skaarjtrooper(Other).weapontype=Class'botpack.UT_flakcannon';
    else
    skaarjtrooper(Other).weapontype=Class'olweapons.olFlakCannon';
    }
    if ( skaarjtrooper(Other).weapontype==Class'unreali.ASMD')
    {
    if (basmd)
    skaarjtrooper(Other).weapontype=Class'olweapons.osShockRifle';
    else
    skaarjtrooper(Other).weapontype=Class'olweapons.olasmd';
    }
    if ( skaarjtrooper(Other).weapontype==Class'GesBioRifle'){
    if (bbiorifle)
    skaarjtrooper(Other).weapontype=Class'botpack.UT_BioRifle';
    else
    skaarjtrooper(Other).weapontype=Class'olweapons.olgesBioRifle';
    }                                             //tourney weaps
    if ( skaarjtrooper(Other).weapontype==Class'dispersionpistol')           //always change......
    skaarjtrooper(Other).weapontype=Class'olweapons.oldpistol';
    if ( skaarjtrooper(Other).weapontype==Class'shockrifle' && !(skaarjtrooper(Other).weapontype==Class'osshockrifle'))
    skaarjtrooper(Other).weapontype=Class'olweapons.osshockrifle';
    if ( skaarjtrooper(Other).weapontype==Class'pulsegun' && !(skaarjtrooper(Other).weapontype==Class'ospulsegun'))
    skaarjtrooper(Other).weapontype=Class'olweapons.ospulsegun';
 /*   if ( skaarjtrooper(Other).weapontype==Class'sniperrifle' && !(skaarjtrooper(Other).weapontype==Class'ossniperrifle'))
    skaarjtrooper(Other).weapontype=Class'olweapons.ossniperrifle';      */  }
    return true;
   }
else //anything else forget about it.....
return true;
if ( Other.IsA('Weapon') )            //set up decal/network weapons.....
  {
    if (Other.Isa('tournamentweapon')){
    if ( Other.IsA('uiweapons') ){
    return true;}                              //possible options for "new" maps....
 /*   If (Other.Isa('Olstinger')&&bstingy){
    ReplaceWith(Other, "olweapons.osPulseGun");
    return false;}
    If (Other.Isa('Olautomag')&&bmag){
    ReplaceWith(Other, "botpack.enforcer");
    return false;}
    If (Other.Isa('Olminigun')&&bmini){
    ReplaceWith(Other, "botpack.minigun2");
    return false;}
    If (Other.Isa('Olgesbiorifle')&&bbiorifle){
    ReplaceWith(Other, "botpack.ut_biorifle");
    return false;}
    If (Other.Isa('Olasmd')&&basmd){
    ReplaceWith(Other, "olweapons.osshockrifle");
    return false;}
    If (Other.Isa('Oleightball')&&beball){
    ReplaceWith(Other, "botpack.ut_eightball");
    return false;}
    If (Other.Isa('Olflakcannon')&&bflak){
    ReplaceWith(Other, "botpack.ut_flakcannon");
    return false;}
    If (Other.Isa('Olrazorjack')&&brazor){
    ReplaceWith(Other, "botpack.ripper");
    return false;}
    If (Other.Isa('Olrifle')&&brifle){
    ReplaceWith(Other, "olweapons.ossniperrifle");
    return false;}
    return true;
    }     */
    if ( Other.class==class'pulsegun')                            //set up UT: SP stuff for old new maps.....
    {
    ReplaceWith(Other, "olweapons.OSPulseGun");
    return false;
    }
 /*   if ( Other.IsA('sniperrifle')&&!Other.Isa('OSsniperrifle'))
    {
    ReplaceWith( Other, "olweapons.OSSniperRifle" );
    return false;
    } */

    if ( Other.class==class'shockrifle')
    {
    ReplaceWith( Other, "olweapons.osShockRifle" );
    return false;
    }
    return true;}
    if ( Other.class==class'Stinger')                             //set up decal/network weapons.....
    {
    if (bstingy)
    ReplaceWith(Other, "olweapons.OSPulseGun");
    else
    ReplaceWith(Other, "olweapons.olstinger");
    return false;
    }
    if ( Other.class==class'Rifle')
    {
    if (brifle)
    ReplaceWith( Other, "botpack.SniperRifle" );
    else
    ReplaceWith( Other, "olweapons.olRifle" );
    return false;
    }
    if ( Other.class==class'Razorjack' )
    {
    if (brazor)
    ReplaceWith(Other, "botpack.ripper");
    else
    ReplaceWith( Other, "olweapons.olrazorjack" );
    return false;
    }
    if (other.class==class'quadshot'){ //some maps had this?
      ReplaceWith(Other,"olweapons.olquadshot");
      return false;
    }
    if ( Other.class==class'Minigun')
    {
    if (bmini)
    ReplaceWith( Other, "botpack.Minigun2" );
    else
    ReplaceWith( Other, "olweapons.olMinigun" );
    return false;
    }
    if ( Other.class==class'AutoMag')
    {
    if (bmag)
    ReplaceWith( Other, "botpack.Enforcer" );
    else
    ReplaceWith( Other, "olweapons.olautomag" );
    return false;
    }
    if ( Other.class==class'Eightball')
    {
    if (beball)
    ReplaceWith( Other, "botpack.UT_Eightball" );
    else
    ReplaceWith( Other, "olweapons.olEightball" );
    return false;
    }
    if ( Other.class==class'FlakCannon')
    {
    if (bflak)
    ReplaceWith( Other, "botpack.UT_flakcannon" );
    else
    ReplaceWith( Other, "olweapons.olFlakCannon" );
    return false;
    }
    if ( Other.class==class'ASMD')
    {
    if (basmd)
    ReplaceWith( Other, "olweapons.osShockRifle" );
    else
    ReplaceWith( Other, "olweapons.olasmd" );
    return false;
    }
    if ( Other.class==class'GesBioRifle' )  {
    if (bbiorifle)
    ReplaceWith( Other, "botpack.UT_BioRifle" );
    else
    ReplaceWith( Other, "olweapons.olgesBioRifle" );
    return false;
    }
    if ( Other.class==class'dispersionpistol' ){ //for Vrikers where you pick it up......
    ReplaceWith( Other, "olweapons.oldpistol" );
    return false;}
  return true;  //some other wierd weapon that got in here :D
  }
  //ammo
if ( Other.IsA('Ammo'))                           //ammo sets for correct item place.......
  {
  if (string(Ammo(Other).PickupSound)~="UnrealShare.Pickups.AmmoSnd") {          //fix up this stuff.....
 Ammo(Other).PickupSound=Sound'BotPack.Pickups.AmmoPick';
     Ammo(Other).bClientAnim=True;       }
    if ( Other.IsA('TournamentAmmo') )           //for UT: SP.......
      { if ( Other.IsA('shockcore')){    //check not default ammo...
      shockcore(other).icon=Texture'UnrealShare.Icons.I_ASMD';
      return true;
    }
    if ( Other.isa('RocketPack'))  {
      RocketPack(Other).UsedInWeaponSlot[5]=0;
      RocketPack(Other).UsedInWeaponSlot[9]=1;
      RocketPack(Other).Icon=Texture'UnrealShare.Icons.I_RocketAmmo';
      return true;
    }
    if ( Other.IsA('Pammo'))
    { Pammo(Other).UsedInWeaponSlot[3]=0;
      Pammo(Other).UsedInWeaponSlot[5]=1;
      Pammo(Other).Icon=Texture'pulseicon';       //ph34r |\/|y 1c0|\| |\/|4k1|\|9 5k1llz!!!!!!!
      return true;
    }
    if ( Other.IsA('bladehopper'))
    {bladehopper(other).UsedInWeaponSlot[7]=0;
bladehopper(other).UsedInWeaponSlot[6]=1;
bladehopper(other).Icon=Texture'UnrealI.Icons.I_RazorAmmo';
      return true;
    }
    if ( Other.IsA('bulletbox'))
    {   bulletbox(other).UsedInWeaponSlot[9]=0;
        bulletbox(other).UsedInWeaponSlot[0]=1;
      return true;
    }
    if ( Other.IsA('Flakammo'))
    { flakammo(other).UsedInWeaponSlot[6]=0;
    flakammo(other).UsedInWeaponSlot[8]=1;
    flakammo(other).Icon=Texture'UnrealI.Icons.I_FlakAmmo';
      return true;
    }
    if ( Other.IsA('miniammo'))
    {  miniammo(other).UsedInWeaponSlot[0]=0;
 miniammo(other).UsedInWeaponSlot[7]=1;
 miniammo(other).Icon=Texture'UnrealShare.Icons.I_ShellAmmo';
      return true;
    }
    if ( Other.IsA('bioammo'))
{   bioammo(other).UsedInWeaponSlot[8]=0;
bioammo(other).UsedInWeaponSlot[3]=1;
bioammo(other).Icon=Texture'UnrealI.Icons.I_SludgeAmmo';
    return true;}
      return true; }

    if ( Other.IsA('ASMDAmmo')&& !Other.IsA('Defaultammo')&&basmd ){    //check not default ammo...
      ReplaceWith( Other, "botpack.ShockCore" );
      return false;
    }
    if ( Other.IsA('RocketCan')&&beball)  {
      ReplaceWith( Other, "botpack.RocketPack" );
      return false;
    }
    if ( Other.IsA('StingerAmmo') &&bstingy)
    {  ReplaceWith(Other, "botpack.PAmmo");     //no icon :( anyone?
      return false;
    }
    if ( Other.IsA('RazorAmmo')&&brazor)
    {ReplaceWith( Other, "botpack.BladeHopper" );
      return false;
    }
    if ( Other.IsA('RifleRound') &&brifle)
    { ReplaceWith( Other, "botpack.RifleShell" );
      return false;
    }
    if ( Other.IsA('RifleAmmo')&&!Other.IsA('RifleRound')&&brifle)
    { ReplaceWith( Other, "botpack.bulletbox" );
      return false;
    }
    if ( Other.IsA('FlakBox')&&!Other.Isa('flakshellammo')&&bflak)
    {  ReplaceWith( Other, "botpack.FlakAmmo" );
      return false;
    }
    if (Other.Isa('flakshellammo')&&bflak)
    {  ReplaceWith( Other, "olweapons.OSFlakshellAmmo" );
      return false;
    }
    if ( Other.IsA('ShellBox')&&!Other.Isa('clip')&&Other.Location != vect(0,0,0)&&Other.owner==None )
    { if(bmag){
    ReplaceWith( Other, "botpack.MiniAmmo" );
      return false;  }
      if (bmini){ //only set slots.....
      miniammo(other).UsedInWeaponSlot[0]=0;
 miniammo(other).UsedInWeaponSlot[7]=1;
 return true;}
    }
if ( Other.IsA('Clip') &&bmag&&Other.Location != vect(0,0,0)&&Other.owner==None )
    { if (bmag){
    ReplaceWith( Other, "botpack.EClip" );
      return false; }
      if (bmini){ //only set slots.....
      miniammo(other).UsedInWeaponSlot[0]=0;
 miniammo(other).UsedInWeaponSlot[7]=1;
 return true;}
    }
    if ( Other.IsA('Sludge')&&bbiorifle)
{   ReplaceWith( Other, "botpack.bioammo" );
    return false;}
    return true; //other stuff...
    }
//items
if ( Other.IsA('pickup') )
{
if (Other.Isa('armor2')){              //icon.....
armor2(other).Icon=Texture'UnrealShare.Icons.I_Armor';
return true;}

if (Other.Isa('thighpads')){  //stronger pads......    (kev suit standarts)
thighpads(other).Icon=Texture'UnrealShare.Icons.I_kevlar'; //to stop confusion :D
return true;}
if ( Other.IsA('Tournamentpickup') )        //sure ok :D
      return true;
  if ( Other.IsA('JumpBoots') &&bjump)
  {
    ReplaceWith( Other, "Botpack.UT_JumpBoots" );
    return false;
  }
  if ( Other.IsA('Amplifier')&&!Other.Isa('OSamplifier')) {
    if (bdamage)ReplaceWith( Other, "Botpack.UDamage" );else
    ReplaceWith( Other, "olweapons.osamplifier" );        //special amp (supports the olweapons...)
    return false;
  }
  if ( Other.IsA('WeaponPowerUp')&&!Other.Isa('OSDispersionpowerup') ){
replacewith( Other, "olWeapons.OsDispersionpowerup");//supports oldpistol
return false; }

  if ( Other.IsA('KevlarSuit') &&bpad) {
  ReplaceWith( Other, "Botpack.ThighPads");
  return false;
  }
  if ( Other.IsA('SuperHealth')&&bmegahealth)
 {
    ReplaceWith( Other, "Botpack.HealthPack" );
    return false;
  }
  if ( Other.IsA('Armor')&&barmor)
  {
  ReplaceWith( Other, "Botpack.Armor2" );
    return false;
  }
  if ( Other.class==class'unrealshare.health' &&bmed)
    {
    ReplaceWith( Other, "Botpack.MedBox" );
    return false;
  }
  if ( Other.IsA('ShieldBelt') &&!Other.Isa('Powershield')) {                  //shieldbelt effects....
    if (bshield)
    ReplaceWith( Other, "olweapons.osUT_ShieldBelt" );
    else
    ReplaceWith( Other, "olweapons.osShieldBelt" );
    return false;
  }
if ( Other.IsA('Powershield')){
    if (bshield)
    ReplaceWith( Other, "olweapons.shieldBeltpower" );
    else
    ReplaceWith( Other, "olweapons.ospowershield" );
    return false;
  }
return true; //other inventory (like invis.) that's not allowed to change for cheating reasons.......
}

  bSuperRelevant = 0;
  return true;
}
//keeps even more inportant stuff......
function bool ReplaceWith(actor Other, string aClassName)
{
  local Actor A;
  local class<Actor> aClass;
  if (PropSetup)
    return false;
  if
  (  (level.game.Difficulty==0 && !Other.bDifficulty0 )          //as gameinfo's isn't called...we'll just make up for it here.....
  ||  (level.game.Difficulty==1 && !Other.bDifficulty1 )
  ||  (level.game.Difficulty==2 && !Other.bDifficulty2 )
  ||  (level.game.Difficulty==3 && !Other.bDifficulty3 )
  ||  (!Other.bSinglePlayer && (Level.NetMode==NM_Standalone) ) 
  ||  (!Other.bNet && ((Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer)) )
  ||  (!Other.bNetSpecial  && (Level.NetMode==NM_Client)) )
    return False;
  if( FRand() > Other.OddsOfAppearing )
    return False;
  if ( Other.IsA('Inventory') && (Other.Location == vect(0,0,0)) )
    return false;
  aClass = class<Actor>(DynamicLoadObject(aClassName, class'Class'));
  if ( aClass != None )
    A = Spawn(aClass,,Other.tag,Other.Location, Other.Rotation);
  if ( Other.IsA('Inventory') )
  {
    if ( Inventory(Other).MyMarker != None )
    {
      Inventory(Other).MyMarker.markedItem = Inventory(A);
      if ( Inventory(A) != None )
      {
        Inventory(A).MyMarker = Inventory(Other).MyMarker;
        A.SetLocation(A.Location 
          + (A.CollisionHeight - Other.CollisionHeight) * vect(0,0,1));
      }
      Inventory(Other).MyMarker = None;
    }
    else if ( A.IsA('Inventory') &&Inventory(Other).bhelditem)
    {
      Inventory(A).bHeldItem = true;
      Inventory(A).Respawntime = 0.0;
    }
  }
  if ( A != None )
  {
        if (A.Isa('thighpads')){   //kev suit pads.....
    Thighpads(A).charge=100;
    Thighpads(A).armorabsorption=80;
Thighpads(A).AbsorptionPriority=6;}
    if (A.Isa('armor2'))
    armor2(A).ArmorAbsorption=90;
    if (A.Isa('udamage')) {               //9 sec Udamage......
    udamage(A).charge=90;
udamage(A).finalcount=2;  }
    if (a.IsA('minigun2')&&!bmag)     //if we have automags we gotta do this.....
    minigun2(a).AmmoName=Class'UnrealShare.ShellBox';
    if (a.IsA('enforcer')&&!bmini)     //if we have minigunz we gotta do this.....
    enforcer(a).AmmoName=Class'UnrealShare.ShellBox';
    if (a.Isa('olautomag')&&Other.Isa('automag')&&automag(other).hitdamage==70){//h4x for Ballad of Ash
    olautomag(A).hitdamage=automag(other).hitdamage;
    olautomag(A).altfiresound=automag(other).AltFireSound;
    olautomag(A).firesound=automag(other).FireSound;
     olautomag(A).misc1sound=automag(other).Misc1Sound;
     olautomag(A).misc2sound=automag(other).Misc2Sound;
     olautomag(A).selectsound=automag(other).SelectSound;
     }

    A.event = Other.event;
    A.tag = Other.tag;
    A.RotationRate= Other.RotationRate; ///other important info.....
    return true;
  }
  return false;
}
//quick save and quickload...... (a cheat code too!!!!)
function Mutate(string MutateString, PlayerPawn Sender)
{ local class<Mappack> Packclass;
  if (MutateString ~= "quicksave")
  {
   if ( (sender.Health > 0)
    && (Level.NetMode == NM_Standalone))
  {
    class'olroot.OldSkoolSlotClientWindow'.default.quicksavetype=class'oldskool.oldskoolnewgameclientwindow'.default.SelectedPackType;       //obvious why this is needed :D
    class'olroot.OldSkoolSlotClientWindow'.static.staticsaveconfig();
    sender.ClientMessage("Saved game");
    sender.ConsoleCommand("SaveGame 1000");
  }
  }
  if ((MutateString ~= "quickload")&&(Level.NetMode == NM_Standalone)&&class'olroot.OldSkoolSlotClientWindow'.default.quicksavetype!=""){
  if (!(class'olroot.OldSkoolSlotClientWindow'.default.quicksavetype ~= "Custom"))
  PackClass = Class<Mappack>(DynamicLoadObject(class'olroot.OldSkoolSlotClientWindow'.default.quicksavetype, class'Class'));
  if ((packclass != None)&&(packclass.default.loadrelevent)) {          //a gameinfo should turn this off.....
    packclass.default.bLoaded = true;
    packclass.static.StaticSaveConfig(); }
  //sender.ConsoleCommand( "open ..\\save\\save1000.usa");}
  sender.ClientTravel( "?load=1000", TRAVEL_Absolute, false);}
  if (MutateString ~= "spyd00d" && Level.Game.Isa('singleplayer2')){
  sender.ClientMessage(spymessage[byte(Singleplayer2(level.game).spectateallowed)]);
  Singleplayer2(level.game).spectateallowed=!Singleplayer2(level.game).spectateallowed;
  }
  if ( NextMutator != None )
    NextMutator.Mutate(MutateString, Sender);
}

//check skaarj feign for autotaunt.
function MutatorTakeDamage( out int ActualDamage, Pawn Victim, Pawn InstigatedBy, out Vector HitLocation, 
            out Vector Momentum, name DamageType)
{
  local int NextTaunt, i;
  if (Victim.isa('skaarj')&&TournamentPlayer(InstigatedBy)!=none&&TournamentPlayer(InstigatedBy).bAutoTaunt&&instigatedby.health>0&&
  (Level.TimeSeconds - SinglePlayer2(level.game).LastTauntTime > 3)
  &&DamageType != 'gibbed'&&(addvelocity(momentum,victim.velocity).z>120)
  &&victim.health-actualdamage< 0.4 * victim.Default.Health){
   //at this point try the random test.
   animsequence=victim.animsequence; //backups
   velocity=victim.velocity;
   victim.animsequence='Lunge';
   victim.velocity.z=121;
   victim.health-=actualdamage;
   skaarj(victim).PlayTakeHit(0,hitlocation,actualdamage);
   //set back:
   victim.velocity=velocity;
   velocity=vect(0,0,0);
   victim.health+=actualdamage; //then will be subtracted again :P
   if (victim.animsequence=='death2'){       //fake taunt!
      SinglePlayer2(level.game).LastTauntTime = Level.TimeSeconds;
    NextTaunt = Rand(class<ChallengeVoicePack>(InstigatedBy.PlayerReplicationInfo.VoiceType).Default.NumTaunts);
    for ( i=0; i<4; i++ )                                   //keeps taunts unique.....
    {
      if ( NextTaunt == SinglePlayer2(level.game).LastTaunt[i] )
        NextTaunt = Rand(class<ChallengeVoicePack>(InstigatedBy.PlayerReplicationInfo.VoiceType).Default.NumTaunts);
      if ( i > 0 )
        SinglePlayer2(level.game).LastTaunt[i-1] = SinglePlayer2(level.game).LastTaunt[i];
    }  
    SinglePlayer2(level.game).LastTaunt[3] = NextTaunt;
   InstigatedBy.SendGlobalMessage(None, 'AUTOTAUNT', NextTaunt, 5);
   }
   else
   victim.animsequence=animsequence; //set back to old. (only this case as need to force skaarj to feign)
   animsequence=''; //don't want something getting messed up :P
   }
   if ( NextDamageMutator != None )       //might as well.
    NextDamageMutator.MutatorTakeDamage( ActualDamage, Victim, InstigatedBy, HitLocation, Momentum, DamageType );
}
function vector AddVelocity( vector NewVelocity, vector current)
{
  if ( (current.Z > 380) && (NewVelocity.Z > 0) )
    NewVelocity.Z *= 0.5;
  current += NewVelocity;
}
function bool IsRelevant(Actor Other, out byte bSuperRelevant)
{
  local bool bResult;

  // allow mutators to remove actors
  bResult = CheckReplacement(Other, bSuperRelevant);
  if ( !propSetup&&bResult && (NextMutator != None) )
    bResult = NextMutator.IsRelevant(Other, bSuperRelevant);

  return bResult;
}

defaultproperties
{
    bmini=True
    bdamage=True
    bUseDecals=True
    PermaDecals=True
    UnAir=True
    spymessage(0)="Monster viewing cheat enabled."
    spymessage(1)="Monster viewing cheat disabled."
}
