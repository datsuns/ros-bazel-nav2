load("@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl", "ros2_cpp_library")

ros2_cpp_library(
    name = "point_cloud_transport",
    srcs = glob(["src/*.cpp"]),
    hdrs = glob(["include/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = [
        "@ros2_rclcpp//:rclcpp",
        "@ros2_common_interfaces//:cpp_sensor_msgs",
        "@pluginlib//:pluginlib",
        "@ros2_rcpputils//:rcpputils",
        "@ros2_message_filters//:message_filters",
        "@ros2_rclcpp//:rclcpp_components",
    ],
)
