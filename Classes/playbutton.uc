// ============================================================
// playbutton. A button with the play icon on it :D
// ============================================================

class playbutton expands UWindowSmallButton;

#exec TEXTURE IMPORT NAME=BluePlay FILE=Textures\blueplay.pcx GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalPlay FILE=Textures\metalplay.pcx GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=Goldplay FILE=Textures\goldplay.pcx GROUP="Icons" MIPS=OFF
  //use the look and feels......
function Paint(Canvas C, float X, float Y)
{
local float K;
local texture drawtex;

  if(bDisabled)
    K = 34;
  else
  if(bMouseDown)
    K = 17;
  else
    k = 0;
  if (lookandfeel.Isa('UMenuBlueLookAndFeel'))     //I.D. look and feels and set accordingly....
  drawtex=Texture'Blueplay';
  else if (lookandfeel.Isa('UMenuMetalLookAndFeel'))
  drawtex=Texture'metalplay';
  else //gold or some custom one....
  drawtex=Texture'goldplay';

  DrawStretchedTextureSegment(C, 0, 0, 3, 16, 0, K, 3, 16, drawtex);             //ripped from the look and feel's
  DrawStretchedTextureSegment(C, WinWidth - 3, 0, 3, 16, 45, K, 3, 16, drawtex);
  DrawStretchedTextureSegment(C, 3, 0, WinWidth-6, 16, 3, k, 42, 16, drawtex);
  Super(uwindowbutton).Paint(C, X, Y);
}

defaultproperties
{
}
