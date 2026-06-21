load("@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl", "ros2_cpp_library")

ros2_cpp_library(
    name = "resource_retriever",
    srcs = glob(["resource_retriever/src/*.cpp"]),
    hdrs = glob(["resource_retriever/include/**/*.h"]),
    includes = ["resource_retriever/include"],
    visibility = ["//visibility:public"],
    deps = [
        "@ros2_ament_index//:ament_index_cpp",
        "@ros2_rclcpp//:rclcpp",
        "@system_libs//:curl",
    ],
)
