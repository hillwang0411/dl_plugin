load("//third_party:repo.bzl", "tf_http_archive", "third_party_http_archive")
load("//third_party/build_option:gcc_configure.bzl", "gcc_configure")
load("//third_party/systemlibs:syslibs_configure.bzl", "syslibs_configure")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//third_party/absl:workspace.bzl", absl = "repo")

def clean_dep(dep):
    return str(Label(dep))

def demo_plugin_workspace(path_prefix = "", tf_repo_name = ""):
    """All external dependencies for TF builds"""
    gcc_configure(name = "local_config_gcc")
    syslibs_configure(name = "local_config_syslibs")

    http_archive(
        name = "bazel_toolchains",
        sha256 = "109a99384f9d08f9e75136d218ebaebc68cc810c56897aea2224c57932052d30",
        strip_prefix = "bazel-toolchains-94d31935a2c94fe7e7c7379a0f3393e181928ff7",
        urls = [
            "http://mirror.tensorflow.org/github.com/bazelbuild/bazel-toolchains/archive/94d31935a2c94fe7e7c7379a0f3393e181928ff7.tar.gz",
            "https://github.com/bazelbuild/bazel-toolchains/archive/94d31935a2c94fe7e7c7379a0f3393e181928ff7.tar.gz",
        ],
    )

    tf_http_archive(
        name = "eigen_archive",
        build_file = clean_dep("//third_party:eigen.BUILD"),
        sha256 = "df23a89e4cdfa7de2d81ee28190bd194413e47ff177c94076f845b32d7280344",  # SHARED_EIGEN_SHA
        strip_prefix = "eigen-5dc2fbabeee17fe023c38756ebde0c1d56472913",
        urls = [
            "https://storage.googleapis.com/mirror.tensorflow.org/gitlab.com/libeigen/eigen/-/archive/5dc2fbabeee17fe023c38756ebde0c1d56472913/eigen-5dc2fbabeee17fe023c38756ebde0c1d56472913.tar.gz",
            "https://gitlab.com/libeigen/eigen/-/archive/5dc2fbabeee17fe023c38756ebde0c1d56472913/eigen-5dc2fbabeee17fe023c38756ebde0c1d56472913.tar.gz",
        ],
    )

#    third_party_http_archive(
#        name = "com_google_absl",
#        build_file = clean_dep("//third_party:com_google_absl.BUILD"),
#        sha256 = "62c27e7a633e965a2f40ff16b487c3b778eae440bab64cad83b34ef1cbe3aa93",
#        strip_prefix = "abseil-cpp-6f9d96a1f41439ac172ee2ef7ccd8edf0e5d068c",
#        urls = [
#            "http://mirror.tensorflow.org/github.com/abseil/abseil-cpp/archive/6f9d96a1f41439ac172ee2ef7ccd8edf0e5d068c.tar.gz",
#            "https://github.com/abseil/abseil-cpp/archive/6f9d96a1f41439ac172ee2ef7ccd8edf0e5d068c.tar.gz",
#        ],
#    )

    absl()

    tf_http_archive(
        name = "zlib",
        build_file = clean_dep("//third_party:zlib.BUILD"),
        sha256 = "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1",
        strip_prefix = "zlib-1.2.11",
        system_build_file = clean_dep("//third_party/systemlibs:zlib.BUILD"),
        urls = [
            "https://storage.googleapis.com/mirror.tensorflow.org/zlib.net/zlib-1.2.11.tar.gz",
            "https://zlib.net/zlib-1.2.11.tar.gz",
        ],
    )

    tf_http_archive(
        name = "com_google_protobuf",
        patch_file = clean_dep("//third_party/protobuf:protobuf.patch"),
        sha256 = "cfcba2df10feec52a84208693937c17a4b5df7775e1635c1e3baffc487b24c9b",
        strip_prefix = "protobuf-3.9.2",
        system_build_file = clean_dep("//third_party/systemlibs:protobuf.BUILD"),
        system_link_files = {
            "//third_party/systemlibs:protobuf.bzl": "protobuf.bzl",
        },
        urls = [
            "https://storage.googleapis.com/mirror.tensorflow.org/github.com/protocolbuffers/protobuf/archive/v3.9.2.zip",
            "https://github.com/protocolbuffers/protobuf/archive/v3.9.2.zip",
        ],
    )
    # https://github.com/bazelbuild/bazel-skylib/releases
    tf_http_archive(
        name = "bazel_skylib",
        sha256 = "1c531376ac7e5a180e0237938a2536de0c54d93f5c278634818e0efc952dd56c",
        urls = [
            "https://storage.googleapis.com/mirror.tensorflow.org/github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
        ],
    )

