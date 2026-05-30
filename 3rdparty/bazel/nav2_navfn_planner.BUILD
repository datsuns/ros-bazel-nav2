load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_library",
)

ros2_cpp_library(
    name = "nav2_navfn_planner",
    srcs = [
        "src/navfn.cpp",
        "src/navfn_planner.cpp",
    ],
    hdrs = glob(["include/nav2_navfn_planner/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = [
        "@ros2_rclcpp//:rclcpp",
        "@ros2_rclcpp//:rclcpp_action",
        "@ros2_rclcpp//:rclcpp_lifecycle",
        "@ros2_common_interfaces//:cpp_std_msgs",
        "@ros2_common_interfaces//:cpp_visualization_msgs",
        "@nav2_util//:nav2_util",
        "@nav2_msgs//:cpp_nav2_msgs",
        "@ros2_common_interfaces//:cpp_nav_msgs",
        "@ros2_common_interfaces//:cpp_geometry_msgs",
        "@ros2_common_interfaces//:c_geometry_msgs",
        "@ros2_rcl_interfaces//:cpp_builtin_interfaces",
        "@ros2_geometry2//:tf2_ros",
        "@nav2_costmap_2d//:nav2_costmap_2d_core",
        "@nav2_costmap_2d//:nav2_costmap_2d_client",
        "@ros2_pluginlib//:pluginlib",
        "@nav2_core//:nav2_core",
    ],
)

