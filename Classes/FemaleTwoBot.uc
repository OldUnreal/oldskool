// ============================================================
// oldskool.femaletwobot: put your comment here
// Psychic_313: DEPRECATED. DON'T USE ME.
// ============================================================

class femaletwobot expands unrealfbot;

function ForceMeshToExist()
{
  Spawn(class'oldskool.femaletwo');
}

defaultproperties
{
    DefaultTalkTexture="female2skiny.sony5"
    TeamSkin="female2skiny.sony1"
    altpackage="female2skins."
    DefaultSkinName="female2skiny.sonya"
    DefaultPackage="female2skiny."
    SelectionMesh="UnrealI.Female2"
    SpecialMesh="Botpack.TrophyFemale1"
    MenuName="Demitra"
    VoiceType="BotPack.VoiceFemaleOn"
    Mesh=LodMesh'UnrealI.Female2'
}
