// ============================================================
// oldskool.maletwobot: Ashy
// Psychic_313: DEPRECATED. DON'T USE ME.
// ============================================================

class maletwobot expands unrealmbot;

function ForceMeshToExist()
{
  Spawn(class'oldskool.maletwo');
}

defaultproperties
{
    DefaultTalkTexture="male2skiny.ash15"
    TeamSkin="male2skiny.ash11"
    altpackage="male2skins."
    CarcassType=Class'UnrealI.MaleTwoCarcass'
    DefaultSkinName="male2skiny.ash"
    DefaultPackage="male2skiny."
    SelectionMesh="UnrealI.Male2"
    SpecialMesh="Botpack.TrophyMale1"
    MenuName="Ash"
    Mesh=LodMesh'UnrealI.Male2'
}
