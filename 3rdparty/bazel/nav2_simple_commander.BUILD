load("@rules_python//python:defs.bzl", "py_library", "py_binary")

py_library(
    name = "nav2_simple_commander",
    srcs = glob(["nav2_simple_commander/*.py"]),
    visibility = ["//visibility:public"],
)

py_binary(
    name = "example_nav_to_pose",
    srcs = ["nav2_simple_commander/example_nav_to_pose.py"],
    main = "nav2_simple_commander/example_nav_to_pose.py",
    deps = [":nav2_simple_commander"],
    visibility = ["//visibility:public"],
)

py_binary(
    name = "example_nav_through_poses",
    srcs = ["nav2_simple_commander/example_nav_through_poses.py"],
    main = "nav2_simple_commander/example_nav_through_poses.py",
    deps = [":nav2_simple_commander"],
    visibility = ["//visibility:public"],
)

py_binary(
    name = "example_waypoint_follower",
    srcs = ["nav2_simple_commander/example_waypoint_follower.py"],
    main = "nav2_simple_commander/example_waypoint_follower.py",
    deps = [":nav2_simple_commander"],
    visibility = ["//visibility:public"],
)

