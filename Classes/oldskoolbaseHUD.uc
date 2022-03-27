// ============================================================
//oldskoolbasehud.  parent of both DM & SP HUDS...... includes many DM enhancements.....
// Psychic_313: unchanged
// ============================================================

class OldSkoolBASEHUD expands UnrealHUD
config;
//realctf skull
#exec TEXTURE IMPORT NAME=RealSkull FILE=TEXTURES\RealSkull.PCX GROUP="Icons" MIPS=OFF
var color BaseColor, WhiteColor, RedColor, GreenColor, CyanColor, UnitColor, BlueColor,
     GoldColor, HUDColor, SolidHUDColor, PurpleColor, TurqColor, GrayColor, FaceColor;
//configuration bools
var globalconfig int olCrosshair;    //so it doesn't interfere with challenge hud's....
var globalconfig bool realicons;
//talktexture stuff.....
var globalconfig bool showtalkface;
var globalconfig bool showfrag; //if we want the frag counter shown in SP that is...... :D
var bool bDrawFaceArea;
var float FaceAreaOffset, MinFaceAreaOffset, facemsgset;
var texture FaceTexture;
var float FaceTime;
var color FaceTeam;
// Server info.
var ServerInfo ServerInfo;
var bool bShowInfo;
var Pawn PawnOwner;  // pawn currently managing this HUD (may be the viewtarget of the owner rather than the owner)
var HUDLocalizedMessage LocalMessages[10];
var bool bResChanged;
var int MessageNumber;
var int OldClipX;
var bool nohud;  //for endgames and teamvortex....
var FontInfo MyFonts;    //for da fonts
var translator translator; //univ as various functions require it.

var class<ServerInfo> ServerInfoClass;
Struct somemessage
{
var name Type;
var PlayerReplicationInfo PRI;
var float lifetime;//don't use console. need to know time of message
var string contents; //what it says :P
};
var somemessage ShortMessages[4];  //events
var somemessage CurrentPickup; //last pickup message
var somemessage CriticalMessage; //last criticalevent

// OldUnreal additions
var float HUDScale, Scale;

// If we allow the HUD and fonts to scale independently, we might need to adjust the Y offset of
// icon + text pairs (e.g., health/armor) to ensure that they are nicely centered
function GetIconAndTextOffsets(Canvas Canvas, Texture Icon, out float IconYOffset, out float TextYOffset)
{
  local float GlyphX, GlyphY, ScaledIconY;

  Canvas.StrLen("0", GlyphX, GlyphY);
  ScaledIconY = Icon.VSize * Scale;

  if (ScaledIconY > GlyphY)
	TextYOffset = (ScaledIconY-GlyphY) / 2;
  else
    IconYOffset = (GlyphY-ScaledIconY) / 2;
}

function GetInvIconAndTextOffsets(Canvas Canvas, Inventory Inv, out float IconYOffset, out float TextYOffset)
{
  local float GlyphX, GlyphY, ScaledIconY;

  Canvas.StrLen("0", GlyphX, GlyphY);
  ScaledIconY = GetInvIconVSize(Inv) * Scale;

  if (ScaledIconY > GlyphY)
	TextYOffset = (ScaledIconY-GlyphY) / 2;
  else
    IconYOffset = (GlyphY-ScaledIconY) / 2;
}

// gets non-scaled VSize for the Inventory's Icon
function float GetInvIconVSize(Inventory Inv)
{
  local Texture Icon;

  Icon = Inv.Icon;
  if (Icon == None)
  {
    Icon = FindIcon(Inv);
	if (Icon == None)
	  return 0.0;
  }

  return Icon.VSize;
}

