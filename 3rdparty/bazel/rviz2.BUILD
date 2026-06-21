load("@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl", "ros2_cpp_library", "ros2_cpp_binary")
load("@map_server_workspace//bazel:qt_macros.bzl", "qt_wrap_cpp", "qt_wrap_ui")

# -- rviz_rendering --
qt_wrap_cpp(
    name = "rviz_rendering_moc",
    hdrs = glob(["rviz_rendering/include/rviz_rendering/**/*.hpp", "rviz_rendering/src/rviz_rendering/**/*.hpp"], exclude=["**/testing/**"]),
)

ros2_cpp_library(
    name = "rviz_rendering",
    srcs = glob([
        "rviz_rendering/src/**/*.cpp",
        "rviz_rendering/src/**/*.hpp",
        "rviz_rendering/src/**/*.h",
    ], exclude=["**/testing/**", "**/test/**"]) + [":rviz_rendering_moc"],
    hdrs = glob(["rviz_rendering/include/rviz_rendering/**/*.hpp"]),
    includes = ["rviz_rendering/include"],
    visibility = ["//visibility:public"],
    deps = [
        "@system_libs//:qt5",
        "@system_libs//:ogre",
        "@system_libs//:assimp",
        "@system_libs//:eigen",
        "@ros2_ament_index//:ament_index_cpp",
        "@resource_retriever//:resource_retriever",
        "@ros2_rclcpp//:rclcpp",
    ],
    linkopts = [
        "-lX11",
        "-lGL",
    ],
    copts = ["-DRVIZ_RENDERING_OGRE_PLUGIN_DIR=\\\"/usr/lib/x86_64-linux-gnu/OGRE/\\\""],
)

# -- rviz_common --
genrule(
    name = "env_config_cpp",
    srcs = ["rviz_common/src/rviz_common/env_config.cpp.in"],
    outs = ["rviz_common/src/rviz_common/env_config.cpp"],
    cmd = "sed -e 's/@RVIZ_VERSION@/14.1.2/g' -e 's/@ROS_DISTRO@/jazzy/g' -e 's/@OGRE_PLUGIN_PATH@/\\/usr\\/lib\\/x86_64-linux-gnu\\/OGRE/g' $< > $@",
)

qt_wrap_cpp(
    name = "rviz_common_moc",
    hdrs = glob(["rviz_common/include/rviz_common/**/*.hpp", "rviz_common/src/rviz_common/**/*.hpp"], exclude=["**/testing/**"]),
)

qt_wrap_ui(
    name = "rviz_common_ui",
    uis = glob(["rviz_common/src/rviz_common/**/*.ui"]),
)

ros2_cpp_library(
    name = "rviz_common",
    srcs = glob([
        "rviz_common/src/**/*.cpp",
        "rviz_common/src/**/*.hpp",
        "rviz_common/src/**/*.h",
    ], exclude=["**/testing/**", "**/test/**", "rviz_common/src/rviz_common/env_config.cpp.in"]) + [":rviz_common_moc", ":env_config_cpp"],
    hdrs = glob(["rviz_common/include/rviz_common/**/*.hpp"]) + [":rviz_common_ui"],
    includes = ["rviz_common/include", "rviz_common/src/rviz_common"],
    visibility = ["//visibility:public"],
    deps = [
        ":rviz_rendering",
        "@system_libs//:qt5",
        "@system_libs//:tinyxml2",
        "@system_libs//:yaml-cpp",
        "@urdf//:urdf",
        "@resource_retriever//:resource_retriever",
        "@pluginlib//:pluginlib",
        "@ros2_rclcpp//:rclcpp",
        "@ros2_common_interfaces//:cpp_geometry_msgs",
        "@ros2_common_interfaces//:cpp_sensor_msgs",
        "@ros2_common_interfaces//:cpp_std_msgs",
        "@ros2_common_interfaces//:cpp_std_srvs",
        "@ros2_geometry2//:tf2",
        "@ros2_geometry2//:tf2_ros",
        "@system_libs//:eigen",
        "@ros2_message_filters//:message_filters",
    ],
)

# -- rviz_default_plugins --
qt_wrap_cpp(
    name = "rviz_default_plugins_moc",
    hdrs = glob(["rviz_default_plugins/include/rviz_default_plugins/**/*.hpp", "rviz_default_plugins/src/rviz_default_plugins/**/*.hpp"], exclude=["**/testing/**"]),
)

ros2_cpp_library(
    name = "rviz_default_plugins",
    srcs = glob([
        "rviz_default_plugins/src/**/*.cpp",
        "rviz_default_plugins/src/**/*.hpp",
        "rviz_default_plugins/src/**/*.h",
    ], exclude=["**/testing/**", "**/test/**"]) + [":rviz_default_plugins_moc"],
    hdrs = glob(["rviz_default_plugins/include/rviz_default_plugins/**/*.hpp"]),
    includes = ["rviz_default_plugins/include"],
    visibility = ["//visibility:public"],
    deps = [
        ":rviz_common",
        ":rviz_rendering",
        "@system_libs//:qt5",
        "@urdf//:urdf",
        "@interactive_markers//:interactive_markers",
        "@pluginlib//:pluginlib",
        "@ros2_rclcpp//:rclcpp",
        "@ros2_common_interfaces//:cpp_geometry_msgs",
        "@ros2_common_interfaces//:cpp_sensor_msgs",
        "@ros2_common_interfaces//:cpp_std_msgs",
        "@ros2_common_interfaces//:cpp_nav_msgs",
        "@ros2_common_interfaces//:cpp_visualization_msgs",
        "@ros2_geometry2//:tf2",
        "@ros2_geometry2//:cpp_tf2_geometry_msgs",
        "@system_libs//:eigen",
        "@ros2_geometry2//:tf2_ros",
        "@image_common//:image_transport",
        "@laser_geometry//:laser_geometry",
        "@map_msgs//:cpp_map_msgs",
        "@point_cloud_transport//:point_cloud_transport",
        "@system_libs//:ignition_math",
    ],
)

# -- rviz2 --
ros2_cpp_binary(
    name = "rviz2",
    srcs = glob(["rviz2/src/*.cpp"]),
    visibility = ["//visibility:public"],
    deps = [
        ":rviz_common",
        ":rviz_default_plugins",
        "@system_libs//:qt5",
        "@ros2_rclcpp//:rclcpp",
    ],
)
