@echo off

copy build_exe      %CCCDIR%\usr\bin\%CCCUNAME%\build.exe    1>NUL
:copy ppo2cpp_exe    %CCCDIR%\usr\bin\%CCCUNAME%\ppo2cpp.exe  1>NUL
copy prg2ppo_exe    %CCCDIR%\usr\bin\%CCCUNAME%\prg2ppo.exe  1>NUL
copy ccomp_exe      %CCCDIR%\usr\bin\%CCCUNAME%\ccomp.exe    1>NUL
