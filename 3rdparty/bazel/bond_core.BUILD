load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_library",
)
load(
    "@com_github_mvukov_rules_ros2//ros2:interfaces.bzl",
    "cpp_ros2_interface_library",
    "ros2_interface_library",
)

# 1. bond (messages)
ros2_interface_library(
    name = "bond",
    srcs = glob(["bond/msg/*.msg"]),
    deps = [
        "@ros2_common_interfaces//:std_msgs",
    ],
)

cpp_ros2_interface_library(
    name = "cpp_bond",
    visibility = ["//visibility:public"],
    deps = [":bond"],
)

# 2. smclib
ros2_cpp_library(
    name = "smclib",
    hdrs = glob(["smclib/include/statemap/*.h"]),
    includes = ["smclib/include"],
    visibility = ["//visibility:public"],
)

# 3. bondcpp
ros2_cpp_library(
    name = "bondcpp",
    srcs = glob(["bondcpp/src/*.cpp"]),
    hdrs = glob(["bondcpp/include/bondcpp/*.hpp"]),
    includes = ["bondcpp/include"],
    visibility = ["//visibility:public"],
    deps = [
        ":cpp_bond",
        ":smclib",
        "@ros2_rclcpp//:rclcpp",
        "@ros2_rclcpp//:rclcpp_lifecycle",
    ],
    linkopts = ["-luuid"],
)

