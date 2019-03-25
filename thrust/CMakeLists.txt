# ########################################################################
# Copyright 2019 Advanced Micro Devices, Inc.
# ########################################################################

set( BIN_INSTALL_DIR ${CMAKE_INSTALL_BINDIR} )
set( LIB_INSTALL_DIR ${CMAKE_INSTALL_LIBDIR} )
set( INCLUDE_INSTALL_DIR ${CMAKE_INSTALL_INCLUDEDIR} )


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

rocm_create_package(
    NAME thrust
    DESCRIPTION "Radeon Open Compute Thrust library"
    MAINTAINER "Saad Rahim <saad.rahim@amd.com>"
)

rocm_install_targets(
  INCLUDE
  ${CMAKE_SOURCE_DIR}/thrust/
  PREFIX thrust

  )

rocm_install_symlink_subdir( thrust )