function Destroyed()
{
  Super.Destroyed();
  if ( MyFonts != None )
    MyFonts.Destroy();
}
exec function ShowServerInfo()
{
  if (bShowInfo)
  {
    bShowInfo = False;
  } else {
    bShowInfo = True;
    PlayerPawn(Owner).bShowScores = False;
  }
}
simulated function Timer()    //for ending hud h4x
{
  MessageNumber++;
}
simulated function postbeginplay(){       //defaults that get set this way....
Super.Postbeginplay();
FaceAreaOffset = -64;
if(Level.DefaultGameType == class'endgame')  //verify the gametypes and set accordingly..
nohud=true;
MyFonts = spawn(Class'Botpack.FontInfo');
if (level.title~="Ending Sequence")
  Event='EndShip';
if (!isa('oldskoolhud')){
  ServerInfo = Spawn(ServerInfoClass, Owner);
  //set slot defaults:
  class'rocketpack'.default.UsedInWeaponSlot[5]=0;
  class'rocketpack'.default.UsedInWeaponSlot[9]=1;
  class'Pammo'.default.UsedInWeaponSlot[3]=0;
  class'Pammo'.default.UsedInWeaponSlot[5]=1;
  class'bladehopper'.default.UsedInWeaponSlot[7]=0;
  class'bladehopper'.default.UsedInWeaponSlot[6]=1;
  class'bulletbox'.default.UsedInWeaponSlot[9]=0;
  class'bulletbox'.default.UsedInWeaponSlot[0]=1;
  class'flakammo'.default.UsedInWeaponSlot[6]=0;
  class'flakammo'.default.UsedInWeaponSlot[8]=1;
  class'miniammo'.default.UsedInWeaponSlot[0]=0;
  class'miniammo'.default.UsedInWeaponSlot[7]=1;
  class'bioammo'.default.UsedInWeaponSlot[8]=0;
  class'bioammo'.default.UsedInWeaponSlot[3]=1;
}
}
//new functionz to add stuff
simulated function postrender(canvas canvas){
  local float ypos, YL, XL, fadevalue;
  local int i;
  local float StartX;    //endgame floatz....
  local InterpolationPoint ip;
  local int TempX,TempY;
  local Actor A;
  local Decoration D;
  local Font TmpFont;
  HUDSetup(canvas);
  if ( PlayerPawn(Owner) != None )
  {
    if ( PlayerPawn(Owner).PlayerReplicationInfo == None )
      return;
	  
    if ( bShowInfo && !self.isa('oldskoolhud'))         //check this first
    {
      ServerInfo.RenderInfo( Canvas );
      return;
	}
	
    if ( PlayerPawn(Owner).bShowMenu )       //will end up going to uwindow (only called in sp mode)..
    {
      DisplayMenu(Canvas);
      return;
    }
	
   if (!nohud)
   {
     bDrawFaceArea = false;
     if ( showtalkface && !PlayerOwner.bShowScores  && Hudmode<5 )
     {
       bDrawFaceArea = (FaceTexture != None) && (FaceTime > Level.TimeSeconds);
     }

     if ( PlayerPawn(Owner).bShowScores )
     {
       if ( ( PlayerPawn(Owner).Weapon != None ) && ( !PlayerPawn(Owner).Weapon.bOwnsCrossHair ) )
         DrawCrossHair(Canvas, 0.5 * Canvas.ClipX - 8, 0.5 * Canvas.ClipY - 8);
       if ( (PlayerPawn(Owner).Scoring == None) && (PlayerPawn(Owner).ScoringType != None) )
         PlayerPawn(Owner).Scoring = Spawn(PlayerPawn(Owner).ScoringType, PlayerPawn(Owner));
       if ( PlayerPawn(Owner).Scoring != None )
       { 
         PlayerOwner.Scoring.OwnerHUD = self;
         PlayerPawn(Owner).Scoring.ShowScores(Canvas);
         DrawTypingPrompt(Canvas, playerpawn(owner).player.Console); //allow typing to show.
         Drawunrealmessages(canvas); //show events, needed at end of game.
         return;
       }
	 }
     else if ( (PawnOwner.Weapon != None) && (Level.LevelAction == LEVACT_None) )
     {
	   Canvas.Font = MyFonts.GetMediumFont(Canvas.ClipX);
       PawnOwner.Weapon.PostRender(Canvas);
       Canvas.Style = ERenderStyle.STY_Normal;
       Canvas.DrawColor.r = 255;     //reset
       Canvas.DrawColor.g = 255;
       Canvas.DrawColor.b = 255;
	   Canvas.Font = MyFonts.GetMediumFont(Canvas.ClipX);  
       if ( !PawnOwner.Weapon.bOwnsCrossHair )
         DrawCrossHair(Canvas, 0.5 * Canvas.ClipX - 8, 0.5 * Canvas.ClipY - 8);
     }
	
	 Canvas.Font = MyFonts.GetMediumFont(Canvas.ClipX);  
     Canvas.StrLen("TEST", XL, YL);
     YPos = FMax(YL*4 + 8, 70);
     if ( bDrawFaceArea )
	 {
	   facemsgset=Ypos+7+faceareaoffset;
       //log ("facemsg set is set to "$facemsgset$".  Ypos is set to "$ypos$".   The face to be drawn is "$facetexture);
       DrawTalkFace( Canvas, YPos );
	 }
     else
	 {
       facemsgset=0; //ensure it is 0.......
       faceareaoffset=-64;
     }
     if ( PlayerPawn(Owner).ProgressTimeOut > Level.TimeSeconds )
       DisplayProgressMessage(Canvas);
   }
   else if ( PlayerPawn(Owner).bShowScores )
   {
     if ( (PlayerPawn(Owner).Scoring == None) && (PlayerPawn(Owner).ScoringType != None) )
       PlayerPawn(Owner).Scoring = Spawn(PlayerPawn(Owner).ScoringType, PlayerPawn(Owner));
     if ( PlayerPawn(Owner).Scoring != None )
     { 
       PlayerOwner.Scoring.OwnerHUD = self;
       PlayerPawn(Owner).Scoring.ShowScores(Canvas);
     }
     return;
   }
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
			Canvas.DrawText( string(LocalMessages[i].Message)@LocalMessages[i].StringMessage, False );
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
          Canvas.DrawText( string(LocalMessages[i].Message)@LocalMessages[i].StringMessage, False );
        }
      }
    }
    Canvas.Style = ERenderStyle.STY_Normal;
    Canvas.DrawColor.r = 255;     //reset
  Canvas.DrawColor.g = 255;
  Canvas.DrawColor.b = 255;
  Canvas.Font = MyFonts.GetMediumFont(Canvas.ClipX);
  }
  if (!nohud){
  if (HudMode==5) 
  {
    DrawInventory(Canvas, Canvas.ClipX - 96 * Scale, 0,False);    
    Return;
  }
  if (Canvas.ClipX<320) HudMode = 4;

  TmpFont = Canvas.Font;
  Canvas.Font = MyFonts.GetBigFont(Canvas.ClipX);
  Canvas.StrLen("A", XL, YL);
  Canvas.Font = TmpFont;

  // Draw Armor
  if (HudMode<2) DrawArmor(Canvas, 0, 0, False);
  else if (HudMode==3 || HudMode==2) DrawArmor(Canvas, 0, Canvas.ClipY-Max(YL, 32 * Scale),False);
  else if (HudMode==4) DrawArmor(Canvas, Canvas.ClipX-64*Scale, Canvas.ClipY-Max(YL * 2, 64 * Scale),True);
  
  // Draw Ammo
  if (HudMode!=4) DrawAmmo(Canvas, Canvas.ClipX-(32+64)*Scale, Canvas.ClipY-Max(YL, 32*Scale));
  else DrawAmmo(Canvas, Canvas.ClipX-32*Scale, Canvas.ClipY-Max(YL, 32*Scale));
  
  // Draw Health
  if (HudMode<2) DrawHealth(Canvas, 0, Canvas.ClipY-Max(YL, 32*Scale));
  else if (HudMode==3||HudMode==2) DrawHealth(Canvas, Canvas.ClipX-128*Scale, Canvas.ClipY-Max(YL, 32*Scale));
  else if (HudMode==4) DrawHealth(Canvas, Canvas.ClipX-64*Scale, Canvas.ClipY-Max(YL, 32*Scale));
    
  // Display Inventory
  if (HudMode<2) DrawInventory(Canvas, Canvas.ClipX - 96 * Scale,0,False);
  else if (HudMode==3) DrawInventory(Canvas, Canvas.ClipX-96*Scale, Canvas.ClipY-Max(YL, 32*Scale)-32*Scale,False);
  else if (HudMode==4) DrawInventory(Canvas, Canvas.ClipX-64*Scale, Canvas.ClipY-Max(YL, 32*Scale)-32*Scale,True);
  else if (HudMode==2) DrawInventory(Canvas, Canvas.ClipX/2-64*Scale, Canvas.ClipY-Max(YL, 32*Scale),False);  

  // Display Frag count (redone to allow in SP....
  if (!self.isa('oldskoolhud')||showfrag)
  {
    if (HudMode<3) DrawFragCount(Canvas, Canvas.ClipX-32*Scale,Canvas.ClipY-Max(YL, 32*Scale)-32*Scale);
    else if (HudMode==3) DrawFragCount(Canvas, 0,Canvas.ClipY-Max(YL, 32*Scale)-32*Scale);
    else if (HudMode==4) DrawFragCount(Canvas, 0,Canvas.ClipY-32*Scale);
  }

  // Display Identification Info
  DrawIdentifyInfo(Canvas, 0, Canvas.ClipY-YL*2);
  }
  // Endgame h4x.....
  if (level.title~="Ending Sequence"){
     ip = InterpolationPoint(PlayerPawn(Owner).Target);
    
    
    if (ip!=None && ip.Position==50) PlayerPawn(Owner).AmbientSound=None;
    
    else if (ip!=None && ip.Position > 51)
    {
      if (MessageNumber==0) 
      {
        MessageNumber++;
        SetTimer(17.0,True);
      }
      HudSetup(Canvas);
      Canvas.bCenter = false;
      Canvas.Font = MyFonts.GetMediumFont(Canvas.ClipX);
      TempX = Canvas.ClipX;
      TempY = Canvas.ClipY;  
      if (MessageNumber < 7){
      XL=canvas.orgx;
      YL=canvas.orgy;
      Canvas.SetOrigin(20,Canvas.ClipY-64);
      Canvas.SetClip(225,110);}
      Canvas.SetPos(0,0);
      Canvas.Style = 1;  
      if (MessageNumber == 1) Canvas.DrawText(class'unreali.endgamehud'.default.Message1, False);
      else if (MessageNumber == 2) Canvas.DrawText(class'unreali.endgamehud'.default.Message2, False);
      else if (MessageNumber == 3) Canvas.DrawText(class'unreali.endgamehud'.default.Message3, False);
      else if (MessageNumber == 4) Canvas.DrawText(class'unreali.endgamehud'.default.Message4, False);
      else if (MessageNumber == 5) Canvas.DrawText(class'unreali.endgamehud'.default.Message5, False);
      else if (MessageNumber == 6) Canvas.DrawText(class'unreali.endgamehud'.default.Message6, False);    
      else if (MessageNumber > 6) {
        Hudsetup(canvas);
        WindowConsole(Playerpawn(Owner).Player.Console).LaunchUWindow();
      }  //open window (rather than green thingy...)
      if (MessageNumber<7) {
        canvas.clipx=TempX;
        canvas.clipy=TempY;
        canvas.orgx=XL;
        canvas.orgy=YL;
      }
      Hudsetup(canvas); //after its over, reset the elements.....
    }
  }
  else{
  //Message of the Day / Map Info Header
  if (MOTDFadeOutTime != 0.0)
    DrawMOTD(Canvas);  }


  if ( HUDMutator != None )
      HUDMutator.PostRender(Canvas);     //use hud mutators.....
  // Team Game Synopsis
  if ( PlayerPawn(Owner) != None )
  {
    if ( (PlayerPawn(Owner).GameReplicationInfo != None) && PlayerPawn(Owner).GameReplicationInfo.bTeamGame)
      DrawTeamGameSynopsis(Canvas);
  }
    //start unreal messages loop.  (would normally be at end of console (end of postrender) here is pretty close...
  drawunrealmessages(canvas);
}
simulated function HUDSetup(canvas canvas)
{
    local string Tmp;
	
    Super.Hudsetup(canvas);
    bResChanged = (Canvas.ClipX != OldClipX);
    OldClipX = Canvas.ClipX;
    Playerowner=Playerpawn(Owner);
    if ( PlayerOwner.ViewTarget == None )            //set pawnowner stuff....
        PawnOwner = PlayerOwner;
    else if ( PlayerOwner.ViewTarget.bIsPawn )
        PawnOwner = Pawn(PlayerOwner.ViewTarget);
    else 
        PawnOwner = PlayerOwner;

    // OldUnreal scaling
	Tmp = PlayerOwner.ConsoleCommand("get botpack.challengehud hudscale");
	if (Tmp != "")
        HUDScale = float(Tmp);
	else
	    HUDScale = 1.0;
    Scale = (HUDScale * Canvas.ClipX) / 1280.0;

	Canvas.SmallFont = MyFonts.GetSmallFont(Canvas.ClipX);
	Canvas.MedFont = MyFonts.GetMediumFont(Canvas.ClipX);
	Canvas.BigFont = MyFonts.GetBigFont(Canvas.ClipX);	
}
function DrawTalkFace(Canvas Canvas, float YPos)
{
  if ( Hudmode<5 )
  {
    Canvas.DrawColor = WhiteColor;
    Canvas.Style = ERenderStyle.STY_Normal;
    Canvas.SetPos(armoroffset, 4);
    Canvas.DrawTile(FaceTexture, Ypos-1+faceareaoffset, YPos - 1, 0-faceareaoffset, 0, FaceTexture.USize+faceareaoffset, FaceTexture.VSize);
    Canvas.Style = ERenderStyle.STY_Translucent;
    Canvas.DrawColor = FaceColor;
    Canvas.SetPos(armoroffset, 0);
    Canvas.DrawTile(texture'botpack.LadrStatic.Static_a00',Ypos + 7+faceareaoffset, YPos + 7, 0-faceareaoffset, 0, texture'botpack.LadrStatic.Static_a00'.USize+faceareaoffset, texture'botpack.LadrStatic.Static_a00'.VSize);
    Canvas.DrawColor = WhiteColor;
  }
}
//as the challenge hud has bindings use these to swap options.......
exec function GrowHUD()
{
  if (hudmode>0)
  hudmode--;
  saveconfig();
}

