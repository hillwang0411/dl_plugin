# Description:
#   GPU-platform specific StreamExecutor support code.

#load("//tensorflow:tensorflow.bzl", "filegroup")
#load(
#    "//tensorflow/core/platform/default:cuda_build_defs.bzl",
#    "if_cuda_is_configured",
#)
#load("//tensorflow:tensorflow.bzl", "if_libtpu", "tf_copts")
#load("@local_config_rocm//rocm:build_defs.bzl", "if_rocm_is_configured")
#load(
#    "//tensorflow/core/platform:rules_cc.bzl",
#    "cc_library",
#)

load("//tensorflow_plugin:demo_plugin.bzl", "tf_copts")

package(
    default_visibility = [
        "//visibility:public",
    ],
    licenses = ["notice"],  # Apache 2.0
)

# Filegroup used to collect source files for the dependency check.
#filegroup(
#    name = "c_srcs",
#    data = glob([
#        "**/*.cc",
#        "**/*.h",
#    ]),
#)

cc_library(
    name = "gpu_activation_header",
    hdrs = ["gpu_activation.h"],
#    deps = ["//tensorflow/stream_executor/platform"],
    deps = ["@local_config_tf//:tf_header_lib"],
)

cc_library(
    name = "gpu_activation",
    srcs = ["gpu_activation.cc"],
    hdrs = ["gpu_activation.h"],
    deps = [
        ":gpu_executor_header",
        ":gpu_activation_header",
        ":gpu_driver_header",
        "@local_config_gcc//:framework_lib",
    ],
)

cc_library(
    name = "gpu_diagnostics_header",
    hdrs = ["gpu_diagnostics.h"],
    deps = [
        "@com_google_absl//absl/strings",
        "@com_google_absl//absl/strings:str_format",
        "@local_config_tf//:tf_header_lib",
    ],
)

cc_library(
    name = "gpu_driver_header",
    hdrs = ["gpu_driver.h"],
    deps = [
        ":gpu_types_header",
        "@local_config_tf//:tf_header_lib",
        "@local_config_cuda//cuda:cuda_headers"
    ],
)

cc_library(
    name = "gpu_event_header",
    hdrs = ["gpu_event.h"],
    deps = [
        ":gpu_driver_header",
        ":gpu_stream_header",
        "@local_config_tf//:tf_header_lib",
        "@com_google_absl//absl/base:core_headers",
        "@com_google_absl//absl/memory",
        "@com_google_absl//absl/strings",
        "@com_google_absl//absl/synchronization",
        "@com_google_absl//absl/types:optional",
        "@com_google_absl//absl/types:span",
    ],
)

cc_library(
    name = "gpu_event",
    srcs = ["gpu_event.cc"],
    hdrs = ["gpu_event.h"],
    deps = [
        ":gpu_driver_header",
        ":gpu_executor_header",
        ":gpu_stream",
        "@local_config_tf//:tf_header_lib",
        "@local_config_gcc//:framework_lib",
    ],
)

cc_library(
    name = "gpu_executor_header",
    hdrs = ["gpu_executor.h"],
    deps = [
        ":gpu_kernel_header",
        "@com_google_absl//absl/strings",
        "@com_google_absl//absl/synchronization",
        "@com_google_absl//absl/strings:str_format",
        "@com_google_absl//absl/types:span",
        "@com_google_absl//absl/container:flat_hash_map",
        "@com_google_absl//absl/container:flat_hash_set",
    ],
)

#cc_library(
#    name = "gpu_helpers_header",
#    hdrs = ["gpu_helpers.h"],
#    deps = [
#        ":gpu_types_header",
#        "@local_config_tf//:tf_header_lib",
#    ],
#)

cc_library(
    name = "gpu_kernel_header",
    hdrs = ["gpu_kernel.h"],
    deps = [
        ":gpu_driver_header",
        "@com_google_absl//absl/strings",
        "@com_google_absl//absl/strings:str_format",
        "@local_config_tf//:tf_header_lib",
    ],
)

cc_library(
    name = "gpu_stream_header",
    hdrs = ["gpu_stream.h"],
    deps = [
        ":gpu_driver_header",
        "@local_config_tf//:tf_header_lib",
    ],
)

cc_library(
    name = "gpu_stream",
    srcs = ["gpu_stream.cc"],
    hdrs = ["gpu_stream.h"],
    deps = [
        ":gpu_driver_header",
        ":gpu_executor_header",
        "@local_config_tf//:tf_header_lib",
        "@local_config_cuda//cuda:cuda_headers"
    ],
)

cc_library(
    name = "gpu_timer_header",
    hdrs = ["gpu_timer.h"],
    deps = [
        ":gpu_driver_header",
        ":gpu_executor_header",
        "@local_config_tf//:tf_header_lib",
    ],
)

cc_library(
    name = "gpu_timer",
    srcs = ["gpu_timer.cc"],
    hdrs = ["gpu_timer.h"],
    deps = [
        ":gpu_driver_header",
        ":gpu_executor_header",
        ":gpu_stream",
        "@local_config_tf//:tf_header_lib",
        "@local_config_gcc//:framework_lib",
    ],
)

cc_library(
    name = "gpu_types_header",
    hdrs = ["gpu_types.h"],
    deps = [
        "@local_config_tf//:tf_header_lib",
        "@local_config_cuda//cuda:cuda_headers",
    ],
)

cc_library(
    name = "gpu_asm_opts",
    hdrs = ["gpu_asm_opts.h"],
    visibility = [
        "//visibility:public",
    ],
    deps = [
        "@com_google_absl//absl/strings",
        "@com_google_absl//absl/types:span",
    ],
)

cc_library(
    name = "asm_compiler",
    srcs = ["asm_compiler.cc"],
    hdrs = ["asm_compiler.h"],
    copts = tf_copts(),
    visibility = [
        "//visibility:public",
    ],
    deps = [
        ":gpu_asm_opts",
        ":gpu_driver_header",
#        ":gpu_helpers_header",
        "@com_google_absl//absl/strings:str_format",
        "@com_google_absl//absl/synchronization",
        "@com_google_absl//absl/types:span",
        "@com_google_absl//absl/container:flat_hash_map",
        "@com_google_absl//absl/container:flat_hash_set",
        "@local_config_tf//:tf_header_lib",
        "@local_config_gcc//:framework_lib",
    ],
)

cc_library(
    name = "redzone_allocator",
    srcs = ["redzone_allocator.cc"],
    hdrs = ["redzone_allocator.h"],
    copts = tf_copts(),
    visibility = [
        "//visibility:public",
    ],
    deps = [
        ":asm_compiler",
        ":gpu_asm_opts",
        "@com_google_absl//absl/base",
        "@com_google_absl//absl/container:fixed_array",
        "@com_google_absl//absl/strings:str_format",
        "@com_google_absl//absl/types:optional",
        "@local_config_tf//:tf_header_lib",
        "@local_config_gcc//:framework_lib",
    ],
)
