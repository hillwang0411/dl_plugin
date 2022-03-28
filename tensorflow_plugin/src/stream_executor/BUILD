# GPU executor library for data-parallel kernel launches and cross-platform
# HPC-library APIs.
#
# Throughout this file, all targets are built with the standard crosstool and
# do not link against restricted binary blobs.

cc_library(
    name = "stream_executor_dlgpu",
    srcs = ["stream_executor_dlgpu.cc"],
    hdrs = ["stream_executor_dlgpu.h"],
    visibility = ["//visibility:public"],
    deps = [
        "//tensorflow_plugin/src/stream_executor/cuda:cuda_platform",
        "//tensorflow_plugin/src/stream_executor/gpu:gpu_stream",
        "//tensorflow_plugin/src/stream_executor/gpu:gpu_timer",
        "//tensorflow_plugin/src/stream_executor/gpu:gpu_event",
        "//tensorflow_plugin/src/stream_executor/gpu:gpu_activation",
        "@local_config_gcc//:framework_lib",
        "@local_config_tf//:tf_header_lib",
    ],
    alwayslink = True,  # Registers itself with the MultiPlatformManager.
)

