// ============================================================
//The main oldskool package.
//Holds the mutators, singleplayer game, windows, Unreal I models and mappacks.
// Psychic_313: unchanged
// ============================================================

class olWarlordRocket expands WarlordRocket;
//more net bugs:
simulated function Tick(float DeltaTime)
{
  local SpriteSmokePuff b;

  Count += DeltaTime;
  if ( (Count>(SmokeRate+FRand()*SmokeRate)) && (Level.NetMode!=NM_DedicatedServer) ) 
  {
    b = Spawn(class'SpriteSmokePuff');
    b.RemoteRole = ROLE_None;    
    Count=0.0;
  }
}
auto state Flying
{
  simulated function BeginState()
  {
    if (Level.bHighDetailMode) SmokeRate = 0.035;
    else SmokeRate = 0.15;  
    Super.BeginState();
  }
}
defaultproperties
{
    ExplosionDecal=Class'olweapons.ODBlastMark'
}
