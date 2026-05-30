load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_library",
)

ros2_cpp_library(
    name = "nav2_core",
    hdrs = glob(["include/nav2_core/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = [
        "@nav2_costmap_2d//:nav2_costmap_2d_core",
        "@ros2_rclcpp//:rclcpp",
        "@ros2_rclcpp//:rclcpp_lifecycle",
        "@ros2_common_interfaces//:cpp_geometry_msgs",
        "@ros2_common_interfaces//:cpp_std_msgs",
        "@ros2_common_interfaces//:cpp_nav_msgs",
        "@ros2_common_interfaces//:cpp_visualization_msgs",
        "@ros2_geometry2//:tf2_ros",
        "@ros2_pluginlib//:pluginlib",
    ],
)
