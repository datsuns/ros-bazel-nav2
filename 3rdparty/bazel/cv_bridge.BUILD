load("@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl", "ros2_cpp_library")

ros2_cpp_library(
    name = "cv_bridge",
    srcs = [
        "src/cv_bridge.cpp",
        "src/rgb_colors.cpp",
    ],
    hdrs = glob(["include/cv_bridge/*.h", "include/cv_bridge/*.hpp"]) + [":cv_bridge_export_h", ":cv_bridge_hpp"],
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = [
        "@ros2_common_interfaces//:cpp_sensor_msgs",
        "@system_libs//:opencv",
    ],
)

genrule(
    name = "cv_bridge_export_h",
    outs = ["include/cv_bridge/cv_bridge_export.h"],
    cmd = "printf '#ifndef CV_BRIDGE_EXPORT_H\\n#define CV_BRIDGE_EXPORT_H\\n#define CV_BRIDGE_EXPORT\\n#define CV_BRIDGE_NO_EXPORT\\n#define CV_BRIDGE_DEPRECATED\\n#define CV_BRIDGE_DEPRECATED_EXPORT\\n#define CV_BRIDGE_DEPRECATED_NO_EXPORT\\n#endif\\n' > $@",
)

genrule(
    name = "cv_bridge_hpp",
    outs = ["include/cv_bridge/cv_bridge.hpp"],
    cmd = "printf '#include \"cv_bridge/cv_bridge.h\"\\n' > $@",
)


