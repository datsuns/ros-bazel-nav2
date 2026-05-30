# /opt/ros 依存削減（ソースビルド移行）計画

本計画は、現在 `system_sdk.bzl` 経由で `/opt/ros/humble` からリンクしている ROS 2 パッケージ群を、Bazel を用いてソースコードから直接ビルドする方式へ移行するためのステップを定義します。
全てのビルド検証作業は、Docker コンテナ `jovial_taussig` 上で実行することを前提とします。

## 1. 移行対象の選定

`system_sdk.bzl` の定義に基づき、現在 `/opt/ros/humble` に依存している以下のパッケージ群を移行対象とします。

*   **メッセージ系**: `map_msgs`
*   **ユーティリティ・基盤系**: `bond_core` (`bond`, `bondcpp`, `smclib`), `angles`
*   **センサー・画像系**: `laser_geometry`, `cv_bridge` (from `vision_opencv`), `image_transport` (from `image_common`)
*   **外部ライブラリ (ROS経由)**: `behaviortree_cpp_v3`, `ompl`

※ `yaml-cpp`, `GraphicsMagick`, `eigen3` などの `/usr` 依存の純粋なシステムライブラリは、本フェーズでは移行対象外（継続して `system_sdk.bzl` を使用）とします。

## 2. 移行アプローチ

各ターゲットパッケージに対し、以下の手順で Bazel ビルド化を進めます。

### Step 2.1: ソースコードの取得 (WORKSPACE への追加)
`WORKSPACE` ファイルに `http_archive` または `git_repository` を追加し、各パッケージのソースコード（対象バージョンのタグ）を取得します。

**例:**
```starlark
http_archive(
    name = "bond_core",
    urls = ["https://github.com/ros/bond_core/archive/refs/tags/3.0.2.tar.gz"],
    strip_prefix = "bond_core-3.0.2",
    build_file = "//3rdparty/bazel:bond_core.BUILD",
)
```

### Step 2.2: 外部 BUILD ファイルの作成
`3rdparty/bazel/` ディレクトリ配下に、各パッケージ用のビルドルール（`*.BUILD`）を作成します。
*   メッセージパッケージ（`map_msgs`, `bond` 等）には `rules_ros2` の `ros2_interface_library` 等を利用。
*   C++ ライブラリには `ros2_cpp_library` 等を利用し、必要な依存関係（`deps`）を定義します。

### Step 2.3: `system_sdk.bzl` の整理
該当パッケージのビルドが Bazel 上で成功した後、`system_sdk.bzl` から該当するシンボリックリンク作成処理と `cc_library` 定義を削除します。

### Step 2.4: 依存元の参照先更新
`nav2` パッケージ群（`BUILD.bazel` や `3rdparty/bazel/*.BUILD`）における依存先を、`@system_libs//:xxx` から新規作成したリポジトリ（例: `@bond_core//:bondcpp`）に変更します。

## 3. フェーズごとの作業計画

安全に移行を進めるため、以下のフェーズに分けて順次対応・検証を行います。
## 3. フェーズごとの作業計画（完了済み）

### Phase 1: 独立性の高いユーティリティ・メッセージの移行 - **完了**
*   **対象**: `angles`, `map_msgs`
*   **成果**: ソースコードからのビルドに成功。

### Phase 2: `bond_core` パッケージ群の移行 - **完了**
*   **対象**: `bond_core` (`bond`, `bondcpp`, `smclib`)
*   **成果**: `uuid` 依存の解決を含め、ソースビルドに成功。

### Phase 3: センサー・画像系ライブラリの移行 - **完了**
*   **対象**: `laser_geometry`, `image_transport`, `cv_bridge`
*   **成果**: `cv_bridge_export.h` の生成や実行ファイルの除外などの調整を行い、ビルド成功。

### Phase 4: 大型外部ライブラリの移行 - **完了**
*   **対象**: `behaviortree_cpp_v3`, `ompl`
*   **成果**: `Boost` 依存の解決、`BT_BOOST_COROUTINE` の定義、`ompl/config.h` の生成などを行い、ソースビルドに成功。

## 4. ビルド検証手順（jovial_taussig コンテナ上）

各フェーズの完了ごとに、Docker コンテナ `jovial_taussig` 内で以下のコマンドを実行し、ビルドの健全性を確認します。

1. **コンテナ内でのコマンド実行**:
   ```bash
   docker exec jovial_taussig bash -c "cd /workspaces/map_server && bazel build //..."
   ```
2. **実行確認**:
   移行したパッケージを利用するバイナリ（例: `map_server` や `amcl`）が、正しくリンクされ実行できるかを検証します。
   ```bash
   docker exec jovial_taussig bash -c "cd /workspaces/map_server && bazel run //:map_server"
   ```

## 5. 期待される成果
*   `/opt/ros/humble` への依存が最小化され、異なる環境（ROS 2 が未インストール等）でも Bazel だけでビルド可能な自己完結性の高い（Hermetic な）ビルドが実現します。
*   ソースコードからのビルドにより、将来のバージョンアップやクロスコンパイルへの対応が容易になります。
