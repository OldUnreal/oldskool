// ============================================================
// menu for them options......
// ============================================================

class oldskoolgameoptionsclient expands UMenuPageWindow;
//main vars.....
var bool Initialized;
var UWindowCheckBox akimbocheck, pistolcheck, quickmap, decalcheck, skprop, fragicon, oldhud, oldboard;
var UWindowEditControl ptimeslider, pamountslider;
var uwindowsmallbutton mutatorbutton, hunter;
var UWindowComboControl backround;
var UWindowMessageBox confirmmutate;
var string bgrs[256];
var int Maxbgr;
var canvas C; //h4ck..

//build menu stuff.....
function created(){
//local class<backrounds> TempClass;
local string Nextbgr;
local string Tempbgr[256];
local string temptitles[256];
local bool bFoundSavedbgr;
local string NextDefault, NextDesc;
local int i, selection, j;
super.created();
i = 0;
backround = UWindowComboControl(CreateControl(class'UWindowComboControl', 10, 10, 210, 1));
backround.SetButtons(True);
backround.SetText("Background");
backround.Align = TA_Left;
backround.SetHelpText("Select the background you wish to have on the UT desktop");
backround.SetFont(F_Normal);
backround.SetEditable(False);
//load the list of backgrounds     ripped from umenustartmatchclientwindow and edited for discription support....
GetPlayerOwner().GetNextIntDesc("backrounds", 0, nextbgr, NextDesc);
  while (Nextbgr != ""&&i<255)
  {
    Tempbgr[i] = Nextbgr;
    Temptitles[i] = nextdesc;
    i++;
    GetPlayerOwner().GetNextIntDesc("backrounds", i, Nextbgr, NextDesc);
  }
  if (dynamicloadobject("osxbackgroundChanger.osxChanger",class'class')!=none) //must load in mem or crash will occur.
    GetPlayerOwner().GetNextIntDesc("osxbackgroundChanger.osxChanger", 0, nextbgr, NextDesc);     //hack to get OSX backgrounds on.
  while (Nextbgr != ""&&I<255)
  {
    Tempbgr[i] = Nextbgr;
    Temptitles[i] = nextdesc;
    i++;
    j++;
    GetPlayerOwner().GetNextIntDesc("osxbackgroundChanger.osxChanger", j, Nextbgr, NextDesc);
  }
  // Fill the control.
  for (i=0; i<256; i++)
  {
    if (Tempbgr[i] != "")
    {
      bgrs[Maxbgr] = Tempbgr[i];
      if ( !bFoundSavedbgr && (bgrs[Maxbgr] ~= oldskoolrootwindow(root).Backround) )
      {
        bFoundSavedbgr = true;
        Selection = Maxbgr;
      }
      backround.AddItem(temptitles[i]);
      Maxbgr++;
    }
  }

backround.SetSelectedIndex(Selection);
mutatorButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 10, 35, 210, 16));
mutatorButton.SetText("SP Mutators");
mutatorbutton.Align = TA_Left;
mutatorButton.SetFont(F_Normal);
mutatorButton.SetHelpText("Select to configure the mutators you wish to use in Singleplayer");
/*decalcheck = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 60, 210, 1));
decalcheck.SetText("Use Decals.");
decalcheck.SethelpText("If checked, Unreal I weapons will use decals.  Also monster projectiles will also have decals, and monster shadows will exist.");
decalcheck.SetFont(F_Normal);
decalcheck.Align = TA_Left;
decalcheck.bChecked = class'Olweapons.uiweapons'.default.bUseDecals;    */
decalcheck = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 60, 210, 1));    //decals now blood decals.
decalcheck.SetText("Blood Decals");
decalcheck.SethelpText("If checked, then Unreal I creatures will have blood decals, providing that decals are on and gore is set to normal.");
decalcheck.SetFont(F_Normal);
decalcheck.Align = TA_Left;
decalcheck.bChecked = class'Oldskool.spoldskool'.default.bUseDecals;
quickmap = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 85, 210, 1));
quickmap.SetText("Use Quickmap");
quickmap.SethelpText("If checked, the new game window will utilitize caching, which will save a list of custom maps, reducing loading time.");
quickmap.SetFont(F_Normal);
quickmap.Align = TA_Left;
quickmap.bChecked = class'olroot.oldskoolmapsclientwindow'.default.bquickmode;
akimbocheck = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 110, 210, 1));
akimbocheck.SetText("Allow Akimbo Automags");
akimbocheck.SethelpText("Do you wish to allow two automags to be held at once in Deathmatch?");
akimbocheck.SetFont(F_Normal);
akimbocheck.Align = TA_Left;
akimbocheck.bChecked = class'Olweapons.uiweapons'.default.akimbomag;
fragicon = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 135, 210, 1));
fragicon.SetText("UT armor rules");
fragicon.SethelpText("If checked, you will only be able to have 150 armor on you.  If not, then you can collect as many as you want.  NOTE: THIS ONLY WORKS RIGHT IF ALL ARMOR IS SET TO UNREAL I versions.");
fragicon.SetFont(F_Normal);
fragicon.Align = TA_Left;
fragicon.bChecked = class'Olweapons.uiweapons'.default.newarmorrules;
/*skprop = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 160, 210, 1));
skprop.SetText("Skaarj Class Properties");
skprop.SethelpText("If checked, the skaarj trooper will have 130 health, be larger than the normal player, and be able to jump higher.");
skprop.SetFont(F_Normal);
skprop.Align = TA_Left;
skprop.bChecked = class'Oldskool.skinconfiguration'.default.skaarjprop;*/
oldhud = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 160, 210, 1));
oldhud.SetText("Unreal I HUD in DM");
//oldhud.SethelpText("If checked, the Unreal I HUD will be used in botmatch/multiplayer provided that OldSkool is in the mutators list.");
oldhud.SethelpText("If checked, the Unreal I HUD will be used in botmatch/multiplayer, even on the client.   Note that this should be turned OFF when using a non-Epic gametype.");

