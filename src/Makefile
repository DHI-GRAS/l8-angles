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

DBEXEC	= \
	l8_angles_db.exe

LIB	= \
	ias_lib\l8ang.lib

DBLIB	= \
	ias_lib\l8ang_db.lib

#------------------------------------------------------------------------------
# Targets for each executable. 
#------------------------------------------------------------------------------
all: exec

debug: db_exec

dll: dll

setup:
	cd "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build" &&\
	vcvarsall.bat x86_amd64; &&\
	set INCLUDE=%INCLUDE%C:\Users\phgr\Documents\l8_angles\src\ias_lib; &&\
	set LIB=%LIB%"C:\Users\phgr\Documents\l8_angles\src\ias_lib;

$(LIB):
	cd ias_lib && make

$(DBLIB):
	cd ias_lib && make debug

dll: $(LIB)
	$(CC) $(OPTS) /LD $(SRC) $(LIB) /link /DLL /OUT:..\l8ang.dll

exec: $(LIB)
	$(CC) $(OPTS) /Fe$(EXEC) $(SRC) $(LIB)

db_exec: $(DBLIB)
	$(CC) $(DBOPTS) /Fe$(DBEXEC) $(SRC) $(DBLIB)

#------------------------------------------------------------------------------
# Misc.
#------------------------------------------------------------------------------
clean:
	rm -f *.obj *.exe *.pdb *.ilk & \
	rm ..\l8ang.dll & \
	cd ias_lib && make clean

