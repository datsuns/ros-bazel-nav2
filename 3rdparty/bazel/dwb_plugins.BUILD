load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_library",
)

ros2_cpp_library(
    name = "dwb_plugins",
    srcs = [
        "src/standard_traj_generator.cpp",
        "src/limited_accel_generator.cpp",
        "src/kinematic_parameters.cpp",
        "src/xy_theta_iterator.cpp",
    ],
    hdrs = glob(["include/dwb_plugins/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = [
        "@angles//:angles",
        "@dwb_core//:dwb_core",
        "@nav_2d_msgs//:cpp_nav_2d_msgs",
        "@nav_2d_utils//:conversions",
        "@nav_2d_utils//:path_ops",
        "@nav_2d_utils//:tf_help",
        "@ros2_pluginlib//:pluginlib",
        "@ros2_rclcpp//:rclcpp",
        "@nav2_util//:nav2_util",
    ],
)

