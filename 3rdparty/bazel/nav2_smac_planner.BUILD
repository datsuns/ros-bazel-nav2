load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_library",
)

COMMON_DEPS = [
    "@ros2_rclcpp//:rclcpp",
    "@ros2_rclcpp//:rclcpp_action",
    "@ros2_rclcpp//:rclcpp_lifecycle",
    "@ros2_common_interfaces//:cpp_std_msgs",
    "@ros2_common_interfaces//:cpp_visualization_msgs",
    "@map_server_workspace//:nav2_util",
    "@map_server_workspace//:cpp_nav2_msgs",
    "@ros2_common_interfaces//:cpp_nav_msgs",
    "@ros2_common_interfaces//:cpp_geometry_msgs",
    "@ros2_common_interfaces//:c_geometry_msgs",
    "@ros2_rcl_interfaces//:cpp_builtin_interfaces",
    "@ros2_geometry2//:tf2_ros",
    "@nav2_costmap_2d//:nav2_costmap_2d_core",
    "@nav2_core//:nav2_core",
    "@ros2_pluginlib//:pluginlib",
    "@system_libs//:angles",
    "@system_libs//:eigen",
    "@system_libs//:ompl",
]

SRC_FILES = [
    "src/a_star.cpp",
    "src/collision_checker.cpp",
    "src/smoother.cpp",
    "src/analytic_expansion.cpp",
    "src/node_hybrid.cpp",
    "src/node_lattice.cpp",
    "src/costmap_downsampler.cpp",
    "src/node_2d.cpp",
    "src/node_basic.cpp",
]

# 1. nav2_smac_planner (Hybrid, with OpenMP)
ros2_cpp_library(
    name = "nav2_smac_planner",
    srcs = SRC_FILES + ["src/smac_planner_hybrid.cpp"],
    hdrs = glob(["include/nav2_smac_planner/**/*.hpp", "include/nav2_smac_planner/thirdparty/**/*.h"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    copts = ["-fopenmp"],
    linkopts = ["-fopenmp"],
    deps = COMMON_DEPS,
)

# 2. nav2_smac_planner_2d
ros2_cpp_library(
    name = "nav2_smac_planner_2d",
    srcs = SRC_FILES + ["src/smac_planner_2d.cpp"],
    hdrs = glob(["include/nav2_smac_planner/**/*.hpp", "include/nav2_smac_planner/thirdparty/**/*.h"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS,
)

# 3. nav2_smac_planner_lattice
ros2_cpp_library(
    name = "nav2_smac_planner_lattice",
    srcs = SRC_FILES + ["src/smac_planner_lattice.cpp"],
    hdrs = glob(["include/nav2_smac_planner/**/*.hpp", "include/nav2_smac_planner/thirdparty/**/*.h"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS,
)
