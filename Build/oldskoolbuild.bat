@ECHO OFF

REM Set to the default dir of UT according to v469, point to the right direction before using!
SET uccdir=C:\Program Files\Unreal Tournament
CD %uccdir%

ECHO --- Deleting Old Files...
del oldskool.u

ECHO --- Compiling...
REM This only works with UT v469
%uccdir%\ucc.exe make -ini=oldskoolbuild.ini -bytehax

ECHO --- All Done!
