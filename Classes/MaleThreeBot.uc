// ============================================================
// oldskool.malethreebot: put your comment here
// Psychic_313: DEPRECATED. DON'T USE ME.
// ============================================================

class malethreebot expands unrealmbot;

function ForceMeshToExist()
{
  Spawn(class'malethree');
}

defaultproperties
{
    DefaultTalkTexture="male3skiny.dant5"
    TeamSkin="male3skiny.dant1"
    altpackage="male3skins."
    CarcassType=Class'UnrealShare.MaleThreeCarcass'
    DefaultSkinName="male3skiny.dante"
    DefaultPackage="male3skiny."
    SelectionMesh="UnrealI.Male3"
    SpecialMesh="Botpack.TrophyMale1"
    MenuName="Bane"
    Mesh=LodMesh'UnrealShare.Male3'
}
