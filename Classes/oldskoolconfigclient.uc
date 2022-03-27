// ============================================================
// oldskool.oldskoolconfigclient: actually its only used for DM mutator configuration, but I'm too lazy to rename it.
// First menu code ever written by me.  Not very clean nor optimized, but I really don't feel like fixing it up...
// ============================================================

class OldskoolConfigClient expands UMenuPageWindow;

var UWindowCheckBox item0,
      item1,
      item2,
      item3,
      item4,
      item5,
      item6,
      item7,
      item8,
      item9,
      item10,
    //  item11,
      item13,
      item14,
      item15,
      item16,
      item17,
      item18,
      item21,
      item22,
      item23;
      var UWindowComboControl ShieldCombo, redeemcombo, arenacombo, quadshotcombo;


function Created()
{
  Super.Created();
  item0 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 10, 210, 1));
  item0.SetText("Make Default: Dispersion Pistol");
  item0.SetFont(F_Normal);
  item0.Align = TA_Left;
  item0.bChecked = class'Oldskool.oldskool'.default.bPistol;

  item1 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 25, 210, 1));
  item1.SetText("Enforcer to Automag");
  item1.SetFont(F_Normal);
  item1.Align = TA_Left;
  item1.bChecked = class'Oldskool.oldskool'.default.bMag;

  item2 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 40, 210, 1));
  item2.SetText("Unreal I BioRifle");
  item2.SetFont(F_Normal);
  item2.Align = TA_Left;
  item2.bChecked = class'Oldskool.oldskool'.default.bBioRifle;

  item3 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 70, 210, 1));
  item3.SetText("Make ShockRifle ASMD");
  item3.SetFont(F_Normal);
  item3.Align = TA_Left;
  item3.bChecked = class'Oldskool.oldskool'.default.bASMD;

  item4 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 85, 210, 1));
  item4.SetText("Make Pulse Gun Stinger");
  item4.SetFont(F_Normal);
  item4.Align = TA_Left;
  item4.bChecked = class'Oldskool.oldskool'.default.bStingy;

  item5 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10,100, 210, 1));
  item5.SetText("Make Ripper Razorjack");
  item5.SetFont(F_Normal);
  item5.Align = TA_Left;
  item5.bChecked = class'Oldskool.oldskool'.default.bRazor;

  item6 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10,115, 210, 1));
  item6.SetText("Unreal I Minigun");
  item6.SetFont(F_Normal);
  item6.Align = TA_Left;
  item6.bChecked = class'Oldskool.oldskool'.default.bmini;

  item7 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 130, 210, 1));
  item7.SetText("Unreal I Flak Cannon");
  item7.SetFont(F_Normal);
  item7.Align = TA_Left;
  item7.bChecked = class'Oldskool.oldskool'.default.bFlak;

  item8 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 145, 210, 1));
  item8.SetText("Make Rocket Launcher Eightball");
  item8.SetFont(F_Normal);
  item8.Align = TA_Left;
  item8.bChecked = class'Oldskool.oldskool'.default.bEball;

  item9 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 160, 210, 1));
  item9.SetText("Unreal I Sniper Rifle");
  item9.SetFont(F_Normal);
  item9.Align = TA_Left;
  item9.bChecked = class'Oldskool.oldskool'.default.bRifle;

  item10 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 175, 210, 1));
  item10.SetText("Chainsaw Disperion Power-up");
  item10.SetFont(F_Normal);
  item10.Align = TA_Left;
  item10.bChecked = class'Oldskool.oldskool'.default.bPower;
  /*
  item11 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 175, 210, 1));
  item11.SetText("Make SuperShock Asmd *4");
  item11.SetFont(F_Normal);
  item11.Align = TA_Left;
  item11.bChecked = class'Oldskool.oldskool'.default.bSuperASMD;
    */
  redeemcombo = UWindowcombocontrol(CreateControl(class'UWindowcombocontrol', 10, 190, 210, 1));
  redeemcombo.SetText("Remeemer to:");
  redeemcombo.SetHelpText("What do you want to change the redeemer into?");
  redeemCombo.SetButtons(False);
  redeemcombo.seteditable(False);
  redeemcombo.SetFont(F_Normal);
  redeemcombo.Align = TA_Left;
  redeemcombo.additem("keep it");
  redeemcombo.additem("ASMD with Amp");
  redeemcombo.additem("SMP");
  redeemCombo.SetSelectedIndex(class'Oldskool.oldskool'.default.redeemmode);

  item13 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 205, 210, 1));
  item13.SetText("Unreal I Jumpboots");
  item13.SetFont(F_Normal);
  item13.Align = TA_Left;
  item13.bChecked = class'Oldskool.oldskool'.default.bJump;

