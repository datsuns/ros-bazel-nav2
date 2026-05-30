load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_library",
)
load(
    "@map_server_workspace//3rdparty/bazel:nav2_behavior_tree_rules.bzl",
    "declare_bt_nodes",
)

COMMON_DEPS = [
    "@ros2_rclcpp//:rclcpp",
    "@ros2_rclcpp//:rclcpp_action",
    "@ros2_rclcpp//:rclcpp_lifecycle",
    "@ros2_common_interfaces//:cpp_geometry_msgs",
    "@ros2_common_interfaces//:c_geometry_msgs",
    "@ros2_common_interfaces//:cpp_sensor_msgs",
    "@map_server_workspace//:cpp_nav2_msgs",
    "@map_server_workspace//:c_nav2_msgs",
    "@ros2_common_interfaces//:cpp_nav_msgs",
    "@system_libs//:behaviortree_cpp_v3",
    "@ros2_geometry2//:tf2",
    "@ros2_geometry2//:tf2_ros",
    "@ros2_geometry2//:cpp_tf2_geometry_msgs",
    "@ros2_common_interfaces//:cpp_std_msgs",
    "@ros2_common_interfaces//:cpp_std_srvs",
    "@map_server_workspace//:nav2_util",
]

# Core engine library
ros2_cpp_library(
    name = "nav2_behavior_tree",
    srcs = [
        "src/behavior_tree_engine.cpp",
    ],
    hdrs = glob(["include/nav2_behavior_tree/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS,
)

# Declare all BT node plugins using the helper macro
declare_bt_nodes(COMMON_DEPS)
