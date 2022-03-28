# Description:
#   CUDA-platform specific StreamExecutor support code.

#load("//tensorflow:tensorflow.bzl", "tf_cc_test", "tf_copts", "tf_cuda_cc_test")
#load("//tensorflow:tensorflow.bzl", "filegroup")
#load(
#    "//tensorflow/stream_executor:build_defs.bzl",
#    "stream_executor_friends",
#    "tf_additional_cuda_driver_deps",
#    "tf_additional_cuda_platform_deps",
#    "tf_additional_cudnn_plugin_copts",
#    "tf_additional_cudnn_plugin_deps",
#)
#load(
#    "//tensorflow/core/platform/default:cuda_build_defs.bzl",
#    "if_cuda_is_configured",
#)
#load(
#    "//tensorflow/core/platform:build_config_root.bzl",
#    "tf_cuda_tests_tags",
#)
#load(
#    "//tensorflow/core/platform:rules_cc.bzl",
#    "cc_library",
#)

load("//tensorflow_plugin:demo_plugin.bzl", "tf_copts")

package(
    default_visibility = ["//visibility:public"],
    licenses = ["notice"],  # Apache 2.0
)

#package_group(
#    name = "friends",
#    packages = stream_executor_friends(),
#)

# Filegroup used to collect source files for the dependency check.
filegroup(
    name = "c_srcs",
    data = glob([
        "**/*.cc",
        "**/*.h",
    ]),
)

cc_library(
    name = "cuda_platform_id",
    srcs = ["cuda_platform_id.cc"],
    hdrs = ["cuda_platform_id.h"],
    deps = [
        "@local_config_gcc//:framework_lib",
        "@local_config_tf//:tf_header_lib",
    ],
)

cc_library(
    name = "cuda_platform",
    srcs = ["cuda_platform.cc"],
    hdrs = ["cuda_platform.h"],
    visibility = ["//visibility:public"],
    deps = [
        ":cuda_driver",
        ":cuda_gpu_executor",
        ":cuda_platform_id",
        "@local_config_gcc//:framework_lib",
        "@local_config_tf//:tf_header_lib",
        "@com_google_absl//absl/base",
        "@com_google_absl//absl/base:core_headers",
        "@com_google_absl//absl/memory",
        "@com_google_absl//absl/strings",
        "@com_google_absl//absl/strings:str_format",
        "@com_google_absl//absl/synchronization",
    ],
    alwayslink = True,  # Registers itself with the MultiPlatformManager.
)

cc_library(
    name = "cuda_diagnostics",
    srcs = ["cuda_diagnostics.cc"],
    hdrs = ["cuda_diagnostics.h"],
    deps = [
        "//tensorflow_plugin/src/stream_executor/gpu:gpu_diagnostics_header",
        "@com_google_absl//absl/container:inlined_vector",
        "@com_google_absl//absl/strings:cord",
        "@local_config_gcc//:framework_lib",
        "@local_config_tf//:tf_header_lib",
    ],
)

cc_library(
    name = "cuda_stub",
    srcs = ["cuda_stub.cc"],
    textual_hdrs = glob(["cuda_*.inc"]),
    deps = [
        "@local_config_cuda//cuda:cuda_headers",
        "@local_config_gcc//:framework_lib",
        "@local_config_tf//:tf_header_lib",
    ],
)

# Buildozer can not remove dependencies inside select guards, so we have to use
# an intermediate target.
cc_library(name = "ptxas_wrapper")

# Buildozer can not remove dependencies inside select guards, so we have to use
# an intermediate target.
cc_library(name = "fatbinary_wrapper")

