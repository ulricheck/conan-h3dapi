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
include( H3DUtilityFunctions )
if( MSVC )
  getMSVCPostFix( msvc_postfix )
  set( h3dapi_name "H3DAPI${msvc_postfix}" )
else()
  set( h3dapi_name h3dapi )
endif()

handleRenamingVariablesBackwardCompatibility( NEW_VARIABLE_NAMES H3DAPI_LIBRARY_DEBUG
                                              OLD_VARIABLE_NAMES H3DAPI_DEBUG_LIBRARY
                                              DOC_STRINGS "Path to ${h3dapi_name}_d library." )

include( H3DCommonFindModuleFunctions )

# Look for the header file.
find_path( H3DAPI_INCLUDE_DIR NAMES H3D/H3DApi.h
                              PATHS ${CONAN_INCLUDE_DIRS_H3DAPI}
                              DOC "Path in which the file H3D/H3DAPI.h is located." )
mark_as_advanced( H3DAPI_INCLUDE_DIR )

# Look for the library.
find_library( H3DAPI_LIBRARY_RELEASE NAMES ${h3dapi_name}
                                     PATHS ${CONAN_LIB_DIRS_H3DAPI}
                                     DOC "Path to ${h3dapi_name} library." )

find_library( H3DAPI_LIBRARY_DEBUG NAMES ${h3dapi_name}_d
                                   PATHS ${CONAN_LIB_DIRS_H3DAPI}
                                   DOC "Path to ${h3dapi_name}_d library." )
mark_as_advanced( H3DAPI_LIBRARY_RELEASE H3DAPI_LIBRARY_DEBUG )

if( H3DAPI_INCLUDE_DIR )
  handleComponentsForLib( H3DAPI
                          MODULE_HEADER_DIRS ${H3DAPI_INCLUDE_DIR}
                          MODULE_HEADER_SUFFIX /H3D/H3DApi.h
                          DESIRED ${H3DAPI_FIND_COMPONENTS}
                          REQUIRED HAPI OpenGL GLEW
                          OPTIONAL         XercesC OpenAL Vorbis Audiofile NvidiaCG LibOVR FTGL Freetype 3DXWARE PythonLibs CURL
                                           SpiderMonkey DirectShow SixenseSDK FFmpeg VirtualHand GLUT OpenEXR
                          OPTIONAL_DEFINES HAVE_XERCES HAVE_OPENAL HAVE_LIBVORBIS HAVE_LIBAUDIOFILE HAVE_CG  HAVE_LIBOVR HAVE_FTGL HAVE_FREETYPE HAVE_3DXWARE HAVE_PYTHON HAVE_LIBCURL
                                           HAVE_SPIDERMONKEY HAVE_DSHOW HAVE_SIXENSE HAVE_FFMPEG HAVE_VIRTUAL_HAND_SDK HAVE_GLUT HAVE_OPENEXR
                          OUTPUT found_vars component_libraries component_include_dirs
                          H3D_MODULES HAPI )
endif()

include( SelectLibraryConfigurations )
select_library_configurations( H3DAPI )

include( FindPackageHandleStandardArgs )
# handle the QUIETLY and REQUIRED arguments and set H3DAPI_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args( H3DAPI DEFAULT_MSG
                                   H3DAPI_INCLUDE_DIR H3DAPI_LIBRARY ${found_vars} )

set( H3DAPI_LIBRARIES ${H3DAPI_LIBRARY} ${component_libraries} )
set( H3DAPI_INCLUDE_DIRS ${H3DAPI_INCLUDE_DIR} ${component_include_dirs} )
list( REMOVE_DUPLICATES H3DAPI_INCLUDE_DIRS )

# Backwards compatibility values set here.
set( H3DAPI_INCLUDE_DIR ${H3DAPI_INCLUDE_DIRS} )


MESSAGE("** CONAN FOUND H3DAPI:  ${H3DAPI_LIBRARIES}")
MESSAGE("** CONAN FOUND H3DAPI INCLUDE:  ${H3DAPI_INCLUDE_DIRS}")

# Additional message on MSVC
if( H3DAPI_FOUND AND MSVC )	
  if( NOT H3DAPI_LIBRARY_RELEASE )
    message( WARNING "H3DAPI release library not found. Release build might not work properly. To get rid of this warning set H3DAPI_LIBRARY_RELEASE." )
  endif()
  if( NOT H3DAPI_LIBRARY_DEBUG )
    message( WARNING "H3DAPI debug library not found. Debug build might not work properly. To get rid of this warning set H3DAPI_LIBRARY_DEBUG." )
  endif()
endif()
