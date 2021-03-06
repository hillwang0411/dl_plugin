cmake_minimum_required(VERSION 3.12.4)

project(dl_plugin)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

option(BUILD_SHARED_LIBS "Build using shared libraries" ON)

include(cmake/utils/Utils.cmake)
include(cmake/utils/FindCUDA.cmake)

if(EXISTS ${CMAKE_CURRENT_BINARY_DIR}/config.cmake)
  include(${CMAKE_CURRENT_BINARY_DIR}/config.cmake)
else()
  if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/config.cmake)
    include(${CMAKE_CURRENT_SOURCE_DIR}/config.cmake)
  endif()
endif()

plugin_option(USE_CUDA "Build with CUDA" ON)
plugin_option(USE_CUDNN "Build with cuDNN" ON)

#3rdparty libraries
#plugin_option(ABSL_PATH "PATH to ABSL" "3rdparty/absl")

set(DLPLUGIN_LINKER_LIBS "")

# Configure path to modules (for find_package)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake/Modules/")

# PYTHON
if(NOT PYTHON_EXECUTABLE)
    find_package(Python 3.6 EXACT COMPONENTS Interpreter REQUIRED)
    set(PY_EXE ${Python_EXECUTABLE})
else()
    set(PY_EXE ${PYTHON_EXECUTABLE})
endif()
message(STATUS "Using command ${PY_EXE}")

#set(TF_TARGET_LIB "tensorflow")
# Find TF
find_package(Tensorflow "2.5.0" REQUIRED)
if(NOT TENSORFLOW_FOUND)
    return()
endif()
message(STATUS "Tensorflow_CXX11 ${Tensorflow_CXX11}")
message(STATUS "Tensorflow_LIBRARIES ${Tensorflow_LIBRARIES}")
message(STATUS "Tensorflow_COMPILE_FLAGS ${Tensorflow_COMPILE_FLAGS}")

#CUDA CUDNN
include(cmake/Modules/CUDA.cmake)
#find_cuda(${USE_CUDA} ${USE_CUDNN})

# include_directories
include_directories("${PROJECT_SOURCE_DIR}/")
include_directories(SYSTEM ${Tensorflow_INCLUDE_DIRS})
#include_directories(${ABSL_PATH})

# third party
set(ABSL_PROPAGATE_CXX_STD ON)
set(ABSL_ENABLE_INSTALL ON)
add_subdirectory(3rdparty)
#add_subdirectory(3rdparty/absl)
#add_subdirectory(stream_executor)

#file(GLOB_RECURSE dl_plugin_files ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/pluggable_device.cc
#                                  ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/stream_executor_dlgpu.cc
#                                  ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/cuda/cuda_platform.cc
#                                  ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/cuda/cuda_gpu_executor.cc)
file(GLOB_RECURSE dl_plugin_files ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/*.cc)
list(REMOVE_ITEM dl_plugin_files ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/cuda/cudnn_version_test.cc
                                    ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/cuda/redzone_allocator_test.cc
                                    ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/cuda/memcpy_test.cc
                                    ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/cuda/cuda_driver_test.cc)

set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/install)
add_library(dl_plugin ${dl_plugin_files})
set_property(TARGET dl_plugin PROPERTY POSITION_INDEPENDENT_CODE ON)
#set_target_properties(dl_plugin PROPERTIES
#IMPORTED_LOCATION ${CMAKE_INSTALL_PREFIX}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}absl${CMAKE_STATIC_LIBRARY_SUFFIX}
#INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_INSTALL_PREFIX}/include)
## treat warnings as errors
##target_compile_options(dl_plugin PRIVATE -Werror)
target_compile_options(dl_plugin PRIVATE ${Tensorflow_COMPILE_FLAGS})
set(CMAKE_CXX_FLAGS "${Tensorflow_COMPILE_FLAGS} -std=c++14 -fPIC -Wformat -Wformat-security -D_FORTIFY_SOURCE=2 -fstack-protector-strong -std=c++11 -Wall -Wno-comment -Wno-sign-compare -march=native -DNDEBUG")
set(CMAKE_SHARED_LINKER_FLAGS "-Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now")
#
#list(APPEND DLPLUGIN_LINKER_LIBS abslstrings)
#
#add_dependencies(dl_plugin absl)  # externalproject won't download without this
target_link_libraries(dl_plugin absl::base absl::synchronization absl::strings absl::debugging absl::memory absl::str_format_internal)
target_link_libraries(dl_plugin ${Tensorflow_LIBRARIES} ${DLPLUGIN_LINKER_LIBS})
