load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_binary",
    "ros2_cpp_library",
)

COMMON_DEPS = [
    "@ros2_common_interfaces//:cpp_geometry_msgs",
    "@map_server_workspace//:nav2_util",
    "@ros2_rclcpp//:rclcpp",
    "@ros2_rclcpp//:rclcpp_components",
]

# 1. velocity_smoother_core
ros2_cpp_library(
    name = "velocity_smoother_core",
    srcs = ["src/velocity_smoother.cpp"],
    hdrs = glob(["include/nav2_velocity_smoother/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS,
)

# 2. Executable
ros2_cpp_binary(
    name = "velocity_smoother",
    srcs = ["src/main.cpp"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS + [
        ":velocity_smoother_core",
    ],
)
