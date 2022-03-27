// ============================================================
// team hud with real ctf enhancements.....
// Psychic_313: unchanged
// ============================================================

class oldskoolteamhud expands oldskoolbaseHUD;
// RealTeamHUD
#exec TEXTURE IMPORT NAME=I_RealRedSkull FILE=TEXTURES\I_RealRedSkull.PCX GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=I_RealBlueSkull FILE=TEXTURES\I_RealBlueSkull.PCX GROUP="Icons" MIPS=OFF
var bool bTraceIdentify;

//reduction of iterators....
simulated function DrawTeamGameSynopsis(Canvas Canvas)
{
  local TeamInfo TI;
  local float XL, YL;
  local TournamentGameReplicationInfo GRI;
  local int i;

  if (class==class'realctfhud') //dont do this for CTF (scores on right side)
  return;
  GRI = TournamentGameReplicationInfo(PlayerOwner.GameReplicationInfo);
  if ( GRI != None ){
  for ( i=0 ;i<4; i++ )
  {
    Ti=GRI.Teams[i];
    if (TI.Size > 0)
    {
      Canvas.Font = MyFonts.GetMediumFont(Canvas.ClipX);
      Canvas.DrawColor = TeamColor[TI.TeamIndex]; 
      Canvas.StrLen(TeamName[TI.TeamIndex], XL, YL);
      Canvas.SetPos(0, Canvas.ClipY - 128 + 16 * TI.TeamIndex);
      Canvas.DrawText(TeamName[TI.TeamIndex], false);
      Canvas.SetPos(XL, Canvas.ClipY - 128 + 16 * TI.TeamIndex);
      Canvas.DrawText(int(TI.Score), false);
    }
  }
  }
  Canvas.DrawColor.R = 255;
  Canvas.DrawColor.G = 255;
  Canvas.DrawColor.B = 255;
}
final simulated function int OwnerTeam()
{
  local byte Team;
  local Pawn p;

  Team = 255;
  p = Pawn(Owner);
  if (p != none) {
    if (p.PlayerReplicationInfo != none) {
      Team = p.PlayerReplicationInfo.Team;
    }
  }
  return(Team);
}
simulated function bool TraceIdentify(canvas Canvas)
{
  local actor Other;
  local vector HitLocation, HitNormal, X, Y, Z, StartTrace, EndTrace;
  local PlayerPawn ppOwner;

  ppOwner = PlayerPawn(Owner);
  StartTrace = Owner.Location;
  StartTrace.Z += ppOwner.BaseEyeHeight;

  EndTrace = StartTrace + vector(ppOwner.ViewRotation) * 1000.0;

  Other = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);

  if (Other != none) {
    if ( (Pawn(Other) != None) && (Pawn(Other).bIsPlayer) )
    {
      IdentifyTarget = Pawn(Other);
      IdentifyFadeTime = 3.0;
    }
  }
  else if ( (Other != None) && SpecialIdentify(Canvas, Other) )
    return false; //we can leave here...
  if ( IdentifyFadeTime == 0.0 ) {
    bTraceIdentify = false;
  } else if ( (IdentifyTarget == None) || (!IdentifyTarget.bIsPlayer) ||
    (IdentifyTarget.PlayerReplicationInfo == None )) {
    bTraceIdentify = false;
  } else if (IdentifyTarget.bHidden) {
    if (ppOwner.GameReplicationInfo.bTeamGame &&
      (IdentifyTarget.PlayerReplicationInfo.Team == 
       ppOwner.PlayerReplicationInfo.Team)) {
      // Invisible teammates are identified
      bTraceIdentify = true;
    } else {
      bTraceIdentify = false;
    }
  } else {
    bTraceIdentify = true;
  }

  return(bTraceIdentify);
}

simulated function bool SpecialIdentify(Canvas Canvas, Actor Other )    //for DOM
{
  return false;
}
function DrawTalkFace(Canvas Canvas, float YPos)    //draw the face.....     (with team stuff)
{
  if ( Hudmode<5 )
  {
    Canvas.Style = ERenderStyle.STY_Normal;
    Canvas.SetPos(armoroffset, 4);
    Canvas.DrawColor = FaceTeam;
    Canvas.DrawTile(texture'botpack.LadrStatic.Static_a00',Ypos + 7, YPos + 7, 0-faceareaoffset, 0, texture'FacePanel1'.USize-faceareaoffset, texture'FacePanel1'.VSize);
    Canvas.DrawColor = WhiteColor;
    Canvas.Style = ERenderStyle.STY_Normal;
    Canvas.SetPos(armoroffset, 4);
    Canvas.DrawTile(FaceTexture, Ypos-1, YPos - 1, 0-faceareaoffset, 0, FaceTexture.USize-faceareaoffset, FaceTexture.VSize);
    Canvas.Style = ERenderStyle.STY_Translucent;
    Canvas.DrawColor = FaceColor;
    Canvas.SetPos(armoroffset, 0);
    Canvas.DrawTile(texture'botpack.LadrStatic.Static_a00',Ypos + 7, YPos + 7, 0-faceareaoffset, 0, texture'botpack.LadrStatic.Static_a00'.USize-faceareaoffset, texture'botpack.LadrStatic.Static_a00'.VSize);
    Canvas.DrawColor = WhiteColor;
  }
}

