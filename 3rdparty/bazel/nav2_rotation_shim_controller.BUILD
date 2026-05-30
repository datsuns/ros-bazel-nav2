load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_library",
)

ros2_cpp_library(
    name = "nav2_rotation_shim_controller",
    srcs = [
        "src/nav2_rotation_shim_controller.cpp",
    ],
    hdrs = glob(["include/nav2_rotation_shim_controller/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = [
        "@ros2_rclcpp//:rclcpp",
        "@ros2_common_interfaces//:cpp_geometry_msgs",
        "@ros2_common_interfaces//:c_geometry_msgs",
        "@ros2_common_interfaces//:cpp_nav_msgs",
        "@map_server_workspace//:nav2_util",
        "@nav2_costmap_2d//:nav2_costmap_2d_core",
        "@ros2_pluginlib//:pluginlib",
        "@nav2_core//:nav2_core",
        "@ros2_geometry2//:tf2",
        "@ros2_geometry2//:tf2_ros",
        "@system_libs//:angles",
        "@nav2_controller//:position_goal_checker",
    ],
)
