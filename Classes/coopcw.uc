// ============================================================
//coopcw.  Cleint window to setup co-op games.........
// ============================================================

class coopcw expands UMenuPageWindow;
//main window vars (settings done via localization in UT, thus no text vars.......
var oldskoolnewgameclientwindow mainparent;
var coopbase pagebase;
var uwindowcombocontrol mapcombo;
var UWindowSmallCloseButton CloseButton;
var UWindowSmallButton StartButton;
var UWindowSmallButton DedicatedButton;
var UWindowHSliderControl FFSlider;
var UWindowEditControl MaxPlayersEdit;
var UWindowMessageBox ConfirmStart;
var UWindowEditControl MaxSpectatorsEdit;
var UWindowHSliderControl SpeedSlider;
var UWindowEditControl GamePasswordEdit;
//webserver vars
var Uwindowlabelcontrol adminlabel;
var UWindowEditControl AdminPasswordEdit;
var UWindowCheckbox baddiecheck;
var UWindowEditControl WebAdminUsernameEdit;
var UWindowEditControl WebAdminPasswordEdit;
var UWindowEditControl ListenPortEdit;
//create window
function Created()
{
  local int ControlWidth, ControlLeft, ControlRight;
  local int CenterWidth, CenterPos, i, Controloffset;
  local int FFS;

pagebase = coopbase(GetParent(class'oldskool.coopbase'));
  //NEVER should happen....... except cause of h4x0rs :D
  if (pagebase == None)
    Log("Error: coopcw without coopbase window.  Stop hacking these scripts you idiot!!!");
  mainParent = oldskoolnewgameclientwindow(pagebase.OwnerWindow);
  ControlOffset = 10;
  Super.Created();

  ControlWidth = WinWidth/2.5;
  ControlLeft = (WinWidth/2 - ControlWidth)/2;
  ControlRight = WinWidth/2 + ControlLeft;

  CenterWidth = (WinWidth/4)*3;
  CenterPos = (WinWidth - CenterWidth)/2;
  /*not fully in client.......
  DedicatedButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', WinWidth-156, WinHeight-24, 48, 16));
  DedicatedButton.SetText(class'utmenu.utstartgamecw'.default.DedicatedText);
  DedicatedButton.SetHelpText(class'utmenu.utstartgamecw'.default.DedicatedHelp);
  CloseButton = UWindowSmallCloseButton(CreateControl(class'UWindowSmallCloseButton', WinWidth-56, WinHeight-24, 48, 16));
  StartButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', WinWidth-106, WinHeight-24, 48, 16));
  StartButton.SetText(class'umenu.umenubotmatchclientwindow'.default.StartText);     */
  //main stuff
  mapcombo = UWindowcombocontrol(CreateControl(class'UWindowcombocontrol', ControlLeft, ControlOffset, ControlWidth, 1));
  MapCombo.SetButtons(True);
  MapCombo.SetText(class'umenu.umenustartmatchclientwindow'.default.MapText);
  MapCombo.SetHelpText(class'umenu.umenustartmatchclientwindow'.default.MapHelp);
  MapCombo.SetFont(F_Normal);
  MapCombo.SetEditable(False);
  for (i=0;i<44;i++){
  if (mainparent.selectedpackclass.default.maps[i]!='')
  Mapcombo.additem(string(mainparent.selectedpackclass.default.maps[i]), string(mainparent.selectedpackclass.default.maps[i]));
  }
  mapcombo.setselectedindex(0);
  if (mainparent.selectedpacktype~="custom"){
  mapcombo.hidewindow();
  pagebase.map=mainparent.map;}
  else
  pagebase.map=string(mainparent.selectedpackclass.default.maps[0]);

  ControlOffset += 25;
  MaxPlayersEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', ControlLeft, ControlOffset, ControlWidth, 1));
    MaxPlayersEdit.SetText(class'umenu.umenugamerulesbase'.default.MaxPlayersText);
    MaxPlayersEdit.SetHelpText(class'umenu.umenugamerulesbase'.default.MaxPlayersHelp);
    MaxPlayersEdit.SetFont(F_Normal);
    MaxPlayersEdit.SetNumericOnly(True);
    MaxPlayersEdit.SetMaxLength(2);
    MaxPlayersEdit.Align = TA_Right;
    MaxPlayersEdit.SetDelayedNotify(True);

    // Max Spectators
    MaxSpectatorsEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', ControlRight, ControlOffset, ControlWidth, 1));
    MaxSpectatorsEdit.SetText(class'umenu.umenugamerulesbase'.default.MaxSpectatorsText);
    MaxSpectatorsEdit.SetHelpText(class'umenu.umenugamerulesbase'.default.MaxSpectatorsHelp);
    MaxSpectatorsEdit.SetFont(F_Normal);
    MaxSpectatorsEdit.SetNumericOnly(True);
    MaxSpectatorsEdit.SetMaxLength(2);
    MaxSpectatorsEdit.Align = TA_Right;
    MaxSpectatorsEdit.SetDelayedNotify(True);
    ControlOffset += 25;
    if(MaxPlayersEdit != None)
    MaxPlayersEdit.SetValue(string(Class'oldskool.coopgame2'.Default.MaxPlayers));

  if(MaxSpectatorsEdit != None)
    MaxSpectatorsEdit.SetValue(string(Class'oldskool.coopgame2'.Default.MaxSpectators));

baddiecheck = UWindowCheckBox(CreateControl(class'UWindowCheckBox', Controlleft, ControlOffset, centerwidth*2, 1));
  baddiecheck.SetText("Allow spectating of monsters");
  baddiecheck.SetFont(F_Normal);
  baddiecheck.bChecked = class'Oldskool.coopgame2'.default.baddiespectate;
 ControlOffset += 25;
FFSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', CenterPos, ControlOffset, CenterWidth, 1));
  FFSlider.SetRange(0, 10, 1);
  FFS = Class'oldskool.coopgame2'.Default.FriendlyFireScale * 10;
  FFSlider.SetValue(FFS);
  FFSlider.SetText(class'utmenu.utteamrcwindow'.default.FFText$" ["$FFS*10$"%]:");
  FFSlider.SetHelpText(class'utmenu.utteamrcwindow'.default.FFHelp);
  FFSlider.SetFont(F_Normal);
  ControlOffset += 25;

   SpeedSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', CenterPos, ControlOffset, CenterWidth, 1));
  SpeedSlider.SetRange(50, 200, 5);
  SpeedSlider.SetText(class'umenu.umenugamesettingsbase'.default.speedtext);
  SpeedSlider.SetHelpText(class'umenu.umenugamesettingsbase'.default.SpeedHelp);
  SpeedSlider.SetFont(F_Normal);
  SpeedSlider.SetValue(Class'oldskool.coopgame2'.Default.GameSpeed * 100.0);
  ControlOffset += 25;

}
 //stuff......
