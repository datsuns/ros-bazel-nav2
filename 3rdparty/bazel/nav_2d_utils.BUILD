load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_library",
)

# Shared dependencies
COMMON_DEPS = [
    "@ros2_common_interfaces//:cpp_geometry_msgs",
    "@ros2_common_interfaces//:cpp_nav_msgs",
    "@ros2_common_interfaces//:cpp_std_msgs",
    "@ros2_rclcpp//:rclcpp",
    "@ros2_geometry2//:tf2",
    "@ros2_geometry2//:cpp_tf2_geometry_msgs",
    "@nav_2d_msgs//:cpp_nav_2d_msgs",
    "@map_server_workspace//:cpp_nav2_msgs",
    "@map_server_workspace//:nav2_util",
]

# 1. conversions
ros2_cpp_library(
    name = "conversions",
    srcs = ["src/conversions.cpp"],
    hdrs = glob(["include/nav_2d_utils/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS,
)

# 2. path_ops
ros2_cpp_library(
    name = "path_ops",
    srcs = ["src/path_ops.cpp"],
    hdrs = glob(["include/nav_2d_utils/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS,
)

# 3. tf_help
ros2_cpp_library(
    name = "tf_help",
    srcs = ["src/tf_help.cpp"],
    hdrs = glob(["include/nav_2d_utils/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS + [
        ":conversions",
    ],
)