cc_library(
    name = "cuda_driver",
    srcs = ["cuda_driver.cc"],
    hdrs = ["cuda_driver.h"],
    deps = [
        ":cuda_diagnostics",
        "@com_google_absl//absl/debugging:leak_check",
        "@com_google_absl//absl/base",
        "@com_google_absl//absl/container:inlined_vector",
        "@com_google_absl//absl/strings",
        "@local_config_cuda//cuda:cuda_headers",
        "//tensorflow_plugin/src/stream_executor/gpu:gpu_driver_header",
        "@local_config_gcc//:framework_lib",
        "@local_config_tf//:tf_header_lib",
        ":cudart_stub",
        "@com_google_absl//absl/base:core_headers",
        "@com_google_absl//absl/memory",
        "@com_google_absl//absl/strings:str_format",
        "@com_google_absl//absl/synchronization",
    ],
)

#tf_cuda_cc_test(
#    name = "cuda_driver_test",
#    srcs = ["cuda_driver_test.cc"],
#    tags = tf_cuda_tests_tags() + [
#        "no_cuda_asan",  # TODO(b/171512140): re-enable.
#    ],
#    deps = [
#        "//tensorflow/core:test",
#        "//tensorflow/core:test_main",
#        "//tensorflow/stream_executor/lib",
#        "@local_config_cuda//cuda:cuda_headers",
#    ],
#)

#tf_cuda_cc_test(
#    name = "memcpy_test",
#    srcs = ["memcpy_test.cc"],
#    tags = tf_cuda_tests_tags() + [
#        "no_cuda_asan",  # TODO(b/171512140): re-enable.
#    ],
#    deps = [
#        "//tensorflow/core:test",
#        "//tensorflow/core:test_main",
#        "//tensorflow/stream_executor/lib",
#    ],
#)

cc_library(
    name = "cudart_stub",
    srcs = ["cudart_stub.cc"],
    textual_hdrs = glob(["cuda_runtime_*.inc"]),
    visibility = ["//visibility:public"],
    deps = [
        ":cuda_stub",
        "@local_config_cuda//cuda:cuda_headers",
        "@local_config_gcc//:framework_lib",
        "@local_config_tf//:tf_header_lib",
    ],
)

# The activation library is tightly coupled to the executor library.
# TODO(leary) split up cuda_gpu_executor.cc so that this can stand alone.
cc_library(
    name = "cuda_activation_header",
    hdrs = ["cuda_activation.h"],
    visibility = ["//visibility:public"],
    deps = [
        "//tensorflow_plugin/src/stream_executor/gpu:gpu_activation_header",
        "@local_config_tf//:tf_header_lib",
    ],
)

cc_library(
    name = "cuda_activation",
    srcs = [],
    hdrs = ["cuda_activation.h"],
    deps = [
        ":cuda_driver",
        "@local_config_cuda//cuda:cuda_headers",
        "//tensorflow_plugin/src/stream_executor/gpu:gpu_activation",
    ],
)

cc_library(
    name = "cuda_gpu_executor_header",
    textual_hdrs = ["cuda_gpu_executor.h"],
    visibility = ["//visibility:public"],
    deps = [
        ":cuda_kernel",
        "//tensorflow_plugin/src/stream_executor/gpu:gpu_executor_header",
        "@local_config_tf//:tf_header_lib",
    ],
)

#cc_library(
#    name = "cublas_stub",
#    srcs = if_cuda_is_configured(["cublas_stub.cc"]),
#    textual_hdrs = glob(["cublas_*.inc"]),
#    deps = if_cuda_is_configured([
#        # LINT.IfChange
#        "@local_config_cuda//cuda:cublas_headers",
#        # LINT.ThenChange(//tensorflow/copy.bara.sky:cublas_headers)
#        "@local_config_cuda//cuda:cuda_headers",
#        "//tensorflow/stream_executor/lib",
#        "//tensorflow/stream_executor/platform:dso_loader",
#    ]),
#)

#alias(
#    name = "cublas_lib",
#    actual = select({
#        "//tensorflow:oss": ":cublas_stub",
#        "//conditions:default": "@local_config_cuda//cuda:cublas",
#    }),
#    visibility = ["//visibility:public"],
#)

