load(
    "@com_github_mvukov_rules_ros2//ros2:interfaces.bzl",
    "cpp_ros2_interface_library",
    "ros2_interface_library",
)

ros2_interface_library(
    name = "dwb_msgs",
    srcs = glob([
        "msg/*.msg",
        "srv/*.srv",
    ]),
    visibility = ["//visibility:public"],
    deps = [
        "@nav_2d_msgs//:nav_2d_msgs",
        "@ros2_common_interfaces//:geometry_msgs",
        "@ros2_common_interfaces//:std_msgs",
        "@ros2_common_interfaces//:nav_msgs",
        "@ros2_rcl_interfaces//:builtin_interfaces",
    ],
)

cpp_ros2_interface_library(
    name = "cpp_dwb_msgs",
    visibility = ["//visibility:public"],
    deps = [":dwb_msgs"],
)
