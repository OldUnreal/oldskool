// ============================================================
//The main oldskool package.
//Holds the mutators, singleplayer game, windows, Unreal I models and mappacks.
// Psychic_313: unchanged
// ============================================================

class olQueenProjectile expands QueenProjectile;

auto state Flying
{
  simulated function BeginState()   //dumb bug
  {
    SetTimer(0.20,False);
    Super.BeginState();
  }
}

defaultproperties
{
    ExplosionDecal=Class'olweapons.ODEnergyImpact'
}
