load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_binary",
    "ros2_cpp_library",
)

COMMON_DEPS = [
    "@system_libs//:angles",
    "@ros2_rclcpp//:rclcpp",
    "@ros2_rclcpp//:rclcpp_action",
    "@ros2_rclcpp//:rclcpp_components",
    "@ros2_common_interfaces//:cpp_std_msgs",
    "@map_server_workspace//:cpp_nav2_msgs",
    "@nav_2d_utils//:conversions",
    "@nav_2d_utils//:path_ops",
    "@nav_2d_utils//:tf_help",
    "@nav_2d_msgs//:cpp_nav_2d_msgs",
    "@map_server_workspace//:nav2_util",
    "@nav2_core//:nav2_core",
    "@ros2_pluginlib//:pluginlib",
]

# 1. simple_progress_checker
ros2_cpp_library(
    name = "simple_progress_checker",
    srcs = ["plugins/simple_progress_checker.cpp"],
    hdrs = glob(["include/nav2_controller/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS,
)

# 2. pose_progress_checker
ros2_cpp_library(
    name = "pose_progress_checker",
    srcs = ["plugins/pose_progress_checker.cpp"],
    hdrs = glob(["include/nav2_controller/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS + [
        ":simple_progress_checker",
    ],
)

# 3. simple_goal_checker
ros2_cpp_library(
    name = "simple_goal_checker",
    srcs = ["plugins/simple_goal_checker.cpp"],
    hdrs = glob(["include/nav2_controller/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS,
)

# 4. stopped_goal_checker
ros2_cpp_library(
    name = "stopped_goal_checker",
    srcs = ["plugins/stopped_goal_checker.cpp"],
    hdrs = glob(["include/nav2_controller/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS + [
        ":simple_goal_checker",
    ],
)

# 5. position_goal_checker
ros2_cpp_library(
    name = "position_goal_checker",
    srcs = ["plugins/position_goal_checker.cpp"],
    hdrs = glob(["include/nav2_controller/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS,
)

# 6. controller_server_core
ros2_cpp_library(
    name = "controller_server_core",
    srcs = ["src/controller_server.cpp"],
    hdrs = glob(["include/nav2_controller/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS,
)

# 7. Executable
ros2_cpp_binary(
    name = "controller_server",
    srcs = ["src/main.cpp"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS + [
        ":controller_server_core",
    ],
)
