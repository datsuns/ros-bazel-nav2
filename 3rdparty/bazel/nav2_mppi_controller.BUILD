load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_library",
)

COMMON_DEPS = [
    "@ros2_rclcpp//:rclcpp",
    "@ros2_pluginlib//:pluginlib",
    "@ros2_geometry2//:tf2",
    "@ros2_common_interfaces//:cpp_geometry_msgs",
    "@ros2_common_interfaces//:c_geometry_msgs",
    "@ros2_common_interfaces//:cpp_visualization_msgs",
    "@ros2_common_interfaces//:cpp_nav_msgs",
    "@nav2_core//:nav2_core",
    "@nav2_costmap_2d//:nav2_costmap_2d_core",
    "@nav2_costmap_2d//:nav2_costmap_2d_client",
    "@nav2_util//:nav2_util",
    "@nav2_msgs//:cpp_nav2_msgs",
    "@ros2_geometry2//:cpp_tf2_geometry_msgs",
    "@ros2_geometry2//:tf2_eigen",
    "@ros2_geometry2//:tf2_ros",
    "@system_libs//:xtensor",
    "@system_libs//:xsimd",
    "@system_libs//:eigen",
]

COPTS = [
    "-fconcepts",
    "-msse4.2",
    "-mavx2",
    "-mfma",
    "-O3",
    "-finline-limit=10000000",
    "-ffp-contract=fast",
    "-ffast-math",
    "-mtune=generic",
]

DEFINES = [
    "XTENSOR_ENABLE_XSIMD",
    "XTENSOR_USE_XSIMD",
]

# 1. mppi_controller
ros2_cpp_library(
    name = "mppi_controller",
    srcs = [
        "src/controller.cpp",
        "src/optimizer.cpp",
        "src/critic_manager.cpp",
        "src/trajectory_visualizer.cpp",
        "src/path_handler.cpp",
        "src/parameters_handler.cpp",
        "src/noise_generator.cpp",
    ],
    hdrs = glob(["include/nav2_mppi_controller/**/*.hpp"]),
    includes = ["include"],
    copts = COPTS,
    defines = DEFINES,
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS,
)

# 2. mppi_critics
ros2_cpp_library(
    name = "mppi_critics",
    srcs = [
        "src/critics/obstacles_critic.cpp",
        "src/critics/cost_critic.cpp",
        "src/critics/goal_critic.cpp",
        "src/critics/goal_angle_critic.cpp",
        "src/critics/path_align_critic.cpp",
        "src/critics/path_align_legacy_critic.cpp",
        "src/critics/path_follow_critic.cpp",
        "src/critics/path_angle_critic.cpp",
        "src/critics/prefer_forward_critic.cpp",
        "src/critics/twirling_critic.cpp",
        "src/critics/constraint_critic.cpp",
        "src/critics/velocity_deadband_critic.cpp",
    ],
    hdrs = glob(["include/nav2_mppi_controller/**/*.hpp"]),
    includes = ["include"],
    copts = COPTS,
    defines = DEFINES,
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS + [
        ":mppi_controller",
    ],
)

