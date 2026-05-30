# nav2_bringup は C++ コードを持たない launch/config ファイルのみのパッケージ。
# filegroup として launch/params/maps/rviz/worlds/urdf ファイルを公開する。

filegroup(
    name = "launch_files",
    srcs = glob(["launch/**"]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "params_files",
    srcs = glob(["params/**"]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "maps_files",
    srcs = glob(["maps/**"]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "rviz_files",
    srcs = glob(["rviz/**"]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "worlds_files",
    srcs = glob(["worlds/**"]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "urdf_files",
    srcs = glob(["urdf/**"]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "all_data",
    srcs = [
        ":launch_files",
        ":params_files",
        ":maps_files",
        ":rviz_files",
        ":worlds_files",
        ":urdf_files",
    ],
    visibility = ["//visibility:public"],
)

