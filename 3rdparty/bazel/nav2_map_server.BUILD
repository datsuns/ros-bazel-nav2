load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_binary",
    "ros2_cpp_library",
)

# 1. map_io Shared Library
ros2_cpp_library(
    name = "map_io",
    srcs = [
        "src/map_io.cpp",
        "src/map_mode.cpp",
    ],
    hdrs = glob(["include/nav2_map_server/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = [
        "@nav2_util//:nav2_util",
        "@ros2_common_interfaces//:cpp_nav_msgs",
        "@ros2_geometry2//:tf2",
        "@system_libs//:yaml-cpp",
        "@system_libs//:graphicsmagick",
    ],
)

# 2. map_server_core Shared Library
ros2_cpp_library(
    name = "map_server_core",
    srcs = [
        "src/map_server/map_server.cpp",
        "src/map_saver/map_saver.cpp",
        "src/costmap_filter_info/costmap_filter_info_server.cpp",
    ],
    hdrs = glob(["include/nav2_map_server/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = [
        ":map_io",
        "@nav2_util//:nav2_util",
        "@nav2_msgs//:cpp_nav2_msgs",
        "@ros2_rclcpp//:rclcpp",
        "@ros2_rclcpp//:rclcpp_lifecycle",
        "@ros2_rclcpp//:rclcpp_components",
        "@ros2_common_interfaces//:cpp_nav_msgs",
        "@ros2_common_interfaces//:cpp_std_msgs",
        "@system_libs//:yaml-cpp",
    ],
)

# 3. Executables
ros2_cpp_binary(
    name = "map_server",
    srcs = ["src/map_server/main.cpp"],
    visibility = ["//visibility:public"],
    deps = [":map_server_core"],
)

ros2_cpp_binary(
    name = "map_saver_cli",
    srcs = ["src/map_saver/main_cli.cpp"],
    visibility = ["//visibility:public"],
    deps = [":map_server_core"],
)

ros2_cpp_binary(
    name = "map_saver_server",
    srcs = ["src/map_saver/main_server.cpp"],
    visibility = ["//visibility:public"],
    deps = [":map_server_core"],
)

ros2_cpp_binary(
    name = "costmap_filter_info_server",
    srcs = ["src/costmap_filter_info/main.cpp"],
    visibility = ["//visibility:public"],
    deps = [":map_server_core"],
)

