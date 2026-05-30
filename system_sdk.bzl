def _system_sdk_repo_impl(repository_ctx):
    repository_ctx.symlink("/usr/include/GraphicsMagick", "graphicsmagick_include")
    repository_ctx.symlink("/usr/lib/x86_64-linux-gnu", "lib_x86_64")
    repository_ctx.symlink("/usr/lib", "lib")
    repository_ctx.symlink("/usr/include/eigen3", "eigen3_include")
    repository_ctx.symlink("/usr/include/opencv4", "opencv4_include")
    repository_ctx.symlink("/usr/include/ceres", "ceres_include")
    repository_ctx.symlink("/usr/include/xtensor", "xtensor_include")
    repository_ctx.symlink("/usr/include/xsimd", "xsimd_include")
    repository_ctx.symlink("/usr/include/xtl", "xtl_include")
    repository_ctx.symlink("/usr/include/boost", "boost_include/boost")
    
    repository_ctx.file("BUILD.bazel", """
package(default_visibility = ["//visibility:public"])

cc_library(
    name = "boost",
    hdrs = glob(["boost_include/boost/**/*"]),
    includes = ["boost_include"],
    linkopts = [
        "-lboost_system",
        "-lboost_coroutine",
        "-lboost_context",
        "-lboost_thread",
        "-lboost_chrono",
        "-lboost_atomic",
    ],
)

cc_library(
    name = "graphicsmagick",
    hdrs = [],
    includes = ["graphicsmagick_include"],
    srcs = ["lib/libGraphicsMagick++.so", "lib/libGraphicsMagick.so"],
)

cc_library(
    name = "yaml-cpp",
    srcs = ["lib_x86_64/libyaml-cpp.so"],
)

cc_library(
    name = "eigen",
    hdrs = glob(["eigen3_include/**/*"]),
    includes = ["eigen3_include"],
)

cc_library(
    name = "opencv",
    hdrs = glob(["opencv4_include/**/*"]),
    includes = ["opencv4_include"],
    linkopts = [
        "-lopencv_core",
        "-lopencv_imgproc",
        "-lopencv_imgcodecs",
        "-lopencv_highgui",
    ],
)

cc_library(
    name = "ceres",
    hdrs = glob(["ceres_include/**/*"]),
    includes = ["ceres_include"],
    srcs = ["lib/libceres.so"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "xtl",
    hdrs = glob(["xtl_include/**/*"]),
    includes = ["xtl_include"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "xsimd",
    hdrs = glob(["xsimd_include/**/*"]),
    includes = ["xsimd_include"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "xtensor",
    hdrs = glob(["xtensor_include/**/*"]),
    includes = ["xtensor_include"],
    visibility = ["//visibility:public"],
    deps = [
        ":xtl",
        ":xsimd",
    ],
)
""")

system_sdk_repo = repository_rule(
    implementation = _system_sdk_repo_impl,
)

