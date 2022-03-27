// ============================================================
//oldskoolspectatorhud.  The HUD for spectators (to use parent's stuff :D)
// Psychic_313: unchanged
// ============================================================

class OldSkoolspectatorhud expands OldSkoolBASEHUD;
simulated function PostRender( canvas Canvas )
{
local float ypos, YL, XL, fadevalue;
local int i;
  local float StartX;

  HUDSetup(canvas);

  if ( PlayerPawn(Owner) != None )
  {
    if ( bShowInfo )         //check this first
  {
    ServerInfo.RenderInfo( Canvas );
    return; }
    if ( PlayerPawn(Owner).bShowMenu  )
    {
      DisplayMenu(Canvas);
      return;
    }
    if ( PlayerPawn(Owner).bShowScores )
    {
      if ( (PlayerPawn(Owner).Scoring == None) && (PlayerPawn(Owner).ScoringType != None) )
        PlayerPawn(Owner).Scoring = Spawn(PlayerPawn(Owner).ScoringType, PlayerPawn(Owner));
      if ( PlayerPawn(Owner).Scoring != None )
      { 
        PlayerOwner.Scoring.OwnerHUD = self;
        PlayerPawn(Owner).Scoring.ShowScores(Canvas);
        return;
      }
    }
    else if ( PlayerPawn(Owner).ProgressTimeOut > Level.TimeSeconds )
      DisplayProgressMessage(Canvas);
        // Master localized message control loop.
    for (i=0; i<10; i++)
    {
      if (LocalMessages[i].Message != None)
      {
        if (LocalMessages[i].Message.Default.bFadeMessage && Level.bHighDetailMode)
        {
          Canvas.Style = ERenderStyle.STY_Translucent;
          FadeValue = (LocalMessages[i].EndOfLife - Level.TimeSeconds);
          if (FadeValue > 0.0)
          {
            if ( bResChanged || (LocalMessages[i].XL == 0) )
            {
              if ( LocalMessages[i].Message.Static.GetFontSize(LocalMessages[i].Switch) == 1 )
                LocalMessages[i].StringFont = MyFonts.GetBigFont( Canvas.ClipX );
              else // ==2
                LocalMessages[i].StringFont = MyFonts.GetHugeFont( Canvas.ClipX );
              Canvas.Font = LocalMessages[i].StringFont;
              Canvas.StrLen(LocalMessages[i].StringMessage, LocalMessages[i].XL, LocalMessages[i].YL);
              LocalMessages[i].YPos = LocalMessages[i].Message.Static.GetOffset(LocalMessages[i].Switch, LocalMessages[i].YL, Canvas.ClipY);
            }
            Canvas.Font = LocalMessages[i].StringFont;
            Canvas.DrawColor = LocalMessages[i].DrawColor * (FadeValue/LocalMessages[i].LifeTime);
            Canvas.SetPos( 0.5 * (Canvas.ClipX - LocalMessages[i].XL), LocalMessages[i].YPos );
            Canvas.DrawText( LocalMessages[i].StringMessage, False );
          }
        } 
        else 
        {
          if ( bResChanged || (LocalMessages[i].XL == 0) )
          {
            if ( LocalMessages[i].Message.Static.GetFontSize(LocalMessages[i].Switch) == 1 )
              LocalMessages[i].StringFont = MyFonts.GetBigFont( Canvas.ClipX );
            else // == 2
              LocalMessages[i].StringFont = MyFonts.GethugeFont( Canvas.ClipX );
            Canvas.Font = LocalMessages[i].StringFont;
            Canvas.StrLen(LocalMessages[i].StringMessage, LocalMessages[i].XL, LocalMessages[i].YL);
            LocalMessages[i].YPos = LocalMessages[i].Message.Static.GetOffset(LocalMessages[i].Switch, LocalMessages[i].YL, Canvas.ClipY);
          }
          Canvas.Font = LocalMessages[i].StringFont;
          Canvas.Style = ERenderStyle.STY_Normal;
          Canvas.DrawColor = LocalMessages[i].DrawColor;
          Canvas.SetPos( 0.5 * (Canvas.ClipX - LocalMessages[i].XL), LocalMessages[i].YPos );
          Canvas.DrawText( LocalMessages[i].StringMessage, False );
        }
      }
    }
    Canvas.Style = ERenderStyle.STY_Normal;
  //start unreal messages loop.
  drawunrealmessages(canvas);
    Canvas.DrawColor.r = 255;     //reset
  Canvas.DrawColor.g = 255;
  Canvas.DrawColor.b = 255;
  Canvas.Font = Font'WhiteFont';
  }
    // Display Identification Info
  DrawIdentifyInfo(Canvas, 0, Canvas.ClipY - 64.0);

  // Message of the Day / Map Info Header
  if (MOTDFadeOutTime != 0.0)
    DrawMOTD(Canvas);

  if ( HUDMutator != None )
      HUDMutator.PostRender(Canvas);     //use hud mutators.....
  if (Canvas.ClipY<290) Return;

  Canvas.Style = ERenderStyle.STY_Translucent;
  StartX = 0.5 * Canvas.ClipX - 128;  
  Canvas.SetPos(StartX,Canvas.ClipY-58);
  Canvas.DrawTile( Texture'MenuBarrier', 256, 64, 0, 0, 256, 64 );
  Canvas.Style = ERenderStyle.STY_Normal;
  StartX = 0.5 * Canvas.ClipX - 128;
  Canvas.SetPos(StartX,Canvas.ClipY-52);
  Canvas.DrawIcon(texture'Logo2', 1.0);  
  Canvas.Style = 1;
}

defaultproperties
{
}
