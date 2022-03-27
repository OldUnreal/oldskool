// ============================================================
// oldskool.skinbotset: the bot skin setter (same as player version)
// Psychic_313: DEPRECATED. DON'T USE ME.
// ============================================================

class skinbotset expands Bot
abstract;

var() string DefaultTalkTexture;       //no talktexture will use this one....
var() string TeamSkin;        //what is the main skin to use for TC's?
var bool  bpartialteam;       //only two colours (i.e. skaarj trooper)...
var string tbackup;        //setmultiskin is called twice.  by having this variable being defined outside the function, the talktexture is preserved.....
var () string altpackage;   //for use with only Unreal Skins.....


static function SetMultiSkin(Actor SkinActor, string SkinName, string FaceName, byte TeamNum)
{
  local string SkinItem, SkinPackage, SkinTeam, Tfix, combine;             //various local strings.....
local Texture NewSkin, Talktestskin;
  local int i;
  local string TeamColor[4];          //from unreali player.  used for non-full versions....
  TeamColor[0]="Red";
  TeamColor[1]="Blue";
  TeamColor[2]="Green";
  TeamColor[3]="Yellow";
  SkinItem = SkinActor.GetItemName(SkinName);
  SkinPackage = Left(SkinName, Len(SkinName) - Len(SkinItem));
  //back-up talktexture, so it doesn't revert to team one
  If (Left(Right(default.teamskin, 5),4) != Left(skinitem, 4))
    default.tbackup=skinitem;
  if( TeamNum != 255 )
  {
    tfix = Left(skinitem$"111", 4);
    combine=skinpackage$tfix$"1T_"$String(TeamNum);
  //check if team skin exists..if it does set it!!!!!!
  if (Right(skinpackage, 6) ~= "skins.") //user is using partail mode........
  NewSkin = texture(DynamicLoadObject(skinpackage$"T_"$TeamColor[TeamNum], class'Texture'));
  else
  NewSkin = Texture(DynamicLoadObject(skinpackage$tfix$"1T_"$String(TeamNum), class'Texture'));
  if ( NewSkin != None )
  SkinActor.Multiskins[0] = Newskin;
  else
  {
    log("Team color not under "$SkinName);
    //check if only two team colors (Skaarj)... skinners willing to help?
    If (!default.bpartialteam)
    skinteam = default.Teamskin$"t_"$String(TeamNum);
    else
      {
      if (TeamNum <2)
       skinteam = default.Teamskin$"t_"$String(TeamNum);
       else
      skinteam = skinname;  }
      SetSkinElement(SkinActor, 0, Skinteam, default.Altpackage$"T_"$TeamColor[TeamNum]);
    for( i=0; i<64; i++ )
    {
    if( class'Oldskool.skinconfiguration'.default.skins[i] == combine )
    {
    SetSkinElement(SkinActor, 0, skinpackage$default.tbackup, skinpackage$default.tbackup);
    break;
    }  
    }
}
}
  //not team......
  else
   SetSkinElement(SkinActor, 0, SkinName, "");
    // Set the talktexture
  if(Pawn(SkinActor) != None)
  {
    if (Right(skinpackage, 6) ~= "skins."){ //user is using partial mode........
    if (Left(skinpackage, 6) ~= "female")
    Pawn(SkinActor).PlayerReplicationInfo.TalkTexture = Texture(DynamicLoadObject("fcommandoskins.cMDo5Ivana", class'Texture'));        //Ivana's face for females......
    else      //cliffyB mode...
    Pawn(SkinActor).PlayerReplicationInfo.TalkTexture = Texture(DynamicLoadObject("UTtech2.Deco.xmetex2x1", class'Texture'));                  //a face: cliffy B :D  (males or sktrooper.....)
    }
    else {
    talktestskin = Texture(DynamicLoadObject(skinpackage$Left(default.tbackup$"111", 4)$"5", class'Texture'));
    if(talktestskin != none)
    Pawn(SkinActor).PlayerReplicationInfo.TalkTexture = talktestskin;
    else{
      log("no talktexture for "$skinname);
      Pawn(SkinActor).PlayerReplicationInfo.TalkTexture = Texture(DynamicLoadObject(default.defaulttalktexture, class'Texture'));
      If (Pawn(SkinActor).PlayerReplicationInfo.TalkTexture ==None){       //apparently we're using some custom skin, yet in the lite version....
      if (Left(skinpackage, 6) ~= "female")
    Pawn(SkinActor).PlayerReplicationInfo.TalkTexture = Texture(DynamicLoadObject("fcommandoskins.cMDo5Ivana", class'Texture'));        //Ivana's face for females......
    else      //cliffyB mode...
    Pawn(SkinActor).PlayerReplicationInfo.TalkTexture = Texture(DynamicLoadObject("UTtech2.Deco.xmetex2x1", class'Texture'));                  //a face: cliffy B :D  (males or sktrooper.....)
    }}
  } }
}
//hehehahaha..this keeps dumb team game from changing stuff....
static function GetMultiSkin( Actor SkinActor, out string SkinName, out string FaceName )
{
  
  SkinName  = String(SkinActor.Multiskins[0]);
  FaceName = "";
}

defaultproperties
{
    DefaultTalkTexture="male2skiny.ashy5"
    TeamSkin="male1skiny.cart1"
    bIsMultiSkinned=False
}
