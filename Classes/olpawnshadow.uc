// ============================================================
// oldskool.olPawnShadow:  By UsAaR33 (well, ripped from playershadow and modified :P
// shadows for scripted pawns (not skaarj trooper though).
// Why can't I use playershadow and update?  It only works if the owner is a player.  I still have yet to figure out what L is...
// Unfortunately, lighting data is lossed making the shadows a little less 1337 :(
// Psychic_313: unchanged. I don't know this stuff :-)
// ============================================================

class olpawnshadow expands Decal;
var vector OldOwnerLocation;
//var vector offset;
var float lastanimframe; //stasis check
var bool timing; //check if timeing.
simulated event PostBeginPlay()
{
drawscale=0.028*owner.collisionradius; //I'm basing this kinda on the playerpawn one :P
if (owner.isa('ledino')||owner.isa('nali')||owner.isa('slith')) //too big on dinos, sliths and nalis!
drawscale*=0.75;
//if (owner.isa('ledino'))
//offset=vect(-40,0,0);
}
simulated function bool CheckRender(){
local bool bRetVal;
if (lastanimframe==0)
  bRetVal=false;
else
  bretval=(lastanimframe!=owner.animframe);
lastanimframe=owner.animframe;
return bRetVal;
}
simulated event timer(){
  local pawn p;
  owner.style=owner.default.style;
/*(  for (p=level.pawnlist;p!=none;p=p.nextpawn)
    if (p.isa('playerpawn')){
      p.clientmessage(owner@"reset to normal at"@level.timeseconds@"with anim"@owner.animsequence);
      return;
    }
*/
}
simulated event tick(float delta)
{
  local Actor HitActor;
  local Vector HitNormal,HitLocation, ShadowStart;
  local bool oldfog;
  //masked stuff?
  if (!timing&&owner.style==STY_MASKED&&owner.default.style==STY_NORMAL&&(level.game==none||level.game.gamereplicationinfo.priarray[0]!=none&&(/*owner.isa('slith')||*/owner.isa('SkaarjWarrior'))&&!owner.IsInState('startup')&&(owner.bstasis||!owner.IsInState('waiting'))&&owner.PlayerCanSeeMe())&&CheckRender()/*&&owner.IsAnimating()&&(owner.bviewtarget||owner.PlayCanSeeMe())&&owner.RenderInterface!=none&&owner.RenderInterface.Observer!=none*/){
    timing=true;
    SetTimer(0.08,false);
    //owner.style=owner.default.style;
    //bstasis=false;
  }
    //owner.style=owner.default.style;
  if ( OldOwnerLocation == Owner.Location )
    return;

  OldOwnerLocation = Owner.Location;

  DetachDecal();
  if ( !Level.bHighDetailMode )
    return;
  if ( Owner.Style == STY_Translucent )
    return;
  if (owner.isa('skaarj')&&owner.AnimSequence == 'Death2')  //feign death.
  return;
  ShadowStart = Owner.Location +/*offset+ */Owner.CollisionRadius * vect(0.1,0.1,0);
  HitActor = Trace(HitLocation, HitNormal, ShadowStart - vect(0,0,300), ShadowStart, false);

  if ( HitActor == None )
    return;

  SetLocation(HitLocation);
  SetRotation(rotator(HitNormal));
  oldfog=region.zone.bfogzone;   //ignore fog zone.
  region.zone.bfogzone=false;
  AttachDecal(10, vect(0.1,0.1,0));
  region.zone.bfogzone=oldfog;
}

defaultproperties
{
    MultiDecalLevel=3
    Texture=Texture'botpack.energymark'
    DrawScale=0.50
}
