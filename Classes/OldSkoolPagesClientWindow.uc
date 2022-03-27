// ============================================================
// oldskool.OldSkoolPagesClientWindow: The main window with all the pages.....
// ============================================================

class OldSkoolPagesClientWindow expands UWindowDialogClientWindow;
var UMenuPageControl Pages;
var UWindowSmallCloseButton CloseButton;

function Created() 
{
  Pages = UMenuPageControl(CreateWindow(class'UMenuPageControl', 0, 0, WinWidth, WinHeight-48));
  Pages.SetMultiLine(True);
/*  Pages.AddPage("Mutator", class'oldskool.oldskoolconfigclient');
  Pages.AddPage("Single Player", class'oldskoolSPclient');
  Pages.AddPage("Options", class'oldskoolgameoptionsClient');
  Pages.AddPage("Music", class'oldskoolmusicClient');
  Pages.AddPage("Keys", class'OldSkoolCustomizeClientWindow');
  Pages.AddPage("About", class'OldSkoolAboutClient');*/
  Pages.AddPage("Mutator", class'OldskoolScrollMain');
  Pages.AddPage("Single Player", class'OldskoolScrollSP');
  Pages.AddPage("Options", class'OldskoolScrollGOp');
  Pages.AddPage("Music", class'OldskoolScrollMusic');
  Pages.AddPage("Keys", class'OldSkoolScrollKeys');
  Pages.AddPage("About", class'OldskoolScrollAbout');

  CloseButton = UWindowSmallCloseButton(CreateControl(class'UWindowSmallCloseButton', WinWidth-56, WinHeight-24, 48, 16));
  Super.Created();
}
function Resized()
{
  Pages.WinWidth = WinWidth;
  Pages.WinHeight = WinHeight - 24;  // OK, Cancel area
  CloseButton.WinLeft = WinWidth-52;
  CloseButton.WinTop = WinHeight-20;
}

function Paint(Canvas C, float X, float Y)
{
  local Texture T;

  T = GetLookAndFeelTexture();
  DrawUpBevel( C, 0, LookAndFeel.TabUnselectedM.H, WinWidth, WinHeight-LookAndFeel.TabUnselectedM.H, T);
}

function GetDesiredDimensions(out float W, out float H)
{  
  Super(UWindowWindow).GetDesiredDimensions(W, H);
  H += 30;
}

defaultproperties
{
}
