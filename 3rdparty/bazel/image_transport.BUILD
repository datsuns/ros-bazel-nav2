load("@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl", "ros2_cpp_library")

ros2_cpp_library(
    name = "image_transport",
    srcs = glob(
        ["src/*.cpp"],
        exclude = [
            "src/republish.cpp",
            "src/list_transports.cpp",
        ],
    ),
    hdrs = glob(["include/image_transport/*.hpp", "include/image_transport/*.h"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = [
        "@ros2_rclcpp//:rclcpp",
        "@ros2_common_interfaces//:cpp_sensor_msgs",
        "@ros2_pluginlib//:pluginlib",
        "@ros2_message_filters//:message_filters",
    ],
)
