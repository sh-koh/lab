#!/usr/bin/env python

from setuptools import setup

setup(
    name='helloworld',
    version='0.0.1',
    py_modules=[ 'main' ],
    entry_points={
        'console_scripts': [ 'helloworld = main:main' ]
    },
)
