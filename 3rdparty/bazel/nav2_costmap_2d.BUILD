load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_binary",
    "ros2_cpp_library",
)

# 1. nav2_costmap_2d_core Shared Library
ros2_cpp_library(
    name = "nav2_costmap_2d_core",
    srcs = [
        "src/costmap_2d.cpp",
        "src/layer.cpp",
        "src/layered_costmap.cpp",
        "src/costmap_2d_ros.cpp",
        "src/costmap_2d_publisher.cpp",
        "src/costmap_math.cpp",
        "src/footprint.cpp",
        "src/costmap_layer.cpp",
        "src/observation_buffer.cpp",
        "src/clear_costmap_service.cpp",
        "src/footprint_collision_checker.cpp",
        "plugins/costmap_filters/costmap_filter.cpp",
    ],
    hdrs = glob(["include/nav2_costmap_2d/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = [
        "@nav2_msgs//:cpp_nav2_msgs",
        "@nav2_util//:nav2_util",
        "@nav2_voxel_grid//:voxel_grid",
        "@ros2_common_interfaces//:cpp_geometry_msgs",
        "@ros2_common_interfaces//:c_geometry_msgs",
        "@ros2_common_interfaces//:cpp_nav_msgs",
        "@ros2_common_interfaces//:cpp_sensor_msgs",
        "@ros2_common_interfaces//:cpp_std_msgs",
        "@ros2_common_interfaces//:cpp_visualization_msgs",
        "@ros2_rclcpp//:rclcpp",
        "@ros2_rclcpp//:rclcpp_lifecycle",
        "@ros2_common_interfaces//:cpp_std_srvs",
        "@ros2_geometry2//:tf2",
        "@ros2_geometry2//:tf2_ros",
        "@ros2_geometry2//:cpp_tf2_geometry_msgs",
        "@ros2_geometry2//:cpp_tf2_sensor_msgs",
        "@ros2_pluginlib//:pluginlib",
        "@ros2_message_filters//:message_filters",
        "@system_libs//:eigen",
        "@laser_geometry//:laser_geometry",
        "@map_msgs//:cpp_map_msgs",
        "@angles//:angles",
        "@system_libs//:yaml-cpp",
    ],
)

# 2. layers Shared Library
ros2_cpp_library(
    name = "layers",
    srcs = [
        "plugins/inflation_layer.cpp",
        "plugins/static_layer.cpp",
        "plugins/obstacle_layer.cpp",
        "src/observation_buffer.cpp",
        "plugins/voxel_layer.cpp",
        "plugins/range_sensor_layer.cpp",
        "plugins/denoise_layer.cpp",
    ],
    hdrs = glob(["include/nav2_costmap_2d/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = [
        ":nav2_costmap_2d_core",
        "@nav2_msgs//:cpp_nav2_msgs",
        "@nav2_util//:nav2_util",
        "@nav2_voxel_grid//:voxel_grid",
        "@ros2_common_interfaces//:cpp_geometry_msgs",
        "@ros2_common_interfaces//:c_geometry_msgs",
        "@ros2_common_interfaces//:cpp_nav_msgs",
        "@ros2_common_interfaces//:cpp_sensor_msgs",
        "@ros2_common_interfaces//:cpp_std_msgs",
        "@ros2_common_interfaces//:cpp_visualization_msgs",
        "@ros2_rclcpp//:rclcpp",
        "@ros2_rclcpp//:rclcpp_lifecycle",
        "@ros2_common_interfaces//:cpp_std_srvs",
        "@ros2_geometry2//:tf2",
        "@ros2_geometry2//:tf2_ros",
        "@ros2_geometry2//:cpp_tf2_geometry_msgs",
        "@ros2_geometry2//:cpp_tf2_sensor_msgs",
        "@ros2_pluginlib//:pluginlib",
        "@ros2_message_filters//:message_filters",
        "@system_libs//:eigen",
        "@laser_geometry//:laser_geometry",
        "@map_msgs//:cpp_map_msgs",
        "@angles//:angles",
        "@system_libs//:yaml-cpp",
    ],
)

# 3. filters Shared Library
ros2_cpp_library(
    name = "filters",
    srcs = [
        "plugins/costmap_filters/keepout_filter.cpp",
        "plugins/costmap_filters/speed_filter.cpp",
        "plugins/costmap_filters/binary_filter.cpp",
    ],
    hdrs = glob(["include/nav2_costmap_2d/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = [
        ":nav2_costmap_2d_core",
        "@nav2_msgs//:cpp_nav2_msgs",
        "@nav2_util//:nav2_util",
        "@ros2_common_interfaces//:cpp_geometry_msgs",
        "@ros2_common_interfaces//:cpp_nav_msgs",
        "@ros2_common_interfaces//:cpp_std_msgs",
        "@ros2_rclcpp//:rclcpp",
        "@ros2_rclcpp//:rclcpp_lifecycle",
        "@ros2_common_interfaces//:cpp_std_srvs",
        "@ros2_geometry2//:tf2",
        "@ros2_geometry2//:tf2_ros",
        "@ros2_geometry2//:cpp_tf2_geometry_msgs",
        "@ros2_pluginlib//:pluginlib",
        "@system_libs//:eigen",
        "@map_msgs//:cpp_map_msgs",
        "@angles//:angles",
    ],
)

# 4. nav2_costmap_2d_client Shared Library
ros2_cpp_library(
    name = "nav2_costmap_2d_client",
    srcs = [
        "src/footprint_subscriber.cpp",
        "src/costmap_subscriber.cpp",
        "src/costmap_topic_collision_checker.cpp",
    ],
    hdrs = glob(["include/nav2_costmap_2d/**/*.hpp"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = [
        ":nav2_costmap_2d_core",
        "@nav2_msgs//:cpp_nav2_msgs",
        "@nav2_util//:nav2_util",
        "@ros2_common_interfaces//:cpp_geometry_msgs",
        "@ros2_common_interfaces//:cpp_nav_msgs",
        "@ros2_common_interfaces//:cpp_std_msgs",
        "@ros2_rclcpp//:rclcpp",
        "@ros2_rclcpp//:rclcpp_lifecycle",
        "@ros2_common_interfaces//:cpp_std_srvs",
        "@ros2_geometry2//:tf2",
        "@ros2_geometry2//:tf2_ros",
        "@ros2_geometry2//:cpp_tf2_geometry_msgs",
        "@ros2_pluginlib//:pluginlib",
        "@system_libs//:eigen",
        "@map_msgs//:cpp_map_msgs",
        "@angles//:angles",
    ],
)

# 5. Executables
ros2_cpp_binary(
    name = "nav2_costmap_2d_markers",
    srcs = ["src/costmap_2d_markers.cpp"],
    deps = [
        ":nav2_costmap_2d_core",
    ],
)

ros2_cpp_binary(
    name = "nav2_costmap_2d_cloud",
    srcs = ["src/costmap_2d_cloud.cpp"],
    deps = [
        ":nav2_costmap_2d_core",
    ],
)

ros2_cpp_binary(
    name = "nav2_costmap_2d",
    srcs = ["src/costmap_2d_node.cpp"],
    deps = [
        ":nav2_costmap_2d_core",
        ":layers",
        ":filters",
    ],
)

