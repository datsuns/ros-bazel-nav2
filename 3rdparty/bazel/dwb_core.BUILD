load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_library",
)

ros2_cpp_library(
    name = "dwb_core",
    srcs = [
        "src/dwb_local_planner.cpp",
        "src/publisher.cpp",
        "src/illegal_trajectory_tracker.cpp",
        "src/trajectory_utils.cpp",
    ],
    hdrs = glob(["include/dwb_core/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = [
        "@ros2_rclcpp//:rclcpp",
        "@ros2_common_interfaces//:cpp_std_msgs",
        "@ros2_common_interfaces//:cpp_geometry_msgs",
        "@ros2_common_interfaces//:c_geometry_msgs",
        "@nav_2d_msgs//:cpp_nav_2d_msgs",
        "@dwb_msgs//:cpp_dwb_msgs",
        "@nav2_costmap_2d//:nav2_costmap_2d_core",
        "@nav2_costmap_2d//:nav2_costmap_2d_client",
        "@ros2_pluginlib//:pluginlib",
        "@ros2_common_interfaces//:cpp_sensor_msgs",
        "@ros2_common_interfaces//:cpp_visualization_msgs",
        "@nav_2d_utils//:conversions",
        "@nav_2d_utils//:path_ops",
        "@nav_2d_utils//:tf_help",
        "@ros2_common_interfaces//:cpp_nav_msgs",
        "@ros2_geometry2//:tf2_ros",
        "@nav2_util//:nav2_util",
        "@nav2_core//:nav2_core",
    ],
)

