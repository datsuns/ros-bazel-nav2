load(
    "@com_github_mvukov_rules_ros2//ros2:interfaces.bzl",
    "cpp_ros2_interface_library",
    "ros2_interface_library",
)

ros2_interface_library(
    name = "geographic_msgs",
    srcs = glob([
        "msg/**/*.msg",
        "srv/**/*.srv",
    ]),
    deps = [
        "@ros2_common_interfaces//:geometry_msgs",
        "@ros2_common_interfaces//:std_msgs",
        "@ros2_unique_identifier_msgs//:unique_identifier_msgs",
    ],
    visibility = ["//visibility:public"],
)

cpp_ros2_interface_library(
    name = "cpp_geographic_msgs",
    visibility = ["//visibility:public"],
    deps = [":geographic_msgs"],
)
