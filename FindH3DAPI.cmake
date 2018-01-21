#=============================================================================
# Copyright 2001-2011 Kitware, Inc.
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)

find_path(H3DAPI_INCLUDE_DIR NAMES H3DAPI/H3DAPI.h PATHS ${CONAN_INCLUDE_DIRS_H3DAPI})
find_library(H3DAPI_LIBRARY NAMES ${CONAN_LIBS_H3DAPI} PATHS ${CONAN_LIB_DIRS_H3DAPI})

MESSAGE("** H3DAPI ALREADY FOUND BY CONAN!")
SET(H3DAPI_FOUND TRUE)
MESSAGE("** FOUND H3DAPI:  ${H3DAPI_LIBRARY}")
MESSAGE("** FOUND H3DAPI INCLUDE:  ${H3DAPI_INCLUDE_DIR}")

set(H3DAPI_INCLUDE_DIRS ${H3DAPI_INCLUDE_DIR})
set(H3DAPI_LIBRARIES ${H3DAPI_LIBRARY})

mark_as_advanced(H3DAPI_LIBRARY H3DAPI_INCLUDE_DIR)