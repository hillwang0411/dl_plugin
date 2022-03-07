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
file(GLOB_RECURSE dl_plugin_files ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/*.cc)
add_library(dl_plugin ${dl_plugin_files})

target_link_libraries(dl_plugin ${Tensorflow_LIBRARIES})
