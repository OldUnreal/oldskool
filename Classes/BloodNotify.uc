// ============================================================
//The main oldskool package.
//Holds the mutators, singleplayer game, windows, Unreal I models and mappacks.
//BloodNotify.  This is used for adding blood decals to the unreali blood effects.
// ============================================================

class BloodNotify expands SpawnNotify;
simulated event postbeginplay(){
if (level.netmode!=nm_client||class'spoldskool'.default.busedecals)
super.postbeginplay();
else
destroy(); //useless on clients that have decals false.
//log ("OSA Blood notify initialized:"@!bdeleteme);
}
function prebeginplay(); //don't call parent! (screwed up)
simulated event Actor SpawnNotification(Actor A)   //put in olbloodburst.
{
  if (a.class!=class'OlBloodBurst'&&class'spoldskool'.default.busedecals){
  a.bhidden=true; //don't want to risk destroying.
  if (level.netmode!=nm_client)
  a.remoterole=role_none; //why replicate?
  return spawn(class'olbloodburst',a.owner,a.tag,a.location,a.rotation); //copy :P
  }
  return A;
}
defaultproperties
{
    ActorClass=Class'UnrealShare.BloodBurst'
}
