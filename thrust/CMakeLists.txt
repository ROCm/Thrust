# ########################################################################
# Copyright 2019 Advanced Micro Devices, Inc.
# ########################################################################


include( GNUInstallDirs )

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

set( package_name thrust )

set(CPACK_DEBIAN_ARCHIVE_TYPE "gnutar")
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
