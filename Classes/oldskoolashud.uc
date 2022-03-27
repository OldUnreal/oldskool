// ============================================================
// an assault HUD......
// Psychic_313: unchanged
// ============================================================

class oldskoolashud expands oldskoolteamhud;

simulated function DrawFragCount(Canvas Canvas, int X, int Y)
{
  local float b;
  if ( Canvas.ClipX <= Canvas.ClipX - 256 )
    B = Canvas.ClipY - 128;
  else
    B = Canvas.ClipY - 192;
  DrawTimeAt(Canvas, 2.0, b);
  Super.DrawFragCount(Canvas, X, Y);
}

simulated function DrawTimeAt(Canvas Canvas,float x, float y)
{
  local int Minutes, Seconds, d;
    if ( PlayerOwner.GameReplicationInfo == None )
    return;
    Canvas.DrawColor = RedColor;
  Canvas.CurX = X;
  Canvas.CurY = Y;
  Canvas.Style = Style;

  if ( PlayerOwner.GameReplicationInfo.RemainingTime > 0 )
  {
    Minutes = PlayerOwner.GameReplicationInfo.RemainingTime/60;
    Seconds = PlayerOwner.GameReplicationInfo.RemainingTime % 60;
  }
  else
  {
    Minutes = 0;
    Seconds = 0;
  }
  
  if ( Minutes > 0 )
  {
    if ( Minutes >= 10 )
    {
      d = Minutes/10;
      Canvas.DrawTile(Texture'BotPack.HudElements1', 25, 64, d*25, 0, 25.0, 64.0);
      Canvas.CurX += 7;
      Minutes= Minutes - 10 * d;
    }
    else
    {
      Canvas.DrawTile(Texture'BotPack.HudElements1', 25, 64, 0, 0, 25.0, 64.0);
      Canvas.CurX += 7;
    }

    Canvas.DrawTile(Texture'BotPack.HudElements1', 25, 64, Minutes*25, 0, 25.0, 64.0);
    Canvas.CurX += 7;
  } else {
    Canvas.DrawTile(Texture'BotPack.HudElements1', 25, 64, 0, 0, 25.0, 64.0);
    Canvas.CurX += 7;
  }
  Canvas.CurX -= 4 ;
  Canvas.DrawTile(Texture'BotPack.HudElements1', 25, 64, 32, 64, 25.0, 64.0);
  Canvas.CurX += 3;

  d = Seconds/10;
  Canvas.DrawTile(Texture'BotPack.HudElements1', 25, 64, 25*d, 0, 25.0, 64.0);
  Canvas.CurX += 7;

  Seconds = Seconds - 10 * d;
  Canvas.DrawTile(Texture'BotPack.HudElements1', 25, 64, 25*Seconds, 0, 25.0, 64.0);
  Canvas.CurX += 7;
}

simulated function bool SpecialIdentify(Canvas Canvas, Actor Other )    //never seems to show.....
{
  local float XL, YL;

  if ( !Other.IsA('FortStandard') )
    return false;

  Canvas.Font = Font'WhiteFont';
  Canvas.DrawColor = RedColor * IdentifyFadeTime * 0.333;
  Canvas.StrLen(class'botpack.AssaultHUD'.default.IdentifyAssault, XL, YL);
  Canvas.SetPos(Canvas.ClipX/2 - XL/2, Canvas.ClipY - 74);
  Canvas.DrawText(class'botpack.AssaultHUD'.default.IdentifyAssault);

  return true;
}

defaultproperties
{
    ServerInfoClass=Class'botpack.ServerInfoAS'
}