final simulated function DrawSkull(Canvas Canvas, int X, int Y, texture SkullTexture, optional bool bDrawRed)
{ 
  local int iScore;

  Canvas.SetPos(X,Y);
  Canvas.DrawIcon(SkullTexture, Scale);  
  Canvas.CurX -= 19 * Scale;
  Canvas.CurY += 23 * Scale;
  Canvas.Font = MyFonts.GetSmallFont(Canvas.ClipX);

  iScore = 0;
  if (Owner.IsA('playerPawn')) {
    if (PawnOwner.PlayerReplicationInfo != none) {
      iScore = PawnOwner.PlayerReplicationInfo.Score;
    }
  }
  // TODO: Scale CurX
  if (iScore<100) Canvas.CurX+=6;
  if (iScore<10) Canvas.CurX+=6;  
  if (iScore<0) Canvas.CurX-=6;

  if (bDrawRed) {
    Canvas.DrawColor.G = 0;
    Canvas.DrawColor.B = 0;
  }
  Canvas.DrawText(iScore,False);
  if (bDrawRed) {
    Canvas.DrawColor.G = 255;
    Canvas.DrawColor.B = 255;
  }
}
simulated function DrawIdentifyInfo(canvas Canvas, float PosX, float PosY)
{
  local float XL, YL, XOffset;

  if (!TraceIdentify(Canvas))
    return;

  Canvas.Font = MyFonts.GetMediumFont(Canvas.ClipX);
  Canvas.Style = 3;

  XOffset = 0.0;
  Canvas.StrLen(IdentifyName$": "$IdentifyTarget.PlayerReplicationInfo.PlayerName, XL, YL);
  XOffset = Canvas.ClipX/2 - XL/2;
  Canvas.SetPos(XOffset, Canvas.ClipY - 74);

  if(IdentifyTarget.PlayerReplicationInfo.PlayerName != "")
  {
    SetDrawColor(Canvas,IdentifyTarget.PlayerReplicationInfo.Team,2,IdentifyFadeTime);
    Canvas.StrLen(IdentifyName$": ", XL, YL);
    XOffset += XL;
    Canvas.DrawText(IdentifyName$": ");
    Canvas.SetPos(XOffset, Canvas.ClipY - 74);

    SetDrawColor(Canvas,IdentifyTarget.PlayerReplicationInfo.Team,1,IdentifyFadeTime);
    Canvas.StrLen(IdentifyTarget.PlayerReplicationInfo.PlayerName, XL, YL);
    Canvas.DrawText(IdentifyTarget.PlayerReplicationInfo.PlayerName);
  }

  XOffset = 0.0;
  Canvas.StrLen(IdentifyHealth$": "$IdentifyTarget.Health, XL, YL);
  XOffset = Canvas.ClipX/2 - XL/2;
  Canvas.SetPos(XOffset, Canvas.ClipY - 64);

  if (PlayerPawn(Owner).GameReplicationInfo.bTeamGame &&
    (Pawn(Owner).PlayerReplicationInfo.Team == IdentifyTarget.PlayerReplicationInfo.Team)) {
    SetDrawColor(Canvas,IdentifyTarget.PlayerReplicationInfo.Team,2,IdentifyFadeTime);
    Canvas.StrLen(IdentifyHealth$": ", XL, YL);
    XOffset += XL;
    Canvas.DrawText(IdentifyHealth$": ");
    Canvas.SetPos(XOffset, Canvas.ClipY - 64);

    SetDrawColor(Canvas,IdentifyTarget.PlayerReplicationInfo.Team,1,IdentifyFadeTime);
    Canvas.StrLen(IdentifyTarget.Health, XL, YL);
    Canvas.DrawText(IdentifyTarget.Health);
  }

  Canvas.Style = 1;
  Canvas.DrawColor.R = 255;
  Canvas.DrawColor.G = 255;
  Canvas.DrawColor.B = 255;
}
simulated function DrawFragCount(Canvas Canvas, int X, int Y)
{
  local texture SkullTexture;
  if (realicons)
  Skulltexture = texture'realskull';
  else
  SkullTexture = texture'IconSkull';     //default.......
  switch (ownerTeam()) {
    case 0:
      if (realicons)
      SkullTexture = Texture'I_RealRedSkull';
      else
      SkullTexture = Texture'redskull';
      break;
     case 1:
      if (realicons)
      SkullTexture = Texture'I_RealBlueSkull';
      else
      Skulltexture = Texture'blueskull';
      break;
    case 2:
      SkullTexture = texture'GreenSkull';        //normal skullz for these colors.....  (no realctf versions)
      break;
    case 3:
      SkullTexture = texture'YellowSkull';
      break;
  }
  If (pawnowner.PlayerReplicationInfo.Team!=255||!realicons)
  DrawSkull(Canvas, X, Y, SkullTexture);
  else
  DrawSkull(Canvas, X, Y, SkullTexture, true);

}

defaultproperties
{
    ServerInfoClass=Class'botpack.ServerInfoTeam'
}