exec function ShrinkHUD()
{
  if (hudmode<5)
  hudmode++;
  saveconfig();
}

simulated function DrawTeamGameSynopsis(Canvas Canvas)
{
	local TeamInfo TI;
	local float XL, YL;

	foreach AllActors(class'TeamInfo', TI)
	{
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

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

simulated function DrawFragCountInternal(Canvas Canvas, int X, int Y, bool bRenderFragText, optional int FragCount)
{
  local color OldCol;
  local float XL, YL;
  
  Canvas.SetPos(X,Y);
  OldCol = Canvas.DrawColor;
  Canvas.DrawColor = WhiteColor;
  if (realicons)
  {
	Canvas.DrawIcon(Texture'Realskull', Scale);
  	Canvas.DrawColor = RedColor;
  }
  else
  {
	Canvas.DrawIcon(Texture'IconSkull', Scale);
	Canvas.DrawColor = GreenColor;
  }
	  
  if (!bRenderFragText)
  {
    Canvas.CurX -= 19 * Scale;
    Canvas.CurY += 23 * Scale;	
    return;
  }

  // try to find a font that is small enough to render the entire frag text inside the icon
  Canvas.Font = MyFonts.GetACompletelyUnreadableFont(Canvas.ClipX);
  Canvas.StrLen(FragCount, XL, YL);
  Canvas.CurX -= XL;
  Canvas.CurY += Texture'IconSkull'.VSize * Scale - YL;

  Canvas.DrawText(FragCount, False);
  Canvas.DrawColor = OldCol;
}

//allow the realctf icon
simulated function DrawFragCount(Canvas Canvas, int X, int Y)
{
  if (PawnOwner.PlayerReplicationInfo == None)
    DrawFragCountInternal(Canvas, X, Y, false);
  else
    DrawFragCountInternal(Canvas, X, Y, true, int(PawnOwner.PlayerReplicationInfo.Score));
}

//tick the faceareoffsets.......
simulated function Tick(float DeltaTime)
{
  local int i;

  Super.Tick(DeltaTime);      //super (ID and MOTD)

  if ( bDrawFaceArea )
  {
    if ( FaceAreaOffset < 0 )
      FaceAreaOffset += DeltaTime * 600;
    if ( FaceAreaOffset > 0 )
      FaceAreaOffset = 0.0;
  } 

}

simulated function DrawIdentifyInfo(canvas Canvas, float PosX, float PosY)
{
	local float XL, YL, XOffset;
	local string Name;

	if (!TraceIdentify(Canvas))
		return;

	Canvas.Font = MyFonts.GetMediumFont(Canvas.ClipX);
	Canvas.Style = 3;

	if(IdentifyTarget.IsA('PlayerPawn'))
		if(PlayerPawn(IdentifyTarget).PlayerReplicationInfo.bFeigningDeath)
			return;

    Name = IdentifyTarget.PlayerReplicationInfo.PlayerName;
//    if (Name == "")
//        Name = string(IdentifyTarget.Class);

	XOffset = 0.0;
	Canvas.StrLen(IdentifyName$": "$Name, XL, YL);
	XOffset = Canvas.ClipX/2 - XL/2;
	Canvas.SetPos(XOffset, Canvas.ClipY - 54);

	if(Name != "")
	{
		Canvas.DrawColor.R = 0;
		Canvas.DrawColor.G = 160 * (IdentifyFadeTime / 3.0);
		Canvas.DrawColor.B = 0;

		Canvas.StrLen(IdentifyName$": ", XL, YL);
		XOffset += XL;
		Canvas.DrawText(IdentifyName$": ");
		Canvas.SetPos(XOffset, Canvas.ClipY - 54);

		Canvas.DrawColor.R = 0;
		Canvas.DrawColor.G = 255 * (IdentifyFadeTime / 3.0);
		Canvas.DrawColor.B = 0;

		Canvas.StrLen(Name, XL, YL);
		Canvas.DrawText(Name);
	}

	Canvas.Style = 1;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

//DO NOT USE ITERATEORS!!!!!!! THEY BAD!!!!!!!!!!!!!!!!
simulated function DrawMOTD(Canvas Canvas)
{
  local GameReplicationInfo GRI;
  local float XL, YL;

  if(Owner == None) return;

  Canvas.Font = MyFonts.GetMediumFont(Canvas.ClipX);
  Canvas.Style = 3;

  Canvas.DrawColor.R = MOTDFadeOutTime;
  Canvas.DrawColor.G = MOTDFadeOutTime;
  Canvas.DrawColor.B = MOTDFadeOutTime;

  Canvas.bCenter = true;

  GRI = PlayerPawn(Owner).GameReplicationInfo;
  if ( (GRI == None) || (GRI.GameName == "Game") || (MOTDFadeOutTime <= 0) ) 
    return;

      Canvas.DrawColor.R = 0;
      Canvas.DrawColor.G = MOTDFadeOutTime / 2;
      Canvas.DrawColor.B = MOTDFadeOutTime;
      Canvas.SetPos(0.0, 32);
      Canvas.StrLen("TEST", XL, YL);
      if (Level.NetMode != NM_Standalone)
        Canvas.DrawText(GRI.ServerName);
      Canvas.DrawColor.R = MOTDFadeOutTime;
      Canvas.DrawColor.G = MOTDFadeOutTime;
      Canvas.DrawColor.B = MOTDFadeOutTime;

      Canvas.SetPos(0.0, 32 + YL);
      Canvas.DrawText("Game Type: "$GRI.GameName, true);
      Canvas.SetPos(0.0, 32 + 2*YL);
      Canvas.DrawText("Map Title: "$Level.Title, true);
      Canvas.SetPos(0.0, 32 + 3*YL);
      Canvas.DrawText("Author: "$Level.Author, true);
      Canvas.SetPos(0.0, 32 + 4*YL);
      if (Level.IdealPlayerCount != "")
        Canvas.DrawText("Ideal Player Load:"$Level.IdealPlayerCount, true);

      Canvas.DrawColor.R = 0;
      Canvas.DrawColor.G = MOTDFadeOutTime / 2;
      Canvas.DrawColor.B = MOTDFadeOutTime;

      Canvas.SetPos(0, 32 + 6*YL);
      Canvas.DrawText(Level.LevelEnterText, true);

      Canvas.SetPos(0.0, 32 + 8*YL);
      Canvas.DrawText(GRI.MOTDLine1, true);
      Canvas.SetPos(0.0, 32 + 9*YL);
      Canvas.DrawText(GRI.MOTDLine2, true);
      Canvas.SetPos(0.0, 32 + 10*YL);
      Canvas.DrawText(GRI.MOTDLine3, true);
      Canvas.SetPos(0.0, 32 + 11*YL);
      Canvas.DrawText(GRI.MOTDLine4, true);


  Canvas.bCenter = false;

  Canvas.Style = 1;
  Canvas.DrawColor.R = 255;
  Canvas.DrawColor.G = 255;
  Canvas.DrawColor.B = 255;
}
// taken from REalCTF........ let offsets for face work......
simulated function bool DisplayMessages( canvas Canvas )
{

  return true;
}
//more stuff ripped from real ctf.......
simulated function bool Draw1337MessageHeader(Canvas Canvas, somemessage ShortMessage, int YPos)
{
  local float XOffset;
  local string strPlayerName;
  local byte Team;

  if ((ShortMessage.Type != 'Say') && (ShortMessage.Type != 'TeamSay'))
    return false;


  if (ShortMessage.PRI != none) {
    Team = ShortMessage.PRI.Team;
    strPlayerName = ShortMessage.PRI.PlayerName;
  } else {
    Team = 255;
    strPlayerName = "h4xx0r";
  }

  SetDrawColor(Canvas,Team,1);
  XOffset += ArmorOffset+facemsgset;
//  XOffset = DrawNextMessagePart(Canvas, strPlayerName$": ", XOffset, YPos);  
  Canvas.SetPos(4 + XOffset, YPos);

  if (ShortMessage.Type == 'TeamSay') {
    // Message text is team color for TeamSay
    SetDrawColor(Canvas,Team,2);
  } else {
    // ...otherwise green
    SetDrawColor(Canvas,255,2);
  }

  return true;
}

final simulated function SetDrawColor(canvas Canvas, byte Team, byte Shade, optional float FadeTime)
{
  if (FadeTime == 0.0)
    FadeTime = 3.0;

  switch (Team) {
    case 0:
      // Red
      switch (Shade) {
        case 1:
          // Bright
          Canvas.DrawColor.R = 255 * (FadeTime / 3.0);
          Canvas.DrawColor.G = 0;
          Canvas.DrawColor.B = 0;
          break;

        case 2:
          // Dim
          Canvas.DrawColor.R = 200 * (FadeTime / 3.0);
          Canvas.DrawColor.G = 0;
          Canvas.DrawColor.B = 0;
          break;
      }
      break;

    case 1:
      // Blue
      switch (Shade) {
        case 1:
          // Bright
          Canvas.DrawColor.R = 0;
          Canvas.DrawColor.G = 128 * (FadeTime / 3.0);
          Canvas.DrawColor.B = 255 * (FadeTime / 3.0);
          break;

        case 2:
          // Dim
          Canvas.DrawColor.R = 0;
          Canvas.DrawColor.G = 94 * (FadeTime / 3.0);
          Canvas.DrawColor.B = 187 * (FadeTime / 3.0);
          break;
      }
      break;
    case 2:
      // green
      switch (Shade) {
        case 1:
          // Bright
          Canvas.DrawColor.R = 0;
          Canvas.DrawColor.G = 255 * (FadeTime / 3.0);
          Canvas.DrawColor.B = 0;
          break;

        case 2:
          // Dim
          Canvas.DrawColor.R = 0;
          Canvas.DrawColor.G = 128 * (FadeTime / 3.0);
          Canvas.DrawColor.B = 0;
          break;
      }
      break;
    case 3:
      // yellow
      switch (Shade) {
        case 1:
          // Bright
          Canvas.DrawColor.R = 255 * (FadeTime / 3.0);
          Canvas.DrawColor.G = 255 * (FadeTime / 3.0);
          Canvas.DrawColor.B = 0;
          break;

        case 2:
          // Dim
          Canvas.DrawColor.R = 255 * (FadeTime / 3.0);
          Canvas.DrawColor.G = 255 * (FadeTime / 3.0);
          Canvas.DrawColor.B = 128 * (FadeTime / 3.0);
          break;
      }
      break;

    default:
      // somehow its non-team....
      Noteam(canvas, shade, fadetime);
      break;
  }
}

final simulated function Noteam(canvas Canvas, byte Shade, optional float FadeTime){
// Team-generic green
  if (FadeTime == 0.0)
    FadeTime = 3.0;

  switch (Shade) {
    case 1:
      // Bright
      Canvas.DrawColor.R = 0;
      Canvas.DrawColor.G = 255 * (FadeTime / 3.0);
      Canvas.DrawColor.B = 0;
      break;

    case 2:
      // Dim
      Canvas.DrawColor.R = 0;
      Canvas.DrawColor.G = 160 * (FadeTime / 3.0);
      Canvas.DrawColor.B = 0;
      break;
  }
}

//to show challenge DM localized messages.
simulated function LocalizedMessage( class<LocalMessage> lMessage, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional String CriticalString )
{
  local int i;

  if ( !lMessage.Default.bIsSpecial )
  {
    if ( ClassIsChildOf(lMessage, class'SayMessagePlus') ||
             ClassIsChildOf(lMessage, class'TeamSayMessagePlus') )
    {
      if(RelatedPRI_1.talktexture!=none||facetime<level.timeseconds){
      FaceTexture = RelatedPRI_1.TalkTexture;
      FaceTime = Level.TimeSeconds + 3;   }
    }
    else if (ClassIsChildOf(lMessage, class'DeathMessagePlus')){ //submit death messages to main query.
    CriticalString = lMessage.Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    message(RelatedPRI_1,criticalstring, 'deathmessage');  }
    return;
  }
  else
  {
    if ( CriticalString == "" )
      CriticalString = lMessage.Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    If (ClassIsChildOf(lMessage, class'pickupmessageplus')){   //don't show this, but client message it....
    message(RelatedPRI_1,criticalstring, 'Pickup');
    return;      }
    if ( lMessage.Default.bIsUnique )
    {
      for (i=0; i<10; i++)
      {
        if (LocalMessages[i].Message != None)
        {
          if ((LocalMessages[i].Message == lMessage)
            || (LocalMessages[i].Message.Static.GetOffset(LocalMessages[i].Switch, 24, 640) 
                == lMessage.Static.GetOffset(Switch, 24, 640)) )
          {
            LocalMessages[i].Message = lMessage;
            LocalMessages[i].Switch = Switch;
            LocalMessages[i].RelatedPRI = RelatedPRI_1;
            LocalMessages[i].OptionalObject = OptionalObject;
            LocalMessages[i].LifeTime = lMessage.Default.Lifetime;
            LocalMessages[i].EndOfLife = lMessage.Default.Lifetime + Level.TimeSeconds;
            LocalMessages[i].StringMessage = CriticalString;
            LocalMessages[i].DrawColor = lMessage.Static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2);
            LocalMessages[i].XL = 0;
            return;
          }
        }
      }
    }
    for (i=0; i<10; i++)
    {
      if (LocalMessages[i].Message == None)
      {
        LocalMessages[i].Message = lMessage;
        LocalMessages[i].Switch = Switch;
        LocalMessages[i].RelatedPRI = RelatedPRI_1;
        LocalMessages[i].OptionalObject = OptionalObject;
        LocalMessages[i].EndOfLife = lMessage.Default.Lifetime + Level.TimeSeconds;
        LocalMessages[i].StringMessage = CriticalString;
        LocalMessages[i].DrawColor = lMessage.Static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2);
        LocalMessages[i].LifeTime = lMessage.Default.Lifetime;
        LocalMessages[i].XL = 0;
        return;
      }
    }

    // No empty slots.  Force a message out.
    for (i=0; i<9; i++)
      CopyMessage(LocalMessages[i],LocalMessages[i+1]);

    LocalMessages[9].Message = lMessage;
    LocalMessages[9].Switch = Switch;
    LocalMessages[9].RelatedPRI = RelatedPRI_1;
    LocalMessages[9].OptionalObject = OptionalObject;
    LocalMessages[9].EndOfLife = lMessage.Default.Lifetime + Level.TimeSeconds;
    LocalMessages[9].StringMessage = CriticalString;
    LocalMessages[9].DrawColor = lMessage.Static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2);
    LocalMessages[9].LifeTime = lMessage.Default.Lifetime;
    LocalMessages[9].XL = 0;
    return;
  }
}
//allows spectating information of bots
simulated function DrawInventory(Canvas Canvas, int X, int Y, bool bDrawOne)
{  
  local bool bGotNext, bGotPrev, bGotSelected;
  local inventory Inv,Prev, Next, SelectedItem;
  local int TempX,TempY, HalfHUDX, HalfHUDY, AmmoIconSize, i;
  local float IconY, TextY;

  if ( HudMode < 4 ) //then draw HalfHUD
  {
    Canvas.Font = MyFonts.GetBigFont(Canvas.ClipX);
	GetIconAndTextOffsets(Canvas, Texture'HalfHud', IconY, TextY);
    Canvas.Font = MyFonts.GetSmallFont(Canvas.ClipX);
    HalfHUDX = Canvas.ClipX-64*Scale;
    HalfHUDY = Canvas.ClipY-32*Scale-IconY;
    Canvas.CurX = HalfHudX;
    Canvas.CurY = HalfHudY;
    Canvas.DrawIcon(Texture'HalfHud', Scale);  
  }

  if ( pawnOwner.Inventory==None) Return;
  bGotSelected = False;
  bGotNext = false;
  bGotPrev = false;
  Prev = None;
  Next = None;
  SelectedItem = PawnOwner.SelectedItem;

  for ( Inv=pawnOwner.Inventory; Inv!=None; Inv=Inv.Inventory )
  {
    if ( !bDrawOne ) // if drawing more than one inventory, find next and previous items
    {
      if ( Inv == SelectedItem )
        bGotSelected = True;
      else if ( Inv.bActivatable )
      {
        if ( bGotSelected )
        {
          if ( !bGotNext )
          {
            Next = Inv;
            bGotNext = true;
          }
          else if ( !bGotPrev )
            Prev = Inv;
        }
        else
        {
          if ( Next == None )
            Next = Prev;
          Prev = Inv;
          bGotPrev = True;
        }
      }
    }
    
    if ( Translator(Inv) != None )
      Translator = Translator(Inv);

    if ( (HudMode < 4) && (Inv.InventoryGroup>0) && (Weapon(Inv)!=None) ) 
    {
      if (PawnOwner.Weapon == Inv) Canvas.Font = MyFonts.GetStaticSmallestFont(Canvas.ClipX);
      else Canvas.Font = MyFonts.GetStaticAReallySmallFont(Canvas.ClipX);
      Canvas.CurX = HalfHudX-3*Scale+Inv.InventoryGroup*6*Scale;
      Canvas.CurY = HalfHudY+4*Scale;
      if (Inv.InventoryGroup<10) Canvas.DrawText(Inv.InventoryGroup,False);
      else Canvas.DrawText("0",False);
    }
    
    
    if ( (HudMode < 4) && (Ammo(Inv)!=None) ) 
    {
      for (i=0; i<10; i++)
      {
        if (Ammo(Inv).UsedInWeaponSlot[i]==1)
        {
          Canvas.CurX = HalfHudX+3*Scale+i*6*Scale;
          if (i==0) Canvas.CurX += 60*Scale;
          Canvas.CurY = HalfHudY+11*Scale;
          AmmoIconSize = 16.0*FMin(1.0,(float(Ammo(Inv).AmmoAmount)/float(Ammo(Inv).MaxAmmo)))*Scale;
          if (AmmoIconSize<8*Scale && Ammo(Inv).AmmoAmount<10 && Ammo(Inv).AmmoAmount>0) 
          {
            Canvas.CurX -= 6*Scale;      
            Canvas.CurY += 5*Scale;
			Canvas.DrawColor=RedColor;
            Canvas.Font = MyFonts.GetStaticAReallySmallFont(Canvas.ClipX);
            Canvas.DrawText(Ammo(Inv).AmmoAmount,False);        
            Canvas.CurY -= 12*Scale;
          }
          Canvas.CurY += 19*Scale-AmmoIconSize;
          Canvas.CurX -= 6*Scale;
          Canvas.DrawColor.g = 255;
          Canvas.DrawColor.r = 0;    
          Canvas.DrawColor.b = 0;          
          if (AmmoIconSize<8*Scale) 
          {
            Canvas.DrawColor.r = 255-AmmoIconSize*30/Scale;
            Canvas.DrawColor.g = AmmoIconSize*30/Scale+40;        
          }
          if (Ammo(Inv).AmmoAmount >0) 
          {
            Canvas.DrawTile(Texture'HudGreenAmmo',4.0*Scale,AmmoIconSize,0,0,4.0*Scale,AmmoIconSize);    
          }
          Canvas.DrawColor.g = 255;
          Canvas.DrawColor.r = 255;    
          Canvas.DrawColor.b = 255;  
        }
      }
    }


    
  }

  // List Translator messages if activated
  if ( Translator!=None )
  {
    if( Translator.bCurrentlyActivated )
    {
      Canvas.bCenter = false;
      Canvas.Font = MyFonts.GetMediumFont(Canvas.ClipX);
      TempX = Canvas.ClipX;
      TempY = Canvas.ClipY;
      CurrentMessage = Translator.NewMessage;
      Canvas.Style = 2;  
      Canvas.SetPos(Canvas.ClipX/2-128*Scale, Canvas.ClipY/2-68*Scale);
      Canvas.DrawIcon(texture'TranslatorHUD3', Scale);
      Canvas.SetOrigin(Canvas.ClipX/2-110*Scale,Canvas.ClipY/2-52*Scale);
      Canvas.SetClip(225*Scale,110*Scale);
      Canvas.SetPos(0,0);
      Canvas.Style = 1;  
      Canvas.DrawText(CurrentMessage, False);  
      HUDSetup(canvas);  
      Canvas.ClipX = TempX;
      Canvas.ClipY = TempY;
    }
    else 
      bFlashTranslator = ( Translator.bNewMessage || Translator.bNotNewMessage );
  }

  if ( HUDMode == 5 )
    return;

  if ( SelectedItem != None )
  {
    Canvas.Font = MyFonts.GetStaticAReallySmallFont(Canvas.ClipX);
    Count++;
    if (Count>20) Count=0;
    
    if (Prev!=None) 
    {
      if ( Prev.bActive || (bFlashTranslator && (Translator == Prev) && (Count>15)) )
      {
        Canvas.DrawColor.b = 0;    
        Canvas.DrawColor.g = 0;    
      }
      DrawHudIcon(Canvas, X, Y, Prev);        
      if ( (Pickup(Prev) != None) && Pickup(Prev).bCanHaveMultipleCopies )
        DrawNumberOf(Canvas,Pickup(Prev).NumCopies,X,Y);
      Canvas.DrawColor.b = 255;
      Canvas.DrawColor.g = 255;    
    }
    if ( SelectedItem.Icon != None )  
    {
      if ( SelectedItem.bActive || (bFlashTranslator && (Translator == SelectedItem) && (Count>15)) )
      {
        Canvas.DrawColor.b = 0;    
        Canvas.DrawColor.g = 0;    
      }
      if ( (Next==None) && (Prev==None) && !bDrawOne) DrawHudIcon(Canvas, X+64*Scale, Y, SelectedItem);
      else DrawHudIcon(Canvas, X+32*Scale, Y, SelectedItem);    
      Canvas.Style = 2;
      Canvas.CurX = X+32*Scale;
      if ( (Next==None) && (Prev==None) && !bDrawOne ) Canvas.CurX = X+64*Scale;
      Canvas.CurY = Y;
      Canvas.DrawIcon(texture'IconSelection', Scale);
      if ( (Pickup(SelectedItem) != None) 
        && Pickup(SelectedItem).bCanHaveMultipleCopies )
        DrawNumberOf(Canvas,Pickup(SelectedItem).NumCopies,Canvas.CurX-32*Scale,Y);
      Canvas.Style = 1;
      Canvas.DrawColor.b = 255;
      Canvas.DrawColor.g = 255;    
    }
    if (Next!=None) {
      if ( Next.bActive || (bFlashTranslator && (Translator == Next) && (Count>15)) )
      {
        Canvas.DrawColor.b = 0;    
        Canvas.DrawColor.g = 0;    
      }
      DrawHudIcon(Canvas, X+64*Scale, Y, Next);
      if ( (Pickup(Next) != None) && Pickup(Next).bCanHaveMultipleCopies )
        DrawNumberOf(Canvas,Pickup(Next).NumCopies,Canvas.CurX-32*Scale,Y);
      Canvas.DrawColor.b = 255;
      Canvas.DrawColor.g = 255;
    }
  }
}

