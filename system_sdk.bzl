def _system_sdk_repo_impl(repository_ctx):
    repository_ctx.symlink("/usr/include/GraphicsMagick", "graphicsmagick_include")
    repository_ctx.symlink("/usr/lib/x86_64-linux-gnu", "lib_x86_64")
    repository_ctx.symlink("/usr/lib", "lib")
    repository_ctx.symlink("/usr/include/eigen3", "eigen3_include")
    repository_ctx.symlink("/usr/include/opencv4", "opencv4_include")
    repository_ctx.symlink("/usr/include/ceres", "ceres_include")
    repository_ctx.symlink("/usr/include/xtensor", "xtensor_include")
    repository_ctx.symlink("/usr/include/xsimd", "xsimd_include")
    repository_ctx.symlink("/usr/include/xtl", "xtl_include")
    repository_ctx.symlink("/usr/include/boost", "boost_include/boost")
    repository_ctx.symlink("/usr/include/ompl-1.5/ompl", "ompl_include/ompl")
    
    repository_ctx.symlink("/usr/include/x86_64-linux-gnu/qt5", "qt5_include")
    repository_ctx.symlink("/usr/include/OGRE", "ogre_include/OGRE")
    repository_ctx.symlink("/usr/include/assimp", "assimp_include/assimp")
    repository_ctx.symlink("/usr/include/tinyxml2.h", "tinyxml2_include/tinyxml2.h")
    repository_ctx.symlink("/usr/include/urdfdom", "urdfdom_include/urdfdom")
    repository_ctx.symlink("/usr/include/urdfdom_headers", "urdfdom_headers_include/urdfdom_headers")
    repository_ctx.symlink("/usr/include/ignition/math6", "ignition_math6_include")
    
    repository_ctx.file("BUILD.bazel", """
package(default_visibility = ["//visibility:public"])

cc_library(
    name = "boost",
    hdrs = glob(["boost_include/boost/**/*"]),
    includes = ["boost_include"],
    linkopts = [
        "-lboost_system",
        "-lboost_coroutine",
        "-lboost_context",
        "-lboost_thread",
        "-lboost_chrono",
        "-lboost_atomic",
    ],
)

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
    name = "eigen",
    hdrs = glob(["eigen3_include/**/*"]),
    includes = ["eigen3_include"],
)

cc_library(
    name = "curl",
    hdrs = glob(["x86_64-linux-gnu_include/x86_64-linux-gnu/curl/**/*"]),
    includes = ["x86_64-linux-gnu_include/x86_64-linux-gnu"],
    linkopts = ["-lcurl"],
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
    name = "ompl",
    hdrs = glob(["ompl_include/ompl/**/*"]),
    includes = ["ompl_include"],
    srcs = ["lib_x86_64/libompl.so"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "qt5",
    hdrs = glob(["qt5_include/**/*"]),
    includes = [
        "qt5_include",
        "qt5_include/QtCore",
        "qt5_include/QtGui",
        "qt5_include/QtWidgets",
        "qt5_include/QtOpenGL",
        "qt5_include/QtSvg",
    ],
    linkopts = [
        "-lQt5Core",
        "-lQt5Gui",
        "-lQt5Widgets",
        "-lQt5OpenGL",
        "-lQt5Svg",
    ],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "ogre",
    hdrs = glob(["ogre_include/OGRE/**/*"]),
    includes = ["ogre_include", "ogre_include/OGRE", "ogre_include/OGRE/Overlay"],
    linkopts = [
        "-lOgreMain",
        "-lOgreOverlay",
    ],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "assimp",
    hdrs = glob(["assimp_include/assimp/**/*"]),
    includes = ["assimp_include"],
    linkopts = ["-lassimp"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "tinyxml2",
    hdrs = ["tinyxml2_include/tinyxml2.h"],
    includes = ["tinyxml2_include"],
    linkopts = ["-ltinyxml2"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "urdfdom",
    hdrs = glob(["urdfdom_include/urdfdom/**/*"]),
    includes = ["urdfdom_include"],
    linkopts = [
        "-lurdfdom_sensor",
        "-lurdfdom_model_state",
        "-lurdfdom_model",
        "-lurdfdom_world",
    ],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "urdfdom_headers",
    hdrs = glob(["urdfdom_headers_include/urdfdom_headers/**/*"]),
    includes = ["urdfdom_headers_include"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "ignition_math",
    hdrs = glob(["ignition_math6_include/**/*"]),
    includes = ["ignition_math6_include"],
    linkopts = ["-lignition-math6"],
    visibility = ["//visibility:public"],
)
""")

system_sdk_repo = repository_rule(
    implementation = _system_sdk_repo_impl,
)

# Force update
