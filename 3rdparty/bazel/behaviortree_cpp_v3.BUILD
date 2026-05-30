cc_library(
    name = "behaviortree_cpp_v3",
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
        "3rdparty/minitrace/*.h",
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
        "@system_libs//:boost",
    ],
    visibility = ["//visibility:public"],
)

