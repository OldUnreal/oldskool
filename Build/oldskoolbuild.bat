@ECHO OFF
ECHO --- Deleting Old Files...
del oldskool.u

ECHO --- Compiling...
REM This only works with UT v469
ucc make -ini=oldskoolbuild.ini -bytehax

ECHO --- All Done!