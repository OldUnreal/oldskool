// ============================================================
// oldskool.GreenBloodSplat : Uses Alcor's green blood decals
// The main oldskool package.
// Holds the mutators, singleplayer game, windows, Unreal I models and mappacks.
// ============================================================

class GreenBloodSplat expands olBloodSplat;
#exec TEXTURE IMPORT NAME=GreenSplat1 FILE=TEXTURES\GreenSplat1.PCX LODSET=2
#exec TEXTURE IMPORT NAME=GreenSplat2 FILE=TEXTURES\GreenSplat2.PCX LODSET=2
#exec TEXTURE IMPORT NAME=GreenSplat3 FILE=TEXTURES\GreenSplat3.PCX LODSET=2
#exec TEXTURE IMPORT NAME=GreenSplat4 FILE=TEXTURES\GreenSplat4.PCX LODSET=2
#exec TEXTURE IMPORT NAME=GreenSplat5 FILE=TEXTURES\GreenSplat5.PCX LODSET=2
#exec TEXTURE IMPORT NAME=GreenSplat6 FILE=TEXTURES\GreenSplat6.PCX LODSET=2
#exec TEXTURE IMPORT NAME=GreenSplat7 FILE=TEXTURES\GreenSplat7.PCX LODSET=2
#exec TEXTURE IMPORT NAME=GreenSplat8 FILE=TEXTURES\GreenSplat8.PCX LODSET=2
#exec TEXTURE IMPORT NAME=GreenSplat9 FILE=TEXTURES\GreenSplat9.PCX LODSET=2
#exec TEXTURE IMPORT NAME=GreenSplat10 FILE=TEXTURES\GreenSplat10.PCX LODSET=2

defaultproperties
{
    Splats(0)=Texture'GreenSplat1'
    Splats(1)=Texture'GreenSplat2'
    Splats(2)=Texture'GreenSplat3'
    Splats(3)=Texture'GreenSplat4'
    Splats(4)=Texture'GreenSplat5'
    Splats(5)=Texture'GreenSplat6'
    Splats(6)=Texture'GreenSplat7'
    Splats(7)=Texture'GreenSplat8'
    Splats(8)=Texture'GreenSplat9'
    Splats(9)=Texture'GreenSplat10'
    Texture=Texture'GreenSplat1'
}
