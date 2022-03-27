// ============================================================
//oldskool.oldskoolaboutclient:  About this mod!
//The main oldskool package.
//Holds the mutators, singleplayer game, windows, Unreal I models and mappacks.
// ============================================================

class OldSkoolAboutClient expands UMenuPageWindow;
//write text:
function WriteText(canvas C, string text, out float Y, optional string TestTEx){
  local float W, H;
  if (testtex=="")
    testtex=text;
  TextSize(C, TestTex, W, H);
  Y+=H;
  ClipText(C, (WinWidth - W)/2, Y, text, true);
}
function Paint(Canvas C, float X, float Y)
{
  Super.Paint(C,X,Y);
  //Set black:
  c.drawcolor.R=0;
  c.drawcolor.G=0;
  c.drawcolor.B=0;
  C.Font=root.fonts[F_Bold];
  Y=5;
  WriteText(C, "OldSkool Amp'd 2.38", Y);
  Y+=8;
  WriteText(C, "By UsAaR33", Y);
  Y+=5;
  WriteText(C, "and much code and skins by Psychic_313", Y);
  Y+=5;
  C.Font=root.fonts[F_Normal];
  WriteText(C, "Special Thanks to:", Y);
  y+=5;
  WriteText(C, "Preacher: Hosting my WebSite", Y);
  WriteText(C, "The Renegade Master: Creating my WebSite:", Y);
  WriteText(C, "&H&T&T&P&:&/&/&w&w&w&.&u&n&r&e&a&l&i&t&y&.&d&k&/&u&s&a&a&r&3&3", Y,"HTTP://www.unreality.dk/usaar33");
  y+=5;
  WriteText(C, "The Real CTF team: Many Skins", Y);
  y+=5;
  WriteText(C, "Nemo_NX: Consistant", Y);
  WriteText(C, "support thoughout this project", Y);
  y+=5;
  WriteText(C, "Antonio \"NetDevil\" Cordero:", Y);
  WriteText(C, "UTPT for mesh extraction", Y);
  y+=5;
  WriteText(C, "Bane: Akimbo automag code", Y);
  y+=5;
  WriteText(C, "Hellscrag: Music Description", Y);
  y+=5;
  WriteText(C, "DrSin: Hosting Forums", Y);
  y+=5;
  WriteText(C, "Mongo: Ever wonder why he is on", Y);
  WriteText(C, "almost every mod's credits list?", Y);
  y+=5;
  WriteText(C, "EzKeel and Cerr:", Y);
  WriteText(C, "Support and testing for Legacy", Y);
  y+=5;
  WriteText(C, "DavidM: \"Where are the scripts?", Y);
  WriteText(C, "Give me the scripts, dammit!\"", Y);
  y+=5;
  WriteText(C, "All of my beta testers, and anyone", Y);
  WriteText(C, "else who somehow contributed to OSA.", Y);
  y+=5;
  WriteText(C, "Epic Megagames and Digital Extremes:", Y);
  WriteText(C, "without &t&h&e&m &y&o&u wouldn't have UT :0", Y,"without them you wouldn't have UT :0");
  c.drawcolor.R=255;  //reset
  c.drawcolor.G=255;
  c.drawcolor.B=255;
  DesiredWidth = 220;
  DesiredHeight = Y+13;
}

defaultproperties
{
}