item14 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 220, 210, 1));
  item14.SetText("Damage to Amplifier");
  item14.SetFont(F_Normal);
  item14.Align = TA_Left;
  item14.bChecked = class'Oldskool.oldskool'.default.bdamage;

item15 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 235, 210, 1));
  item15.SetText("Thigh Pad to Kevlar");
  item15.SetFont(F_Normal);
  item15.Align = TA_Left;
  item15.bChecked = class'Oldskool.oldskool'.default.bpad;

item16 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 250, 210, 1));
  item16.SetText("Unreal I Megahealth");
  item16.SetFont(F_Normal);
  item16.Align = TA_Left;
  item16.bChecked = class'Oldskool.oldskool'.default.bmegahealth;

item17 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 265, 210, 1));
  item17.SetText("Unreal I Armor");
  item17.SetFont(F_Normal);
  item17.Align = TA_Left;
  item17.bChecked = class'Oldskool.oldskool'.default.barmor;

item18 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 280, 210, 1));
  item18.SetText("Vial to bandage");
  item18.SetFont(F_Normal);
  item18.Align = TA_Left;
  item18.bChecked = class'Oldskool.oldskool'.default.bbandaid;

/* old checkbox was here....
item19 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10,310, 210, 1));
  item19.SetText("Old Shieldbelt (100)");
  item19.SetFont(F_Normal);
  item19.Align = TA_Left;
  item19.bChecked = class'Oldskool.oldskool'.default.bshield;

item20 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10,325, 210, 1));
  item20.SetText("Shield to Powershield (200)");
  item20.SetFont(F_Normal);
  item20.Align = TA_Left;
  item20.bChecked = class'Oldskool.oldskool'.default.bpshield;  */

  ShieldCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', 10, 295, 210, 1));
  ShieldCombo.SetButtons(False);
  ShieldCombo.SetText("ShieldBelt to:");
  ShieldCombo.SetHelpText("What do you want to make the shieldbelt?");
  ShieldCombo.SetFont(F_Normal);
  ShieldCombo.SetEditable(False);
  ShieldCombo.Align = TA_Left;
  ShieldCombo.AddItem("Keep it (150)");
  ShieldCombo.AddItem("Old shieldbelt (100)");
  ShieldCombo.AddItem("PowerShield (200)");
  ShieldCombo.SetSelectedIndex(class'Oldskool.oldskool'.default.shieldmode);

item21 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10,310, 210, 1));
  item21.SetText("Unreal I HealthPack");
  item21.SetFont(F_Normal);
  item21.Align = TA_Left;
  item21.bChecked = class'Oldskool.oldskool'.default.bmed;

item22 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 325, 210, 1));
  item22.SetText("Full Invisibility");
  item22.SetFont(F_Normal);
  item22.Align = TA_Left;
  item22.bChecked = class'Oldskool.oldskool'.default.binvis;

item23 = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 55, 210, 1));
  item23.SetText("Start off with automag");
  item23.SetFont(F_Normal);
  item23.Align = TA_Left;
  item23.bChecked = class'Oldskool.oldskool'.default.bdefauto;

