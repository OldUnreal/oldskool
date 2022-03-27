// ============================================================
// oldskool.DecalNotify :  Disables timer on decals, thus preventing their destruction. are bgamerelevant.
// The main oldskool package.
// Holds the mutators, singleplayer game, windows, Unreal I models and mappacks.
// ============================================================

class DecalNotify expands SpawnNotify;

simulated event postbeginplay(){
if (level.netmode!=nm_client||class'spoldskool'.default.PermaDecals)
super.postbeginplay();
else
destroy(); //useless on clients that have decals false.
//log ("OSA Blood notify initialized:"@!bdeleteme);
}
function prebeginplay(); //don't call parent! (screwed up)
simulated event Actor SpawnNotification(Actor A)   //put in olbloodburst.
{
  if (class'spoldskool'.default.PermaDecals&&A.class!=class'pock'){
    A.disable('timer');
    A.bstasis=true; //doesn't change :P
  }
  return A;
}
defaultproperties
{
    ActorClass=Class'botpack.Scorch'
}
