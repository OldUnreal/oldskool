// ============================================================
// oldskool.scorekeeper: a hidden inventory spawned by singleplayer which keeps track of the score and stuff (so maps keep going and going...) no way to save though....
// based on unrogue's tally translator....
// Psychic_313: unchanged, although maybe extensibility would be good?
// ============================================================

class scorekeeper expands TournamentPickup;
var travel int Skaarjw;
var travel int Skaarjt;
var travel int hugeguys;
var travel int Nali;
var travel int Tentacles;
var travel int Pupae;
var travel int Animals;
var travel int Brutes;
var travel int Gasbags;
var travel int Krall;
var travel int Mercs;
var travel int Sliths;
var travel int Titans;
var travel int Fish;
var travel int Flies;
var travel int Mantas;
var travel int blobs;
var travel int killtotal;
var travel int Score;

function PreBeginPlay()
{
  If (!Level.Game.Isa('SinglePlayer2'))
    Destroy(); //can only exist for SP2....
}

//ripped and modified from tallytranslator......
function scoreit(pawn WhatDied)
{
  local int points, intlevel;
  if (WhatDied != None)
  {
    points = int(10*((WhatDied.skill/2) + 1)*(whatdied.default.health/150)+whatdied.intelligence/1.5); //calculated by difficulty (major), health (slightly less important) and AI (tiny difference)
    If (points<8)
      points=8; //force to at least give 8 points.
    if (PlayerPawn(Owner).ReducedDamageType == 'All')
      Points*=(-10); //cheater!!!!!!!!
    if (WhatDied.IsA('Nali')){ //killing nalis is bad.....
      Nali++;
      Points=-32;
    }
    else if (WhatDied.IsA('Brute')) Brutes++;
    else if (WhatDied.IsA('Gasbag')) Gasbags++;
    else if (WhatDied.IsA('Krall')) Krall++;
    else if (WhatDied.IsA('Mercenary')) Mercs++;
    else if (WhatDied.IsA('Queen')) hugeguys++;
    else if (WhatDied.IsA('Slith')) Sliths++;
    else if (WhatDied.IsA('Titan')) Titans++;
    else if (WhatDied.IsA('Warlord')) hugeguys++;
    else if (WhatDied.IsA('Skaarjwarrior')) Skaarjw++;
    else if (WhatDied.IsA('Skaarjtrooper')) Skaarjt++;
    else if (WhatDied.IsA('nalirabbit')) { Animals++; points= -4;}
    else if (WhatDied.IsA('bird1')) { Animals++; points= -7;}
    else if (WhatDied.IsA('Brute')) Brutes++;
    else if (WhatDied.IsA('cow')){ Animals++; points= -10;} //don't kill innocent animals :D
    else if (WhatDied.IsA('tentacle')) tentacles++;
    else if ((WhatDied.IsA('ParentBlob'))||(Whatdied.Isa('Bloblet'))) blobs++;
    else if ((WhatDied.IsA('BiterfishSchool'))||(Whatdied.Isa('biterfish'))||(Whatdied.Isa('devilfish'))||(Whatdied.Isa('squid'))) fish++;
    else if (WhatDied.IsA('manta')) mantas++;
    else if (WhatDied.IsA('fly')) flies++;
    else if (WhatDied.IsA('pupae')) pupae++;
    if (WhatDied.IsA('ScriptedPawn'))
      if (ScriptedPawn(WhatDied).bIsBoss) points *=3;          //bonus for killing bosses.....
    Score += points;
    Killtotal += 1;

  }

}

defaultproperties
{
    PickupMessage="You weren't supposed to pick this up!"
    ItemName="Scorekeeper"
    bHidden=True
}
