cdef extern from "ias_lib/ias_angle_gen_distro.h":
    cdef struct IAS_ANGLE_GEN_METADATA:
        pass

    int ias_angle_gen_read_ang(const char* ang_filename,
                               IAS_ANGLE_GEN_METADATA* metadata)

cdef extern from "ias_lib/ias_logging.h":
    int ias_log_initialize(const char* log_program_name)

cdef extern from "ias_lib/ias_satellite_attributes.h":
    ctypedef enum IAS_SATELLITE_ID:
        IAS_L8

    int ias_sat_attr_initialize(IAS_SATELLITE_ID satellite_id)

cdef extern from "l8_angles.h":
    cdef enum angle_type:
        AT_UNKNOWN = 0,
        AT_BOTH,
        AT_SATELLITE,
        AT_SOLAR
    ctypedef angle_type ANGLE_TYPE

    cdef struct angles_frame:
        int num_lines
        int num_samps
    ctypedef angles_frame ANGLES_FRAME
    ctypedef struct L8_ANGLES_PARAMETERS:
        pass

    int l8_angles(int band_idx, int n_lines, int n_samples,
                  int sub_sample, ANGLE_TYPE angle,
                  const IAS_ANGLE_GEN_METADATA* metadata,
                  double* sun_az, double* sun_zn,
                  double* sat_az, double* sat_zn)

cdef extern from "angles_api.c":
    int get_frame(const IAS_ANGLE_GEN_METADATA* metadata,
                  int band_index, ANGLES_FRAME* frame)