oldhud.SetFont(F_Normal);
oldhud.Align = TA_Left;
oldhud.bChecked = oldskoolrootwindow(root).bhud;
oldboard = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 185, 210, 1));
oldboard.SetText("Unreal I Scoreboard in DM");
//oldboard.SethelpText("If checked, the Unreal I Scoreboard will be used in botmatch/multiplayer provided that OldSkool is in the mutators list.");
oldboard.SethelpText("If checked, the Unreal I Scoreboard will be used in botmatch/multiplayer, even on the client.  Note that this should be turned OFF when using a non-Epic gametype.");
oldboard.SetFont(F_Normal);
oldboard.Align = TA_Left;
//oldboard.bChecked = class'Oldskool.oldskool'.default.bscorebored;   //bscoreBORED..lol ;)
oldboard.bChecked = oldskoolrootwindow(root).bscoreboard;   //bscoreBORED..lol ;)
pistolcheck = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 210, 210, 1));
pistolcheck.SetText("Random Dispersion Pistol Power-ups");
pistolcheck.SethelpText("If checked, random dispersion powerups will be spawned in the level, in accordance with the two options below.  Do NOT use if the level already has powerups in it.");
pistolcheck.SetFont(F_Normal);
pistolcheck.Align = TA_Left;
pistolcheck.bChecked = class'Oldskool.oldskool'.default.bpowerups;
ptimeslider = UWindowEditControl(CreateControl(class'UWindowEditControl', 10, 235, 210, 1));
ptimeslider.SetNumericOnly(True);
ptimeslider.SetMaxLength(3);
ptimeslider.Align = TA_Left;
ptimeslider.SetValue(string(class'Oldskool.oldskool'.default.poweruptime));
ptimeslider.SetText("Power-up Time");
ptimeslider.SetHelpText("Select how long powerups will stay after spawning.  Select 0 for them to last until they are pickup up.");
ptimeslider.SetFont(F_Normal);
//ptimeslider.setsize(WinWidth/2.5, 1);
pamountslider = UWindowEditControl(CreateControl(class'UWindowEditControl', 10, 260, 210, 1));
pamountslider.SetNumericOnly(True);
pamountslider.SetMaxLength(3);
pamountslider.Align = TA_Left;
//pamountslider.setsize(WinWidth/2.5, 1);
pamountslider.SetValue(string(class'Oldskool.oldskool'.default.maxpowerups));
pamountslider.SetText("Power-up Amount");
pamountslider.SetHelpText("Select how many power-ups will be spawned.");
pamountslider.SetFont(F_Normal);
DesiredWidth = 220;
DesiredHeight = 280;
if (!class'Oldskool.oldskool'.default.bpowerups){
ptimeslider.hidewindow();           //disable sliders if main option disabled.
pamountslider.hidewindow();
DesiredHeight = 230;}
Initialized = True;
}
function BeforePaint(Canvas C, float X, float Y)    //to set the stuff correctly.....
{
  local int ControlWidth, ControlLeft, ControlRight;
  local int CenterWidth, CenterPos, ButtonWidth, ButtonLeft;

  Super.BeforePaint(C, X, Y);

  ControlWidth = WinWidth/2.5;
  ControlLeft = (WinWidth/2 - ControlWidth)/2;
  ControlRight = WinWidth/2 + ControlLeft;

  CenterWidth = (WinWidth/4)*3;
  CenterPos = (WinWidth - CenterWidth)/2;

 // backround.SetSize(CenterWidth, 1);
  //backround.WinLeft = CenterPos;
  backround.EditBoxWidth = 120;

  //pamountslider.SetSize(ControlWidth, 1);
//  pamountslider.WinLeft = ControlLeft;
  pamountslider.EditBoxWidth = 25;

 // ptimeslider.SetSize(ControlWidth+8, 1);
 // ptimeslider.WinLeft = ControlRight-ControlWidth;
  ptimeslider.EditBoxWidth = 25;
}

