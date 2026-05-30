# Bazel 移行フェーズ1 実施レポート: ROS 2 nav2_map_server

## 1. 概要
本レポートは、ROS 2 Humble `nav2_map_server` および関連パッケージの Bazel (WORKSPACE形式) への移行フェーズ1の結果をまとめたものです。既存の CMake (colcon) 環境と並行して、Bazel による高速かつ再現性の高いビルド環境を構築しました。

## 2. Bazel 構成の基本方針
*   **非侵襲的（Non-invasive）統合**: 既存の ROS 2 ソースコードを一切変更せず、外部の `3rdparty/bazel/` ディレクトリでビルド設定を管理しています。
*   **WORKSPACE 形式の採用**: `rules_ros2` との互換性を重視し、Bzlmod を無効化した従来の `WORKSPACE` 管理を採用しています。
*   **システムSDKの活用**: ホスト OS の `/opt/ros/humble` や `/usr` にインストール済みのライブラリを `system_sdk.bzl` を通じて Bazel ターゲットとしてロードし、ビルドの効率化を図っています。

## 3. 依存関係の解決方針
1.  **ROS 2 コアパッケージ**: `rules_ros2` を使用して GitHub 等から外部リポジトリとして取得。
2.  **システム依存 (apt)**: `system_sdk.bzl` によりホストの `.so` やヘッダーを `cc_library` としてラッピング。
3.  **プロジェクト内パッケージ**: `WORKSPACE` の `new_local_repository` でローカルディレクトリを外部リポジトリとして定義。

## 4. ビルド環境の追加要件
以下のコンポーネントが開発環境にインストールされている必要があります。
*   **システムライブラリ**: `yaml-cpp`, `GraphicsMagick`, `Eigen3`, `ceres-solver`, `xtensor`, `xsimd`, `xtl`
*   **ROS 2 パッケージ**: `bondcpp`, `smclib`, `laser_geometry`, `map_msgs`, `angles`, `cv_bridge`, `behaviortree_cpp_v3`

## 5. 追加ファイルの構成
| ファイル/ディレクトリ | 内容 |
| :--- | :--- |
| `WORKSPACE` | プロジェクト全体のルート定義、外部リポジトリの登録。 |
| `BUILD.bazel` | ルートレベルの検証用ターゲット（`my_subscriber_node`等）のみを定義。 |
| `3rdparty/bazel/` | 全ての Nav2 パッケージ（`nav2_msgs.BUILD`, `nav2_util.BUILD`, `nav2_map_server.BUILD`, `nav2_amcl.BUILD` 等）のビルド定義。 |
| `system_sdk.bzl` | システムライブラリを Bazel にインポートするためのカスタムルール。 |
| `patches/` | ビルドエラー回避のためのソースコード修正用パッチ。 |

## 6. colcon と Bazel のビルド生成物比較

| 生成物カテゴリ | colcon (CMake) | Bazel (rules_ros2) | 判定 / 差異の説明 |
| :--- | :--- | :--- | :--- |
| **共有ライブラリ (map_io)** | `install/.../libmap_io.so` | `bazel-bin/libmap_io.so` | **一致**。正常に共有ライブラリが生成。 |
| **コアライブラリ** | `.../libmap_server_core.so` | `.../libmap_server_core.a` | **一部差異**。Bazelは静的リンクを優先。動作上問題なし。 |
| **実行バイナリ (map_server)** | `install/.../map_server` | `bazel-bin/map_server` | **一致**。バイナリは同等。 |
| **ヘッダーファイル** | `install/.../include/*.hpp` | なし (ソース直接参照) | **設計差異**。Bazelは物理コピーをせずサンドボックスで解決。 |
| **メッセージヘッダー** | `build/nav2_msgs/...` | `bazel-bin/nav2_msgs/...` | **一致**。自動生成ヘッダーが正しく配置。 |
| **環境セットアップ** | `setup.bash` 等 | なし (`runfiles` で代替) | **設計差異**。Bazelは自己完結型バイナリ（runfiles）を構築。 |

## 7. 確認済みパッケージと実行コマンド
以下のパッケージが Bazel で正常にビルド・実行可能であることを確認しました。

*   **AMCL の実行**:
    ```bash
    bazel run @nav2_amcl//:amcl
    ```
*   **Map Server の実行**:
    ```bash
    bazel run @nav2_map_server//:map_server
    ```

## 9. 主要なビルドコマンド
プロジェクトのビルドおよびパッケージごとのビルドに使用する主要なコマンドです。

*   **全ターゲットのビルド**:
    ```bash
    bazel build //...
    ```
*   **Map Server のビルド**:
    ```bash
    bazel build @nav2_map_server//:map_server
    ```
*   **AMCL のビルド**:
    ```bash
    bazel build @nav2_amcl//:amcl
    ```
*   **Costmap 2D のビルド**:
    ```bash
    bazel build @nav2_costmap_2d//:nav2_costmap_2d
    ```
*   **メッセージパッケージ (nav2_msgs) のビルド**:
    ```bash
    bazel build @nav2_msgs//:cpp_nav2_msgs
    ```
*   **特定の外部リポジトリパッケージのビルド (例: voxel_grid)**:
    ```bash
    bazel build @nav2_voxel_grid//:voxel_grid
    ```
