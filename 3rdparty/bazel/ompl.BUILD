cc_library(
    name = "ompl",
    srcs = glob([
        "src/ompl/base/**/*.cpp",
        "src/ompl/control/**/*.cpp",
        "src/ompl/geometric/**/*.cpp",
        "src/ompl/util/**/*.cpp",
    ]),
    hdrs = glob([
        "src/ompl/base/**/*.h",
        "src/ompl/base/**/*.hpp",
        "src/ompl/control/**/*.h",
        "src/ompl/control/**/*.hpp",
        "src/ompl/geometric/**/*.h",
        "src/ompl/geometric/**/*.hpp",
        "src/ompl/util/**/*.h",
        "src/ompl/util/**/*.hpp",
    ]) + [":ompl_config_h"],
    includes = ["src"],
    visibility = ["//visibility:public"],
    deps = [
        "@system_libs//:eigen",
        "@system_libs//:boost",
    ],
    linkopts = ["-lpthread"],
)

genrule(
    name = "ompl_config_h",
    outs = ["src/ompl/config.h"],
    cmd = "printf '#ifndef OMPL_CONFIG_\\n#define OMPL_CONFIG_\\n#define OMPL_VERSION \"1.7.0\"\\n#define OMPL_MAJOR_VERSION 1\\n#define OMPL_MINOR_VERSION 7\\n#define OMPL_PATCH_VERSION 0\\n#define OMPL_VERSION_VALUE ( OMPL_MAJOR_VERSION * 1000000 + OMPL_MINOR_VERSION * 1000 + OMPL_PATCH_VERSION)\\n#define OMPL_HAVE_FLANN 0\\n#define OMPL_HAVE_SPOT 0\\n#define OMPL_HAVE_NUMPY 0\\n#endif\\n' > $@",
)

