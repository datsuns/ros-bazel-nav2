load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_library",
)

ros2_cpp_library(
    name = "costmap_queue",
    srcs = [
        "src/costmap_queue.cpp",
        "src/limited_costmap_queue.cpp",
    ],
    hdrs = glob(["include/costmap_queue/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = [
        "@nav2_costmap_2d//:nav2_costmap_2d_core",
        "@ros2_rclcpp//:rclcpp",
    ],
)

