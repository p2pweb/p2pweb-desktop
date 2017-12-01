#!/usr/bin/env python
# -*- coding: utf-8 -*-
from os.path import abspath, dirname, basename, join, exists
from dirreplace import dirreplace

FROM_STRING = """
GitBox
"""

TO_STRING = """
GitBox
"""


dirreplace(
    dirname(abspath(__file__)),
    FROM_STRING,
    TO_STRING,
)
