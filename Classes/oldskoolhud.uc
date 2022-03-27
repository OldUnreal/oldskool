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
local color oldcol;
  scoreholder = scorekeeper(pawn(owner).FindInventoryType(class 'scorekeeper'));
  Canvas.SetPos(X,Y);
  if (realicons) {
  Canvas.DrawIcon(Texture'Realskull', 1.0);
  oldcol=canvas.drawcolor;
  canvas.drawcolor=redcolor;  }
  else
  Canvas.DrawIcon(Texture'IconSkull', 1.0);  
  Canvas.CurX -= 31;
  Canvas.CurY += 23;
  if ( scoreholder == None )
    return;
  Canvas.Font = Font'TinyWhiteFont';
  if (scoreholder.score<10000)
    Canvas.CurX+=6;
  if (scoreholder.score<1000)
    Canvas.CurX+=6;
  if (scoreholder.score<100)
    Canvas.CurX+=6;
  if (scoreholder.score<10)
    Canvas.CurX+=6;  
  if (scoreholder.score<0)
    Canvas.CurX-=6;
  if (scoreholder.score<-9)
    Canvas.CurX-=6;
  if (scoreholder.score<-90)
    Canvas.CurX-=6;
    if (scoreholder.score<-900)
    Canvas.CurX-=6;
  if (scoreholder.score<-9000)
    Canvas.CurX-=6;
  Canvas.DrawText(scoreholder.score,False);
    if (realicons)
  canvas.drawcolor=oldcol;

}

defaultproperties
{
}
