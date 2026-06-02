cc_library(
    name = "minitrace",
    hdrs = glob(["3rdparty/minitrace/*.h"]),
    strip_include_prefix = "3rdparty",
)

# Implementation library with original include paths (behaviortree_cpp_v3/...)
cc_library(
    name = "behaviortree_cpp_v3_impl",
    srcs = glob([
        "src/*.cpp",
        "src/actions/*.cpp",
        "src/conditions/*.cpp",
        "src/controls/*.cpp",
        "src/decorators/*.cpp",
        "src/loggers/*.cpp",
        "3rdparty/minitrace/minitrace.cpp",
    ], exclude = [
        "src/example.cpp",
        "src/manual_metadata.cpp",
        "src/shared_library_WIN.cpp",
    ]),
    hdrs = glob([
        "include/behaviortree_cpp_v3/**/*.h",
    ]),
    includes = ["include", "3rdparty"],
    defines = [
        "BT_ZMQ_ENABLED",
        "BT_BOOST_COROUTINE",
    ],
    linkopts = [
        "-lpthread",
        "-lzmq",
    ],
    deps = [
        ":minitrace",
        "@system_libs//:boost",
    ],
    visibility = ["//visibility:private"],
)

# Public alias/wrapper library that exposes headers with the "behaviortree_cpp/" prefix
cc_library(
    name = "behaviortree_cpp_v3",
    hdrs = glob([
        "include/behaviortree_cpp_v3/**/*.h",
    ]),
    strip_include_prefix = "include/behaviortree_cpp_v3",
    include_prefix = "behaviortree_cpp",
    deps = [
        ":behaviortree_cpp_v3_impl",
    ],
    visibility = ["//visibility:public"],
)