quadshotcombo = UWindowcombocontrol(CreateControl(class'UWindowcombocontrol', 10, 340, 210, 1));
  quadshotcombo.SetText("Weapon to Quadshot:");
  quadshotcombo.SetHelpText("What weapon should become the Quadshot?  Note that the Unreal I equivilents will also change with this option....");
  quadshotcombo.seteditable(False);
  quadshotcombo.SetFont(F_Normal);
  quadshotcombo.Align = TA_Left;
  quadshotcombo.additem("Nothing");
  quadshotcombo.additem("Impact Hammer");
  quadshotcombo.additem("Enforcer");
  quadshotcombo.additem("Pulse Gun");
  quadshotcombo.additem("Shock Rifle");
  quadshotcombo.additem("Rocket Launcher");
  quadshotcombo.additem("Flak Cannon");
  quadshotcombo.additem("Ripper");
  quadshotcombo.additem("GES BioRifle");
  quadshotcombo.additem("Sniper Rifle");
  quadshotcombo.additem("Minigun");
  quadshotcombo.additem("Redeemer");
  quadshotCombo.SetSelectedIndex(class'Oldskool.oldskool'.default.quadmode);

  arenacombo = UWindowcombocontrol(CreateControl(class'UWindowcombocontrol', 10, 355, 210, 1));
  arenacombo.SetText("Arena:");
  arenacombo.SetHelpText("Select the weapon you wish to act as an arena.  Select No Arena for OldSkool to use all the above options.");
  arenacombo.seteditable(False);
  arenacombo.SetFont(F_Normal);
  arenacombo.Align = TA_Left;
  arenacombo.additem("No Arena");
  arenacombo.additem("Dispersion Pistol");
  arenacombo.additem("Automag");
  arenacombo.additem("Stinger");
  arenacombo.additem("ASMD");
  arenacombo.additem("Eightball");
  arenacombo.additem("Flak Cannon");
  arenacombo.additem("Razorjack");
  arenacombo.additem("GES BioRifle");
  arenacombo.additem("Sniper Rifle");
  arenacombo.additem("Minigun");
  arenacombo.additem("QuadShot");
  arenacombo.additem("SMP");
  arenaCombo.SetSelectedIndex(class'Oldskool.oldskool'.default.arenamode);
    DesiredWidth = 220;
  DesiredHeight = 380;
}
function RightClickTab()     // :D
{
MessageBox("Semi-Secret Message", "Close, but no cigar.  Try again!", MB_OK, MR_OK, MR_OK);    //hey!!!!! don't look at this!!!
}
function Notify(UWindowDialogControl C, byte E)
{
  Super.Notify(C, E);
  switch(E) {
    case DE_Change:
    switch(C) {
      case item0:
        
        class'Oldskool.oldskool'.default.bPistol = item0.bChecked;
        class'Oldskool.oldskool'.static.StaticSaveConfig();

        break;
      case item1:
                
        class'Oldskool.oldskool'.default.bMag = item1.bChecked;
       class'Oldskool.oldskool'.static.StaticSaveConfig();
       class'olroot.oldskoolweaponprioritylistbox'.default.bnewmag = !item1.bChecked;      //for weapon priorities
       class'olroot.oldskoolweaponprioritylistbox'.static.StaticSaveConfig();

        break;
      case item2:
        
        class'Oldskool.oldskool'.default.bBioRifle = item2.bChecked;
       class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;
      case item3:
        
        class'Oldskool.oldskool'.default.bASMD = item3.bChecked;

        class'Oldskool.oldskool'.static.StaticSaveConfig();

        break;
      case item4:
        
        class'Oldskool.oldskool'.default.bStingy = item4.bChecked;

        class'Oldskool.oldskool'.static.StaticSaveConfig();

        break;
      case item5:
        class'Oldskool.oldskool'.default.bRazor = item5.bChecked;
       class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;
      case item6:
        class'Oldskool.oldskool'.default.bmini = item6.bChecked;
       class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;

      case item7:
        class'Oldskool.oldskool'.default.bFlak = item7.bChecked;
        class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;
      case item8:
        class'Oldskool.oldskool'.default.bEball = item8.bChecked;
       class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;
      case item9:
        class'Oldskool.oldskool'.default.bRifle = item9.bChecked;
        class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;
      case item10:
        class'Oldskool.oldskool'.default.bPower=item10.bchecked;
       class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;
  /*    case item11:
        class'Oldskool.oldskool'.default.bSuperASMD = item11.bChecked;
      class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;                                                   */
      case item13:
        class'Oldskool.oldskool'.default.bjump = item13.bChecked;
        class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;
    case item14:
        class'Oldskool.oldskool'.default.bdamage = item14.bChecked;
       class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;
    case item15:
        class'Oldskool.oldskool'.default.bpad = item15.bChecked;
       class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;
    case item16:
        class'Oldskool.oldskool'.default.bmegahealth = item16.bChecked;
       class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;
    case item17:
        class'Oldskool.oldskool'.default.barmor = item17.bChecked;
        class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;
    case item18:
        class'Oldskool.oldskool'.default.bbandaid = item18.bChecked;
        class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;
   /* case item19:

class'Oldskool.oldskool'.default.bshield = item19.bChecked;
    class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;
    case item20:
class'Oldskool.oldskool'.default.bpshield = item20.bChecked;
    class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;          */
    case item21:
        class'Oldskool.oldskool'.default.bmed = item21.bChecked;
       class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;
case item22:
        class'Oldskool.oldskool'.default.binvis = item22.bChecked;
       class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;
    case item23:
        class'Oldskool.oldskool'.default.bdefauto = item23.bChecked;
        class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;
    case ShieldCombo:
        class'Oldskool.oldskool'.default.shieldmode = shieldcombo.getselectedindex();
        class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;
    case redeemCombo:
        class'Oldskool.oldskool'.default.redeemmode = redeemcombo.getselectedindex();
        class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;
    case quadshotCombo:
        class'Oldskool.oldskool'.default.quadmode = quadshotcombo.getselectedindex();
        class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;
     case ArenaCombo:
        class'Oldskool.oldskool'.default.arenamode = Arenacombo.getselectedindex();
        class'Oldskool.oldskool'.static.StaticSaveConfig();
        break;
    }
    break;
  }
}

defaultproperties
{
}
