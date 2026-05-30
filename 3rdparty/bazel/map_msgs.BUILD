load(
    "@com_github_mvukov_rules_ros2//ros2:interfaces.bzl",
    "cpp_ros2_interface_library",
    "ros2_interface_library",
)

ros2_interface_library(
    name = "map_msgs",
    srcs = glob([
        "msg/*.msg",
        "srv/*.srv",
    ]),
    deps = [
        "@ros2_common_interfaces//:nav_msgs",
        "@ros2_common_interfaces//:sensor_msgs",
        "@ros2_common_interfaces//:std_msgs",
    ],
)

cpp_ros2_interface_library(
    name = "cpp_map_msgs",
    visibility = ["//visibility:public"],
    deps = [":map_msgs"],
)