#cc_library(
#    name = "cublas_lt_stub",
#    srcs = if_cuda_is_configured(["cublasLt_stub.cc"]),
#    textual_hdrs = glob(["cublasLt_*.inc"]),
#    deps = if_cuda_is_configured([
#        # LINT.IfChange
#        "@local_config_cuda//cuda:cublas_headers",
#        # LINT.ThenChange(//tensorflow/copy.bara.sky:cublasLt_headers)
#        "@local_config_cuda//cuda:cuda_headers",
#        "//tensorflow/stream_executor/lib",
#        "//tensorflow/stream_executor/platform:dso_loader",
#    ]),
#)

cc_library(name = "empty_lib")

#alias(
#    name = "cublas_lt_lib",
#    actual = select({
#        "//tensorflow:oss": ":cublas_lt_stub",
#        "//conditions:default": ":empty_lib",
#    }),
#    visibility = ["//visibility:public"],
#)

#cc_library(
#    name = "cublas_plugin",
#    srcs = if_cuda_is_configured(["cuda_blas.cc"]),
#    hdrs = if_cuda_is_configured(["cuda_blas.h"]),
#    visibility = ["//visibility:public"],
#    deps = if_cuda_is_configured([
#        ":cublas_lib",
#        ":cublas_lt_lib",
#        ":cuda_activation",
#        ":cuda_gpu_executor",
#        ":cuda_platform_id",
#        ":cuda_stream",
#        ":cuda_timer",
#        ":cuda_helpers",
#        "@com_google_absl//absl/strings",
#        "//third_party/eigen3",
#        # LINT.IfChange
#        "@local_config_cuda//cuda:cublas_headers",
#        # LINT.ThenChange(//tensorflow/copy.bara.sky:cublas_headers)
#        "@local_config_cuda//cuda:cuda_headers",
#        "//tensorflow/core:lib",
#        "//tensorflow/core:lib_internal",
#        "//tensorflow/core/platform:tensor_float_32_utils",
#        "//tensorflow/stream_executor",
#        "//tensorflow/stream_executor:event",
#        "//tensorflow/stream_executor:host_or_device_scalar",
#        "//tensorflow/stream_executor:plugin_registry",
#        "//tensorflow/stream_executor:scratch_allocator",
#        "//tensorflow/stream_executor:timer",
#        "//tensorflow/stream_executor/gpu:gpu_helpers_header",
#        "//tensorflow/stream_executor/lib",
#        "//tensorflow/stream_executor/platform",
#    ]) + [
#        "@com_google_absl//absl/strings:str_format",
#        "@com_google_absl//absl/synchronization",
#    ],
#    alwayslink = True,
#)

#cc_library(
#    name = "cufft_stub",
#    srcs = if_cuda_is_configured(["cufft_stub.cc"]),
#    textual_hdrs = glob(["cufft_*.inc"]),
#    deps = if_cuda_is_configured([
#        "@local_config_cuda//cuda:cuda_headers",
#        # LINT.IfChange
#        "@local_config_cuda//cuda:cufft_headers",
#        # LINT.ThenChange(//tensorflow/copy.bara.sky:cublas_headers)
#        "//tensorflow/stream_executor/lib",
#        "//tensorflow/stream_executor/platform:dso_loader",
#    ]),
#)
#
#alias(
#    name = "cufft_lib",
#    actual = select({
#        "//tensorflow:oss": ":cufft_stub",
#        "//conditions:default": "@local_config_cuda//cuda:cufft",
#    }),
#    visibility = ["//visibility:public"],
#)
#
#cc_library(
#    name = "cufft_plugin",
#    srcs = if_cuda_is_configured(["cuda_fft.cc"]),
#    hdrs = if_cuda_is_configured(["cuda_fft.h"]),
#    visibility = ["//visibility:public"],
#    deps = if_cuda_is_configured([
#        ":cuda_activation_header",
#        ":cuda_gpu_executor_header",
#        ":cuda_platform_id",
#        ":cuda_stream",
#        ":cuda_helpers",
#        ":cufft_lib",
#        "@local_config_cuda//cuda:cuda_headers",
#        "//tensorflow/stream_executor:event",
#        "//tensorflow/stream_executor:fft",
#        "//tensorflow/stream_executor:plugin_registry",
#        "//tensorflow/stream_executor:scratch_allocator",
#        "//tensorflow/stream_executor/gpu:gpu_helpers_header",
#        "//tensorflow/stream_executor/lib",
#        "//tensorflow/stream_executor/platform",
#        "//tensorflow/stream_executor/platform:dso_loader",
#    ]),
#    alwayslink = True,
#)

