//=============================================================================
// MaleOne for Oldskool
// Psychic_313: DEPRECATED. DON'T USE ME.
//=============================================================================
class MaleOne extends UnrealMale;
/*
that did alot
if you are looking in the editor this looks like it does nothing
Hey! why ya looking at my all secret code
If you export this class..I......Will.....aw...screw this

#exec AUDIO IMPORT FILE="Sounds\metwalk1.WAV" NAME="metwalk1" GROUP="Male"
#exec AUDIO IMPORT FILE="Sounds\metwalk2.WAV" NAME="metwalk2" GROUP="Male"
#exec AUDIO IMPORT FILE="Sounds\metwalk3.WAV" NAME="metwalk3" GROUP="Male"    */
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
    step = sound'unrealshare.male.MetWalk1';
  else if (decision < 0.67 )
    step = sound'unrealshare.male.MetWalk2';
  else
    step = sound'unrealshare.male.MetWalk3';

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
    DefaultSkinName="male1skiny.kurgan"
    DefaultPackage="male1skiny."
    CarcassType=Class'UnrealI.MaleOneCarcass'
    SelectionMesh="UnrealI.Male1"
    SpecialMesh="Botpack.TrophyMale1"
    MenuName="Kurgan"
    Mesh=LodMesh'UnrealI.Male1'
}
