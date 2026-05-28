def _system_sdk_repo_impl(repository_ctx):
    repository_ctx.symlink("/usr/include/GraphicsMagick", "graphicsmagick_include")
    repository_ctx.symlink("/opt/ros/humble/include/bondcpp", "bondcpp_include")
    repository_ctx.symlink("/opt/ros/humble/include/bond", "bond_include")
    repository_ctx.symlink("/opt/ros/humble/include/smclib", "smclib_include")
    repository_ctx.symlink("/opt/ros/humble/lib", "ros_lib")
    repository_ctx.symlink("/usr/lib/x86_64-linux-gnu", "lib_x86_64")
    repository_ctx.symlink("/usr/lib", "lib")
    
    repository_ctx.file("BUILD.bazel", """
package(default_visibility = ["//visibility:public"])

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
    name = "bondcpp",
    hdrs = [],
    includes = [
        "bondcpp_include", 
        "bond_include",
        "smclib_include",
    ],
    srcs = [
        "ros_lib/libbondcpp.so",
    ] + glob(["ros_lib/libbond__*.so"]),
)
""")

system_sdk_repo = repository_rule(
    implementation = _system_sdk_repo_impl,
)