simulated function DrawNumberOf(Canvas Canvas, int NumberOf, int X, int Y)
{
	local int TempX,TempY;
	local color TmpColor;
	
	if (NumberOf<=0) Return;

	Canvas.CurX = X + 14 * Scale;
	Canvas.CurY = Y + 20 * Scale;
	NumberOf++;
	if (NumberOf<100) Canvas.CurX+=6 * Scale;
	if (NumberOf<10) Canvas.CurX+=6 * Scale;
	TmpColor = Canvas.DrawColor;
	Canvas.DrawColor = RedColor;
	Canvas.Font = MyFonts.GetStaticAReallySmallFont(Canvas.ClipX);
	Canvas.DrawText(NumberOf,False);
	Canvas.DrawColor = TmpColor;
}

simulated function DrawArmor(Canvas Canvas, int X, int Y, bool bDrawOne)
{
  Local int ArmorAmount, CurAbs;
  Local inventory Inv, BestArmor;
  Local float XL, YL, IconY, TextY;
  local color TmpColor;

  ArmorAmount = 0;
  ArmorOffset = 0;
  Canvas.Font = MyFonts.GetBigFont(Canvas.ClipX);
  Canvas.CurX = X;
  Canvas.CurY = Y;
  CurAbs=0;
  BestArmor=None;
  for( Inv=pawnOwner.Inventory; Inv!=None; Inv=Inv.Inventory )
  {
    if (Inv.bIsAnArmor) 
    {
      ArmorAmount += Inv.Charge;        
      if (Inv.Charge>0 && (Inv.Icon!=None||findicon(inv)!=none))
      {
        if (!bDrawOne) 
        {
          ArmorOffset += 32 * Scale;
		  GetInvIconAndTextOffsets(Canvas, Inv, IconY, TextY);
          DrawHudIcon(Canvas, Canvas.CurX, Y + IconY, Inv);
          DrawIconValue(Canvas, Inv.Charge);            
        }
        else if (Inv.ArmorAbsorption>CurAbs) 
        {
          CurAbs = Inv.ArmorAbsorption;
          BestArmor = Inv;
        }
      }
    }
  }
  if (bDrawOne && BestArmor!=None) 
  {
    GetInvIconAndTextOffsets(Canvas, Inv, IconY, TextY);  
    DrawHudIcon(Canvas, Canvas.CurX, Y + IconY, BestArmor);
    DrawIconValue(Canvas, BestArmor.Charge);
  }
  Canvas.CurY = Y + TextY;
  if (ArmorAmount>0 && HudMode==0)
  {
    TmpColor = Canvas.DrawColor;
	Canvas.DrawColor = GreenColor;
    Canvas.StrLen(ArmorAmount, XL, YL);
    ArmorOffset += XL;
    Canvas.DrawText(ArmorAmount, False);
	Canvas.DrawColor = TmpColor;
  }
}

