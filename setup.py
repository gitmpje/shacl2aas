#!/usr/bin/env python3
# Copyright (c) 2022 ...
#
# This program and the accompanying materials are made available under the terms of the Eclipse Public License v. 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0, or the Apache License, Version 2.0 which is available
# at https://www.apache.org/licenses/LICENSE-2.0.
#
# SPDX-License-Identifier: EPL-2.0 OR Apache-2.0

import setuptools

with open("README.md", "r", encoding='utf-8') as fh:
    long_description = fh.read()

setuptools.setup(
    name="shacl2aas",
    version="0.0.1",
    author="Mark van der Pas",
    author_email="mark.van.der.pas@semaku.com",
    description="A tool to convert an SHACL (RDF serialized) shapes graph to a basic Asset Administration Shell for Industry 4.0",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="",
    packages=setuptools.find_packages(exclude=["test", "test.*"]),
    zip_safe=False,
    package_data={
    },
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: Eclipse Public License 2.0 (EPL-2.0)",
        "License :: OSI Approved :: Apache Software License",
        "Operating System :: OS Independent",
        "Development Status :: 3 - Alpha",
    ],
    entry_points={
        'console_scripts': [
            # "aas_compliance_check = aas.compliance_tool.cli:main"
        ]
    },
    python_requires='>=3.6',
    install_requires=[
        'rdflib'
    ]
)