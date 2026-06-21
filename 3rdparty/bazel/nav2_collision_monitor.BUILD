load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_binary",
    "ros2_cpp_library",
)

COMMON_DEPS = [
    "@ros2_common_interfaces//:cpp_geometry_msgs",
    "@ros2_common_interfaces//:cpp_sensor_msgs",
    "@nav2_msgs//:cpp_nav2_msgs",
    "@nav2_util//:nav2_util",
    "@nav2_costmap_2d//:nav2_costmap_2d_core",
    "@nav2_costmap_2d//:nav2_costmap_2d_client",
    "@ros2_rclcpp//:rclcpp",
    "@ros2_rclcpp//:rclcpp_components",
    "@ros2_geometry2//:tf2",
    "@ros2_geometry2//:tf2_ros",
    "@ros2_geometry2//:cpp_tf2_geometry_msgs",
]

# 1. collision_monitor_core
ros2_cpp_library(
    name = "collision_monitor_core",
    srcs = [
        "src/collision_monitor_node.cpp",
        "src/polygon.cpp",
        "src/polygon_source.cpp",
        "src/velocity_polygon.cpp",
        "src/circle.cpp",
        "src/source.cpp",
        "src/scan.cpp",
        "src/pointcloud.cpp",
        "src/range.cpp",
        "src/kinematics.cpp",
        "src/collision_detector_node.cpp",
    ],
    hdrs = glob(["include/nav2_collision_monitor/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS,
)

# 2. Executable
ros2_cpp_binary(
    name = "collision_monitor",
    srcs = ["src/collision_monitor_main.cpp"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS + [
        ":collision_monitor_core",
    ],
)

ros2_cpp_binary(
    name = "collision_detector",
    srcs = ["src/collision_detector_main.cpp"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS + [
        ":collision_monitor_core",
    ],
)

