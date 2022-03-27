// ============================================================
//for oldskool 2.20
//and with the unrealshare.transporter epic said let's break future compatibility by only searching for unreali players!
//and so it was
//this is a nice ugly hack to fix it.
//mutator checks if a transporter is spawned and then copies properties over to this.
// Psychic_313: unchanged in Oldskool III. So _that's_ why I couldn't get past Illumination without cheating. Thanks UsAaR33 :-)
// ============================================================

class transhack expands Info;
var Vector Offset;
function Trigger( Actor Other, Pawn EventInstigator )
{
  local pawn p;     //do tournamentplayer here

  // Move the player instantaneously by the Offset vector
  
  // Find the players
  for (p=level.pawnlist;p!=none;p=p.nextpawn)
  {  
    if (p.isa('playerpawn'))
      p.SetLocation( p.Location + Offset );
  }

  Disable( 'Trigger' );
}

defaultproperties
{
}
