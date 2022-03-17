cmake_minimum_required(VERSION 3.12.4)

project(dl_plugin)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

option(BUILD_SHARED_LIBS "Build using shared libraries" ON)

include(cmake/utils/Utils.cmake)

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

#CUDA CUDNN
include(cmake/utils/FindCUDA.cmake)
SET(USE_CUDA ON)
SET(USE_CUDNN ON)
include(cmake/Modules/CUDA.cmake)
#find_cuda(${USE_CUDA} ${USE_CUDNN})

include_directories(SYSTEM ${Tensorflow_INCLUDE_DIRS})
include_directories("${PROJECT_SOURCE_DIR}/")
file(GLOB_RECURSE dl_plugin_files ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/pluggable_device.cc
                                  ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/stream_executor_dlgpu.cc
                                  ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/cuda/cuda_platform.cc
                                  ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/cuda/cuda_gpu_executor.cc)
#file(GLOB_RECURSE dl_plugin_files ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/*.cc)
#list(REMOVE_ITEM dl_plugin_files ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/cuda/cudnn_version_test.cc
#                                    ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/cuda/redzone_allocator_test.cc
#                                    ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/cuda/memcpy_test.cc
#                                    ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/cuda/cuda_driver_test.cc)

add_library(dl_plugin ${dl_plugin_files})

# treat warnings as errors
#target_compile_options(dl_plugin PRIVATE -Werror)
target_compile_options(dl_plugin PRIVATE ${Tensorflow_COMPILE_FLAGS})

target_link_libraries(dl_plugin ${Tensorflow_LIBRARIES})
