"""
patched_local_repository: new_local_repository にパッチ適用機能を追加したカスタムリポジトリルール

ソースディレクトリの内容をコピーし、パッチを適用してからビルドに使用します。
これにより元のソースコードが汚染されることなく、Bazelビルド内でのみパッチが適用されます。

Usage in WORKSPACE:
    load("//3rdparty/bazel:patched_local_repository.bzl", "patched_local_repository")
    patched_local_repository(
        name = "nav2_behavior_tree",
        path = "src/navigation2/nav2_behavior_tree",
        build_file = "//3rdparty/bazel:nav2_behavior_tree.BUILD",
        patches = ["//patches:nav2_behavior_tree_fix_path_headers.patch"],
        patch_strip = 2,  # "nav2_behavior_tree/include/..." -> "include/..." となるよう2レベル除去
    )
"""

def _patched_local_repository_impl(repository_ctx):
    workspace_root = repository_ctx.workspace_root
    src_path = str(workspace_root) + "/" + repository_ctx.attr.path

    # ソースをリポジトリキャッシュディレクトリにコピー
    result = repository_ctx.execute(["cp", "-rL", src_path + "/.", "."])
    if result.return_code != 0:
        fail("Failed to copy source: {}".format(result.stderr))

    # パッチを順番に適用する (repository_ctx.patch は strip を指定できる)
    strip = repository_ctx.attr.patch_strip
    for patch_label in repository_ctx.attr.patches:
        patch_file = repository_ctx.path(patch_label)
        result = repository_ctx.execute(
            ["patch", "-p{}".format(strip), "--input=" + str(patch_file)],
        )
        if result.return_code != 0:
            fail("Failed to apply patch {} (p{}): stdout={} stderr={}".format(
                patch_label, strip, result.stdout, result.stderr
            ))

    # BUILD ファイルを配置する
    if repository_ctx.attr.build_file:
        build_file_path = repository_ctx.path(repository_ctx.attr.build_file)
        repository_ctx.symlink(build_file_path, "BUILD.bazel")
    elif repository_ctx.attr.build_file_content:
        repository_ctx.file("BUILD.bazel", repository_ctx.attr.build_file_content)

patched_local_repository = repository_rule(
    implementation = _patched_local_repository_impl,
    attrs = {
        "path": attr.string(
            mandatory = True,
            doc = "ワークスペースルートからの相対パス",
        ),
        "build_file": attr.label(
            allow_single_file = True,
            doc = "外部 BUILD ファイルへのラベル",
        ),
        "build_file_content": attr.string(
            doc = "BUILD ファイルの内容（build_file の代替）",
        ),
        "patches": attr.label_list(
            allow_files = True,
            doc = "適用するパッチファイルのリスト（git diff 形式）",
        ),
        "patch_strip": attr.int(
            default = 1,
            doc = "patch コマンドの -p オプション（除去するパスコンポーネント数）",
        ),
    },
    local = True,
)
