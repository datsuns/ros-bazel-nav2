workspace(name = "map_server_workspace")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

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
