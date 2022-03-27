// ============================================================
// fixes team name bug.
// Psychic_313: unchanged
// ============================================================

class oldskoolTeamScoreBoard expands UnrealTeamScoreBoard;
var TournamentGameReplicationInfo OwnerGame;

var bool bCheckedRegFont;

function ShowScores( canvas Canvas )
{
  local PlayerReplicationInfo PRI;
  local int PlayerCount, I, XOffset;
  local int LoopCountTeam[4];
  local float XL, YL, YOffset;
  local TeamInfo TI;
  OwnerGame = TournamentGameReplicationInfo(PlayerPawn(Owner).GameReplicationInfo);

  if (!bCheckedRegFont && oldskoolbasehud(OwnerHUD) != None)
  {
    bCheckedRegFont = true;
	if (RegFont == Font'WhiteFont')
	  RegFont = oldskoolbasehud(OwnerHUD).MyFonts.GetMediumFont(Canvas.ClipX);
  }

  Canvas.Font = RegFont;

  // Header
  DrawHeader(Canvas);

  // Trailer
  DrawTrailer(Canvas);

  for ( I=0; I<16; I++ )
    Scores[I] = -500;

  for ( I=0; I<4; I++ )
    PlayerCounts[I] = 0;

  PlayerCount = 0;
  for ( i=0; i<32; i++ )
  {
    if (PlayerPawn(Owner).GameReplicationInfo.PRIArray[i] != None)
    {
      PRI = PlayerPawn(Owner).GameReplicationInfo.PRIArray[i];
      if ( !PRI.bIsSpectator || PRI.bWaitingPlayer )
      {
        PlayerNames[PlayerCount] = PRI.PlayerName;
      TeamNames[PlayerCount] = PRI.TeamName;
      Scores[PlayerCount] = PRI.Score;
      Teams[PlayerCount] = PRI.Team;
      Pings[PlayerCount] = PRI.Ping;
        PlayerCount++;
        PlayerCounts[PRI.Team]++;
      }
    }
  }
  SortScores(PlayerCount);

  for ( I=0; I<PlayerCount; I++ )
  {
    if ( Teams[I] % 2 == 1 )
      XOffset = Canvas.ClipX/8 + Canvas.ClipX/2;
    else
      XOffset = Canvas.ClipX/8;
    Canvas.DrawColor = AltTeamColor[Teams[I]];

    // Player name
    DrawName( Canvas, I, XOffset, LoopCountTeam[Teams[I]] );

    // Player ping
    DrawPing( Canvas, I, XOffset, LoopCountTeam[Teams[I]] );

    // Player score
    Canvas.DrawColor = TeamColor[Teams[I]];
    DrawScore( Canvas, I, XOffset, LoopCountTeam[Teams[I]] );

    LoopCountTeam[Teams[I]]++;
  }

 for ( i=0; i<4; i++ )
  {
    if (PlayerCounts[i] > 0)
    {
      if ( i % 2 == 1 )    //the % means divide and give remainder..... wow...these Epic guyz can code ;)
        XOffset = Canvas.ClipX/8 + Canvas.ClipX/2;
      else
        XOffset = Canvas.ClipX/8;
       if (i - 1 > 0)
          YOffset = Canvas.ClipY/4 + PlayerCounts[i - 2] * 16 + 32;
        else
          YOffset = Canvas.ClipY/4 - 16;
       Canvas.DrawColor = TeamColor[i];
      Canvas.SetPos(XOffset, Yoffset);           //only thing that had to be changed (don't know why epic did it this way)
      Canvas.StrLen(TeamName[i], XL, YL);
      Canvas.DrawText(TeamName[i], false);
      Canvas.SetPos(XOffset + 96, Yoffset);
      Canvas.DrawText(int(OwnerGame.Teams[i].Score), false);
    }
  }

  Canvas.DrawColor.R = 255;
  Canvas.DrawColor.G = 255;
  Canvas.DrawColor.B = 255;
}

defaultproperties
{
}
