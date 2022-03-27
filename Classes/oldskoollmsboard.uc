// ============================================================
// coloring for LMS.....
// Psychic_313: unchanged
// ============================================================

class oldskoollmsboard expands UnrealScoreBoard;
function DrawScore( canvas Canvas, int I, float XOffset, int LoopCount )    //uses different colors for out dudes...
{
  local int Step;
  local color LightCyanColor,  GoldColor;
  LightCyanColor.R=128;
  LightCyanColor.G=255;
  LightCyanColor.B=255; //set color.......
  GoldColor.R=255;
  GoldColor.G=255;
  GoldColor.B=255;

  if (Canvas.ClipX >= 640)
    Step = 16;
  else
    Step = 8;

  Canvas.SetPos(Canvas.ClipX/4 * 3, Canvas.ClipY/4 + (LoopCount * Step));

  if(Scores[I] >= 100.0)
    Canvas.CurX -= 6.0;
  if(Scores[I] >= 10.0)
    Canvas.CurX -= 6.0;
  if(Scores[I] < 1.0)
  Canvas.DrawColor = LightCyanColor;
  else
    Canvas.DrawColor = GoldColor;
  if(Scores[I] < 0.0)
    Canvas.CurX -= 6.0;
  Canvas.DrawText(int(Scores[I]), false);
}

defaultproperties
{
}
