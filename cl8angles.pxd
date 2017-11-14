cdef extern from ias_lib/ias_angle_gen_distro.h:
    ctypedef struct IAS_ANGLE_GEN_METADATA:
        pass

    int ias_angle_gen_read_ang(const char* ang_filename,
                               IAS_ANGLE_GEN_METADATA* metadata)

cdef extern from ias_lib/ias_logging.h:
    int ias_log_initialize(const char* log_program_name)

cdef extern from ias_lib/ias_satellite_attributes.h:
    ctypedef enum IAS_SATELLITE_ID:
        IAS_L8

    int ias_sat_attr_initialize(IAS_SATELLITE_ID satellite_id)

cdef extern from l8_angles.h:
    ctypedef enum ANGLE_TYPE:
        AT_UNKNOWN = 0,
        AT_BOTH,
        AT_SATELLITE,
        AT_SOLAR
    ctypedef struct L8_ANGLES_PARAMETERS:
        pass

    int calculate_angles(const IAS_ANGLE_GEN_METADATA* metadata, int line, 
                         int samp, int band_index, ANGLE_TYPE angle_type,
                         double* sat_angles, double* sun_angles)

cdef extern from l8_angles.c:
    int process_parameters(const int argument_count, char** arguments,
                           L8_ANGLES_PARAMETERS* parameters)