cc_library(
    name = "cudnn_stub",
    srcs = ["cudnn_stub.cc"],
    textual_hdrs = glob(["cudnn_*.inc"]),
    deps = [
        "@local_config_cuda//cuda:cudnn_header",
        "@local_config_gcc//:framework_lib",
        "@local_config_tf//:tf_header_lib",
        ":cudnn_version",
    ],
)

alias(
    name = "cudnn_lib",
    actual = ":cudnn_stub",
    visibility = ["//visibility:public"],
)

cc_library(
    name = "cuda_dnn_headers",
    textual_hdrs = ["cuda_dnn.h"],
    deps = [
        ":cuda_activation_header",
    ],
)

cc_library(
    name = "cudnn_plugin",
    srcs = ["cuda_dnn.cc"],
    hdrs = ["cuda_dnn.h"],
#    copts = tf_additional_cudnn_plugin_copts(),
    visibility = ["//visibility:public"],
    deps = [
        ":cuda_activation",
        ":cuda_diagnostics",
        ":cuda_driver",
        ":cuda_gpu_executor",
        ":cuda_platform_id",
        ":cuda_stream",
        ":cuda_timer",
        ":cudnn_version",
        ":cudnn_lib",
        "@com_google_absl//absl/memory",
        "@com_google_absl//absl/strings",
        "//third_party/eigen3",
        "@local_config_cuda//cuda:cuda_headers",
        "@local_config_cuda//cuda:cudnn_header",
        # copybara:comment_begin(OSS only)
        "@cudnn_frontend_archive//:cudnn_frontend",
        # copybara:comment_end
        "@local_config_gcc//:framework_lib",
        "@local_config_tf//:tf_header_lib",
        "@com_google_absl//absl/synchronization",
    ],
    alwayslink = True,
)

#cc_library(
#    name = "curand_stub",
#    srcs = if_cuda_is_configured(["curand_stub.cc"]),
#    textual_hdrs = ["curand_10_0.inc"],
#    deps = if_cuda_is_configured([
#        "@local_config_cuda//cuda:cuda_headers",
#        # LINT.IfChange
#        "@local_config_cuda//cuda:curand_headers",
#        # LINT.ThenChange(//tensorflow/copy.bara.sky:cublas_headers)
#        "//tensorflow/stream_executor/lib",
#        "//tensorflow/stream_executor/platform:dso_loader",
#    ]),
#)
#
#alias(
#    name = "curand_lib",
#    actual = select({
#        "//tensorflow:oss": ":curand_stub",
#        "//conditions:default": "@local_config_cuda//cuda:curand",
#    }),
#    visibility = ["//visibility:public"],
#)
#
#cc_library(
#    name = "curand_plugin",
#    srcs = if_cuda_is_configured(["cuda_rng.cc"]),
#    hdrs = if_cuda_is_configured(["cuda_rng.h"]),
#    deps = if_cuda_is_configured([
#        ":cuda_activation",
#        ":cuda_gpu_executor",
#        ":cuda_platform_id",
#        ":cuda_stream",
#        ":cuda_helpers",
#        ":curand_lib",
#        "@local_config_cuda//cuda:cuda_headers",
#        "//tensorflow/stream_executor:event",
#        "//tensorflow/stream_executor:plugin_registry",
#        "//tensorflow/stream_executor:rng",
#        "//tensorflow/stream_executor/gpu:gpu_helpers_header",
#        "//tensorflow/stream_executor/gpu:gpu_rng_header",
#        "//tensorflow/stream_executor/lib",
#        "//tensorflow/stream_executor/platform",
#        "//tensorflow/stream_executor/platform:dso_loader",
#    ]),
#    alwayslink = True,
#)
#
#cc_library(
#    name = "cupti_stub",
#    srcs = if_cuda_is_configured(["cupti_stub.cc"]),
#    data = if_cuda_is_configured(["@local_config_cuda//cuda:cupti_dsos"]),
#    textual_hdrs = ["cupti_10_0.inc"],
#    deps = if_cuda_is_configured([
#        "@local_config_cuda//cuda:cuda_headers",
#        "@local_config_cuda//cuda:cupti_headers",
#        "//tensorflow/stream_executor/lib",
#        "//tensorflow/stream_executor/platform:dso_loader",
#    ]),
#)

