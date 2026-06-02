load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_binary",
    "ros2_cpp_library",
)

COMMON_DEPS = [
    "@ros2_rclcpp//:rclcpp",
    "@ros2_rclcpp//:rclcpp_action",
    "@ros2_rclcpp//:rclcpp_lifecycle",
    "@ros2_rclcpp//:rclcpp_components",
    "@ros2_common_interfaces//:cpp_nav_msgs",
    "@nav2_msgs//:cpp_nav2_msgs",
    "@nav2_util//:nav2_util",
    "@ros2_geometry2//:tf2_ros",
    "@nav2_core//:nav2_core",
    "@ros2_pluginlib//:pluginlib",
    "@image_common//:image_transport",
    "@vision_opencv//:cv_bridge",
    "@system_libs//:opencv",
    "@robot_localization//:cpp_robot_localization",
]

# 1. waypoint_follower_core
ros2_cpp_library(
    name = "waypoint_follower_core",
    srcs = [
        "src/waypoint_follower.cpp",
    ],
    hdrs = glob(["include/nav2_waypoint_follower/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS,
)

# 2. Executable
ros2_cpp_binary(
    name = "waypoint_follower",
    srcs = [
        "src/main.cpp",
    ],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS + [
        ":waypoint_follower_core",
    ],
)

# 3. wait_at_waypoint
ros2_cpp_library(
    name = "wait_at_waypoint",
    srcs = ["plugins/wait_at_waypoint.cpp"],
    hdrs = glob(["include/nav2_waypoint_follower/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS + [
        ":waypoint_follower_core",
    ],
)

# 4. photo_at_waypoint
ros2_cpp_library(
    name = "photo_at_waypoint",
    srcs = ["plugins/photo_at_waypoint.cpp"],
    hdrs = glob(["include/nav2_waypoint_follower/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS + [
        ":waypoint_follower_core",
    ],
)

# 5. input_at_waypoint
ros2_cpp_library(
    name = "input_at_waypoint",
    srcs = ["plugins/input_at_waypoint.cpp"],
    hdrs = glob(["include/nav2_waypoint_follower/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS + [
        ":waypoint_follower_core",
    ],
)

