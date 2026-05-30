load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_binary",
    "ros2_cpp_library",
)

# 1. pf_lib
ros2_cpp_library(
    name = "pf_lib",
    srcs = [
        "src/pf/pf.c",
        "src/pf/pf_kdtree.c",
        "src/pf/pf_pdf.c",
        "src/pf/pf_vector.c",
        "src/pf/eig3.c",
        "src/pf/pf_draw.c",
    ],
    hdrs = glob(["src/pf/*.h", "src/include/pf/*.h", "include/nav2_amcl/pf/*.hpp"]),
    includes = ["include", "src/include"],
    local_defines = ["HAVE_DRAND48"],
    visibility = ["//visibility:public"],
)

# 2. map_lib
ros2_cpp_library(
    name = "map_lib",
    srcs = [
        "src/map/map.c",
        "src/map/map_range.c",
        "src/map/map_draw.c",
        "src/map/map_cspace.cpp",
    ],
    hdrs = glob(["src/map/*.h", "src/include/map/*.h", "include/nav2_amcl/map/*.hpp"]),
    includes = ["include", "src/include"],
    visibility = ["//visibility:public"],
)

# 3. motions_lib
ros2_cpp_library(
    name = "motions_lib",
    srcs = [
        "src/motion_model/omni_motion_model.cpp",
        "src/motion_model/differential_motion_model.cpp",
    ],
    hdrs = glob(["src/include/motion_model/*.hpp", "include/nav2_amcl/motion_model/*.hpp"]),
    includes = ["include", "src/include"],
    visibility = ["//visibility:public"],
    deps = [
        ":pf_lib",
        "@ros2_pluginlib//:pluginlib",
        "@map_server_workspace//:nav2_util",
        "@ros2_rclcpp//:rclcpp",
    ],
)

# 4. sensors_lib
ros2_cpp_library(
    name = "sensors_lib",
    srcs = [
        "src/sensors/laser/laser.cpp",
        "src/sensors/laser/beam_model.cpp",
        "src/sensors/laser/likelihood_field_model.cpp",
        "src/sensors/laser/likelihood_field_model_prob.cpp",
    ],
    hdrs = glob(["src/include/sensors/**/*.hpp", "src/include/sensors/**/*.h", "include/nav2_amcl/sensors/**/*.hpp"]),
    includes = ["include", "src/include"],
    visibility = ["//visibility:public"],
    deps = [
        ":pf_lib",
        ":map_lib",
        "@ros2_rclcpp//:rclcpp",
    ],
)

COMMON_DEPS = [
    "@ros2_rclcpp//:rclcpp",
    "@ros2_rclcpp//:rclcpp_lifecycle",
    "@ros2_rclcpp//:rclcpp_components",
    "@ros2_message_filters//:message_filters",
    "@ros2_geometry2//:cpp_tf2_geometry_msgs",
    "@ros2_common_interfaces//:cpp_geometry_msgs",
    "@ros2_common_interfaces//:c_geometry_msgs",
    "@ros2_common_interfaces//:cpp_nav_msgs",
    "@ros2_common_interfaces//:cpp_sensor_msgs",
    "@ros2_common_interfaces//:cpp_std_srvs",
    "@ros2_geometry2//:tf2_ros",
    "@ros2_geometry2//:tf2",
    "@map_server_workspace//:nav2_util",
    "@map_server_workspace//:cpp_nav2_msgs",
    "@ros2_pluginlib//:pluginlib",
]

# 5. amcl_core
ros2_cpp_library(
    name = "amcl_core",
    srcs = [
        "src/amcl_node.cpp",
    ],
    hdrs = glob(["include/nav2_amcl/**/*.hpp"]),
    includes = ["include", "src/include"],
    local_defines = ["HAVE_DRAND48"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS + [
        ":pf_lib",
        ":map_lib",
        ":motions_lib",
        ":sensors_lib",
    ],
)

# 6. amcl (executable)
ros2_cpp_binary(
    name = "amcl",
    srcs = [
        "src/main.cpp",
    ],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS + [
        ":amcl_core",
    ],
)
