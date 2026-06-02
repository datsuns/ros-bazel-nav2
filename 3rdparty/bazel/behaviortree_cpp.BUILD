cc_library(
    name = "behaviortree_cpp",
    srcs = glob([
        "src/*.cpp",
        "src/actions/*.cpp",
        "src/controls/*.cpp",
        "src/decorators/*.cpp",
        "src/loggers/*.cpp",
        "3rdparty/tinyxml2/tinyxml2.cpp",
        "3rdparty/minitrace/minitrace.cpp",
        "3rdparty/lexy/src/input/file.cpp",
    ], exclude = [
        "src/example.cpp",
        "src/shared_library_WIN.cpp",
    ]),
    hdrs = glob([
        "include/behaviortree_cpp/**/*.h",
        "include/behaviortree_cpp/**/*.hpp",
        "3rdparty/tinyxml2/tinyxml2.h",
        "3rdparty/minicoro/minicoro.h",
        "3rdparty/minitrace/minitrace.h",
        "3rdparty/wildcards/wildcards.hpp",
        "3rdparty/lexy/include/**/*.hpp",
        "3rdparty/lexy/include/**/*.h",
    ]),
    includes = [
        "include",
        "3rdparty",
        "3rdparty/lexy/include",
    ],
    defines = [
        "BT_ZMQ_ENABLED",
        "BTCPP_LIBRARY_VERSION=\\\"4.6.2\\\"",
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
