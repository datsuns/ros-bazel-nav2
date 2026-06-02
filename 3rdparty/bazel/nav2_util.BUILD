load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_library",
)

ros2_cpp_library(
    name = "nav2_util",
    srcs = [
        "src/costmap.cpp",
        "src/array_parser.cpp",
        "src/node_utils.cpp",
        "src/lifecycle_service_client.cpp",
        "src/string_utils.cpp",
        "src/lifecycle_utils.cpp",
        "src/lifecycle_node.cpp",
        "src/robot_utils.cpp",
        "src/node_thread.cpp",
        "src/odometry_utils.cpp",
    ],
    hdrs = glob(["include/nav2_util/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = [
        "@nav2_msgs//:cpp_nav2_msgs",
        "@ros2_rclcpp//:rclcpp",
        "@ros2_rclcpp//:rclcpp_lifecycle",
        "@ros2_rclcpp//:rclcpp_action",
        "@ros2_geometry2//:tf2",
        "@ros2_geometry2//:tf2_ros",
        "@ros2_geometry2//:cpp_tf2_geometry_msgs",
        "@ros2_common_interfaces//:cpp_nav_msgs",
        "@ros2_common_interfaces//:cpp_geometry_msgs",
        "@ros2_rcl_interfaces//:cpp_lifecycle_msgs",
        "@bond_core//:bondcpp",
    ],
)

