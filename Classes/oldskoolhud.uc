// ============================================================
// oldskool.oldskoolHUD: for green menu h4ck........ and frag counter showing pts.
// Psychic_313: @@@ OLROOT DEPENDENCIES INSIDE
// ============================================================

class oldskoolHUD expands oldskoolbaseHUD;
simulated function DisplayMenu( canvas Canvas )            //prevent green menu from showing...
{
local class<mappack> packclass;//local playerpawn playerowner;
  Playerpawn(Owner).bShowMenu = false;
    //show uwindow menu

WindowConsole(Playerpawn(Owner).Player.Console).bQuickKeyEnable = true;  //ensures it will then close.....
  WindowConsole(Playerpawn(Owner).Player.Console).LaunchUWindow();   //open window.....
if (class'olroot.oldskoolnewgameclientwindow'.default.SelectedPackType!="Custom"&&class'olroot.oldskoolnewgameclientwindow'.default.SelectedPackType!=""){
  packclass=Class<MapPack>(DynamicLoadObject(class'olroot.oldskoolnewgameclientwindow'.default.SelectedPackType, class'Class'));
  WindowConsole(Playerpawn(Owner).Player.Console).Root.CreateWindow(PackClass.default.loadmenu, 100, 100, 200, 200); }
else
WindowConsole(Playerpawn(Owner).Player.Console).Root.CreateWindow(class'OldSkoolLoadGameWindow', 100, 100, 200, 200);
}


simulated function DrawFragCount(Canvas Canvas, int X, int Y)     //to use the scorekeeper's score....
{
  local scorekeeper scoreholder;
  scoreholder = scorekeeper(pawn(owner).FindInventoryType(class 'scorekeeper'));
  if (scoreholder == None)
    DrawFragCountInternal(Canvas, X, Y, false);
  else
    DrawFragCountInternal(Canvas, X, Y, true, scoreholder.score);
}

defaultproperties
{
}
