# ########################################################################
# Copyright 2016 Advanced Micro Devices, Inc.
# ########################################################################

# The following helper functions wrap common cmake functions.  They are
# used to cope with a few wierdnesses of hipcc/nvcc.
# ########################################################################
# HELPER FUNCTIONS
# ########################################################################

# ########################################################################
# target_compile_features() override
# ########################################################################


# Build into subdirectories
#add_subdirectory( src )

# The following code is setting variables to control the behavior of CPack to generate our
# if( WIN32 )
#     set( CPACK_SOURCE_GENERATOR "ZIP" )
#     set( CPACK_GENERATOR "ZIP" )
# else( )
#     set( CPACK_SOURCE_GENERATOR "TGZ" )
#     set( CPACK_GENERATOR "DEB;RPM" CACHE STRING "cpack list: 7Z, DEB, IFW, NSIS, NSIS64, RPM, STGZ, TBZ2, TGZ, TXZ, TZ, ZIP" )
#     # set( CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON )
# endif( )

set ( package_targets thrust )

set( rocblas_headers_public
  include/rocblas.h
  #  include/rocblas.hpp
  include/rocblas-types.h
  include/rocblas-auxiliary.h
  include/rocblas-functions.h
  ${PROJECT_BINARY_DIR}/include/rocblas-version.h
  )



file ( GLOB_RECURSE HEADERS *.h )



source_group( "Header Files\\Public" FILES ${HEADERS} )

set( BIN_INSTALL_DIR ${CMAKE_INSTALL_BINDIR} )
set( LIB_INSTALL_DIR ${CMAKE_INSTALL_LIBDIR} )
set( INCLUDE_INSTALL_DIR ${CMAKE_INSTALL_INCLUDEDIR} )

#add_subdirectory ( system )

# Package specific CPACK vars
set( CPACK_DEBIAN_PACKAGE_DEPENDS "hip_hcc (>= 1.3)" )
set( CPACK_RPM_PACKAGE_REQUIRES "hip_hcc >= 1.3" )
set( CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/../LICENSE.md" )

if( NOT CPACK_PACKAGING_INSTALL_PREFIX )
  set( CPACK_PACKAGING_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}" )
endif( )

set( CPACK_RPM_EXCLUDE_FROM_AUTO_FILELIST_ADDITION "\${CPACK_PACKAGING_INSTALL_PREFIX}" "\${CPACK_PACKAGING_INSTALL_PREFIX}/include" "\${CPACK_PACKAGING_INSTALL_PREFIX}/lib" )

# Give rocblas compiled for CUDA backend a different name
#if( CMAKE_CXX_COMPILER MATCHES ".*/hcc$" OR CXX_VERSION_STRING MATCHES "clang" )
set( package_name thrust )
#else( )
#    set( package_name rocblas-alt )
#endif( )

set( ROCBLAS_CONFIG_DIR "\${CPACK_PACKAGING_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}" CACHE PATH "Path placed into ldconfig file" )
add_library ( thrust INTERFACE )


#target_include_directories( thrust
  #PUBLIC  $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/thrust
#)
rocm_create_package(
    NAME thrust
    DESCRIPTION "Radeon Open Compute BLAS library"
    MAINTAINER "Kent Knox <kent.knox@amd.com>"
#    LDCONFIG
#    LDCONFIG_DIR ${ROCBLAS_CONFIG_DIR}
)

rocm_install_targets(

#  TARGETS ${package_targets}
  INCLUDE
  ${CMAKE_SOURCE_DIR}/thrust/

#  ${CMAKE_BINARY_DIR}/include

  PREFIX thrust

  )

rocm_install_symlink_subdir( thrust )