// Draw the icons value in text on the icon
//
simulated function DrawIconValue(Canvas Canvas, int Amount)
{
	local int TempX,TempY;

	if (HudMode==0 || HudMode==3) Return;

	TempX = Canvas.CurX;
	TempY = Canvas.CurY;
	Canvas.CurX -= 20 * Scale;
	Canvas.CurY -= 5 * Scale;
	if (Amount<100) Canvas.CurX+=6 * Scale;
	if (Amount<10) Canvas.CurX+=6 * Scale;	
	Canvas.Font = MyFonts.GetStaticSmallestFont(Canvas.ClipX);
	Canvas.DrawText(Amount,False);
	Canvas.Font = MyFonts.GetBigFont(Canvas.ClipX);
	Canvas.CurX = TempX;
	Canvas.CurY = TempY;
}

simulated function DrawAmmo(Canvas Canvas, int X, int Y)
{
  local texture foundicon;
  local color TmpColor;
  local float IconY, TextY, XL, YL;
  
  if ( (PawnOwner.Weapon == None) || (PawnOwner.Weapon.AmmoType == None) )
    return;

  Canvas.Font = MyFonts.GetBigFont(Canvas.ClipX);

  GetInvIconAndTextOffsets(Canvas, PawnOwner.Weapon.AmmoType, IconY, TextY);

  TmpColor = Canvas.DrawColor;  
  if (PawnOwner.Weapon.AmmoType.AmmoAmount<10)
	Canvas.DrawColor = RedColor;
  else
    Canvas.DrawColor = GreenColor;
	
  if (HudMode==0)
  {
    Canvas.StrLen(PawnOwner.Weapon.AmmoType.AmmoAmount, XL, YL);
    Canvas.CurX = X - XL;
    Canvas.CurY = Canvas.ClipY - YL - TextY;	
    Canvas.DrawText(PawnOwner.Weapon.AmmoType.AmmoAmount,False);
  }

  Canvas.DrawColor = WhiteColor;
  Canvas.CurX = X;
  Canvas.CurY = Y + IconY;
  if (PawnOwner.Weapon.AmmoType.Icon!=None)
  {
    Canvas.DrawIcon(PawnOwner.Weapon.AmmoType.Icon, Scale);
  }
  else
  {  
    foundicon=findicon(pawnowner.weapon.ammotype);
    if (foundicon!=none)
      Canvas.DrawIcon(foundicon, Scale);
  }
  Canvas.CurX = X;
  Canvas.CurY = Y + IconY + 29*Scale;
  DrawIconValue(Canvas, PawnOwner.Weapon.AmmoType.AmmoAmount);
  Canvas.CurX = X + 2*Scale;
  Canvas.CurY = Y + IconY + 29*Scale;
  if (HudMode!=1 && HudMode!=2 && HudMode!=4)  Canvas.DrawTile(Texture'HudLine',
    FMin(27.0*(float(PawnOwner.Weapon.AmmoType.AmmoAmount)/float(PawnOwner.Weapon.AmmoType.MaxAmmo)),27)*Scale,2.0*Scale,0,0,32.0*Scale,2.0*Scale);
  Canvas.DrawColor = TmpColor;
	
}
simulated function ChangeCrosshair(int d)    //wierd bug that caused challengehud crosshair to change to....
{
  olCrosshair = olCrosshair + d;
  if ( olCrosshair>6 ) olCrosshair=0;
  else if ( olCrosshair < 0 ) olCrosshair = 6;
}
simulated function DrawCrossHair( canvas Canvas, int StartX, int StartY )
{
	local float XScale, PickDiff;
	local float XLength, YLength;
	local texture T;

    if (olCrosshair>5) Return;

    /*
    Canvas.SetPos(StartX, StartY );
    Canvas.Style = 2;
    if    (olCrosshair==0)   Canvas.DrawIcon(Texture'Crosshair1', 1.0);
    else if (olCrosshair==1)   Canvas.DrawIcon(Texture'Crosshair2', 1.0);
    else if (olCrosshair==2)   Canvas.DrawIcon(Texture'Crosshair3', 1.0);
    else if (olCrosshair==3)   Canvas.DrawIcon(Texture'Crosshair4', 1.0);
    else if (olCrosshair==4)   Canvas.DrawIcon(Texture'Crosshair5', 1.0);
    else if (olCrosshair==5)   Canvas.DrawIcon(Texture'Crosshair7', 1.0);
    Canvas.Style = 1;
    */

	// TODO: Use UT crosshair?
    if    (olCrosshair==0)   T = Texture'Crosshair1';
    else if (olCrosshair==1)   T = Texture'Crosshair2';
    else if (olCrosshair==2)   T = Texture'Crosshair3';
    else if (olCrosshair==3)   T = Texture'Crosshair4';
    else if (olCrosshair==4)   T = Texture'Crosshair5';
    else if (olCrosshair==5)   T = Texture'Crosshair7';

	if (class'ChallengeHUD'.default.bAutoCrosshairScale)
	{
		if ( Canvas.ClipX < 512 )
		    XScale = 0.5;
		else
			XScale = Clamp(int(0.1 + Canvas.ClipX/640.0), 1, 2);
	}
	else
	{
		XScale = class'ChallengeHUD'.default.CrosshairScale;
	}

	XLength = XScale * T.USize;
	YLength = XScale * T.VSize;

	Canvas.bNoSmooth = !class'ChallengeHUD'.default.bSmoothCrosshair;
	if ( class'ChallengeHUD'.default.bAlwaysCenterCrosshair || (PlayerOwner.Handedness != 1 && PlayerOwner.HandedNess != -1) )
		Canvas.SetPos(0.5 * (Canvas.ClipX - XLength), 0.5 * (Canvas.ClipY - YLength));
	else if ( class'ChallengeHUD'.default.PlayerOwner.Handedness == -1 )
		Canvas.SetPos(0.503 * (Canvas.ClipX - XLength), 0.504 * (Canvas.ClipY - YLength));
	else if ( class'ChallengeHUD'.default.PlayerOwner.Handedness == 1 )
		Canvas.SetPos(0.497 * (Canvas.ClipX - XLength), 0.496 * (Canvas.ClipY - YLength));

    if (class'ChallengeHUD'.default.bTranslucentCrosshair)
        Canvas.Style = ERenderStyle.STY_Translucent;
	else
	    Canvas.Style = ERenderStyle.STY_Normal;
	Canvas.DrawColor = 15 * class'ChallengeHUD'.default.CrosshairColor;

	Canvas.DrawTile(T, XLength, YLength, 0, 0, T.USize, T.VSize);
	Canvas.bNoSmooth = True;
	Canvas.Style = Style;
}

