// ============================================================
// to swap HUDS.......
// ============================================================

class oldhudNotify expands SpawnNotify;
var bool bdisabled;
simulated event Actor SpawnNotification( Actor A )
{
if (bdisabled)
   return a;
   if (a.owner.Isa('spectator')){
   a.destroy();//use spectator HUD for spectators
   return Spawn( Class'oldskool.oldskoolspectatorhud', A.Owner );  }
     if (a.class.name=='assaultHUD'){
     a.destroy();
      return Spawn( Class'oldskool.oldskoolashud', A.Owner );}
      if (a.class.name=='ChallengectfHUD'){
      a.destroy();
      return Spawn( Class'oldskool.realctfhud', A.Owner );}
      if (a.class.name=='ChallengeDominationHUD'){
      a.destroy();
      return Spawn( Class'oldskool.oldskooldomHUD', A.Owner );}
      if (a.class.name=='ChallengeTeamHUD'){
      a.destroy();
      return Spawn( Class'oldskool.oldskoolTeamHUD', A.Owner );}

      if (a.class.name=='ChallengeHUD'){          //use normal HUD
      a.destroy();
      return Spawn( Class'oldskool.oldskoolBASEHUD', A.Owner );}
      return a; //custom HUD: use it.
}

defaultproperties
{
    ActorClass=Class'botpack.ChallengeHUD'
}
