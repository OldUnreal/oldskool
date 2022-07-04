@ECHO OFF
ECHO --- Deleting Old Files...
del oldskool.u

ECHO --- Compiling...
REM This only works with UT v469c RC2 and upwards
ucc make -ini=oldskoolbuild.ini -fixcompat -noconstchecks
ucc conform oldskool.u oldskool.u.230

ECHO --- All Done!
