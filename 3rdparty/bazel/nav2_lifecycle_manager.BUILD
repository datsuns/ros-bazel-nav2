load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_binary",
    "ros2_cpp_library",
)

COMMON_DEPS = [
    "@ros2_common_interfaces//:cpp_geometry_msgs",
    "@ros2_rcl_interfaces//:cpp_lifecycle_msgs",
    "@map_server_workspace//:cpp_nav2_msgs",
    "@map_server_workspace//:nav2_util",
    "@ros2_rclcpp//:rclcpp",
    "@ros2_rclcpp//:rclcpp_action",
    "@ros2_rclcpp//:rclcpp_lifecycle",
    "@ros2_rclcpp//:rclcpp_components",
    "@ros2_common_interfaces//:cpp_std_msgs",
    "@ros2_common_interfaces//:cpp_std_srvs",
    "@ros2_geometry2//:cpp_tf2_geometry_msgs",
    "@bond_core//:bondcpp",
    "@ros2_diagnostics//:cpp_diagnostic_updater",
]

# 1. nav2_lifecycle_manager_core
ros2_cpp_library(
    name = "nav2_lifecycle_manager_core",
    srcs = [
        "src/lifecycle_manager.cpp",
        "src/lifecycle_manager_client.cpp",
    ],
    hdrs = glob(["include/nav2_lifecycle_manager/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS,
)

# 2. Executable
ros2_cpp_binary(
    name = "lifecycle_manager",
    srcs = ["src/main.cpp"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS + [
        ":nav2_lifecycle_manager_core",
    ],
)
