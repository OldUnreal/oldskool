// ============================================================
// framed window for co-op
// ============================================================

class coopwindow expands UWindowFramedWindow;

function Created()
{
  bStatusBar = False;
  bSizable = False;

  Super.Created();

  SetSizePos();
}

function SetSizePos()
{
  if(Root.WinHeight < 290)
    SetSize(Min(Root.WinWidth-10, 280) , 220);
  else
    SetSize(Min(Root.WinWidth-10, 280), 270);
  
  WinLeft = Root.WinWidth/2 - WinWidth/2;
  WinTop = Root.WinHeight/2 - WinHeight/2;
}

function ResolutionChanged(float W, float H)
{
  SetSizePos();
  Super.ResolutionChanged(W, H);
}

defaultproperties
{
    ClientClass=Class'coopbase'
    WindowTitle="Co-op Game"
}
