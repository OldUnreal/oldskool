// ============================================================
// h4ck to save under different thing.....
// ============================================================

class OldSkoolMutatorCW expands UMenuMutatorCW;
function Created()
{
  Super(Umenudialogclientwindow).Created();

  Splitter = UWindowHSplitter(CreateWindow(class'UWindowHSplitter', 0, 0, WinWidth, WinHeight));

  FrameExclude = UMenuMutatorFrameCW(Splitter.CreateWindow(class'UMenuMutatorFrameCW', 0, 0, 100, 100));
  FrameInclude = UMenuMutatorFrameCW(Splitter.CreateWindow(class'UMenuMutatorFrameCW', 0, 0, 100, 100));

  Splitter.LeftClientWindow  = FrameExclude;
  Splitter.RightClientWindow = FrameInclude;

  Exclude = UMenuMutatorExclude(CreateWindow(class'UMenuMutatorExclude', 0, 0, 100, 100, Self));
  FrameExclude.Frame.SetFrame(Exclude);
  Include = UMenuMutatorInclude(CreateWindow(class'UMenuMutatorInclude', 0, 0, 100, 100, Self));
  FrameInclude.Frame.SetFrame(Include);

  Exclude.Register(Self);
  Include.Register(Self);

  Exclude.SetHelpText(ExcludeHelp);
  Include.SetHelpText(IncludeHelp);

  Include.DoubleClickList = Exclude;
  Exclude.DoubleClickList = Include;

  Splitter.bSizable = False;
  Splitter.bRightGrow = True;
  Splitter.SplitPos = WinWidth/2;

  LoadMutators();
}
function LoadMutators()
{
  local int NumMutatorClasses;
  local string NextMutator, NextDesc;
  local UMenuMutatorList I;
  local string MutatorList;
  local int j;
  local int k;

  GetPlayerOwner().GetNextIntDesc(MutatorBaseClass, 0, NextMutator, NextDesc);
  while( (NextMutator != "") && (NumMutatorClasses < 200) )
  {
    I = UMenuMutatorList(Exclude.Items.Append(class'UMenuMutatorList'));
    I.MutatorClass = NextMutator;

    k = InStr(NextDesc, ",");
    if(k == -1)
    {
      I.MutatorName = NextDesc;
      I.HelpText = "";
    }
    else
    {
      I.MutatorName = Left(NextDesc, k);
      I.HelpText = Mid(NextDesc, k+1);
    }

    NumMutatorClasses++;
    GetPlayerOwner().GetNextIntDesc(MutatorBaseClass, NumMutatorClasses, NextMutator, NextDesc);
  }

  MutatorList = class'olroot.oldskoolnewgameclientwindow'.default.MutatorList;

  while(MutatorList != "")
  {
    j = InStr(MutatorList, ",");
    if(j == -1)
    {
      NextMutator = MutatorList;
      MutatorList = "";
    }
    else
    {
      NextMutator = Left(MutatorList, j);
      MutatorList = Mid(MutatorList, j+1);
    }
    
    I = UMenuMutatorList(Exclude.Items).FindMutator(NextMutator);
    if(I != None)
    {
      I.Remove();
      Include.Items.AppendItem(I);
    }
    else
      Log("Unknown mutator in mutator list: "$NextMutator);
  }

  Exclude.Sort();
}
function SaveConfigs()
{
  local UMenuMutatorList I;
  local string MutatorList;

  Super(umenudialogclientwindow).SaveConfigs();
  
  for(I = UMenuMutatorList(Include.Items.Next); I != None; I = UMenuMutatorList(I.Next))
  {
    if(MutatorList == "")
      MutatorList = I.MutatorClass;
    else
      MutatorList = MutatorList $ "," $I.MutatorClass;
  }
  class'olroot.oldskoolnewgameclientwindow'.default.MutatorList = MutatorList;
  class'olroot.oldskoolnewgameclientwindow'.static.staticsaveconfig();
}
function Notify(UWindowDialogControl C, byte E)
{
  Super(umenudialogclientwindow).Notify(C, E);
}

defaultproperties
{
}
