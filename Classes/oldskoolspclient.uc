// ============================================================
// oldskool.oldskoolspclient: the SP mutator client based on oldskool client....:D
// ============================================================

class oldskoolspclient expands UMenuPageWindow;

var UWindowCheckBox
      item1,
      item2,
      item3,
      item4,
      item5,
      item6,
      item7,
      item8,
      item9,
      item13,
      item14,
      item15,
      item16,
      item17,
      item19,
      item21,
      Pause,
      SpTaunt,
      Aircon,
      PermaCarc,
      PermaDec;

var localized string warnhelp;
function Created()
{
  Super.Created();
  item1 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 10, 210, 1));
  item1.SetText("Automag to Enforcer");
  item1.SetHelpText(warnhelp$"  Furthermore, Liandri will confiscate one enforcer if you have two of them, upon entering a new level.");
  item1.SetFont(F_Normal);
  item1.Align = TA_Left;
  item1.bChecked = class'Oldskool.spoldskool'.default.bMag;

  item2 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 28, 210, 1));
  item2.SetText("UT BioRifle");
  item2.SetHelpText(warnhelp);
  item2.SetFont(F_Normal);
  item2.Align = TA_Left;
  item2.bChecked = class'Oldskool.spoldskool'.default.bBioRifle;

  item3 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 46, 210, 1));
  item3.SetText("Change ASMD into ShockRifle");
  item3.SetFont(F_Normal);
  item3.Align = TA_Left;
  item3.bChecked = class'Oldskool.spoldskool'.default.bASMD;

  item4 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 64, 210, 1));
  item4.SetText("Change Stinger into Pulse Gun");
  item4.SetHelpText(warnhelp);
  item4.SetFont(F_Normal);
  item4.Align = TA_Left;
  item4.bChecked = class'Oldskool.spoldskool'.default.bStingy;

  item5 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10,82, 210, 1));
  item5.SetText("Change Razorjack into Ripper");
  item5.SetHelpText(warnhelp);
  item5.SetFont(F_Normal);
  item5.Align = TA_Left;
  item5.bChecked = class'Oldskool.spoldskool'.default.bRazor;

  item6 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10,98, 210, 1));
  item6.SetText("UT minigun");
  item6.SetFont(F_Normal);
  item6.Align = TA_Left;
  item6.bChecked = class'Oldskool.spoldskool'.default.bmini;

  item7 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 116, 210, 1));
  item7.SetText("UT Flak Cannon");
  item7.SetHelpText(warnhelp);
  item7.SetFont(F_Normal);
  item7.Align = TA_Left;
  item7.bChecked = class'Oldskool.spoldskool'.default.bFlak;

  item8 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 134, 210, 1));
  item8.SetText("Change Eightball into Rocket Launcher");
  item8.SetFont(F_Normal);
  item8.Align = TA_Left;
  item8.bChecked = class'Oldskool.spoldskool'.default.bEball;

  item9 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 152, 210, 1));
  item9.SetText("UT Sniper Rifle");
  item9.SetFont(F_Normal);
  item9.Align = TA_Left;
  item9.bChecked = class'Oldskool.spoldskool'.default.bRifle;

  item13 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 170, 210, 1));
  item13.SetText("UT Jumpboots");
  item13.SetFont(F_Normal);
  item13.Align = TA_Left;
  item13.bChecked = class'Oldskool.spoldskool'.default.bJump;

item14 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 188, 210, 1));
  item14.SetText("Amplifier to Udamage");
  item14.SetHelpText(warnhelp$"  Note that this damage only will last 9 seconds...");
  item14.SetFont(F_Normal);
  item14.Align = TA_Left;
  item14.bChecked = class'Oldskool.spoldskool'.default.bdamage;

item15 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 206, 210, 1));
  item15.SetText("Kevlar Suit to Thigh Pads");
  item15.SetFont(F_Normal);
  item15.Align = TA_Left;
  item15.bChecked = class'Oldskool.spoldskool'.default.bpad;

item16 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 224, 210, 1));
  item16.SetText("UT Megahealth");
  item16.SetFont(F_Normal);
  item16.Align = TA_Left;
  item16.bChecked = class'Oldskool.spoldskool'.default.bmegahealth;

item17 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 242, 210, 1));
  item17.SetText("UT Armor");
  item17.SetFont(F_Normal);
  item17.Align = TA_Left;
  item17.bChecked = class'Oldskool.spoldskool'.default.barmor;

item19 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10,260, 210, 1));
  item19.SetText("UT shieldbelts");
  item19.SetFont(F_Normal);
  item19.Align = TA_Left;
  item19.bChecked = class'Oldskool.spoldskool'.default.bshield;


item21 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10,278, 210, 1));
  item21.SetText("UT HealthPack");
  item21.SetFont(F_Normal);
  item21.Align = TA_Left;
  item21.bChecked = class'Oldskool.spoldskool'.default.bmed;
