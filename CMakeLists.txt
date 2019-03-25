cmake_minimum_required(VERSION 3.5)

# Consider removing this in the future

# This should appear before the project command, because it does not use FORCE

if( WIN32 )

  set( CMAKE_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/package" CACHE PATH "Install path prefix, prepended onto install directories" )

else( )

  set( CMAKE_INSTALL_PREFIX "/opt/rocm" CACHE PATH "Install path prefix, prepended onto install directories" )

endif( )

set (PROJECT_NAME "thrust")

project(${PROJECT_NAME})

# This finds the rocm-cmake project, and installs it if not found
# rocm-cmake contains common cmake code for rocm projects to help setup and install
set( PROJECT_EXTERN_DIR ${CMAKE_CURRENT_BINARY_DIR}/extern )
find_package( ROCM CONFIG QUIET PATHS /opt/rocm )
if( NOT ROCM_FOUND )
  set( rocm_cmake_tag "master" CACHE STRING "rocm-cmake tag to download" )
  file( DOWNLOAD https://github.com/RadeonOpenCompute/rocm-cmake/archive/${rocm_cmake_tag}.zip
      ${PROJECT_EXTERN_DIR}/rocm-cmake-${rocm_cmake_tag}.zip STATUS status LOG log)

  list(GET status 0 status_code)
  list(GET status 1 status_string)

  if(NOT status_code EQUAL 0)
    message(FATAL_ERROR "error: downloading
    'https://github.com/RadeonOpenCompute/rocm-cmake/archive/${rocm_cmake_tag}.zip' failed
    status_code: ${status_code}
    status_string: ${status_string}
    log: ${log}
    ")
  endif()

  message(STATUS "downloading... done")

  execute_process( COMMAND ${CMAKE_COMMAND} -E tar xzvf ${PROJECT_EXTERN_DIR}/rocm-cmake-${rocm_cmake_tag}.zip
    WORKING_DIRECTORY ${PROJECT_EXTERN_DIR} )

  find_package( ROCM REQUIRED CONFIG PATHS ${PROJECT_EXTERN_DIR}/rocm-cmake-${rocm_cmake_tag} )
endif( )

include( ROCMSetupVersion )
include( ROCMCreatePackage )
include( ROCMInstallTargets )
include( ROCMPackageConfigHelpers )
include( ROCMInstallSymlinks )




set ( VERSION_STRING "2.3.2." )
# Check if BUILD_NUMBER is defined in a Jenkins envirnment
if ($ENV{BUILD_NUMBER} )
  string(CONCAT BUILD_VERSION ${VERSION_STRING} $ENV{BUILD_NUMBER})
else ()
  string(CONCAT BUILD_VERSION ${VERSION_STRING} "0")
endif ()

rocm_setup_version( VERSION ${BUILD_VERSION} NO_GIT_TAG_VERSION )



# Get the git tag version
include ( cmake/version.cmake )

rocm_get_git_commit_id ( rocblas_VERSION_COMMIT_ID )

# force library install path to lib (CentOS 7 defaults to lib64)

set(CMAKE_INSTALL_LIBDIR "lib" CACHE INTERNAL "Installation directory for libraries" FORCE)




add_subdirectory( thrust )
