load("@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl", "ros2_cpp_library")

ros2_cpp_library(
    name = "interactive_markers",
    srcs = glob(["src/*.cpp"]),
    hdrs = glob(["include/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = [
        "@ros2_rclcpp//:rclcpp",
        "@ros2_common_interfaces//:cpp_visualization_msgs",
        "@ros2_common_interfaces//:cpp_geometry_msgs",
        "@ros2_common_interfaces//:cpp_std_msgs",
        "@ros2_geometry2//:tf2",
        "@ros2_geometry2//:tf2_ros",
        "@ros2_geometry2//:cpp_tf2_geometry_msgs",
    ],
)
