// ============================================================
// oldskool.EverythingNotify : for co-op. runs tests client-side
// The main oldskool package.
// Holds the mutators, singleplayer game, windows, Unreal I models and mappacks.
// ============================================================

class EverythingNotify expands SpawnNotify;
function prebeginplay(); //don't call parent! (screwed up)
simulated function PostBeginPlay()
{
  local actor other;
  if (level.netmode!=nm_client) //mutator works on server.
    return;
  Super.PostBeginPlay(); //add.
  log ("EveryThing Notify Initialized");
  ForEach Allactors(class'actor',other){   //mask.
    if (other.style==STY_NORMAL&&(other.IsA('decoration')&&((other.isa('tree')||left(getitemname(string(other.class)),5)~="plant"))||(other.role==role_authority&&other.isa('pawn')&&(other.isa('skaarjwarrior')||other.isa('krall')||other.isa('warlord')||other.isa('bird1')||other.isa('Slith')||other.isa('manta')))))
      Other.Style=Sty_masked;
    if (other.IsA('scriptedpawn')&&!other.isa('tentacle')&&pawn(other).shadow==none)     //no decal for them.
      scriptedpawn(other).Shadow = Spawn(class'olpawnShadow',other,,other.location);
  }
}
simulated event Actor SpawnNotification(Actor other)
{
    if (other.style==STY_NORMAL&&(other.IsA('decoration')&&((other.isa('tree')||left(getitemname(string(other.class)),5)~="plant"))||(other.role==role_authority&&other.isa('pawn')&&(other.isa('skaarjwarrior')||other.isa('krall')||other.isa('warlord')||other.isa('bird1')||other.isa('Slith')||other.isa('manta')))))
      Other.Style=Sty_masked;
 if (other.IsA('scriptedpawn')&&!other.isa('tentacle')&&pawn(other).shadow==none)     //no decal for them.
      scriptedpawn(other).Shadow = Spawn(class'olpawnShadow',other,,other.location);
  return other;
}
defaultproperties
{
}
