// ============================================================
// OldSkool.MaleThree:why bother reading?  I really don't actually comment code you know...
// Psychic_313: DEPRECATED. DON'T USE ME.
// ============================================================
class MaleThree extends UnrealMale;

//mostly because there is nothing to comment..
//well see the default properties?
//CarcassType tells what carcass to spawn when this dude gets killed
//Default Package tells where to look for the skinz
//Selection Mesh is that idiot standing in the selection menu who can't move 'cause   //epic screwed this all up
//Special Mesh is virtually pointless to have here ;)
//Menu Name does nothing in UT
//Mesh...well......that is very important :)

//thank you for reading these pointless comments you code h4x0r

defaultproperties
{
    DefaultTalkTexture="male3skiny.dant5"
    TeamSkin="male3skiny.dant1"
    altpackage="male3skins."
    DefaultSkinName="male3skiny.dante"
    DefaultPackage="male3skiny."
    CarcassType=Class'UnrealShare.MaleThreeCarcass'
    SelectionMesh="UnrealI.Male3"
    SpecialMesh="Botpack.TrophyMale1"
    MenuName="Bane"
    Mesh=LodMesh'UnrealShare.Male3'
}
