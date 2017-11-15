import os.path

import numpy as np
cimport numpy as np

cimport cl8angles


cdef init_lib():

    cdef int status = 0
    status = cl8angles.ias_log_initialize("l8angles")
    if status == -1:
        raise RuntimeError('Could not init logging')
    status = cl8angles.ias_sat_attr_initialize(IAS_L8)
    if status == -1:
        raise RuntimeError('Could not initialize satellite attributes')


def init_bandlist(bands):

    bandlist = np.zeros(11, dtype=intc)
    for i in range(len(bands)):
        idx = bands[i]
        bandlist[idx-1] = 1

    return bandlist


def calculate_angles(metadata_fp, angle_type='BOTH',
                     int subsample=1, bands=None):

    cdef int status = 0

    if bands is None:
        bandlist = np.arange(11, dtype=np.intc)
    else:
        if any(x < 1 for x in bandlist) or any(x > 11 for x in bandlist):
            raise ValueError('Invalid bandindex in bandlist')
        bandlist = np.array(bands, dtype=np.intc)
        bandlist -= 1

    if subsample < 1:
        raise ValueError('Subsample must be a positive integer')

    if angle_type not in ['BOTH', 'SATELLITE', 'SOLAR']:
        raise ValueError('angle_type must be either BOTH, SATELLITE or SOLAR')

    cdef ANGLE_TYPE ang = AT_UNKNOWN
    if angle_type == 'BOTH':
        ang = AT_BOTH
    elif angle_type == 'SATELLITE':
        ang = AT_SATELLITE
    elif angle_type == 'SOLAR':
        ang = AT_SOLAR

    init_lib()

    if not os.path.isfile(metadata_fp):
        raise ValueError('Metadata file does not exist')
    filename = metadata_fp.encode('ascii')
    cdef char* c_filename = filename

    cdef IAS_ANGLE_GEN_METADATA metadata
    status = cl8angles.ias_angle_gen_read_ang(c_filename, &metadata)
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
    cdef ANGLES_FRAME frame
    for i in range(bandlist.size):
        band = bandlist[i]
        status = cl8angles.get_frame(&metadata, band, &frame)
        if status == -1:
            raise ValueError('Band {} not present in metadata file'.format(band + 1))
        n_lines = (frame.num_lines - 1) // subsample + 1
        n_samps = (frame.num_samps - 1) // subsample + 1
        if angle_type == 'BOTH': 
            sun_az = np.empty((n_lines, n_samps), dtype=np.float64)
            sun_zn = np.empty((n_lines, n_samps), dtype=np.float64)
            sat_az = np.empty((n_lines, n_samps), dtype=np.float64)
            sat_zn = np.empty((n_lines, n_samps), dtype=np.float64)
            status = cl8angles.l8_angles(band, n_lines, n_samps, subsample, ang, &metadata,
                                         &sun_az[0,0], &sun_zn[0,0], &sat_az[0,0], &sat_zn[0,0])
            if status == -1:
                raise RuntimeError('Something horrible happened')
            data['sun_az'].append(sun_az)
            data['sun_zn'].append(sun_zn)
            data['sat_az'].append(sat_az)
            data['sat_zn'].append(sat_zn)
        elif angle_type == 'SATELLITE': 
            sat_az = np.empty((n_lines, n_samps), dtype=np.float64)
            sat_zn = np.empty((n_lines, n_samps), dtype=np.float64)
            status = cl8angles.l8_angles(band, n_lines, n_samps, subsample, ang, &metadata,
                                         NULL, NULL, &sat_az[0,0], &sat_zn[0,0])
            if status == -1:
                raise RuntimeError('Something horrible happened')
            data['sat_az'].append(sat_az)
            data['sat_zn'].append(sat_zn)
        elif angle_type == 'SOLAR': 
            sun_az = np.empty((n_lines, n_samps), dtype=np.float64)
            sun_zn = np.empty((n_lines, n_samps), dtype=np.float64)
            status = cl8angles.l8_angles(band, n_lines, n_samps, subsample, ang, &metadata,
                                         &sun_az[0,0], &sun_zn[0,0], NULL, NULL)
            if status == -1:
                raise RuntimeError('Something horrible happened')
            data['sat_az'].append(sat_az)
            data['sat_zn'].append(sat_zn)

    return data


cdef _calculate_angles(char** argv, int sample_factor, ANGLE_TYPE angle_type):

    # Try parsing the file and parameters
    cdef L8_ANGLES_PARAMETERS params
    cdef int argc = 6
    cdef int status = cl8angles.process_parameters(argc, argv, &params)
    if status == -1:
        raise ValueError('One or more invalid arguments or invalid metadata file')

