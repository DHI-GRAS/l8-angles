set WORKDIR=%~dp0
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64
cd %WORKDIR%
set INCLUDE=%INCLUDE%%WORKDIR%src\ias_lib;
set LIB=%LIB%%WORKDIR%src\ias_lib;
