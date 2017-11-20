from setuptools import setup
from setuptools.extension import Extension
from Cython.Build import cythonize
import numpy

extensions = [
    Extension("l8angles", ["l8angles.pyx"],
              include_dirs = ["src", "src/ias_lib", numpy.get_include()],
              libraries=["l8_angles"])
]

setup(
    name= 'l8angles',
    ext_modules = cythonize(extensions),
)
