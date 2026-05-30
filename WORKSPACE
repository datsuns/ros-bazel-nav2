workspace(name = "map_server_workspace")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//3rdparty/bazel:patched_local_repository.bzl", "patched_local_repository")

# Bzlmod-free workaround for protobuf dependency rules
http_archive(
    name = "proto_bazel_features",
    sha256 = "bdc12fcbe6076180d835c9dd5b3685d509966191760a0eb10b276025fcb76158",
    strip_prefix = "bazel_features-1.17.0",
    urls = ["https://github.com/bazel-contrib/bazel_features/archive/refs/tags/v1.17.0.tar.gz"],
)

# rules_ros2 の取得 (指定コミット)
http_archive(
    name = "com_github_mvukov_rules_ros2",
    strip_prefix = "rules_ros2-5308eab4530909c19ee8535fc533655a3397158a",
    url = "https://github.com/mvukov/rules_ros2/archive/5308eab4530909c19ee8535fc533655a3397158a.tar.gz",
)

# rules_ros2 の依存関係ロード
load("@com_github_mvukov_rules_ros2//repositories:repositories.bzl", "ros2_repositories", "ros2_workspace_repositories")

ros2_workspace_repositories()
ros2_repositories()

load("@com_github_mvukov_rules_ros2//repositories:deps.bzl", "ros2_deps")

ros2_deps()

# Python ツールのセットアップ
load("@rules_python//python:repositories.bzl", "py_repositories", "python_register_toolchains")

py_repositories()

python_register_toolchains(
    name = "rules_ros2_python",
    python_version = "3.10",
)

# pip 依存関係
load("@rules_python//python:pip.bzl", "pip_parse")

pip_parse(
    name = "rules_ros2_pip_deps",
    python_interpreter_target = "@rules_ros2_python_host//:python",
    requirements_lock = "@com_github_mvukov_rules_ros2//:requirements_lock.txt",
)

load(
    "@rules_ros2_pip_deps//:requirements.bzl",
    install_rules_ros2_pip_deps = "install_deps",
)

install_rules_ros2_pip_deps()

# 自前のシステムライブラリ定義
load("//:system_sdk.bzl", "system_sdk_repo")

system_sdk_repo(name = "system_libs")

# Navigation2 packages mapped externally
new_local_repository(
    name = "nav2_voxel_grid",
    path = "src/navigation2/nav2_voxel_grid",
    build_file = "//3rdparty/bazel:nav2_voxel_grid.BUILD",
)

new_local_repository(
    name = "nav_2d_msgs",
    path = "src/navigation2/nav2_dwb_controller/nav_2d_msgs",
    build_file = "//3rdparty/bazel:nav_2d_msgs.BUILD",
)

new_local_repository(
    name = "dwb_msgs",
    path = "src/navigation2/nav2_dwb_controller/dwb_msgs",
    build_file = "//3rdparty/bazel:dwb_msgs.BUILD",
)

new_local_repository(
    name = "nav2_costmap_2d",
    path = "src/navigation2/nav2_costmap_2d",
    build_file = "//3rdparty/bazel:nav2_costmap_2d.BUILD",
)

new_local_repository(
    name = "nav2_core",
    path = "src/navigation2/nav2_core",
    build_file = "//3rdparty/bazel:nav2_core.BUILD",
)

new_local_repository(
    name = "nav_2d_utils",
    path = "src/navigation2/nav2_dwb_controller/nav_2d_utils",
    build_file = "//3rdparty/bazel:nav_2d_utils.BUILD",
)

new_local_repository(
    name = "costmap_queue",
    path = "src/navigation2/nav2_dwb_controller/costmap_queue",
    build_file = "//3rdparty/bazel:costmap_queue.BUILD",
)

new_local_repository(
    name = "nav2_lifecycle_manager",
    path = "src/navigation2/nav2_lifecycle_manager",
    build_file = "//3rdparty/bazel:nav2_lifecycle_manager.BUILD",
)

new_local_repository(
    name = "nav2_velocity_smoother",
    path = "src/navigation2/nav2_velocity_smoother",
    build_file = "//3rdparty/bazel:nav2_velocity_smoother.BUILD",
)

