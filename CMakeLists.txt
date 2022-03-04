cmake_minimum_required(VERSION 3.12.4)

project(dl_plugin)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

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

set(TF_TARGET_LIB "tensorflow")
# Find TF
find_package(Tensorflow "2.5.0" REQUIRED)
if(NOT TENSORFLOW_FOUND)
    return()
endif()

include_directories(SYSTEM ${Tensorflow_INCLUDE_DIRS})
file(GLOB_RECURSE dl_plugin_files ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/*.cc)
add_library(dl_plugin SHARED ${dl_plugin_files})

target_link_libraries(dl_plugin ${TF_LDFLAGS})
