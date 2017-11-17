import os.path

import numpy as np
cimport numpy as np

cimport cl8angles as cl8


cdef int init_lib():

    cdef int status = 0
    status = cl8.ias_log_initialize("l8angles")
    if status == -1:
        return -1
    cl8.ias_log_set_output_level(cl8.IAS_LOG_LEVEL_DISABLE)
    status = cl8.ias_sat_attr_initialize(cl8.IAS_L8)
    if status == -1:
        return -2


def calculate_angles(metadata_fp, angle_type='BOTH',
                     int subsample=1, bands=None):

    cdef int status = 0

    if bands is None:
        bandlist = np.arange(11, dtype=np.intc)
    else:
        if any(x < 1 for x in bands) or any(x > 11 for x in bands):
            raise ValueError('Invalid bandindex in bandlist')
        bandlist = np.array(bands, dtype=np.intc)
        bandlist -= 1

    if subsample < 1:
        raise ValueError('Subsample must be a positive integer')

    if angle_type not in ['BOTH', 'SATELLITE', 'SOLAR']:
        raise ValueError('angle_type must be either BOTH, SATELLITE or SOLAR')

    cdef cl8.ANGLE_TYPE ang = cl8.AT_UNKNOWN
    if angle_type == 'BOTH':
        ang = cl8.AT_BOTH
    elif angle_type == 'SATELLITE':
        ang = cl8.AT_SATELLITE
    elif angle_type == 'SOLAR':
        ang = cl8.AT_SOLAR

    status = init_lib()
    if status == -1:
        raise RuntimeError('Could not initialize logging')
    if status == -2:
        raise RuntimeError('Could not initialize library')

    if not os.path.isfile(metadata_fp):
        raise ValueError('Metadata file does not exist')
    filename = metadata_fp.encode('ascii')
    cdef char* c_filename = filename

    cdef cl8.IAS_ANGLE_GEN_METADATA metadata
    status = cl8.ias_angle_gen_read_ang(c_filename, &metadata)
    if status == -1:
        raise ValueError('Invalid metadata file')

    if angle_type == 'BOTH':
        data = {'sun_az': [], 'sun_zn': [], 'sat_az': [], 'sat_zn': []}
    if angle_type == 'SATELLITE':
        data = {'sat_az': [], 'sat_zn': []}
    if angle_type == 'SOLAR':
        data = {'sun_az': [], 'sun_zn': []}
    
    cdef int n_lines
    cdef int n_samps
    cdef cl8.ANGLES_FRAME frame
    cdef np.ndarray[np.float64_t, ndim=2] sun_az
    cdef np.ndarray[np.float64_t, ndim=2] sun_zn
    cdef np.ndarray[np.float64_t, ndim=2] sat_az
    cdef np.ndarray[np.float64_t, ndim=2] sat_zn
    for i in range(bandlist.size):
        band = bandlist[i]
        status = cl8.get_frame(&metadata, band, &frame)
        if status == -1:
            raise ValueError('Band {} not present in metadata file'.format(band + 1))
        n_lines = (frame.num_lines - 1) // subsample + 1
        n_samps = (frame.num_samps - 1) // subsample + 1
        if angle_type == 'BOTH': 
            sun_az = np.empty((n_lines, n_samps), dtype=np.float64)
            sun_zn = np.empty((n_lines, n_samps), dtype=np.float64)
            sat_az = np.empty((n_lines, n_samps), dtype=np.float64)
            sat_zn = np.empty((n_lines, n_samps), dtype=np.float64)
            status = cl8.l8_angles(band, n_lines, n_samps, subsample, ang, &metadata,
                                   &sun_az[0,0], &sun_zn[0,0], &sat_az[0,0], &sat_zn[0,0])
            if status == -1:
                raise RuntimeError('Internal error in l8ang lib')
            data['sun_az'].append(sun_az)
            data['sun_zn'].append(sun_zn)
            data['sat_az'].append(sat_az)
            data['sat_zn'].append(sat_zn)
        elif angle_type == 'SATELLITE': 
            sat_az = np.empty((n_lines, n_samps), dtype=np.float64)
            sat_zn = np.empty((n_lines, n_samps), dtype=np.float64)
            status = cl8.l8_angles(band, n_lines, n_samps, subsample, ang, &metadata,
                                   NULL, NULL, &sat_az[0,0], &sat_zn[0,0])
            if status == -1:
                raise RuntimeError('Internal error in l8ang lib')
            data['sat_az'].append(sat_az)
            data['sat_zn'].append(sat_zn)
        elif angle_type == 'SOLAR': 
            sun_az = np.empty((n_lines, n_samps), dtype=np.float64)
            sun_zn = np.empty((n_lines, n_samps), dtype=np.float64)
            status = cl8.l8_angles(band, n_lines, n_samps, subsample, ang, &metadata,
                                   &sun_az[0,0], &sun_zn[0,0], NULL, NULL)
            if status == -1:
                raise RuntimeError('Internal error in l8ang lib')
            data['sun_az'].append(sun_az)
            data['sun_zn'].append(sun_zn)

    return data

