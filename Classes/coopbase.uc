// ============================================================
//coopbase.  builds the duel-pages for Co-op.....
// ============================================================

class coopbase expands UMenuDialogClientWindow;
var string Map;
var UMenuPageControl Pages;
var UWindowSmallCloseButton CloseButton;
var UWindowSmallButton StartButton;
var UWindowSmallButton DedicatedButton;
var UWindowMessageBox ConfirmStart;
var UWindowPageControlPage ServerTab;
var coopcw coopTab;

function Created()
{
CreatePages();
DedicatedButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', WinWidth-156, WinHeight-24, 48, 16));
  DedicatedButton.SetText(class'utmenu.utstartgamecw'.default.DedicatedText);
  DedicatedButton.SetHelpText(class'utmenu.utstartgamecw'.default.DedicatedHelp);
  CloseButton = UWindowSmallCloseButton(CreateControl(class'UWindowSmallCloseButton', WinWidth-56, WinHeight-24, 48, 16));
  StartButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', WinWidth-106, WinHeight-24, 48, 16));
  StartButton.SetText(class'umenu.umenubotmatchclientwindow'.default.StartText);
}

function CreatePages()
{
Pages = UMenuPageControl(CreateWindow(class'UMenuPageControl', 0, 0, WinWidth, WinHeight));
  Pages.AddPage(class'umenu.umenubotmatchclientwindow'.default.StartMatchTab, class'oldskool.coopcw');
  ServerTab = Pages.AddPage(class'utmenu.utstartgamecw'.default.ServerText, class'UTServerSetupSC');
}
function Resized()
{
  Pages.WinWidth = WinWidth;
  Pages.WinHeight = WinHeight - 24;
  CloseButton.WinLeft = WinWidth-52;
  CloseButton.WinTop = WinHeight-20;
  StartButton.WinLeft = WinWidth-102;
  StartButton.WinTop = WinHeight-20;
  DedicatedButton.WinLeft = WinWidth-152;
  DedicatedButton.WinTop = WinHeight-20;
}

function Paint(Canvas C, float X, float Y)
{
  local Texture T;

  T = GetLookAndFeelTexture();
  DrawUpBevel( C, 0, LookAndFeel.TabUnselectedM.H, WinWidth, WinHeight-LookAndFeel.TabUnselectedM.H, T);
}

function Notify(UWindowDialogControl C, byte E)
{
  switch(E)
  {
  case DE_Click:
    switch (C)
    {
      case StartButton:
        if ((GetLevel().Game.Default.bWorldLog == True) && (GetPlayerOwner().GetNGSecret() == "") && (!GetPlayerOwner().ngSecretSet))
        {
          ConfirmStart = MessageBox(class'utmenu.utstartgamecw'.default.ConfirmTitle, class'utmenu.utstartgamecw'.default.ConfirmText, MB_YesNo, MR_Yes, MR_No);          
        } else
          StartPressed();
        return;
      case DedicatedButton:
        DedicatedPressed();
        return;
      default:
        Super.Notify(C, E);
        return;
    }
  default:
    Super.Notify(C, E);
    return;
  }
}
function GetDesiredDimensions(out float W, out float H)
{  
  Super(UWindowWindow).GetDesiredDimensions(W, H);
  H += 30;
}
function MessageBoxDone(UWindowMessageBox W, MessageBoxResult Result)
{
  if(W == ConfirmStart)
  {
    switch(Result)
    {
    case MR_Yes:
      Root.CreateWindow(class<UWindowWindow>(DynamicLoadObject("UTMenu.ngWorldSecretWindow", class'Class')), 100, 100, 200, 200, Root, True);
      break;
    case MR_No:
      GetPlayerOwner().ngSecretSet = True;
      GetPlayerOwner().SaveConfig();
      StartPressed();
      break;
    }        
  }
}

function DedicatedPressed()
{
  local string URL;
  local GameInfo NewGame;
  local string LanPlay;

  if(UTServerSetupPage(UTServerSetupSC(ServerTab.Page).ClientArea).bLanPlay)
    LanPlay = " -lanplay";

  if (oldskoolnewgameclientwindow(ownerwindow).selectedpacktype~="custom")
  URL = Map $ "?Game=oldskool.coopgame2?Mutator="$oldskoolnewgameclientwindow(ownerwindow).MutatorList;
  else
  URL = oldskoolnewgameclientwindow(ownerwindow).selectedpackclass.default.basedir$Map $ "?Game="$oldskoolnewgameclientwindow(ownerwindow).selectedpackclass.default.coopgameinfo$"?Mutator="$oldskoolnewgameclientwindow(ownerwindow).MutatorList;
  URL = URL $ "?Listen";

  ParentWindow.Close();
  oldskoolnewgameclientwindow(ownerwindow).Close();
  Root.Console.CloseUWindow();
  GetPlayerOwner().ConsoleCommand("RELAUNCH "$URL$LanPlay$" -server log="$class'oldskool.coopgame2'.Default.ServerLogName);
}

// Override botmatch's start behavior
function StartPressed()
{
  local string URL, Checksum;
  local GameInfo NewGame;

  class'coopgame2'.Static.ResetGame();
  if (oldskoolnewgameclientwindow(ownerwindow).selectedpacktype~="custom")
  URL = Map $ "?Game=oldskool.coopgame2?Mutator="$oldskoolnewgameclientwindow(ownerwindow).MutatorList;
  else
  URL = oldskoolnewgameclientwindow(ownerwindow).selectedpackclass.default.basedir$Map$"?Game="$oldskoolnewgameclientwindow(ownerwindow).selectedpackclass.default.coopgameinfo$"?Mutator="$oldskoolnewgameclientwindow(ownerwindow).MutatorList;
  URL = URL $ "?Listen";
  class'StatLog'.Static.GetPlayerChecksum(GetPlayerOwner(), Checksum);
  URL = URL $ "?Checksum="$Checksum;

  ParentWindow.Close();
  oldskoolnewgameclientwindow(ownerwindow).Close();
  Root.Console.CloseUWindow();
  GetPlayerOwner().ClientTravel(URL, TRAVEL_Absolute, false);
}

defaultproperties
{
}