#cc_library(
#    name = "cusolver_stub",
#    srcs = if_cuda_is_configured(["cusolver_stub.cc"]),
#    textual_hdrs = glob(["cusolver_dense_*.inc"]),
#    deps = if_cuda_is_configured([
#        # LINT.IfChange
#        "@local_config_cuda//cuda:cublas_headers",
#        "@local_config_cuda//cuda:cusolver_headers",
#        # LINT.ThenChange(//tensorflow/copy.bara.sky:cublas_headers)
#        "@local_config_cuda//cuda:cuda_headers",
#        "//tensorflow/stream_executor/lib",
#        "//tensorflow/stream_executor/platform:dso_loader",
#    ]),
#)
#
#alias(
#    name = "cusolver_lib",
#    actual = select({
#        "//tensorflow:oss": ":cusolver_stub",
#        "//conditions:default": "@local_config_cuda//cuda:cusolver",
#    }),
#    visibility = ["//visibility:public"],
#)
#
#cc_library(
#    name = "cusparse_stub",
#    srcs = if_cuda_is_configured(["cusparse_stub.cc"]),
#    textual_hdrs = glob(["cusparse_*.inc"]),
#    deps = if_cuda_is_configured([
#        "@local_config_cuda//cuda:cuda_headers",
#        # LINT.IfChange
#        "@local_config_cuda//cuda:cusparse_headers",
#        # LINT.ThenChange(//tensorflow/copy.bara.sky:cublas_headers)
#        "//tensorflow/stream_executor/lib",
#        "//tensorflow/stream_executor/platform:dso_loader",
#    ]),
#)
#
#alias(
#    name = "cusparse_lib",
#    actual = select({
#        "//tensorflow:oss": ":cusparse_stub",
#        "//conditions:default": "@local_config_cuda//cuda:cusparse",
#    }),
#    visibility = ["//visibility:public"],
#)

cc_library(
    name = "cuda_kernel",
    srcs = ["cuda_kernel.cc"],
    hdrs = ["cuda_kernel.h"],
    deps = [
        ":cuda_driver",
        "@local_config_cuda//cuda:cuda_headers",
        "//tensorflow_plugin/src/stream_executor/gpu:gpu_kernel_header",
        "@com_google_absl//absl/strings:cord",
        "@local_config_gcc//:framework_lib",
        "@local_config_tf//:tf_header_lib",
    ],
)

# TODO(leary) we likely need to canonicalize/eliminate this.
cc_library(
    name = "cuda_helpers",
    textual_hdrs = ["cuda_helpers.h"],
    deps = [
        "//tensorflow_plugin/src/stream_executor/gpu:gpu_helpers_header",
    ],
)

cc_library(
    name = "cuda_event",
    srcs = ["cuda_event.cc"],
    hdrs = ["cuda_event.h"],
    deps = [
        ":cuda_driver",
        ":cuda_gpu_executor_header",
        ":cuda_stream",
        "//tensorflow_plugin/src/stream_executor/gpu:gpu_event",
        "//tensorflow_plugin/src/stream_executor/gpu:gpu_stream_header",
        "@local_config_gcc//:framework_lib",
        "@local_config_tf//:tf_header_lib",
    ],
)

