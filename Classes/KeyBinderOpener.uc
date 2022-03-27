// ============================================================
// oldskool.KeyBinderOpener : For the purpose of ONP.  Will allow the keybinder to be accessed in the future when changed.
// The main oldskool package.
// Holds the mutators, singleplayer game, windows, Unreal I models and mappacks.
// ============================================================

class KeyBinderOpener expands Object;

static function OpenBinder(playerpawn p){
local OldSkoolPagesClientWindow opcw;
    WindowConsole(P.Player.Console).LaunchUWindow();
    if (!WindowConsole(P.Player.Console).bcreatedroot) //odd that this occured, but I must generate root
      WindowConsole(P.Player.Console).createrootwindow(none);
    //make menu:
    opcw=OldSkoolPagesClientWindow(uwindowframedwindow(WindowConsole(P.Player.Console).Root.CreateWindow(class<uwindowwindow>(DynamicLoadObject("oldskool.OldskoolConfigWindow", class'class')) , 100, 100, 200, 200)).clientarea);
    //log ("Page seems to be:"@OPCW.Pages.GetPage("Keys"));
    OPCW.Pages.GotoTab(OPCW.Pages.GetPage("Keys")); 
}
defaultproperties
{
}
