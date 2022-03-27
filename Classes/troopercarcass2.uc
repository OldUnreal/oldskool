// ============================================================
// oldskool.troopercarcass2: needed so when Skaarj dies his skin won't revert back.......
// Psychic_313: DEPRECATED. DON'T USE ME.
// ============================================================

class troopercarcass2 expands HumanCarcass;

function ForceMeshToExist()
{
  //never called
  Spawn(class 'SkaarjTrooper');
}

function CreateReplacement()
{
  local CreatureChunks carc;
  
  if (bHidden)
    return;
  carc = Spawn(class'TrooperMasterChunk'); 
  if (carc != None)
  {
    carc.bMasterChunk = true;
    carc.Initfor(self);
    carc.Bugs = Bugs;
    if ( Bugs != None )
      Bugs.SetBase(carc);
    Bugs = None;
  }
  else if ( Bugs != None )
    Bugs.Destroy();
}

defaultproperties
{
    bodyparts(0)=LodMesh'UnrealShare.SkaarjBody'
    bodyparts(1)=LodMesh'UnrealShare.SkaarjHead'
    bodyparts(2)=LodMesh'UnrealShare.SkaarjBody'
    bodyparts(3)=LodMesh'UnrealShare.SkaarjLeg'
    bodyparts(4)=LodMesh'UnrealShare.SkaarjLeg'
    bodyparts(5)=LodMesh'UnrealShare.CowBody1'
    bodyparts(6)=LodMesh'UnrealShare.CowBody2'
    AnimSequence=Death
    Mesh=LodMesh'UnrealI.sktrooper'
    CollisionRadius=32.00
    CollisionHeight=42.00
    Mass=130.00
}