cc_library(
    name = "cuda_stream",
    srcs = [],
    hdrs = ["cuda_stream.h"],
    deps = [
        ":cuda_driver",
        ":cuda_gpu_executor_header",
        "//tensorflow_plugin/src/stream_executor/gpu:gpu_stream",
        "@local_config_tf//:tf_header_lib",
    ],
)

cc_library(
    name = "cuda_timer",
    srcs = [],
    hdrs = ["cuda_timer.h"],
    deps = [
        ":cuda_driver",
        ":cuda_gpu_executor_header",
        ":cuda_stream",
        "//tensorflow_plugin/src/stream_executor/gpu:gpu_timer",
        "@local_config_tf//:tf_header_lib",
    ],
)

cc_library(
    name = "cuda_asm_compiler",
    srcs = ["cuda_asm_compiler.cc"],
    deps = [
        "//tensorflow_plugin/src/stream_executor/gpu:asm_compiler",
        "//tensorflow_plugin/src/stream_executor/gpu:gpu_driver_header",
        "@local_config_gcc//:framework_lib",
        "@local_config_tf//:tf_header_lib",
    ],
)

cc_library(
    name = "cuda_gpu_executor",
    srcs = ["cuda_gpu_executor.cc"],
    hdrs = ["cuda_gpu_executor.h"],
    deps = [
        ":cuda_activation",
        ":cuda_diagnostics",
        ":cuda_driver",
        ":cuda_event",
        ":cuda_kernel",
        ":cuda_platform_id",
        ":cuda_stream",
        ":cuda_timer",
        ":cuda_asm_compiler",
        "@com_google_absl//absl/strings",
        "//tensorflow_plugin/src/stream_executor/gpu:gpu_executor_header",
        "@com_google_absl//absl/strings:str_format",
        "@local_config_gcc//:framework_lib",
        "@local_config_tf//:tf_header_lib",
    ],
    alwayslink = True,
)

cc_library(
    name = "cudnn_version",
    srcs = ["cudnn_version.cc"],
    hdrs = ["cudnn_version.h"],
    deps = [
        "@com_google_absl//absl/strings",
    ],
)

#tf_cc_test(
#    name = "cudnn_version_test",
#    srcs = ["cudnn_version_test.cc"],
#    deps = [
#        ":cudnn_version",
#        "//tensorflow/core:test",
#        "//tensorflow/core:test_main",
#    ],
#)

cc_library(
    name = "all_runtime",
    copts = tf_copts(),
    visibility = ["//visibility:public"],
    deps = [
#        ":cublas_plugin",
        ":cuda_driver",
        ":cuda_platform",
        ":cudnn_plugin",
#        ":cufft_plugin",
#        ":curand_plugin",
    ],
    alwayslink = 1,
)

#tf_cuda_cc_test(
#    name = "redzone_allocator_test",
#    srcs = ["redzone_allocator_test.cc"],
#    tags = tf_cuda_tests_tags() + [
#        "no_cuda_asan",  # TODO(b/171512140): re-enable.
#    ],
#    deps = [
#        ":cuda_activation",
#        ":cuda_gpu_executor",
#        "//tensorflow/core:test",
#        "//tensorflow/core:test_main",
#        "//tensorflow/core/platform:stream_executor_no_cuda",
#        "//tensorflow/core/platform/default/build_config:stream_executor_cuda",
#        "//tensorflow/stream_executor:device_memory_allocator",
#        "//tensorflow/stream_executor:event",
#        "//tensorflow/stream_executor:kernel",
#        "//tensorflow/stream_executor/gpu:gpu_asm_opts",
#        "//tensorflow/stream_executor/gpu:redzone_allocator",
#    ],
#)
