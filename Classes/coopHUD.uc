// ============================================================
// coop hud... different calling of fragcount....
// Psychic_313: unchanged
// ============================================================

class coopHUD expands oldskoolHUD;
simulated function DrawFragCount(Canvas Canvas, int X, int Y)     //to make better use of scoring #'s...
{
  local color oldcol;
  Canvas.SetPos(X,Y);
  if (realicons) {
  Canvas.DrawIcon(Texture'Realskull', 1.0);
  oldcol=canvas.drawcolor;
  canvas.drawcolor=redcolor;  }
  else
  Canvas.DrawIcon(Texture'IconSkull', 1.0);  
  Canvas.CurX -= 31;
  Canvas.CurY += 23;
  if ( PawnOwner.PlayerReplicationInfo == None )
    return;
  Canvas.Font = Font'TinyWhiteFont';
  if (PawnOwner.PlayerReplicationInfo.score<10000)
    Canvas.CurX+=6;
  if (PawnOwner.PlayerReplicationInfo.score<1000)
    Canvas.CurX+=6;
  if (PawnOwner.PlayerReplicationInfo.score<100)
    Canvas.CurX+=6;
  if (PawnOwner.PlayerReplicationInfo.score<10)
    Canvas.CurX+=6;  
  if (PawnOwner.PlayerReplicationInfo.score<0)
    Canvas.CurX-=6;
  if (PawnOwner.PlayerReplicationInfo.score<-9)
    Canvas.CurX-=6;
  if (PawnOwner.PlayerReplicationInfo.score<-90)
    Canvas.CurX-=6;
    if (PawnOwner.PlayerReplicationInfo.score<-900)
    Canvas.CurX-=6;
  if (PawnOwner.PlayerReplicationInfo.score<-9000)
    Canvas.CurX-=6;
  Canvas.DrawText(int(PawnOwner.PlayerReplicationInfo.score),False);
     if (realicons)
  canvas.drawcolor=oldcol;
}

defaultproperties
{
}
