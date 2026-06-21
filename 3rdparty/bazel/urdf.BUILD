load("@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl", "ros2_cpp_library")

ros2_cpp_library(
    name = "urdf_parser_plugin",
    hdrs = glob(["urdf_parser_plugin/include/**/*.h"]),
    includes = ["urdf_parser_plugin/include"],
    visibility = ["//visibility:public"],
    deps = [
        "@system_libs//:urdfdom_headers",
    ],
)

genrule(
    name = "generate_urdfdom_compatibility",
    srcs = ["urdf/urdfdom_compatibility.h.in"],
    outs = ["urdf/include/urdf/urdfdom_compatibility.h"],
    cmd = "sed -e 's/@URDFDOM_HEADERS_MAJOR_VERSION@/1/g' " +
          "-e 's/@URDFDOM_HEADERS_MINOR_VERSION@/0/g' " +
          "-e 's/@URDFDOM_HEADERS_REVISION_VERSION@/5/g' $< > $@",
)

ros2_cpp_library(
    name = "urdf",
    srcs = ["urdf/src/model.cpp", "urdf/src/urdf_plugin.cpp"],
    hdrs = glob(["urdf/include/**/*.h", "urdf/include/**/*.hpp"]) + ["urdf/include/urdf/urdfdom_compatibility.h"],
    includes = ["urdf/include"],
    visibility = ["//visibility:public"],
    deps = [
        ":urdf_parser_plugin",
        "@system_libs//:urdfdom",
        "@system_libs//:urdfdom_headers",
        "@system_libs//:tinyxml2",
        "@ros2_rcutils//:rcutils",
        "@pluginlib//:pluginlib",
    ],
)
