// ============================================================
//oldskool.olslithprojectile: addded in OSA 2.20 finally.  like slith decals?
//The main oldskool package.
//Holds the mutators, singleplayer game, windows, Unreal I models and mappacks.
// ============================================================

class olSlithProjectile expands SlithProjectile;
auto state Flying
{
  simulated function HitWall( vector HitNormal, actor Wall )
  {
    if (level.netmode!=nm_dedicatedserver)
      Spawn(class'ODbiomark',self,,Location, rotator(HitNormal));
    super.hitwall(hitnormal,wall);
  }
}
defaultproperties
{
}
