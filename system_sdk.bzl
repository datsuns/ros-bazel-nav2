def _system_sdk_repo_impl(repository_ctx):
    repository_ctx.symlink("/usr/include/GraphicsMagick", "graphicsmagick_include")
    repository_ctx.symlink("/opt/ros/humble/include/bondcpp", "bondcpp_include")
    repository_ctx.symlink("/opt/ros/humble/include/bond", "bond_include")
    repository_ctx.symlink("/opt/ros/humble/include/smclib", "smclib_include")
    repository_ctx.symlink("/opt/ros/humble/lib", "ros_lib")
    repository_ctx.symlink("/usr/lib/x86_64-linux-gnu", "lib_x86_64")
    repository_ctx.symlink("/usr/lib", "lib")
    repository_ctx.symlink("/usr/include/eigen3", "eigen3_include")
    repository_ctx.symlink("/opt/ros/humble/include/laser_geometry", "laser_geometry_include")
    repository_ctx.symlink("/opt/ros/humble/include/map_msgs", "map_msgs_include")
    repository_ctx.symlink("/opt/ros/humble/include/angles", "angles_include")
    repository_ctx.symlink("/usr/include/opencv4", "opencv4_include")
    repository_ctx.symlink("/opt/ros/humble/include/cv_bridge", "cv_bridge_include")
    repository_ctx.symlink("/opt/ros/humble/include/image_transport", "image_transport_include")
    repository_ctx.symlink("/opt/ros/humble/include/ompl-1.7", "ompl_include")
    repository_ctx.symlink("/opt/ros/humble/lib/x86_64-linux-gnu", "ros_lib_x86_64")
    repository_ctx.symlink("/usr/include/ceres", "ceres_include")
    repository_ctx.symlink("/usr/include/xtensor", "xtensor_include")
    repository_ctx.symlink("/usr/include/xsimd", "xsimd_include")
    repository_ctx.symlink("/usr/include/xtl", "xtl_include")
    repository_ctx.symlink("/opt/ros/humble/include/behaviortree_cpp_v3", "ros_include/behaviortree_cpp_v3")
    
    repository_ctx.file("BUILD.bazel", """
package(default_visibility = ["//visibility:public"])

cc_library(
    name = "graphicsmagick",
    hdrs = [],
    includes = ["graphicsmagick_include"],
    srcs = ["lib/libGraphicsMagick++.so", "lib/libGraphicsMagick.so"],
)

cc_library(
    name = "yaml-cpp",
    srcs = ["lib_x86_64/libyaml-cpp.so"],
)

cc_library(
    name = "bondcpp",
    hdrs = [],
    includes = [
        "bondcpp_include", 
        "bond_include",
        "smclib_include",
    ],
    srcs = [
        "ros_lib/libbondcpp.so",
    ] + glob(["ros_lib/libbond__*.so"]),
)

cc_library(
    name = "eigen",
    hdrs = glob(["eigen3_include/**/*"]),
    includes = ["eigen3_include"],
)

cc_library(
    name = "laser_geometry",
    hdrs = glob(["laser_geometry_include/**/*"]),
    includes = ["laser_geometry_include"],
    srcs = ["ros_lib/liblaser_geometry.so"],
)

cc_library(
    name = "map_msgs",
    hdrs = glob(["map_msgs_include/**/*"]),
    includes = ["map_msgs_include"],
    srcs = [
        "ros_lib/libmap_msgs__rosidl_generator_c.so",
        "ros_lib/libmap_msgs__rosidl_typesupport_cpp.so",
        "ros_lib/libmap_msgs__rosidl_typesupport_c.so",
        "ros_lib/libmap_msgs__rosidl_typesupport_fastrtps_cpp.so",
        "ros_lib/libmap_msgs__rosidl_typesupport_fastrtps_c.so",
        "ros_lib/libmap_msgs__rosidl_typesupport_introspection_cpp.so",
        "ros_lib/libmap_msgs__rosidl_typesupport_introspection_c.so",
    ],
)

cc_library(
    name = "angles",
    hdrs = glob(["angles_include/**/*"]),
    includes = ["angles_include"],
)

cc_library(
    name = "opencv",
    hdrs = glob(["opencv4_include/**/*"]),
    includes = ["opencv4_include"],
    linkopts = [
        "-lopencv_core",
        "-lopencv_imgproc",
        "-lopencv_imgcodecs",
        "-lopencv_highgui",
    ],
)

cc_library(
    name = "cv_bridge",
    hdrs = glob(["cv_bridge_include/**/*"]),
    includes = ["cv_bridge_include"],
    srcs = ["ros_lib/libcv_bridge.so"],
    deps = [
        ":opencv",
        "@ros2_common_interfaces//:cpp_sensor_msgs",
    ],
)

cc_library(
    name = "image_transport",
    hdrs = glob(["image_transport_include/**/*"]),
    includes = ["image_transport_include"],
    srcs = ["ros_lib/libimage_transport.so"],
    deps = [
        "@ros2_rclcpp//:rclcpp",
        "@ros2_common_interfaces//:cpp_sensor_msgs",
    ],
)

cc_library(
    name = "ompl",
    hdrs = glob(["ompl_include/**/*"]),
    includes = ["ompl_include"],
    srcs = ["ros_lib_x86_64/libompl.so"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "ceres",
    hdrs = glob(["ceres_include/**/*"]),
    includes = ["ceres_include"],
    srcs = ["lib/libceres.so"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "xtl",
    hdrs = glob(["xtl_include/**/*"]),
    includes = ["xtl_include"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "xsimd",
    hdrs = glob(["xsimd_include/**/*"]),
    includes = ["xsimd_include"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "xtensor",
    hdrs = glob(["xtensor_include/**/*"]),
    includes = ["xtensor_include"],
    visibility = ["//visibility:public"],
    deps = [
        ":xtl",
        ":xsimd",
    ],
)

cc_library(
    name = "behaviortree_cpp_v3",
    hdrs = glob(["ros_include/behaviortree_cpp_v3/**/*"]),
    includes = ["ros_include"],
    srcs = ["ros_lib/libbehaviortree_cpp_v3.so"],
    visibility = ["//visibility:public"],
)
""")

system_sdk_repo = repository_rule(
    implementation = _system_sdk_repo_impl,
)

