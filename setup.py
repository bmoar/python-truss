#!/usr/bin/env python3

from setuptools import setup, find_packages

setup(
    name='python_truss',
    version='1.0.0',
    packages=find_packages(),
    zip_safe=False,
    include_package_data=True,
    install_requires=[
        'coverage',
    ],
    classifiers=[
        'Private :: Do Not Upload'
    ],
    entry_points={
        'console_scripts': [
            'manage = flask_truss.scripts.manage:main_manager',
            'app = flask_truss.scripts.manage:main_app',
        ]
    }
)
