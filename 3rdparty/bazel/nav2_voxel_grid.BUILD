load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_library",
)

ros2_cpp_library(
    name = "voxel_grid",
    srcs = ["src/voxel_grid.cpp"],
    hdrs = glob(["include/nav2_voxel_grid/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = [
        "@ros2_rclcpp//:rclcpp",
    ],
)
