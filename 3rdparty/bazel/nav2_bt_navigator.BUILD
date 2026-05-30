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
    "@ros2_common_interfaces//:cpp_geometry_msgs",
    "@ros2_common_interfaces//:c_geometry_msgs",
    "@ros2_common_interfaces//:cpp_nav_msgs",
    "@ros2_common_interfaces//:cpp_std_srvs",
    "@map_server_workspace//:cpp_nav2_msgs",
    "@map_server_workspace//:nav2_util",
    "@nav2_core//:nav2_core",
    "@nav2_behavior_tree//:nav2_behavior_tree",
    "@system_libs//:behaviortree_cpp_v3",
    "@ros2_geometry2//:tf2",
    "@ros2_geometry2//:tf2_ros",
    "@ros2_geometry2//:cpp_tf2_geometry_msgs",
]

ros2_cpp_library(
    name = "bt_navigator_core",
    srcs = [
        "src/bt_navigator.cpp",
        "src/navigators/navigate_to_pose.cpp",
        "src/navigators/navigate_through_poses.cpp",
    ],
    hdrs = glob(["include/nav2_bt_navigator/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS,
)

ros2_cpp_binary(
    name = "bt_navigator",
    srcs = ["src/main.cpp"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS + [":bt_navigator_core"],
)
