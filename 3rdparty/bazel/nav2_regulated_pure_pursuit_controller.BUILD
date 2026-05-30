load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_library",
)

ros2_cpp_library(
    name = "nav2_regulated_pure_pursuit_controller",
    srcs = [
        "src/regulated_pure_pursuit_controller.cpp",
    ],
    hdrs = glob(["include/nav2_regulated_pure_pursuit_controller/**/*.hpp"]),
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
        "@ros2_geometry2//:cpp_tf2_geometry_msgs",
    ],
)