function Notify(UWindowDialogControl C, byte E)
{
  Super.Notify(C, E);

  switch(E)
  {
  case DE_Change:    //sliders, combos, and checkboxes
    switch(C)
    {
    Case backround:
    backgroundchanged();    //too many calculations to fit here :D
    break;
    Case decalcheck:
   // class'Olweapons.uiweapons'.default.bUseDecals = decalcheck.bChecked;
   // class'Olweapons.uiweapons'.static.StaticSaveConfig();
   class'spoldskool'.default.bUseDecals = decalcheck.bChecked;
    class'spoldskool'.static.StaticSaveConfig();
    break;
    Case fragicon:
    class'olweapons.uiweapons'.default.newarmorrules = fragicon.bChecked;
    class'Olweapons.uiweapons'.static.StaticSaveConfig();
    break;
    Case oldhud:
    hudchanged();
     break;
    Case oldboard:
    boardchanged();
    break;
    Case quickmap:
    class'olroot.oldskoolmapsclientwindow'.default.bquickmode = quickmap.bChecked;
    class'olroot.oldskoolmapsclientwindow'.static.StaticSaveConfig();
    break;
    Case skprop:
    class'Oldskool.skinconfiguration'.default.skaarjprop = skprop.bChecked;
    class'Oldskool.skinconfiguration'.static.StaticSaveConfig();
    break;
    Case pistolcheck:
    if (pistolcheck.bChecked){
      ptimeslider.showwindow();           //show stuff if main option enabled.
      pamountslider.showwindow();
      DesiredHeight = 280;
    }
    else{
      ptimeslider.hidewindow();           //hide stuff if main option disabled.
      pamountslider.hidewindow();
      DesiredHeight = 230;
    }
    class'Oldskool.oldskool'.default.bpowerups = pistolcheck.bChecked;
    class'Oldskool.oldskool'.static.StaticSaveConfig();
    break;
    Case pamountslider:
    class'Oldskool.oldskool'.default.maxpowerups = int(pamountslider.getvalue());
    class'Oldskool.oldskool'.static.StaticSaveConfig();
    break;
    Case akimbocheck:
    class'Olweapons.uiweapons'.default.akimbomag = akimbocheck.bchecked;
    class'olweapons.uiweapons'.static.staticsaveconfig();
    break;
    Case ptimeslider:
    class'Oldskool.oldskool'.default.poweruptime = int(ptimeslider.getvalue());
    class'Oldskool.oldskool'.static.StaticSaveConfig();
    break;
    }
    break;
    case DE_Click:    //buttons
    switch(C)
    {
    case MutatorButton:
      Confirmmutate = MessageBox("Confirm Access to mutators window", "WARNING: Generally the use of this option is considered cheating.\\n\\nAlso, the use of mutators in SinglePlayer/Co-op has not been extensively tested and unexpected play and game crashes may result.\\n\\nDo you want to continue?", MB_YesNo, MR_No, MR_None);
      break;
       }
   break;
  }
}
function MessageBoxDone(UWindowMessageBox W, MessageBoxResult Result)    //to see if we want to go into mutators window...
{
  if(Result == MR_Yes)
  {
    switch(W)
    {
    case ConfirmMutate:
      GetParent(class'UWindowFramedWindow').ShowModal(Root.CreateWindow(class'OldSkoolMutatorWindow', 0, 0, 100, 100, Self));
      break;
    }
  }
}
function backgroundchanged(){ //called when the backround is changed.....
local int Currentbgr;
 if (!Initialized)
    return;
  Currentbgr = Backround.GetSelectedIndex();
  oldskoolrootwindow(root).backround = bgrs[currentbgr];
  root.saveconfig();         //save stuff.....
}
function hudchanged(){
local spawnnotify sn;
oldskoolrootwindow(root).bhud=oldhud.bChecked;
root.saveconfig();
//try to revert ownerz HUD.
if (!oldhud.bchecked&&getplayerowner().myhud.isa('oldskoolbasehud')&&!getplayerowner().myhud.isa('oldskoolhud')){
for (sn=getlevel().SpawnNotify;sn!=none;sn=sn.next){  //remove spawnnotifiers.
log ("spawnnotify is "$sn.class);
if (sn.class==class'oldskool.oldhudnotify') {
oldhudnotify(sn).bdisabled=true;
sn.destroy();        }
}
getplayerowner().myhud.destroy(); //it will get spawned again, next prerender.
}
//swap HUD.
if (oldhud.bchecked&&getplayerowner().myhud.isa('ChallengeHUD')){
sn=getlevel().spawn(class'oldhudnotify');
getplayerowner().myhud=hud(sn.spawnnotification(getplayerowner().myhud));} //fancy way :P
}
function boardchanged(){ //change board type.
local spawnnotify sn;
oldskoolrootwindow(root).bscoreboard = oldboard.bChecked;
root.saveconfig();
if (!oldboard.bchecked){
for (sn=getlevel().SpawnNotify;sn!=none;sn=sn.next){  //remove spawnnotifiers.
log ("spawnnotify is "$sn.class);
if (sn.class==class'oldskool.oldboardnotify'){
oldboardnotify(sn).bdisabled=true;
sn.destroy();                     }
}
if (getplayerowner().scoring!=none)
getplayerowner().myhud.destroy(); //it will get spawned again, next prerender.
}
if (oldboard.bchecked){ //swap HUD.
sn=getlevel().spawn(class'oldhudnotify');
if (getplayerowner().scoring!=none)
getplayerowner().scoring=scoreboard(sn.spawnnotification(getplayerowner().scoring));} //fancy way :P
}
defaultproperties
{
}
