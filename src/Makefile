#----------------------------------------------------------------------------
# Make options
#----------------------------------------------------------------------------
SHELL = cmd

#----------------------------------------------------------------------------
# Set up the compiler options.  
#----------------------------------------------------------------------------
OPTS	= /O2 /favor:INTEL64
DBOPTS  = /Zi
CC 	= cl

#---------------------------------------------------------
# Define the source code object files for each executable.
#---------------------------------------------------------
SRC	= \
	l8_angles.c \
	angles_api.c 

EXEC 	= \
	l8_angles.exe

#------------------------------------------------------------------------------
# Targets for each executable. 
#------------------------------------------------------------------------------
all: setup exec

debug: setup db_exec

setup:
	cd "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build" &&\
	vcvarsall.bat x86_amd64; &&\
	set INCLUDE=%INCLUDE%C:\Users\phgr\Documents\l8_angles\src\ias_lib; &&\
	set LIB=%LIB%"C:\Users\phgr\Documents\l8_angles\src\ias_lib;

exec: lib
	$(CC) $(OPTS) /Fe$(EXEC) $(SRC) ias_lib\l8ang.lib 

db_exec: dblib
	$(CC) $(DBOPTS) /Fe$(EXEC) $(SRC) ias_lib\l8ang.lib

lib:
	cd ias_lib && make

dblib:
	cd ias_lib && make debug

#------------------------------------------------------------------------------
# Misc.
#------------------------------------------------------------------------------
clean:
	rm -f *.obj *.exe *.pdb *.ilk & \
	cd ias_lib && make clean

