// ============================================================
// a scoreboard for assault.....
// Psychic_313: unchanged
// ============================================================

class asscoreboard expands oldskoolTeamScoreBoard;
function ShowScores( canvas Canvas )        //check to draw the time stuff.....
{
  Super.ShowScores(Canvas);

  if ( OwnerHUD.IsA('oldskoolashud') )
    oldskoolashud(OwnerHUD).DrawTimeAt(Canvas, 0.5 * Canvas.ClipX - 80 * Canvas.ClipX/1280, 4);
}

defaultproperties
{
}
