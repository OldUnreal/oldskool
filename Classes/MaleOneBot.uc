// ============================================================
// oldskool.MaleoneBot: whatever......
// Psychic_313: DEPRECATED. DON'T USE ME.
// ============================================================

class MaleoneBot expands unrealmbot;

function ForceMeshToExist()
{
  Spawn(class'oldskool.maleone');
}

simulated function PlayMetalStep()
{
  local sound step;
  local float decision;

  if ( !bIsWalking && (Level.Game != None) && (Level.Game.Difficulty > 1) && ((Weapon == None) || !Weapon.bPointing) )
    MakeNoise(0.05 * Level.Game.Difficulty);
  if ( FootRegion.Zone.bWaterZone )
  {
    PlaySound(sound 'LSplash', SLOT_Interact, 1, false, 1000.0, 1.0);
    return;
  }

  decision = FRand();
  if ( decision < 0.34 )
    step = sound'MetWalk1';
  else if (decision < 0.67 )
    step = sound'MetWalk2';
  else
    step = sound'MetWalk3';

  if ( bIsWalking )
    PlaySound(step, SLOT_Interact, 0.5, false, 400.0, 1.0);
  else 
    PlaySound(step, SLOT_Interact, 1, false, 800.0, 1.0);

}

defaultproperties
{
    DefaultTalkTexture="male1skiny.kurg5"
    TeamSkin="male1skiny.kurg1"
    altpackage="male1skins."
    CarcassType=Class'UnrealI.MaleOneCarcass'
    DefaultSkinName="male1skiny.kurgan"
    DefaultPackage="male1skiny."
    SelectionMesh="UnrealI.Male1"
    SpecialMesh="Botpack.TrophyMale1"
    MenuName="Kurgan"
    Mesh=LodMesh'UnrealI.Male1'
}
