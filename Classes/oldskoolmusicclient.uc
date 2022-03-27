// ============================================================
//oldskoolmusicclient.  the l337 mu5ic selector thingy.......
// ============================================================

class oldskoolmusicclient expands UMenuPageWindow;
// music vars
var UWindowComboControl musicselect;      //main combo to select music
var UWindowCheckBox force, CDcheck;      //force music and let cdmusic be used
var UwindowHsliderControl track, volume;    //used for both musics that have multiple tracks as well as CD track :D   volume allowz quick colume setting....
var UWindowSmallButton reset; //to reset to level's music...
var playbutton playbutton; //a custom button which a logo.  notify has this play stuff......
var UMenuLabelControl tracklabel;  //this shows what song # is selected.
var bool breset; //was it reset (can't over-ride save if it was :D)
var bool initialized; //to prevent accccessed nones......
var bool requestNoCD;  //to allaw turning off of CD trackz......
var float nocdtimer;  //can't set a timer in Uwindows so we do it the ugly way :P

function created(){
local int i, k;
local string musicclass, musicdesc, amount, selection;
local bool foundmusicclass; //if we find it stop searching D:
super.created();
i=0; //ensure.....
force = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 10, 90, 1));
force.SetText("Force Music");
force.SethelpText("If unchecked, the music choice will only run if there is no music in the level, a menu is running, or you select 'Play'.");
force.SetFont(F_Normal);
force.Align = TA_Left;
force.bChecked = class'Olroot.oldskoolrootwindow'.default.force;
CDcheck = UWindowCheckBox(CreateControl(class'UWindowCheckBox', winwidth-95, 10, 90, 1));
CDcheck.SetText("Use CD music");
CDcheck.SethelpText("If checked, music will be played off a CD in the CDROM.");
CDcheck.SetFont(F_Normal);
CDcheck.Align = TA_Left;
CDcheck.bChecked = bool(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice UseCDMusic")); //bool needs to be run, as this stuff is saved in strings
if (cdcheck.bchecked){
force.bchecked=true;
force.bdisabled=true;}
//volume ripped from umenuaudioclient purely for convenience.....
Volume = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', 10, 35, 210, 1));
Volume.SetRange(0, 255, 32);
Volume.SetValue(int(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice MusicVolume")));   //saved in strings.....
Volume.SetText(class'umenu.umenuaudioclientwindow'.default.MusicVolumeText);               //allow localization
Volume.SetHelpText(class'umenu.umenuaudioclientwindow'.default.MusicVolumeHelp);
Volume.SetFont(F_Normal);
Volume.Align = TA_Left;
musicselect = UWindowComboControl(CreateControl(class'UWindowComboControl', 10, 60, 210, 1));
musicselect.SetButtons(false);      //option debatable......
musicselect.SetText("Select Song");
musicselect.Align = TA_Left;
musicselect.SetHelpText("Select the song that you wish to have played.");
musicselect.SetFont(F_Normal);
musicselect.SetEditable(False);
musicselect.editboxwidth = 150;
GetPlayerOwner().GetNextIntDesc("engine.music", 0, musicclass, musicDesc); //load's the first one... I used engine.music as it looked good (any valid class would have worked fine)
while (musicclass != "")      //while allows for infine amounts of songz....       (ok..10,000 actually..hardcoded into lists)
  {
  k = InStr(musicDesc, ",");      //search for the comma to ID the description and the amount of songs in the music...
    if(k == -1)
    {
      amount=","$1;         //default to 1 track.....
    }
    else
    {
      amount = ","$Mid(musicDesc, k+1);
      musicdesc = Left(musicDesc, k);       //split off....
    }
  if (!foundmusicclass&&musicclass==class'olroot.oldskoolrootwindow'.default.musicclass){
  foundmusicclass=true;
  selection=musicclass$amount;}
  musicselect.AddItem(musicDesc, musicclass$amount);  //the first item will show.. second stores the class and song amount that may be called later... (not shown to user)
  i++;
  GetPlayerOwner().GetNextIntDesc("engine.music", i, musicclass, musicDesc);
  }
musicselect.sort(); //alphabatize :D
k=musicselect.FindItemIndex2(selection, True);
musicselect.SetSelectedIndex(Max(k, 0));   //set it as we found it above....
Reset = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 10, 83, 70, 1));
Reset.SetText("RESET");
Reset.SetFont(F_Bold);
Reset.Align = TA_Left;
Reset.SetHelpText("Reset the music to the level's default");
reset.bdisabled=(getplayerowner().myhud.isa('oldskoolhud')); //disable if force is checked or we are in SP....
Playbutton = playButton(CreateControl(class'playButton', winwidth-78, 83, 70, 1));
Playbutton.SetText("");    //nothing is written as the graphic is self-explanitory...
Playbutton.SetFont(F_Normal);
Playbutton.Align = TA_Right;
Playbutton.SetHelpText("Play the selected music!");
if (!cdcheck.bchecked&&getplayerowner().myhud.isa('oldskoolhud'))
playbutton.bdisabled=true;
track = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', 10, 108, 210, 1));
if (cdcheck.bchecked){             //disable and hide stuff.....
track.SetText("CD Track");
track.SetHelpText("Select the CD track number you wish to play");
reset.bdisabled=true;           //can't reset if CD is playing :D
reset.sethelptext("You cannot reset to level music while CD music is enabled");
musicselect.hidewindow(); //don't show music if CD is checked....
track.SetRange(1, 32, 1); } //up to 32 trackz.....
else{ //set it as music sayz it.....
musicdesc=musicselect.GetValue2();  //read selection amount item
k = InStr(musicDesc, ","); //read comma
amount = Mid(musicDesc, k+1); //read the amount....
track.SetRange(0, INT(amount)-1, 1);
track.SetText("Song Number");
track.SetHelpText("Select the song number you wish to play");} //set range to amount of trackz songs have.....
track.SetValue(class'olroot.oldskoolrootwindow'.default.track);   //what track we saved at?
track.SetFont(F_Normal);
track.Align = TA_Left;
tracklabel=UMenuLabelControl(CreateWindow(class'UMenuLabelControl', 10, 121,210, 1));
tracklabel.Align = TA_Center;
track.SetFont(F_Bold);
if (cdcheck.bchecked)
tracklabel.SetText("CD Track "$string(class'olroot.oldskoolrootwindow'.default.track)$" selected");
else
tracklabel.SetText("Song Number "$string(class'olroot.oldskoolrootwindow'.default.track)$" selected");
tracklabel.SethelpText("01d5k001 0wnz j00!!!!"); // :D
If (amount=="1"){        //hide as we only have amount of one (it is set to 0 for CD's always)
track.hidewindow();
tracklabel.SetText("Only One Song Available");}
if (k==-1&&!cdcheck.bchecked)//music not found in int's
tracklabel.SetText("Level's song, "$Left(string(getplayerowner().song),InStr(string(getplayerowner().song), "."))$" has no INT reference!");
initialized=true;
  DesiredWidth = 220;
  DesiredHeight = 146;
}
function Notify(UWindowDialogControl C, byte E)          //notifification!!1
{
  Super.Notify(C, E);
  If (!initialized) return; //prevent accessed nones......

  switch(E)      //type
  {
  case DE_Change:
    switch(C)      //name of control....
    {
    Case Volume:
    GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice MusicVolume "$Volume.Value);
    break;
    Case force:
    oldskoolrootwindow(root).force = force.bchecked;
    class'Olroot.oldskoolrootwindow'.default.force = force.bchecked;
    class'Olroot.oldskoolrootwindow'.static.staticSaveconfig();
    break;
    Case musicselect:
    Musicchanged();       //only swaps the track...
    break;
    Case Cdcheck:
    cdchanged(); //don't want too much stuff in the case.
    break;
    case track:    //only change label.. true saving done by close/play
    breset=false;
    if (cdcheck.bchecked)
    tracklabel.SetText("CD Track "$string(int(track.value))$" selected");
    else
    tracklabel.SetText("Song Number "$string(int(track.value))$" selected");
    break;
    }
  break;

  case DE_Click:   //button clicks....
    switch(C)
    {
    Case playbutton: //change the vars here
    Play(); //too much stuff
    break;
    Case reset:
    Resetstuff();
    break;
    }
   break;
  }
}
function resetstuff(){
local int a, b, k, amount;
local bool found;
local string temp;
If (reset.bdisabled) return; //wierd bug...very wierd...
breset=true;
If (Getlevel().song !=None){   //we can safely set it
    Getplayerowner().ClientSetMusic( GetLevel().Song, GetLevel().SongSection, GetLevel().CdTrack, MTRAN_Fade );   //reset it...
    oldskoolrootwindow(root).musicclass=string(GetLevel().Song);
    oldskoolrootwindow(root).track=int(GetLevel().SongSection);}
    else{ //with no music, it will reset to umenu, so we need to load the nullmusic
    Getplayerowner().ClientSetMusic( Music'olroot.null', 0, 255, MTRAN_Fade);
    oldskoolrootwindow(root).musicclass="olroot.null";
    oldskoolrootwindow(root).track=0;
    class'olroot.oldskoolRootwindow'.default.musicclass="olroot.null";
    class'olroot.oldskoolRootwindow'.default.track=0;}
    a=1;
    while (!found&&a<5){            //attempt to fine it in the class.....
    temp=oldskoolrootwindow(root).musicclass$","$string(a);
    b=musicselect.FinditemIndex2(temp, true);
    if (b != -1) //-1 means not found....
    found=true;
    a++;
    }
    musicselect.SetSelectedIndex(max(0,b));
    k = InStr(musicselect.getvalue2(), ","); //read comma
amount = INT(Mid(musicselect.getvalue2(), k+1)); //read the amount....
track.SetRange(0, amount-1, 1);
    track.SetValue(class'olroot.oldskoolrootwindow'.default.track);
    tracklabel.SetText("Song Number "$string(class'olroot.oldskoolrootwindow'.default.track)$" selected");
    If (amount==1){        //hide as we only have amount of one (it is set to 0 for CD's always)
track.hidewindow();
tracklabel.SetText("Only One Song Number in Selected Song");
if (b==-1)//music not found in int's
tracklabel.SetText("Level's song, "$Left(string(getplayerowner().song),InStr(string(getplayerowner().song), "."))$" has no INT reference!");
class'Olroot.oldskoolrootwindow'.static.staticSaveconfig();}

}
function play() //really saving configs for root
{
local int i;
local string musicclass;
If (playbutton.bdisabled) return; //wierd bug...very wierd...
breset=false;
if (!cdcheck.bchecked){
musicclass=musicselect.GetValue2();  //read selection amount item
I = InStr(musicclass, ","); //read comma
musicclass = Left(musicclass, i);    //read actual object reference
oldskoolrootwindow(root).musicclass=musicclass;
oldskoolrootwindow(root).Saveconfig(); } //save (it's gobalconfig)
oldskoolrootwindow(root).bswaptrack=false;
oldskoolrootwindow(root).swaptime=0.0;
//now save track....
oldskoolrootwindow(root).track=track.value;
oldskoolrootwindow(root).saveconfig();
if (oldskoolrootwindow(root).force) return; //allow OSA to process it.
//force play......
If ((string(getplayerowner().song)!=musicclass)||int(getplayerowner().songsection)!=track.value){
if (cdcheck.bchecked)
getplayerowner().clientsetmusic(music'olroot.null',0,track.value,MTRAN_Fade);
else
getplayerowner().clientsetmusic(music(dynamicloadobject(musicclass, class'music')),track.value,255,MTRAN_Fade);}
}
function RightClickTab()     // :D
{
MessageBox("Secret Message", "Congradulations!  You have found the secret message.  E-mail me at usaar33@yahoo.com with the password\\n'Hyp3r10n s00x (1 w4r3d j00!!)'\\nto be rewarded!", MB_OK, MR_OK, MR_OK);    //hey!!!!! don't look at this!!!
}
function cdchanged(){     //cd options...
local int k, amount;
local string musicdesc;
local bool digimusic;
breset=false;
reset.bdisabled=CDCheck.bChecked;
digimusic=!Cdcheck.bchecked;
       //set the ini
if (cdcheck.bchecked){ //window swapping.....
GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice UseCDMusic true");
force.bchecked=true;
force.bdisabled=true;
playbutton.bdisabled=false; //ensure it is enabled.....
track.SetText("CD Track");
track.SetHelpText("Select the CD track number you wish to play");
reset.sethelptext("You cannot reset to level music while CD music is enabled");
musicselect.hidewindow(); //don't show music
track.SetRange(1, 32, 1);  //up to 32 trackz.....
oldskoolrootwindow(root).track=max(1, oldskoolrootwindow(root).track);
class'olroot.oldskoolRootwindow'.default.track=max(1, oldskoolrootwindow(root).track);
class'Olroot.oldskoolrootwindow'.static.staticSaveconfig(); //ensure its not 0...
track.SetValue(oldskoolrootwindow(root).track);
tracklabel.SetText("CD Track "$string(oldskoolrootwindow(root).track)$" selected");
track.showwindow();
getplayerowner().clientsetmusic(music'olroot.null',0,track.value,MTRAN_Fade);
oldskoolrootwindow(root).cdused=true;                        //active
class'olroot.oldskoolRootwindow'.default.cdused=true;        //save
class'Olroot.oldskoolrootwindow'.static.staticSaveconfig();
}
else{ //going to non-CD mode.....
oldskoolrootwindow(root).cdused=false;                        //active
class'olroot.oldskoolRootwindow'.default.cdused=false;        //save
class'Olroot.oldskoolrootwindow'.static.staticSaveconfig();
force.bchecked=class'Olroot.oldskoolrootwindow'.default.force;           //reset it to what it should be....
force.bdisabled=false;
reset.bdisabled=(getplayerowner().myhud.isa('oldskoolhud'));
musicdesc=musicselect.GetValue2();  //read selection amount item
k = InStr(musicDesc, ","); //read comma
amount = INT(Mid(musicDesc, k+1)); //read the amount....
track.SetRange(0,amount-1, 1);
oldskoolrootwindow(root).track=255;
class'olroot.oldskoolRootwindow'.default.track=min(amount, oldskoolrootwindow(root).track)-1;//ensure # is valid
class'Olroot.oldskoolrootwindow'.static.staticSaveconfig();
track.SetValue(class'olroot.oldskoolrootwindow'.default.track);
tracklabel.SetText("Song Number "$string(class'olroot.oldskoolrootwindow'.default.track)$" selected");
If (amount==1){        //hide as we only have amount of one
track.hidewindow();
tracklabel.SetText("Only One Song Available"); }
else
track.showwindow();
track.SetText("Song Number");
track.SetHelpText("Select the song number you wish to play");
reset.sethelptext("Reset the music to the level's default");
musicselect.showwindow(); //show music
if (getplayerowner().myhud.isa('oldskoolhud')){
If (getlevel().song!=None)
getplayerowner().clientsetmusic(getlevel().song, getlevel().songsection,255,MTRAN_Fade);
else //with no music, it will reset to umenu, so we need to load the nullmusic
Getplayerowner().ClientSetMusic( Music'olroot.null', 0, 255, MTRAN_Fade);
playbutton.bdisabled=true;  }
else
getplayerowner().clientsetmusic(music(dynamicloadobject(oldskoolrootwindow(root).musicclass, class'music')),track.value,255,MTRAN_Fade);
requestnocd=true;    }
GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice UseDigitalMusic "$digimusic);      //ensure won't play stuff wrong....
}
function tick(float delta){ //the ticker (to stop tracks correctly.....
if (!requestnocd)
return;
nocdtimer+=delta;
if (nocdtimer>2){
nocdtimer=0;
requestnocd=false;
oldskoolrootwindow(root).track=min(track.maxvalue+1, oldskoolrootwindow(root).track)-1;
GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice UseCDMusic false");   }
}
function musicchanged(){
local int k, amount;
breset=false; //duh!
k = InStr(musicselect.getvalue2(), ","); //read comma
amount = INT(Mid(musicselect.getvalue2(), k+1)); //read the amount....
track.SetRange(0, amount-1, 1);
oldskoolrootwindow(root).track=min(oldskoolrootwindow(root).track,amount-1);      //verification
track.SetValue(oldskoolrootwindow(root).track);
tracklabel.SetText("Song Number "$string(oldskoolrootwindow(root).track)$" selected");
If (amount==1){        //hide as we only have amount of one (it is set to 0 for CD's always)
track.hidewindow();
tracklabel.SetText("Only One Song Available");}
else
track.showwindow();
}
function Close(optional bool bByParent){ //saves configs when we close the main window.....
local int i;
local string musicclass;
if (!breset){        //don't over-ride saves if it was reset....
if (!cdcheck.bchecked){
musicclass=musicselect.GetValue2();  //read selection amount item
I = InStr(musicclass, ","); //read comma
musicclass = Left(musicclass, i);    //read actual object reference
oldskoolrootwindow(root).musicclass=musicclass;} //save (it's gobalconfig)
//now save track....
oldskoolrootwindow(root).track=track.value;}
oldskoolrootwindow(root).saveconfig();
Super.Close(bByParent);}

defaultproperties
{
}
