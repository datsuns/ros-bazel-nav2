load(
    "@com_github_mvukov_rules_ros2//ros2:interfaces.bzl",
    "c_ros2_interface_library",
    "cpp_ros2_interface_library",
    "ros2_interface_library",
)

ros2_interface_library(
    name = "nav2_msgs",
    srcs = glob([
        "msg/**/*.msg",
        "srv/**/*.srv",
        "action/**/*.action",
    ]),
    deps = [
        "@ros2_common_interfaces//:geometry_msgs",
        "@ros2_common_interfaces//:std_msgs",
        "@ros2_common_interfaces//:nav_msgs",
        "@ros2_rcl_interfaces//:action_msgs",
        "@ros2_rcl_interfaces//:builtin_interfaces",
        "@ros2_unique_identifier_msgs//:unique_identifier_msgs",
    ],
    visibility = ["//visibility:public"],
)

cpp_ros2_interface_library(
    name = "cpp_nav2_msgs",
    visibility = ["//visibility:public"],
    deps = [":nav2_msgs"],
)

c_ros2_interface_library(
    name = "c_nav2_msgs",
    visibility = ["//visibility:public"],
    deps = [":nav2_msgs"],
)

