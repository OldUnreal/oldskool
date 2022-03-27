// ============================================================
//OldSkool.OldSkoolCustomizeClientWindow: Key bindings are easier when seperate
//The main oldskool package.
//Holds the mutators, singleplayer game, windows, Unreal I models and mappacks.
// ============================================================

class OldSkoolCustomizeClientWindow expands UTCustomizeClientWindow;
function Created() //ripped from utcostomize.  used right now for ONP
{
  local int NumBindingClasses;
  local string NextBindingClass;
  local class<OSAExtraKeyBindings> BindingClass;
  local int ButtonWidth, ButtonLeft, ButtonTop, I, J, pos;
  local int LabelWidth, LabelLeft;
  local UMenuLabelControl Heading;
  local bool bTop;


  for (i=6;i<100;i++)  //hack.  (defaults wouldn't work right
    AliasNames[i]="";
  i=6;
  NextBindingClass = GetPlayerOwner().GetNextInt("OldSkool.OSAExtraKeyBindings", 0);
  if(NextBindingClass != "")
  {
    while( (NextBindingClass != "") && (NumBindingClasses < 50) && (i < ArrayCount(AliasNames)) )
    {
      BindingClass = class<OSAExtraKeyBindings>(DynamicLoadObject(NextBindingClass, class'Class'));
      for( j=0;j<ArrayCount(BindingClass.default.AliasNames);j++ )
      {
        if( BindingClass.default.AliasNames[j] == "" )
          break;

        if( j == 0 )
          LabelList[i] = BindingClass.default.SectionName$","$BindingClass.default.LabelList[j];
        else
          LabelList[i] = BindingClass.default.LabelList[j];
        AliasNames[i] = BindingClass.default.AliasNames[j];    
        i++;
        if( i >= ArrayCount(AliasNames) )
          break;                
      }
      NumBindingClasses++;
      NextBindingClass = GetPlayerOwner().GetNextInt("OldSkool.OSAExtraKeyBindings", NumBindingClasses);
    }
  }
  
  bIgnoreLDoubleClick = True;
  bIgnoreMDoubleClick = True;
  bIgnoreRDoubleClick = True;

  Super(UMenuPageWindow).Created();

  SetAcceptsFocus();

  ButtonWidth = WinWidth - 140;
  ButtonLeft = WinWidth - ButtonWidth - 40;

  LabelWidth = WinWidth - 100;
  LabelLeft = 20;

  ButtonTop = 10;
  bTop = True;
  for (I=0; I<100; I++)
  {
    if(AliasNames[I] == "")
      break;

    j = InStr(LabelList[I], ",");
    if(j != -1)
    {
      if(!bTop)
        ButtonTop += 10;
      Heading = UMenuLabelControl(CreateControl(class'UMenuLabelControl', LabelLeft-10, ButtonTop+3, WinWidth, 1));
      Heading.SetText(Left(LabelList[I], j));
      Heading.SetFont(F_Bold);
      LabelList[I] = Mid(LabelList[I], j+1);
      ButtonTop += 19;
    }
    bTop = False;

    KeyNames[I] = UMenuLabelControl(CreateControl(class'UMenuLabelControl', LabelLeft, ButtonTop+3, LabelWidth, 1));
    KeyNames[I].SetText(LabelList[I]);
    KeyNames[I].SetHelpText(CustomizeHelp);
    KeyNames[I].SetFont(F_Normal);
    KeyButtons[I] = UMenuRaisedButton(CreateControl(class'UMenuRaisedButton', ButtonLeft, ButtonTop, ButtonWidth, 1));
    KeyButtons[I].SetHelpText(CustomizeHelp);
    KeyButtons[I].bAcceptsFocus = False;
    KeyButtons[I].bIgnoreLDoubleClick = True;
    KeyButtons[I].bIgnoreMDoubleClick = True;
    KeyButtons[I].bIgnoreRDoubleClick = True;
    ButtonTop += 19;
  }
  AliasCount = I;
  NoJoyDesiredHeight = ButtonTop + 10;
  LoadExistingKeys();

  DesiredWidth = 220;

}
function WindowShown()
{
  Super(UMenuPageWindow).WindowShown();
  Root.bAllowConsole = False;
}
function LoadExistingKeys()
{
  local int I, J, pos;
  local string KeyName;
  local string Alias;

  for (I=0; I<AliasCount; I++)
  {
    BoundKey1[I] = 0;
    BoundKey2[I] = 0;
  }

  for (I=0; I<255; I++)
  {
    KeyName = GetPlayerOwner().ConsoleCommand( "KEYNAME "$i );
    RealKeyName[i] = KeyName;
    if ( KeyName != "" )
    {
      Alias = GetPlayerOwner().ConsoleCommand( "KEYBINDING "$KeyName );
      if ( Alias != "" )
      {
        pos = InStr(Alias, " ");
        if ( pos != -1 )
        {
          if( !(Left(Alias, pos) ~= "taunt") &&
            !(Left(Alias, pos) ~= "getweapon") &&
            !(Left(Alias, pos) ~= "viewplayernum") &&
            !(Left(Alias, pos) ~= "button") &&
            !(Left(Alias, pos) ~= "mutate") &&
            !(Left(Alias, pos) ~= "stat") &&
            !(Left(Alias, pos) ~= "speech"))
            Alias = Left(Alias, pos);
        }
        for (J=0; J<AliasCount; J++)
        {
          if ( AliasNames[J] ~= Alias && AliasNames[J] != "None" )
          {
            if ( BoundKey1[J] == 0 )
              BoundKey1[J] = i;
            else
            if ( BoundKey2[J] == 0)
              BoundKey2[J] = i;
          }
        }
      }
    }
  }

}
//access nones suck:
function BeforePaint(Canvas C, float X, float Y)
{
  local int ButtonWidth, ButtonLeft, I;
  local int LabelWidth, LabelLeft;

  ButtonWidth = WinWidth - 135;
  ButtonLeft = WinWidth - ButtonWidth - 20;

  LabelWidth = WinWidth - 100;
  LabelLeft = 20;

  DesiredHeight = NoJoyDesiredHeight;

  for (I=0; I<AliasCount; I++)
  {
    KeyButtons[I].SetSize(ButtonWidth, 1);
    KeyButtons[I].WinLeft = ButtonLeft;

    KeyNames[I].SetSize(LabelWidth, 1);
    KeyNames[I].WinLeft = LabelLeft;
  }

  for (I=0; I<AliasCount; I++ )
  {
    if ( BoundKey1[I] == 0 )
      KeyButtons[I].SetText("");
    else
    if ( BoundKey2[I] == 0 )
      KeyButtons[I].SetText(LocalizedKeyName[BoundKey1[I]]);
    else
      KeyButtons[I].SetText(LocalizedKeyName[BoundKey1[I]]$OrString$LocalizedKeyName[BoundKey2[I]]);
  }
}
defaultproperties
{
    LabelList(0)="Single Player, Next Item"
    LabelList(1)="Previous Item"
    LabelList(2)="Activate Item"
    LabelList(3)="Reload"
    LabelList(4)="Quicksave/Ping"
    LabelList(5)="QuickLoad"
    AliasNames(0)="InventoryNext"
    AliasNames(1)="InventoryPrevious"
    AliasNames(2)="InventoryActivate"
    AliasNames(3)="button bextra3"
    AliasNames(4)="stat net | mutate quicksave"
    AliasNames(5)="mutate quickload"
    AliasNames(6)=""
    AliasNames(7)=""
    AliasNames(8)=""
    AliasNames(9)=""
    AliasNames(10)=""
    AliasNames(11)=""
    AliasNames(12)=""
    AliasNames(13)=""
    AliasNames(14)=""
    AliasNames(15)=""
    AliasNames(16)=""
    AliasNames(17)=""
    AliasNames(18)=""
    AliasNames(19)=""
    AliasNames(20)=""
    AliasNames(21)=""
    AliasNames(22)=""
    AliasNames(23)=""
    AliasNames(24)=""
    AliasNames(25)=""
    AliasNames(26)=""
    AliasNames(27)=""
    AliasNames(28)=""
    AliasNames(29)=""
    AliasNames(30)=""
    AliasNames(31)=""
    AliasNames(32)=""
    AliasNames(33)=""
    AliasNames(34)=""
    AliasNames(35)=""
    AliasNames(36)=""
    AliasNames(37)=""
    AliasNames(38)=""
    AliasNames(39)=""
    AliasNames(40)=""
    AliasNames(41)=""
    AliasNames(42)=""
    AliasNames(43)=""
    AliasNames(44)=""
    AliasNames(45)=""
    AliasNames(46)=""
    AliasNames(47)=""
    AliasNames(48)=""
    AliasNames(49)=""
    AliasNames(50)=""
    AliasNames(51)=""
    AliasNames(52)=""
    AliasNames(53)=""
    AliasNames(54)=""
}