new_local_repository(
    name = "nav2_collision_monitor",
    path = "src/navigation2/nav2_collision_monitor",
    build_file = "//3rdparty/bazel:nav2_collision_monitor.BUILD",
)

new_local_repository(
    name = "nav2_planner",
    path = "src/navigation2/nav2_planner",
    build_file = "//3rdparty/bazel:nav2_planner.BUILD",
)

new_local_repository(
    name = "nav2_controller",
    path = "src/navigation2/nav2_controller",
    build_file = "//3rdparty/bazel:nav2_controller.BUILD",
)

new_local_repository(
    name = "nav2_smoother",
    path = "src/navigation2/nav2_smoother",
    build_file = "//3rdparty/bazel:nav2_smoother.BUILD",
)

new_local_repository(
    name = "nav2_navfn_planner",
    path = "src/navigation2/nav2_navfn_planner",
    build_file = "//3rdparty/bazel:nav2_navfn_planner.BUILD",
)

new_local_repository(
    name = "nav2_regulated_pure_pursuit_controller",
    path = "src/navigation2/nav2_regulated_pure_pursuit_controller",
    build_file = "//3rdparty/bazel:nav2_regulated_pure_pursuit_controller.BUILD",
)

new_local_repository(
    name = "nav2_rotation_shim_controller",
    path = "src/navigation2/nav2_rotation_shim_controller",
    build_file = "//3rdparty/bazel:nav2_rotation_shim_controller.BUILD",
)

new_local_repository(
    name = "dwb_core",
    path = "src/navigation2/nav2_dwb_controller/dwb_core",
    build_file = "//3rdparty/bazel:dwb_core.BUILD",
)

new_local_repository(
    name = "dwb_critics",
    path = "src/navigation2/nav2_dwb_controller/dwb_critics",
    build_file = "//3rdparty/bazel:dwb_critics.BUILD",
)

new_local_repository(
    name = "dwb_plugins",
    path = "src/navigation2/nav2_dwb_controller/dwb_plugins",
    build_file = "//3rdparty/bazel:dwb_plugins.BUILD",
)

new_local_repository(
    name = "nav2_amcl",
    path = "src/navigation2/nav2_amcl",
    build_file = "//3rdparty/bazel:nav2_amcl.BUILD",
)

new_local_repository(
    name = "nav2_waypoint_follower",
    path = "src/navigation2/nav2_waypoint_follower",
    build_file = "//3rdparty/bazel:nav2_waypoint_follower.BUILD",
)

new_local_repository(
    name = "nav2_smac_planner",
    path = "src/navigation2/nav2_smac_planner",
    build_file = "//3rdparty/bazel:nav2_smac_planner.BUILD",
)

new_local_repository(
    name = "nav2_constrained_smoother",
    path = "src/navigation2/nav2_constrained_smoother",
    build_file = "//3rdparty/bazel:nav2_constrained_smoother.BUILD",
)

new_local_repository(
    name = "nav2_mppi_controller",
    path = "src/navigation2/nav2_mppi_controller",
    build_file = "//3rdparty/bazel:nav2_mppi_controller.BUILD",
)

patched_local_repository(
    name = "nav2_behavior_tree",
    path = "src/navigation2/nav2_behavior_tree",
    build_file = "//3rdparty/bazel:nav2_behavior_tree.BUILD",
    patches = ["//patches:nav2_behavior_tree_fix_path_headers.patch"],
    patch_strip = 2,
)


new_local_repository(
    name = "nav2_bt_navigator",
    path = "src/navigation2/nav2_bt_navigator",
    build_file = "//3rdparty/bazel:nav2_bt_navigator.BUILD",
)

new_local_repository(
    name = "nav2_simple_commander",
    path = "src/navigation2/nav2_simple_commander",
    build_file = "//3rdparty/bazel:nav2_simple_commander.BUILD",
)

new_local_repository(
    name = "nav2_bringup",
    path = "src/navigation2/nav2_bringup",
    build_file = "//3rdparty/bazel:nav2_bringup.BUILD",
)

















