file(GLOB_RECURSE stream_executor_files ${CMAKE_CURRENT_SOURCE_DIR}/pluggable_device.cc
                                  ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor_dlgpu.cc
                                  ${CMAKE_CURRENT_SOURCE_DIR}/cuda/cuda_platform.cc
                                  ${CMAKE_CURRENT_SOURCE_DIR}/cuda/cuda_gpu_executor.cc)
#file(GLOB_RECURSE stream_executor_files ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/*.cc)
#list(REMOVE_ITEM stream_executor_files ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/cuda/cudnn_version_test.cc
#                                    ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/cuda/redzone_allocator_test.cc
#                                    ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/cuda/memcpy_test.cc
#                                    ${CMAKE_CURRENT_SOURCE_DIR}/stream_executor/cuda/cuda_driver_test.cc)

#add_library(stream_executor ${stream_executor_files})

# treat warnings as errors
#target_compile_options(stream_executor PRIVATE -Werror)
#target_compile_options(stream_executor PRIVATE ${Terflow_COMPILE_FLAGS})

#list(APPEND DLPLUGIN_LINKER_LIBS abslstrings)
message(STATUS ${ABSL_INTERNAL_DLL_TARGETS})
#list(APPEND DLPLUGIN_LINKER_LIBS ${ABSL_INTERNAL_DLL_TARGETS})

# TODO:fix me, this is not a good way.
message(STATUS ${CMAKE_BINARY_DIR})
link_directories(${CMAKE_BINARY_DIR}/3rdparty/absl/absl/types)
link_directories(${CMAKE_BINARY_DIR}/3rdparty/absl/absl/debugging)
link_directories(${CMAKE_BINARY_DIR}/3rdparty/absl/absl/synchronization)
link_directories(${CMAKE_BINARY_DIR}/3rdparty/absl/absl/random)
link_directories(${CMAKE_BINARY_DIR}/3rdparty/absl/absl/base)
link_directories(${CMAKE_BINARY_DIR}/3rdparty/absl/absl/status)
link_directories(${CMAKE_BINARY_DIR}/3rdparty/absl/absl/flags)
link_directories(${CMAKE_BINARY_DIR}/3rdparty/absl/absl/time)
link_directories(${CMAKE_BINARY_DIR}/3rdparty/absl/absl/numeric)
link_directories(${CMAKE_BINARY_DIR}/3rdparty/absl/absl/strings)
link_directories(${CMAKE_BINARY_DIR}/3rdparty/absl/absl/hash)
link_directories(${CMAKE_BINARY_DIR}/3rdparty/absl/absl/container)
add_library(stream_executor ${stream_executor_files})
target_compile_options(stream_executor PRIVATE ${Terflow_COMPILE_FLAGS})
list(APPEND DLPLUGIN_LINKER_LIBS absl_bad_optional_access
                                 absl_bad_variant_access
                                 absl_bad_any_cast_impl
                                 absl_leak_check_disable
                                 absl_demangle_internal
                                 absl_stacktrace
                                 absl_debugging_internal
                                 absl_symbolize
                                 absl_failure_signal_handler
                                 absl_examine_stack
                                 absl_leak_check
                                 absl_synchronization
                                 absl_graphcycles_internal
                                 absl_random_internal_randen
                                 absl_random_internal_randen_hwaes
                                 absl_random_internal_randen_slow
                                 absl_random_internal_pool_urbg
                                 absl_random_seed_gen_exception
                                 absl_random_internal_distribution_test_util
                                 absl_random_distributions
                                 absl_random_internal_randen_hwaes_impl
                                 absl_random_seed_sequences
                                 absl_random_internal_seed_material
                                 absl_random_internal_platform
                                 absl_malloc_internal
                                 absl_raw_logging_internal
                                 absl_spinlock_wait
                                 absl_throw_delegate
                                 absl_exponential_biased
                                 absl_base
                                 absl_scoped_set_env
                                 absl_log_severity
                                 absl_periodic_sampler
                                 absl_strerror
                                 absl_status
                                 absl_statusor
                                 absl_flags_config
                                 absl_flags_usage_internal
                                 absl_flags_commandlineflag_internal
                                 absl_flags_commandlineflag
                                 absl_flags_reflection
                                 absl_flags_parse
                                 absl_flags_private_handle_accessor
                                 absl_flags_program_name
                                 absl_flags_marshalling
                                 absl_flags_usage
                                 absl_flags_internal
                                 absl_flags
                                 absl_time_zone
                                 absl_civil_time
                                 absl_time
                                 absl_int128
                                 absl_cord
                                 absl_strings_internal
                                 absl_str_format_internal
                                 absl_strings
                                 absl_city
                                 absl_hash
                                 absl_raw_hash_set
                                 absl_hashtablez_sampler)
                             #target_link_libraries(stream_executor ${Terflow_LIBRARIES} ${DLPLUGIN_LINKER_LIBS})
target_link_libraries(stream_executor ${DLPLUGIN_LINKER_LIBS} ${Terflow_LIBRARIES})
