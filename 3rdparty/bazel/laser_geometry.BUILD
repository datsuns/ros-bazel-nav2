load("@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl", "ros2_cpp_library")

ros2_cpp_library(
    name = "laser_geometry",
    srcs = glob(["src/*.cpp"]),
    hdrs = glob(["include/laser_geometry/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = [
        "@ros2_rclcpp//:rclcpp",
        "@ros2_common_interfaces//:cpp_sensor_msgs",
        "@ros2_geometry2//:tf2",
        "@ros2_geometry2//:tf2_ros",
        "@ros2_geometry2//:cpp_tf2_geometry_msgs",
        "@system_libs//:eigen",
    ],
)
