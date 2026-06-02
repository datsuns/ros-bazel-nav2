load(
    "@com_github_mvukov_rules_ros2//ros2:interfaces.bzl",
    "cpp_ros2_interface_library",
    "ros2_interface_library",
)

ros2_interface_library(
    name = "robot_localization",
    srcs = glob([
        "srv/**/*.srv",
    ]),
    deps = [
        "@geographic_info//:geographic_msgs",
        "@ros2_common_interfaces//:geometry_msgs",
        "@ros2_common_interfaces//:std_msgs",
        "@ros2_common_interfaces//:std_srvs",
    ],
    visibility = ["//visibility:public"],
)

cpp_ros2_interface_library(
    name = "cpp_robot_localization",
    visibility = ["//visibility:public"],
    deps = [":robot_localization"],
)
