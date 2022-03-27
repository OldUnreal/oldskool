// ============================================================
// Oldskool.OldSkoolScoreBoard: the scoreboard that keeps track of killz and stuff....
// Psychic_313: unchanged
// ============================================================

class OldSkoolScoreBoard expands ScoreBoard;

var string difficulties[4];

function ShowScores( canvas Canvas )
{
  local int i, row;
  local color Yellow, Red, White;
  local scorekeeper scoreholder;

  scoreholder = scorekeeper(Instigator.FindInventoryType(class 'scorekeeper'));

  if (scoreholder != None)
  {
    White.R = 255;
    White.G = 255;
    White.B = 255;
    White.A = 200;

    Yellow.R = 255;
    Yellow.G = 255;
    Yellow.B = 0;
    Yellow.A = 200;
  
    Red.R = 255;
    Red.G = 20;
    Red.B = 20;
    Red.A = 200;

    // Display the scoreboard.
    Canvas.Font = Canvas.MedFont;
    Canvas.DrawColor = Red;
    
    Canvas.SetPos(0.2 * Canvas.ClipX, 0.1 * Canvas.ClipY );
    Canvas.DrawText("Creatures", False);
    Canvas.SetPos(0.6 * Canvas.ClipX, 0.1 * Canvas.ClipY );
    Canvas.DrawText("Killcount", False);

    Canvas.DrawColor = White;
    row = 1;

    if (scoreholder.Brutes > 0)
      DrawBodyCount("Brutes", scoreholder.Brutes, Canvas, row++);
    if (scoreholder.Gasbags > 0)
      DrawBodyCount("Gasbag", scoreholder.Gasbags, Canvas, row++);
    if (scoreholder.Krall > 0)
      DrawBodyCount("Krall", scoreholder.Krall, Canvas, row++);
    if (scoreholder.Mercs > 0)
      DrawBodyCount("Mercenaries", scoreholder.Mercs, Canvas, row++);
    if (scoreholder.blobs > 0)
      DrawBodyCount("Blobs", scoreholder.blobs, Canvas, row++);
    if (scoreholder.Sliths > 0)
      DrawBodyCount("Sliths", scoreholder.Sliths, Canvas, row++);
    if (scoreholder.flies > 0)
      DrawBodyCount("Flies", scoreholder.flies, Canvas, row++);
     if (scoreholder.tentacles > 0)
      DrawBodyCount("Tentacles", scoreholder.tentacles, Canvas, row++);
      if (scoreholder.pupae > 0)
      DrawBodyCount("Pupae", scoreholder.pupae, Canvas, row++);
    if (scoreholder.mantas > 0)
      DrawBodyCount("Mantas", scoreholder.mantas, Canvas, row++);
    if (scoreholder.fish > 0)
      DrawBodyCount("Fish", scoreholder.Fish, Canvas, row++);
     if (scoreholder.Titans > 0)
      DrawBodyCount("Titans", scoreholder.Titans, Canvas, row++);
    if (scoreholder.Skaarjw > 0)
      DrawBodyCount("Skaarj Warriors", scoreholder.Skaarjw, Canvas, row++);
    if (scoreholder.Skaarjt > 0)
      DrawBodyCount("Skaarj Troopers", scoreholder.Skaarjt, Canvas, row++);
    if (scoreholder.hugeguys > 0)
      DrawBodyCount("Skaarj Leaders", scoreholder.hugeguys, Canvas, row++);
    if (scoreholder.Nali > 0){
      Canvas.DrawColor = Red;
      DrawBodyCount("Nali", scoreholder.Nali, Canvas, row++);
      Canvas.DrawColor = White;}
    if (scoreholder.animals > 0){
      Canvas.DrawColor = Red;
      DrawBodyCount("Harmless Critters", scoreholder.animals, Canvas, row++);
      Canvas.DrawColor = White; }
    row++;
    DrawBodyCount("Total Kills", scoreholder.killtotal, Canvas, row++);
    DrawdiffCount("Difficlulty", difficulties[Level.Game.Difficulty], Canvas, row++);
    DrawBodyCount("Score", scoreholder.score, Canvas, row++);
    row++;
    DrawdiffCount("Map Title", level.title, Canvas, row++);              //kinda mirror DM....
    DrawdiffCount("Author", level.author, Canvas, row++);



  } else {
  
    Canvas.Font = Canvas.MedFont;
    Canvas.SetPos(0.2 * Canvas.ClipX, 0.2 * Canvas.ClipY );
    Canvas.DrawText("Score Keeper inventory not found!!! Please stop ]-[4xx1ng the code!", False);
  
  }
}

function DrawBodyCount(string thingy, int amount, canvas Canvas, int row)
{
  Canvas.SetPos(0.2 * Canvas.ClipX, 0.1 * Canvas.ClipY + 10 * row );
  Canvas.DrawText(thingy, False);
  Canvas.SetPos(0.6 * Canvas.ClipX, 0.1 * Canvas.ClipY + 10 * row );
  Canvas.DrawText(amount, False);
}
function DrawdiffCount(string thingy, string amount, canvas Canvas, int row)           //just for the difficulties...
{
  Canvas.SetPos(0.2 * Canvas.ClipX, 0.1 * Canvas.ClipY + 10 * row );
  Canvas.DrawText(thingy, False);
  Canvas.SetPos(0.6 * Canvas.ClipX, 0.1 * Canvas.ClipY + 10 * row );
  Canvas.DrawText(amount, False);
}

defaultproperties
{
    Difficulties(0)="Easy"
    Difficulties(1)="Medium"
    Difficulties(2)="Hard"
    Difficulties(3)="Unreal"
}
