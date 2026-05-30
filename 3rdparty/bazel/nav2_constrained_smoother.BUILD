load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_library",
)

ros2_cpp_library(
    name = "nav2_constrained_smoother",
    srcs = [
        "src/constrained_smoother.cpp",
    ],
    hdrs = glob(["include/nav2_constrained_smoother/**/*.hpp"]),
    includes = ["include"],
    defines = ["PLUGINLIB__DISABLE_BOOST_FUNCTIONS"],
    visibility = ["//visibility:public"],
    deps = [
        "@ros2_rclcpp//:rclcpp",
        "@ros2_rclcpp//:rclcpp_action",
        "@ros2_common_interfaces//:cpp_std_msgs",
        "@map_server_workspace//:nav2_util",
        "@map_server_workspace//:cpp_nav2_msgs",
        "@ros2_common_interfaces//:cpp_nav_msgs",
        "@ros2_common_interfaces//:cpp_geometry_msgs",
        "@ros2_common_interfaces//:c_geometry_msgs",
        "@ros2_geometry2//:tf2_ros",
        "@nav2_costmap_2d//:nav2_costmap_2d_core",
        "@nav2_core//:nav2_core",
        "@ros2_pluginlib//:pluginlib",
        "@angles//:angles",
        "@system_libs//:ceres",
        "@system_libs//:eigen",
    ],
)
