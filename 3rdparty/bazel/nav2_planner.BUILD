load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_binary",
    "ros2_cpp_library",
)

COMMON_DEPS = [
    "@ros2_rclcpp//:rclcpp",
    "@ros2_rclcpp//:rclcpp_action",
    "@ros2_rclcpp//:rclcpp_lifecycle",
    "@ros2_rclcpp//:rclcpp_components",
    "@ros2_common_interfaces//:cpp_std_msgs",
    "@ros2_common_interfaces//:cpp_visualization_msgs",
    "@map_server_workspace//:nav2_util",
    "@map_server_workspace//:cpp_nav2_msgs",
    "@ros2_common_interfaces//:cpp_nav_msgs",
    "@ros2_common_interfaces//:cpp_geometry_msgs",
    "@ros2_rcl_interfaces//:cpp_builtin_interfaces",
    "@ros2_geometry2//:tf2_ros",
    "@nav2_costmap_2d//:nav2_costmap_2d_core",
    "@nav2_costmap_2d//:nav2_costmap_2d_client",
    "@ros2_pluginlib//:pluginlib",
    "@nav2_core//:nav2_core",
]

# 1. planner_server_core
ros2_cpp_library(
    name = "planner_server_core",
    srcs = ["src/planner_server.cpp"],
    hdrs = glob(["include/nav2_planner/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS,
)

# 2. Executable
ros2_cpp_binary(
    name = "planner_server",
    srcs = ["src/main.cpp"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS + [
        ":planner_server_core",
    ],
)
