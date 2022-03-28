workspace(name = "org_tensorflow_plugin")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("//third_party:version_check.bzl", "check_bazel_version_at_least")

check_bazel_version_at_least("3.1.0")

load("//tensorflow_plugin:tf_configure.bzl", "tf_configure")

tf_configure(name = "local_config_tf")

load("//tensorflow_plugin:workspace.bzl", "clean_dep", "demo_plugin_workspace")

demo_plugin_workspace()

load(
    "@bazel_toolchains//repositories:repositories.bzl",
    bazel_toolchains_repositories = "repositories",
)

bazel_toolchains_repositories()

load("//third_party/gpus:cuda_configure.bzl", "cuda_configure")
cuda_configure(name = "local_config_cuda")
