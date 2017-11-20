# l8_angles

This package implements a simple Python interface to the USGS Landsat 8 tool for computing
per-pixel solar and sensor azimuth and zenith angles, from Angle Coefficient Files
(https://landsat.usgs.gov/solar-illumination-and-sensor-viewing-angle-coefficient-file)

## Installation
Since this package depends on C code, it is recommended that you either
build the package with conda-build, using the recipe at (https://github.com/DHI-GRAS/py-l8angles-conda)
or install with the latest binaries from the DHI-GRAS conda channel:

```
conda config --add channels DHI-GRAS
conda install py-l8angles
```

## Usage
The package exposes a single function `calculate_angles`, taking the following parameters:
- metadata_file: str
    Path to the ANG file
- angle_type: str (default: 'BOTH')
    What angles to compute, either 'BOTH', 'SOLAR' or 'SATELLITE'
- subsample: int (default: 1)
    Subsample factor, i.e. a subsample of 2 will halve the resolution
- bands: list (default: [1..11])
    What bands to compute angles for

The function returns a dictionary, mapping angle type (sun/sat_az/zn, where az and zn is azimuth and zenith)
to lists of numpy 2D arrays. Each array in a list correspond to a single band.
The lists are ordered with respect to the input bands.

## Example
```python
import l8angles

data = l8angles.calculate_angles('./test_ANG.txt', angle_type='SOLAR',
                                 subsample=2, bands=[3,6,7])
```

