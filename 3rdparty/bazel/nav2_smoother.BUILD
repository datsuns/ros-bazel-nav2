load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_binary",
    "ros2_cpp_library",
)

COMMON_DEPS = [
    "@system_libs//:angles",
    "@ros2_rclcpp//:rclcpp",
    "@ros2_rclcpp//:rclcpp_action",
    "@ros2_rclcpp//:rclcpp_components",
    "@ros2_common_interfaces//:cpp_std_msgs",
    "@map_server_workspace//:cpp_nav2_msgs",
    "@nav_2d_utils//:conversions",
    "@nav_2d_utils//:path_ops",
    "@nav_2d_utils//:tf_help",
    "@nav_2d_msgs//:cpp_nav_2d_msgs",
    "@map_server_workspace//:nav2_util",
    "@nav2_core//:nav2_core",
    "@nav2_costmap_2d//:nav2_costmap_2d_core",
    "@nav2_costmap_2d//:nav2_costmap_2d_client",
    "@ros2_pluginlib//:pluginlib",
]

# 1. simple_smoother
ros2_cpp_library(
    name = "simple_smoother",
    srcs = ["src/simple_smoother.cpp"],
    hdrs = glob(["include/nav2_smoother/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS,
)

# 2. savitzky_golay_smoother
ros2_cpp_library(
    name = "savitzky_golay_smoother",
    srcs = ["src/savitzky_golay_smoother.cpp"],
    hdrs = glob(["include/nav2_smoother/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS,
)

# 3. smoother_server_core
ros2_cpp_library(
    name = "smoother_server_core",
    srcs = ["src/nav2_smoother.cpp"],
    hdrs = glob(["include/nav2_smoother/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS,
)

# 4. Executable
ros2_cpp_binary(
    name = "smoother_server",
    srcs = ["src/main.cpp"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS + [
        ":smoother_server_core",
    ],
)
