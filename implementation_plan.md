# 作業方針：ROS 2 nav2_map_server ビルド依存関係解析と Bazel (WORKSPACE形式) 移行

本プロジェクトでは、Bzlmod形式から非Bzlmod（WORKSPACE形式）の管理に切り替えてビルド可能なワークスペースを構築します。

## User Review Required

> [!IMPORTANT]
> - 本移行により、依存関係の解決方法が `MODULE.bazel` から `WORKSPACE` ファイルへと切り替わります。
> - Bzlmod を無効化するため、`.bazelrc` に `common --noenable_bzlmod` を指定します。
> - `system_sdk.bzl` の `module_extension` 定義を廃止し、`WORKSPACE` から `repository_rule` を直接呼び出す形式に変更します。

## Proposed Changes

### [Bazel Configuration]

#### [MODIFY] [.bazelrc](file:///workspaces/map_server/.bazelrc)
Bzlmod を無効化するオプションを追加します。
```
common --noenable_bzlmod
```

#### [NEW] [WORKSPACE](file:///workspaces/map_server/WORKSPACE)
`rules_ros2` およびその依存、システムライブラリ（`system_libs`）をロードする非Bzlmod設定ファイルを新規作成します。

#### [DELETE] [MODULE.bazel](file:///workspaces/map_server/MODULE.bazel)
不要となった Bzlmod モジュール設定ファイルを削除します。

#### [MODIFY] [system_sdk.bzl](file:///workspaces/map_server/system_sdk.bzl)
Bzlmod用の `module_extension` のコードを削除し、`repository_rule` のみをエクスポートするように修正します。

---

## Verification Plan

### Automated Tests
以下のコマンドを実行して、WORKSPACE形式でのビルドが正常に通ることを検証します。
```bash
bazel build //...
```
また、動作確認のため `bazel run //:map_server` を実行して、実行時依存の RMW 読み込みなどのシーケンスに入ることを確認します。