SpTaunt = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 296, 210, 1));
SpTaunt.SetText("SinglePlayer Auto-Taunt");
SpTaunt.SethelpText("If checked, a taunt will be played when you defeat an enemy in SinglePlayer.  Also, headshot messages will appear if you headshot an enemy.  Does not apply to coop");
SpTaunt.SetFont(F_Normal);
SpTaunt.Align = TA_Left;
SpTaunt.bChecked = class'singleplayer2'.default.SpTaunts;
Pause = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 314, 210, 1));
Pause.SetText("Load w/ Pause");
Pause.SethelpText("If checked, the game will be paused after loading a saved game");
Pause.SetFont(F_Normal);
Pause.Align = TA_Left;
Pause.bChecked = class'singleplayer2'.default.Pause;
AirCon = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 332, 210, 1));
AirCon.SetText("Un&r&e&a&l Air Control");
AirCon.SethelpText("If checked, the game will have very little air control, as unreal did. Thus is always false for Legacy.  Please note that some maps may require that this is true and others wish it to be false.");
AirCon.SetFont(F_Normal);
AirCon.Align = TA_Left;
AirCon.bChecked = class'spoldskool'.default.UnAir;
PermaCarc = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 350, 210, 1));
PermaCarc.SetText("Permanent Carcasses");
PermaCarc.SethelpText("If checked, carcasses will remain until destroyed.");
PermaCarc.SetFont(F_Normal);
PermaCarc.Align = TA_Left;
PermaCarc.bChecked = class'olcreaturecarcass'.default.PermaCarcass;
PermaDec = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 368, 210, 1));
PermaDec.SetText("Permanent Decals");
PermaDec.SethelpText("If checked, decals will remain forever in the level.");
PermaDec.SetFont(F_Normal);
PermaDec.Align = TA_Left;
PermaDec.bChecked = class'spoldskool'.default.PermaDecals;
  DesiredWidth = 220;
  DesiredHeight = 388;
}

function Notify(UWindowDialogControl C, byte E)
{
  Super.Notify(C, E);
  switch(E) {
    case DE_Change:
    switch(C) {

      case item1:
                
        class'Oldskool.spoldskool'.default.bMag = item1.bChecked;
       class'Oldskool.spoldskool'.static.StaticSaveConfig();

        break;
      case item2:
        
        class'Oldskool.spoldskool'.default.bBioRifle = item2.bChecked;
       class'Oldskool.spoldskool'.static.StaticSaveConfig();
        break;
      case item3:
        
        class'Oldskool.spoldskool'.default.bASMD = item3.bChecked;

        class'Oldskool.spoldskool'.static.StaticSaveConfig();

        break;
      case item4:
        
        class'Oldskool.spoldskool'.default.bStingy = item4.bChecked;

        class'Oldskool.spoldskool'.static.StaticSaveConfig();

        break;
      case item5:
        class'Oldskool.spoldskool'.default.bRazor = item5.bChecked;
       class'Oldskool.spoldskool'.static.StaticSaveConfig();
        break;
      case item6:
        class'Oldskool.spoldskool'.default.bmini = item6.bChecked;
       class'Oldskool.spoldskool'.static.StaticSaveConfig();
        break;
      case item7:
        class'Oldskool.spoldskool'.default.bFlak = item7.bChecked;
        class'Oldskool.spoldskool'.static.StaticSaveConfig();
        break;
      case item8:
        class'Oldskool.spoldskool'.default.bEball = item8.bChecked;
       class'Oldskool.spoldskool'.static.StaticSaveConfig();
        break;
      case item9:
        class'Oldskool.spoldskool'.default.bRifle = item9.bChecked;
        class'Oldskool.spoldskool'.static.StaticSaveConfig();
        break;
     case item13:
        class'Oldskool.spoldskool'.default.bjump = item13.bChecked;
        class'Oldskool.spoldskool'.static.StaticSaveConfig();
        break;
    case item14:
        class'Oldskool.spoldskool'.default.bdamage = item14.bChecked;
       class'Oldskool.spoldskool'.static.StaticSaveConfig();
        break;
    case item15:
        class'Oldskool.spoldskool'.default.bpad = item15.bChecked;
       class'Oldskool.spoldskool'.static.StaticSaveConfig();
        break;
    case item16:
        class'Oldskool.spoldskool'.default.bmegahealth = item16.bChecked;
       class'Oldskool.spoldskool'.static.StaticSaveConfig();
        break;
    case item17:
        class'Oldskool.spoldskool'.default.barmor = item17.bChecked;
        class'Oldskool.spoldskool'.static.StaticSaveConfig();
        break;

    case item19:

class'Oldskool.spoldskool'.default.bshield = item19.bChecked;
    class'Oldskool.spoldskool'.static.StaticSaveConfig();
        break;

    case item21:
        class'Oldskool.spoldskool'.default.bmed = item21.bChecked;
       class'Oldskool.spoldskool'.static.StaticSaveConfig();
        break;
    Case Pause:
    class'singleplayer2'.default.Pause=Pause.bChecked;
    class'singleplayer2'.static.staticSaveConfig();
    break;
    case SPTaunt:
    class'singleplayer2'.default.SpTaunts=SpTaunt.bChecked;
    class'singleplayer2'.static.staticSaveConfig();
    if (getlevel().game!=none&&Getlevel().game.isa('singleplayer2'))
      singleplayer2(getlevel().game).SpTaunts=SpTaunt.bChecked;
    break;
    case AirCon:
    class'spoldskool'.default.UnAir=AirCon.bChecked;
    class'spoldskool'.static.staticSaveConfig();
    if (getlevel().game!=none&&Getlevel().game.isa('singleplayer2')&&!GetLevel().Game.isa('LegacySP')&&!GetLevel().Game.Isa('tvsp')){
      if (AirCon.bchecked)
        getPlayerOwner().aircontrol=class'pawn'.default.aircontrol;
      else
        getPlayerOwner().aircontrol=getPlayerOwner().default.aircontrol;
    }
    break;
    case PermaCarc:
    class'olcreaturecarcass'.default.PermaCarcass=PermaCarc.bChecked;
    class'olcreaturecarcass'.static.StaticSaveConfig();
    break;
    case PermaDec:
    class'spoldskool'.default.PermaDEcals=PermaDec.bChecked;
    class'spoldskool'.static.StaticSaveConfig();
    break;
    }
    break;
  }
}

defaultproperties
{
    warnhelp="Warning: Enabling this may be considered cheating."
}