simulated function DisplayProgressMessage( canvas Canvas )
{
	local int i;
	local float YOffset, XL, YL;

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	Canvas.bCenter = true;
	Canvas.Font = MyFonts.GetMediumFont(Canvas.ClipX);
	YOffset = 0;
	Canvas.StrLen("TEST", XL, YL);
	for (i=0; i<8; i++)
	{
		Canvas.SetPos(0, 0.25 * Canvas.ClipY + YOffset);
		Canvas.DrawColor = PlayerPawn(Owner).ProgressColor[i];
		Canvas.DrawText(PlayerPawn(Owner).ProgressMessage[i], false);
		YOffset += YL + 1;
	}
	Canvas.bCenter = false;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

simulated function DisplayMenu( canvas Canvas )
{
	local float VersionW, VersionH;

	if ( MainMenu == None )
		CreateMenu();
	if ( MainMenu != None )
		MainMenu.DrawMenu(Canvas);

	if ( MainMenu.Class == MainMenuType )
	{
		Canvas.bCenter = false;
		Canvas.Font = MyFonts.GetMediumFont(Canvas.ClipX);
		Canvas.Style = 1;
		Canvas.StrLen(VersionMessage@Level.EngineVersion, VersionW, VersionH);
		Canvas.SetPos(Canvas.ClipX - VersionW - 4, 4);	
		Canvas.DrawText(VersionMessage@Level.EngineVersion, False);	
	}
}

simulated function DrawHealth(Canvas Canvas, int X, int Y)
{
  local Color TmpColor;
  local float IconY, TextY;
  
  Canvas.Font = MyFonts.GetBigFont(Canvas.ClipX);

  GetIconAndTextOffsets(Canvas, Texture'IconHealth', IconY, TextY);
  Canvas.CurY = Y + IconY;
  Canvas.CurX = X;  
  
  TmpColor = Canvas.DrawColor;
  if (PawnOwner.Health<25) Canvas.DrawColor = RedColor;
  Canvas.DrawIcon(Texture'IconHealth', Scale);

  Canvas.CurY = Y + IconY + 29 * Scale;  
  DrawIconValue(Canvas, Max(0,PawnOwner.Health));
  if (HudMode==0)
  {
    Canvas.CurY = Y + TextY;
	if (PawnOwner.Health>=25)
	  Canvas.DrawColor = GreenColor;
    Canvas.DrawText(Max(0,PawnOwner.Health),False);
  }
  Canvas.CurY = Y + IconY + 29 * Scale;    
  Canvas.CurX = X + 2 * Scale;
  if (HudMode!=1 && HudMode!=2 && HudMode!=4) 
    Canvas.DrawTile(Texture'HudLine', FMin(27.0*(float(PawnOwner.Health)/float(PawnOwner.Default.Health)),27) * Scale, 2.0 * Scale , 0, 0, 32.0 * Scale, 2.0 * Scale);
  Canvas.CurY = Y;
  Canvas.DrawColor = TmpColor;
}

//read PRI face
simulated function Message( PlayerReplicationInfo PRI, coerce string Msg, name MsgType )
{
  local int I;
  local float PickupColor;
if ((MsgType=='say' || msgtype=='teamsay')&& (pri.talktexture!=none||facetime<level.timeseconds)) //if no face, render, unless one is present.
  {
if (pri.team<4)
FaceTeam = TeamColor[PRI.Team];
FaceTexture = PRI.TalkTexture;
      FaceTime = Level.TimeSeconds + 3;
}
if (msg=="") return;
if (msgtype=='pickupmessageplus') //make pickupplus pickup.
msgtype='pickup';
  if (msgtype=='pickup'){
  currentpickup.lifetime=6+level.timeseconds;
  currentpickup.contents=msg;}
  else if (msgtype=='criticalevent'){
  criticalmessage.lifetime=6+level.timeseconds;
  criticalmessage.contents=msg;
  if (translator!=none&&translator.bcurrentlyactivated)
  translator.activatetranslator(false); } //shut off translator so message shows.
  else{   //main speech area (say, events, and deaths)
  for (i=2;i>-1;i--){    //move events down.
  if (shortmessages[i].contents!="")
  copyolmessage(shortmessages[i+1],shortmessages[i]);
  }
  shortmessages[0].type=msgtype;        //setup new message.
  shortmessages[0].contents=msg;
  shortmessages[0].PRI=PRI;
  shortmessages[0].lifetime=6+level.timeseconds;  }

}
simulated function drawunrealmessages(canvas canvas){   //for unreal style criticalevents, pickups, events, speech, and deathmessages
  local float XL, YL;
  local int I, J, YPos, ExtraSpace;
  local float PickupColor;
  local console Console;
  local inventory Inv;
  Console = PlayerPawn(Owner).Player.Console;

  Canvas.Font = MyFonts.GetMediumFont(Canvas.ClipX);
  Canvas.StrLen("TEST", XL, YL);

  if ( !Console.Viewport.Actor.bShowMenu )
    DrawTypingPrompt(Canvas, Console);

  if ( currentpickup.lifetime>level.timeseconds)   //pickup message
    {
      Canvas.bCenter = true;
      if ( Level.bHighDetailMode )
        Canvas.Style = ERenderStyle.STY_Translucent;
      else
        Canvas.Style = ERenderStyle.STY_Normal;
      PickupColor = 42.0 * (currentpickup.lifetime-level.timeseconds);
      Canvas.DrawColor.r = PickupColor;
      Canvas.DrawColor.g = PickupColor;
      Canvas.DrawColor.b = PickupColor;
      Canvas.SetPos(4, Console.FrameY - 4 - YL);
      Canvas.DrawText( currentpickup.contents, true );
      Canvas.bCenter = false;
      Canvas.Style = ERenderStyle.STY_Normal;
    }

    if (criticalmessage.lifetime>=level.timeseconds){     // Display critical message
    Canvas.bCenter = true;
    Canvas.Style = ERenderStyle.STY_Translucent;
    Canvas.DrawColor.b = 255;
    Canvas.DrawColor.r = 0;
    Canvas.DrawColor.g = 128;
Canvas.SetPos(0, Console.FrameY/2 - 12 - YL/2);
    if (translator==none||!translator.bcurrentlyactivated)  //don't overwrite translator.
    canvas.DrawText( criticalmessage.contents, true );
    Canvas.bCenter = false;
    Canvas.Style = ERenderStyle.STY_Normal;    }
  for (i=3;i>-1;i--) //go in backwards.
  {
    if (shortmessages[i].contents!=""&&shortmessages[i].lifetime>=level.timeseconds) //thx to setup order this always works :P
    {
    YPos = 2 + (10 * J) + (10 * ExtraSpace);
    if ( !Draw1337MessageHeader(Canvas, ShortMessages[I], YPos) )
        {
          if (ShortMessages[I].Type == 'DeathMessage') {
            Canvas.DrawColor.r = 160;
            Canvas.DrawColor.g = 160;
            Canvas.DrawColor.b = 160;  
          } else {
            Canvas.DrawColor.r = 200;
            Canvas.DrawColor.g = 200;
            Canvas.DrawColor.b = 200;  
          }

          Canvas.SetPos(4+armoroffset+facemsgset, YPos);
        }
          Canvas.DrawText(shortmessages[I].contents, false );
          J++;
        if ( YL == 18.0 )
          ExtraSpace++;
       }
  }

}
function CopyolMessage(out somemessage M1, somemessage M2)  //copying.
{
  M1.contents = M2.contents;
  M1.LifeTime = M2.LifeTime;
  M1.pri = M2.pri;
  m1.type = m2.type;
}

simulated function DrawTypingPrompt( canvas Canvas, console Console )
{
	local string TypingPrompt;
	local float XL, YL;

	if ( Console.bTyping )
	{
		Canvas.DrawColor.r = 0;
		Canvas.DrawColor.g = 255;
		Canvas.DrawColor.b = 0;	
		TypingPrompt = "(> "$Console.TypedStr$"_";
		Canvas.Font = MyFonts.GetMediumFont(Canvas.ClipX);
		Canvas.StrLen( TypingPrompt, XL, YL );
		Canvas.SetPos( 2, Console.FrameY - Console.ConsoleLines - YL - 1 );
		Canvas.DrawText( TypingPrompt, false );
	}
}

simulated function DrawHudIcon(Canvas Canvas, int X, int Y, Inventory Item)     //modified so it can find icons.
{
  local int Width;
  local texture icon;
  
  icon=item.icon;
  if (Icon==None)
  {
    icon=findicon(item);
    if (icon==none) return;
  }
  
  Width = Canvas.CurX;
  Canvas.CurX = X;
  Canvas.CurY = Y;
  Canvas.DrawIcon(Item.Icon, Scale);
  Canvas.CurX -= Item.Icon.USize * Scale - 2; // was 30
  Canvas.CurY += Item.Icon.VSize * Scale - 4; // was 28
  if ((HudMode!=2 && HudMode!=4 && HudMode!=1) || !Item.bIsAnArmor)
    Canvas.DrawTile(Texture'HudLine', fMin(27.0,27.0*(float(Item.Charge)/float(Item.Default.Charge))) * Scale, 2.0 * Scale , 0, 0, 32.0 * Scale, 2.0 * Scale);
  Canvas.CurX = Width + Item.Icon.USize * Scale;
}

simulated function texture findicon(inventory inv){    //try to get inv based on botpack inv.
if (inv.isa('miniammo'))
return Texture'UnrealShare.Icons.I_ShellAmmo';
switch inv.class{
case class'rocketpack':
return Texture'UnrealShare.Icons.I_RocketAmmo';
case class'pammo':
return Texture'pulseicon';
case class'bladehopper':
return Texture'UnrealI.Icons.I_RazorAmmo';
case class'flakammo':
return Texture'UnrealI.Icons.I_FlakAmmo';
case class'bioammo':
return Texture'UnrealI.Icons.I_SludgeAmmo';
case class'shockcore':
return Texture'UnrealShare.Icons.I_ASMD';
case class'thighpads':
return Texture'UnrealShare.Icons.I_kevlar';
case class'armor2':
return Texture'UnrealShare.Icons.I_Armor';
case class'warheadammo':  //nothing really fits....
return Texture'UnrealShare.Icons.I_Dispersion';
}
return none;
}

defaultproperties
{
    WhiteColor=(R=255,G=255,B=255,A=0),
    RedColor=(R=255,G=0,B=0,A=0),
    GreenColor=(R=0,G=255,B=0,A=0),
    CyanColor=(R=0,G=255,B=255,A=0),
    UnitColor=(R=1,G=1,B=1,A=0),
    BlueColor=(R=0,G=0,B=255,A=0),
    GoldColor=(R=255,G=255,B=0,A=0),
    PurpleColor=(R=255,G=0,B=255,A=0),
    TurqColor=(R=0,G=128,B=255,A=0),
    GrayColor=(R=200,G=200,B=200,A=0),
    FaceColor=(R=50,G=50,B=50,A=0),
    olCrosshair=4
    realicons=True
    showtalkface=True
    showfrag=True
    ServerInfoClass=Class'botpack.ServerInfo'
    HUDConfigWindowType="oldskool.oldskoolhudconfig"
}