function BeforePaint(Canvas C, float X, float Y)
{
  local int ControlWidth, ControlLeft, ControlRight;
  local int CenterWidth, CenterPos, ButtonWidth, ButtonLeft, EditWidth;

  Super.BeforePaint(C, X, Y);

  ControlWidth = WinWidth/2.5;
  ControlLeft = (WinWidth/2 - ControlWidth)/2;
  ControlRight = WinWidth/2 + ControlLeft;

  CenterWidth = (WinWidth/4)*3;
  CenterPos = (WinWidth - CenterWidth)/2;

MapCombo.SetSize(CenterWidth, 1);
  MapCombo.WinLeft = CenterPos;
  MapCombo.EditBoxWidth = 150;
baddiecheck.SetSize(CenterWidth, 1);
baddiecheck.WinLeft = CenterPos;
FFSlider.SetSize(CenterWidth, 1);
  FFSlider.SliderWidth = 90;
  FFSlider.WinLeft = CenterPos;

  if(MaxPlayersEdit != None)
  {
    MaxPlayersEdit.SetSize(ControlWidth, 1);
    MaxPlayersEdit.WinLeft = ControlLeft;
    MaxPlayersEdit.EditBoxWidth = 25;
  }

  if(MaxSpectatorsEdit != None)
  {
    MaxSpectatorsEdit.SetSize(ControlWidth, 1);
    MaxSpectatorsEdit.WinLeft = ControlRight;
    MaxSpectatorsEdit.EditBoxWidth = 25;
  }
  SpeedSlider.SetSize(CenterWidth, 1);
  SpeedSlider.SliderWidth = 90;
  SpeedSlider.WinLeft = CenterPos;
  EditWidth = CenterWidth - 100;

 }
function Notify(UWindowDialogControl C, byte E)
{
    switch(E)
    {
    case DE_Change:
      switch(C)
      {
      case MaxPlayersEdit:
        MaxPlayersChanged();
        break;
      case MaxSpectatorsEdit:
        MaxSpectatorsChanged();
        break;
      case FFSlider:
        FFChanged();
        break;
      case baddiecheck:
       class'Oldskool.coopgame2'.default.baddiespectate = baddiecheck.bChecked;
         break;
      case SpeedSlider:
        SpeedChanged();
        break;
      case mapcombo:
      pagebase.map=string(mainparent.selectedpackclass.default.maps[mapcombo.Getselectedindex()]);
      break;
      }
    }

  Super.Notify(C, E);
}
function MaxPlayersChanged()
{
  if(int(MaxPlayersEdit.GetValue()) > 16)
    MaxPlayersEdit.SetValue("16");
  if(int(MaxPlayersEdit.GetValue()) < 1)
    MaxPlayersEdit.SetValue("1");

  Class'oldskool.coopgame2'.Default.MaxPlayers = int(MaxPlayersEdit.GetValue());
}

function MaxSpectatorsChanged()
{
  if(int(MaxSpectatorsEdit.GetValue()) > 16)
    MaxSpectatorsEdit.SetValue("16");
  
  if(int(MaxSpectatorsEdit.GetValue()) < 0)
    MaxSpectatorsEdit.SetValue("0");

  Class'oldskool.coopgame2'.Default.MaxSpectators = int(MaxSpectatorsEdit.GetValue());
}
function SpeedChanged()
{
  local int S;

  S = SpeedSlider.GetValue();
  SpeedSlider.SetText(class'umenu.umenugamesettingsbase'.default.SpeedText$" ["$S$"%]:");
  Class'oldskool.coopgame2'.Default.GameSpeed = float(S) / 100.0;
}
function FFChanged()
{
  Class'oldskool.coopgame2'.Default.FriendlyFireScale = FFSlider.GetValue() / 10;
  FFSlider.SetText(class'utmenu.utteamrcwindow'.default.FFText$" ["$int(FFSlider.GetValue()*10)$"%]:");
}
function RightClickTab()     // :D
{
MessageBox("Think about it!", "In case you haven't noticed, right clicking doesn't do anything in Uwindow's mode.\\nWell, at least in Epic's windows ;)", MB_OK, MR_OK, MR_OK);    //;p
}

defaultproperties
{
}
