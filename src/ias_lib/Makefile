#----------------------------------------------------------------------------
# Make options
#----------------------------------------------------------------------------
SHELL = cmd
#----------------------------------------------------------------------------
# Set up the compiler options.
#----------------------------------------------------------------------------
DBOPTS  = /Zi /c
OPTS    = /O2 /favor:INTEL64 /c
CC 	= cl
#-------------------------------------------------------
# Define the executable(s), the pdf(s), and the html(s).
#-------------------------------------------------------
LIB   = l8ang.lib

DBLIB = l8ang_db.lib

INCS =	\
	ias_angle_gen_distro.h \
	ias_angle_gen_private.h \
	ias_angle_gen_includes.h \
	ias_math.h \
	ias_const.h \
	ias_types.h \
	ias_structures.h \
	ias_logging.h \
	ias_miscellaneous.h \
	ias_odl.h \
	ias_satellite_attributes.h

#---------------------------------------------------------
# Define the source code object files for each executable.
#---------------------------------------------------------
SRC	= \
	ias_angle_gen_calculate_angles_rpc.c \
	ias_angle_gen_read_ang.c \
	ias_angle_gen_utilities.c \
	ias_angle_gen_initialize.c \
	ias_angle_gen_write_image.c \
	ias_angle_gen_find_scas.c \
	ias_geo_convert_dms2deg.c \
	ias_math_compute_unit_vector.c \
	ias_math_compute_vector_length.c \
	ias_math_find_line_segment_intersection.c \
	ias_logging.c \
	ias_misc_create_output_image_trim_lut.c \
	ias_misc_convert_to_uppercase.c \
	ias_misc_write_envi_header.c \
	ias_odl_free_tree.c	\
	ias_odl_get_field.c	\
	ias_odl_read_tree.c	\
	ias_parm_provide_help.c \
	ias_parm_read.c \
	ias_parm_map_odl_type.c \
	ias_parm_check_ranges.c \
	ias_satellite_attributes.c \
	landsat8.c \
	lablib3.c

OBJ	= $(SRC:.c=.obj)

.PHONY: clean obj dbobj

#------------------------------------------------------------------------------
# Targets for each executable. 
#------------------------------------------------------------------------------
all: $(LIB)

debug: $(DBLIB)

$(LIB): obj 
	lib /out:$@ $(OBJ) 

$(DBLIB): dbobj
	lib /out:$@ $(OBJ)

#---------------------------------------
# Target to distribute the executable(s)
#---------------------------------------
obj:
	$(CC) $(OPTS) $(SRC)

dbobj:
	$(CC) $(DBOPTS) $(SRC)

clean:
	rm -f *.obj *.lib *.pdb
