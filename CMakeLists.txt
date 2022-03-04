cmake_minimum_required(VERSION 3.12.4)

project(dl_plugin)

# PYTHON
if(NOT PYTHON_EXECUTABLE)
    find_package(Python 3.6 COMPONENTS Interpreter REQUIRED)
    set(PY_EXE ${Python_EXECUTABLE})
else()
    set(PY_EXE ${PYTHON_EXECUTABLE})
endif()
message(STATUS "Using command ${PY_EXE}")

execute_process(COMMAND ${PY_EXE} -c "import tensorflow as tf; print(\" \".join(tf.sysconfig.get_compile_flags()))"
                OUTPUT_VARIABLE TF_CFLAGS)

execute_process(COMMAND ${PY_EXE} -c "import tensorflow as tf; print(\" \".join(tf.sysconfig.get_link_flags()))"
                OUTPUT_VARIABLE TF_LDFLAGS)

if(NOT TF_CFLAGS)
  message(WARNING "tensorflow package not found")
  message(WARNING "Please make sure 'tensorflow' installed in your python environment")
  message(WARNING "dl_plugin disabled")
  return()
endif()

