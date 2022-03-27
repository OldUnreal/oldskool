// ============================================================
// notification to swap scoreboards.....
// ============================================================

class oldboardNotify expands spawnnotify;
var bool bdisabled;
simulated event Actor SpawnNotification( Actor A )
{
   local actor oldowner;
   local bool isteam, isas, islms;
   if (bdisabled)
   return a;
   islms=A.isa('lmsscoreboard');
   isteam=A.isa('teamscoreboard');
   isas=A.isa('AssaultScoreboard');
   oldowner = A.Owner;    //as we are destroying the actor we still need to know who it's owner was..
   A.Destroy();
   if (isteam)     //check which ones we will use.....
      {
      if (isas)           //for time on HUD to show.....
      return Spawn( Class'oldskool.asscoreboard', oldowner );
      else
      return Spawn( Class'oldskool.oldskoolTeamScoreBoard', oldowner );
      }
      else{           //use normal scoreboard
      if (islms)   //if we're in LMS mode.....
      return Spawn( Class'oldskool.oldskoollmsboard', oldowner );
      else
      return Spawn( class'UnrealShare.UnrealScoreBoard', oldowner ); }
}

defaultproperties
{
    ActorClass=Class'botpack.TournamentScoreBoard'
}
