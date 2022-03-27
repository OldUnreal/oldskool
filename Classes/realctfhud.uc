// ============================================================
//HUD taken from realctf.... and edited for ctf-plus, so to speak.....
// Psychic_313: Hey, UsAaR33, if Team is 0 or 1, Abs(Team-1) == 1-Team.
// Sorry, the extra Abs() just offended my sense of mathematical laziness :-)
// ============================================================

class realctfhud expands oldskoolteamhud;
// RealCTFHUD
#exec TEXTURE IMPORT NAME=I_RealRedFlagGone FILE=TEXTURES\I_RealRedFlagGone.PCX GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=I_RealRedFlagInBase FILE=TEXTURES\I_RealRedFlagInBase.PCX GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=I_RealBlueFlagGone FILE=TEXTURES\I_RealBlueFlagGone.PCX GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=I_RealBlueFlagInBase FILE=TEXTURES\I_RealBlueFlagInBase.PCX GROUP="Icons" MIPS=OFF
var CTFFlag MyFlag;
simulated function postbeginplay(){
Super.PostBeginPlay();
  SetTimer(1.0, True);
  }
function Timer()    //message thing....
{
if ( (PlayerOwner == None) || (Pawn(Owner) == None) )
     return;
  if ( Pawn(Owner).PlayerReplicationInfo.HasFlag != None )
    PlayerOwner.ReceiveLocalizedMessage( class'CTFMessage2', 0 );
  if ( (MyFlag != None) && !MyFlag.bHome )
    PlayerOwner.ReceiveLocalizedMessage( class'CTFMessage2', 1 );
}
simulated function DrawFlag(Canvas Canvas, int X, int Y, int teamindex)
{ 
  local Texture texFlag;
  local CTFFlag Flag;
  local int iScore;
  local playerreplicationInfo pri;
  local float fWidth,fHeight;
  local color colorOld;
  //local CTFReplicationInfo CTFReplicationInfo;
  local teaminfo ti;
  local TournamentGameReplicationInfo GRI;

  
  if ( (PlayerOwner == None) || (PlayerOwner.GameReplicationInfo == None))
    return;
  Flag = CTFReplicationInfo(PlayerOwner.GameReplicationInfo).FlagList[teamindex];
  // Determine which flag status icon to draw
  if ( Flag != None )
      {
  if (Flag.Team == Pawn(Owner).PlayerReplicationInfo.Team)
          MyFlag = Flag;
  if (TeamIndex == 0) {
    // Red team
    if (Flag.bHome)
      texFlag = Texture'I_RealRedFlagInBase';
     else
      texFlag = Texture'I_RealRedFlagGone';

  } else if (TeamIndex == 1) {
    // Blue team
   if ( Flag.bHome )
      texFlag = Texture'I_RealBlueFlagInBase';
     else
      texFlag = Texture'I_RealBlueFlagGone';

  } else  //error
    return;
  }
  else //error
  return;

  // Draw flag status icon
  Canvas.SetPos(X,Y);
  Canvas.DrawIcon(texFlag, 1.0);  

  // Draw team score
  Canvas.CurX -= 25;
  Canvas.CurY += 23;
  Canvas.Font = MyFonts.GetSmallFont(Canvas.ClipX);
  GRI = TournamentGameReplicationInfo(PlayerOwner.GameReplicationInfo);
  TI = GRI.Teams[teamindex];
  iScore = int(ti.Score);
  // TODO: Scale CurX
  if (iScore < 1000) Canvas.CurX+=6;
  if (iScore < 100) Canvas.CurX+=6;
  if (iScore < 10) Canvas.CurX+=6;  
  if (iScore < 0) Canvas.CurX-=6;
  Canvas.DrawText(iScore);

  if (Flag.bHeld) {
    // Draw name of flag carrier
    if (level.netmode!=nm_client)
    pri = flag.Holder.playerreplicationinfo;
    else //client-side replication.  I have to go through the entire PRIs to find it :(
    pri = findflagholder(flag);
    if (pri != none) {
      Canvas.Font = MyFonts.GetMediumFont(Canvas.ClipX);
      Canvas.StrLen(pri.PlayerName,fWidth,fHeight);
      if (X == 0) {
        Canvas.CurX = X + 34;
      } else {
        Canvas.CurX = X - fWidth - 2;
      }
      Canvas.CurY = Y + (32 - fHeight);
      SetDrawColor(Canvas,pri.Team,2);
      Canvas.DrawText(pri.PlayerName);
      Canvas.DrawColor.R = 255;
      Canvas.DrawColor.G = 255;
      Canvas.DrawColor.B = 255;
    }
  }
}

simulated function DrawFlagStatus(Canvas Canvas, int X, int Y)
{
  local texture texBase;
  local int Team;

  // Friendly flag
  Team = OwnerTeam();
  if (Team == 255)
    // Spectator
    Team = 0;


   // Draw friendly flag in place
    DrawFlag(Canvas,X,Y,Team);


  // Enemy flag
  // Draw enemy flag status above friendly flag status
  // Psychic_313: I do maths :-)    UsAaR33: hehe
    DrawFlag(Canvas,X,Y-32,1 - Team);

}

simulated function DrawFragCount(Canvas Canvas, int X, int Y)
{
  Super.DrawFragCount(Canvas,X,Y);
  DrawFlagStatus(Canvas,X,Y-42);
}
final simulated function Playerreplicationinfo FindFlagHolder (ctfflag flag){   //search through PRIs to get flag holder
local int i;
for (i=0;i<32;i++){
  if (playerowner.gamereplicationinfo.priarray[i]==none)
    return none;  //?
  if (playerowner.gamereplicationinfo.priarray[i].hasflag==flag)
    return playerowner.gamereplicationinfo.priarray[i];
}
}
defaultproperties
{
    ServerInfoClass=Class'botpack.ServerInfoCTF'
}
