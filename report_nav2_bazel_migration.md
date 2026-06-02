# Navigation2 Bazel 移行 結果レポート

## 1. 全体の基本方針

### 1.1 プロジェクト概要
ROS 2 Humble の Navigation2 (Nav2) パッケージ群を、`nav2_map_server` で確立済みの Bazel (WORKSPACE形式) ビルド手法を基に、全パッケージへ横展開して Bazel ビルド化した。

### 1.2 ビルドシステムの基本構成

| 要素 | 選択 |
|:---|:---|
| Bazel バージョン | 7.6.1 (Bazelisk 経由) |
| ROS 2 ルール | `rules_ros2` (mvukov/rules_ros2) |
| WORKSPACE 形式 | WORKSPACE ファイル + `new_local_repository` |

### 1.3 非侵襲的 (Non-invasive) 移行方針

元の `src/navigation2/` ディレクトリ内のファイルを直接修正・汚染しないことを最優先の方針とした。

| 方針 | 実装方法 |
|:---|:---|
| **Bazel設定ファイルの外部配置** | 各パッケージのBUILDファイルを `3rdparty/bazel/*.BUILD` に配置し、`new_local_repository` の `build_file` 属性でマッピング |
| **ソースコード修正のパッチ管理** | 修正が必要な場合は `patches/` ディレクトリにパッチファイルを保管し、カスタムリポジトリルール `patched_local_repository` で自動適用 |
| **BUILDファイルはnavigation2外** | `src/navigation2/` 以下に `BUILD.bazel` を一切配置しない |

---

## 2. 依存関係の解決方針

Nav2 パッケージ群の依存関係は、以下の3つのカテゴリに分類して解決した。

### 2.1 ROS 2 コアライブラリ（rules_ros2 経由）

`rules_ros2` が管理する ROS 2 コアパッケージ群。Bazel ターゲットとして直接参照できる。

| ライブラリ | Bazel ターゲット例 |
|:---|:---|
| rclcpp / rclcpp_action / rclcpp_lifecycle | `@ros2_rclcpp//:rclcpp` |
| geometry_msgs / nav_msgs / sensor_msgs | `@ros2_common_interfaces//:cpp_geometry_msgs` |
| tf2 / tf2_ros | `@ros2_geometry2//:tf2_ros` |
| pluginlib | `@ros2_pluginlib//:pluginlib` |

### 2.2 ROS 2 インターフェース（メッセージ自動生成）

Nav2 固有のメッセージ (`nav2_msgs`) は、`ros2_interface_library` と `cpp_ros2_interface_library` で `.msg` / `.srv` / `.action` からC++ヘッダーを自動生成する。

```starlark
ros2_interface_library(
    name = "nav2_msgs",
    srcs = glob(["src/navigation2/nav2_msgs/msg/**/*.msg", ...]),
    deps = ["@ros2_common_interfaces//:geometry_msgs", ...],
)
cpp_ros2_interface_library(name = "cpp_nav2_msgs", deps = [":nav2_msgs"])
c_ros2_interface_library(name = "c_nav2_msgs", deps = [":nav2_msgs"])
```

### 2.3 システムライブラリ（system_sdk.bzl 経由）

開発コンテナ内のシステムパス（`/usr/include`, `/usr/lib`, `/opt/ros/humble`）から、`system_sdk.bzl` のカスタムリポジトリルールを用いてシンボリックリンクを張り、`cc_library` ターゲットとして公開する。

| ライブラリ名 | ソースパス | ターゲット | 利用パッケージ |
|:---|:---|:---|:---|
| **Eigen3** | `/usr/include/eigen3` | `@system_libs//:eigen` | costmap_2d, smac_planner, mppi_controller |
| **OpenCV** | `/usr/include/opencv4` | `@system_libs//:opencv` | waypoint_follower |
| **Ceres Solver** | `/usr/include/ceres` | `@system_libs//:ceres` | constrained_smoother |
| **xtensor** | `/usr/include/xtensor` | `@system_libs//:xtensor` | mppi_controller |
| **xsimd** | `/usr/include/xsimd` | `@system_libs//:xsimd` | mppi_controller (xtensor経由) |
| **xtl** | `/usr/include/xtl` | `@system_libs//:xtl` | mppi_controller (xtensor経由) |
| **GraphicsMagick** | `/usr/include/GraphicsMagick` | `@system_libs//:graphicsmagick` | map_server |
| **yaml-cpp** | `/usr/lib/x86_64-linux-gnu` | `@system_libs//:yaml-cpp` | map_server |
| **Boost** | `/usr/include/boost` | `@system_libs//:boost` | smac_planner (OpenMP代替) |

### 2.4 ROS パッケージ（WORKSPACE で個別定義）

ROS 2 のパッケージのうち `rules_ros2` に含まれていないものは、`new_local_repository` または専用BUILDファイルを通じて個別に定義した。

| パッケージ | 管理方法 |
|:---|:---|
| BehaviorTree.CPP v3 | `/opt/ros/humble` からヘッダーと `.so` をリンク |
| OMPL | `/opt/ros/humble` からヘッダーと `.so` をリンク |
| bond_core / bondcpp | `/opt/ros/humble` からリンク |
| angles / laser_geometry / map_msgs | `/opt/ros/humble` からリンク |
| cv_bridge / image_transport | `/opt/ros/humble` からリンク |

---

## 3. ビルド環境に追加でインストールしたもの

### 3.1 元の Dockerfile (ベースイメージ: `althack/ros2:humble-dev`)

```dockerfile
RUN apt-get update && apt-get install -y \
    libgraphicsmagick++1-dev \
    libyaml-cpp-dev \
    curl git nodejs npm
RUN npm install -g @bazel/bazelisk
```

### 3.2 Nav2 全パッケージ移行に伴い追加が必要なパッケージ

以下は Bazel ビルドがシステムパスから参照するため、コンテナ上にインストールされている必要がある。
（`ros-humble-navigation2` のインストール時に依存関係として自動的に導入されているものを含む）

| パッケージ名 | バージョン | 用途 |
|:---|:---|:---|
| `libeigen3-dev` | 3.4.0-2ubuntu2 | nav2_costmap_2d, smac_planner, mppi_controller |
| `libceres-dev` | 2.0.0+dfsg1-5 | nav2_constrained_smoother |
| `libsuitesparse-dev` | 5.10.1+dfsg-4 | Ceres Solver の依存 |
| `libxtensor-dev` | 0.23.10-15 | nav2_mppi_controller |
| `libxsimd-dev` | 7.6.0-2 | nav2_mppi_controller (xtensor経由) |
| `xtl-dev` | 0.7.2-2 | nav2_mppi_controller (xtensor経由) |
| `ros-humble-behaviortree-cpp-v3` | 3.8.7 | nav2_behavior_tree, nav2_bt_navigator |
| `ros-humble-ompl` | 1.7.0 | nav2_smac_planner (lattice) |
| `ros-humble-nav2-msgs` | 1.1.20 | メッセージ定義の参照 |
| `ros-humble-nav2-util` | 1.1.20 | ユーティリティの参照 |
| `ros-humble-nav2-map-server` | 1.1.20 | map_server の参照 |

> [!NOTE]
> `ros-humble-navigation2` メタパッケージのインストールにより、上記の多くは自動的にインストールされる。

---

## 4. 追加ファイルの構成

### 4.1 全体ディレクトリ構成

```
/workspaces/map_server/
├── WORKSPACE                           # リポジトリ定義（247行、46リポジトリ）
├── BUILD.bazel                         # ルートBUILD（nav2_msgs, nav2_util, map_server）
├── system_sdk.bzl                      # システムライブラリのBazelラッピング
├── 3rdparty/
│   └── bazel/                          # 42ファイル
│       ├── BUILD.bazel                 # 3rdpartyパッケージの空BUILD
│       ├── patched_local_repository.bzl  # パッチ適用カスタムリポジトリルール
│       ├── nav2_behavior_tree_rules.bzl  # BTノード大量宣言用ヘルパーマクロ
│       ├── nav2_core.BUILD
│       ├── nav2_voxel_grid.BUILD
│       ├── nav2_costmap_2d.BUILD
│       ├── nav2_lifecycle_manager.BUILD
│       ├── nav2_velocity_smoother.BUILD
│       ├── nav2_collision_monitor.BUILD
│       ├── nav2_planner.BUILD
│       ├── nav2_controller.BUILD
│       ├── nav2_smoother.BUILD
│       ├── nav2_navfn_planner.BUILD
│       ├── nav2_regulated_pure_pursuit_controller.BUILD
│       ├── nav2_rotation_shim_controller.BUILD
│       ├── nav2_amcl.BUILD
│       ├── nav2_waypoint_follower.BUILD
│       ├── nav2_smac_planner.BUILD
│       ├── nav2_constrained_smoother.BUILD
│       ├── nav2_mppi_controller.BUILD
│       ├── nav2_behavior_tree.BUILD
│       ├── nav2_bt_navigator.BUILD
│       ├── nav2_simple_commander.BUILD
│       ├── nav2_bringup.BUILD
│       ├── nav_2d_msgs.BUILD
│       ├── nav_2d_utils.BUILD
│       ├── dwb_msgs.BUILD
│       ├── dwb_core.BUILD
│       ├── dwb_critics.BUILD
│       ├── dwb_plugins.BUILD
│       └── costmap_queue.BUILD
├── patches/
│   ├── BUILD.bazel
│   └── nav2_behavior_tree_fix_path_headers.patch
└── src/
    └── navigation2/                    # サブモジュール（変更なし）
```

### 4.2 主要ファイルの役割

| ファイル | 行数 | 役割 |
|:---|:---|:---|
| [WORKSPACE](file:///workspaces/map_server/WORKSPACE) | 247 | 全リポジトリの定義。`rules_ros2` の取得、各Nav2パッケージの `new_local_repository` / `patched_local_repository` 定義 |
| [BUILD.bazel](file:///workspaces/map_server/BUILD.bazel) | 151 | ルートビルドファイル。`nav2_msgs`（メッセージ自動生成）、`nav2_util`（ユーティリティ）、`map_server` 関連バイナリの定義 |
| [system_sdk.bzl](file:///workspaces/map_server/system_sdk.bzl) | 98 | システムライブラリ（Eigen, OpenCV, Ceres, xtensor等）のBazelラッピング |
| [patched_local_repository.bzl](file:///workspaces/map_server/3rdparty/bazel/patched_local_repository.bzl) | 62 | パッチ自動適用機能付きカスタムリポジトリルール |
| [nav2_behavior_tree_rules.bzl](file:///workspaces/map_server/3rdparty/bazel/nav2_behavior_tree_rules.bzl) | — | 40+個のBTノードプラグインを宣言するヘルパーマクロ（BUILDファイルでforループが使えないため） |

### 4.3 パッチファイル

| ファイル | 内容 | 理由 |
|:---|:---|:---|
| [nav2_behavior_tree_fix_path_headers.patch](file:///workspaces/map_server/patches/nav2_behavior_tree_fix_path_headers.patch) | `#include "nav_msgs/msg/path.h"` → `path.hpp` に変更（5ファイル） | colcon では C/C++ 両ヘッダーが同一パスに配置されるが、Bazel (rules_ros2) では `c_ros2_interface_library` と `cpp_ros2_interface_library` に分離されるため、C++コードでは `.hpp` を使う必要がある |

---

## 5. 各パッケージのビルド生成物の確認結果

### 5.1 全体サマリー

| 指標 | 値 |
|:---|:---|
| クリーンビルド総アクション数 | **2,229** |
| クリーンビルド総ターゲット数 | **102** |
| 所要時間（クリーン） | **624秒**（Critical Path: 301秒） |
| ビルド結果 | ✅ **Build completed successfully** |

### 5.2 パッケージ別ビルド生成物

#### 基盤パッケージ（フェーズ 0: 移行済み基盤）

| パッケージ | 実行バイナリ | 共有ライブラリ (.so) | 備考 |
|:---|:---|:---|:---|
| **nav2_map_server** | `map_server`, `map_saver_server`, `map_saver_cli`, `costmap_filter_info_server` | `libmap_io.so`, `libmap_server_core.so` | ✅ 先行移行済み |

#### インターフェース・基礎ライブラリ（フェーズ 1-2）

| パッケージ | 生成物タイプ | 生成ファイル | 状態 |
|:---|:---|:---|:---|
| **nav2_core** | ヘッダーオンリー | — (hdrs のみ) | ✅ |
| **nav2_voxel_grid** | ライブラリ | `libnav2_voxel_grid.so` | ✅ |
| **nav_2d_msgs** | メッセージ | C++ヘッダー自動生成 | ✅ |
| **dwb_msgs** | メッセージ | C++ヘッダー自動生成 | ✅ |
| **nav_2d_utils** | ライブラリ | `libnav_2d_utils.so` | ✅ |
| **costmap_queue** | ライブラリ | `libcostmap_queue.so` | ✅ |

#### 周辺ノード（フェーズ 2）

| パッケージ | 実行バイナリ | 共有ライブラリ (.so) | 状態 |
|:---|:---|:---|:---|
| **nav2_lifecycle_manager** | `lifecycle_manager` | `libnav2_lifecycle_manager_core.so` | ✅ |
| **nav2_velocity_smoother** | `velocity_smoother` | `libvelocity_smoother_core.so` | ✅ |
| **nav2_collision_monitor** | `collision_monitor` | `libcollision_monitor_core.so` | ✅ |

#### コストマップ・サーバー群（フェーズ 3）

| パッケージ | 実行バイナリ | 共有ライブラリ (.so) | 状態 |
|:---|:---|:---|:---|
| **nav2_costmap_2d** | `nav2_costmap_2d`, `nav2_costmap_2d_cloud`, `nav2_costmap_2d_markers` | `libnav2_costmap_2d_core.so`, `liblayers.so`, `libfilters.so` | ✅ |
| **nav2_planner** | `planner_server` | `libplanner_server_core.so` | ✅ |
| **nav2_controller** | `controller_server` | `libcontroller_server_core.so` | ✅ |
| **nav2_smoother** | `smoother_server` | `libsmoother_server_core.so`, `libsimple_smoother.so`, `libsavitzky_golay_smoother.so` | ✅ |

#### プランナー・コントローラプラグイン（フェーズ 4）

| パッケージ | 共有ライブラリ (.so) | 外部依存 | 状態 |
|:---|:---|:---|:---|
| **nav2_navfn_planner** | `libnav2_navfn_planner.so` | — | ✅ |
| **nav2_regulated_pure_pursuit_controller** | `libnav2_regulated_pure_pursuit_controller.so` | — | ✅ |
| **nav2_rotation_shim_controller** | `libnav2_rotation_shim_controller.so` | — | ✅ |
| **dwb_core** | `libdwb_core.so` | — | ✅ |
| **dwb_critics** | `libdwb_critics.so` | — | ✅ |
| **dwb_plugins** | `libdwb_plugins.so` | — | ✅ |
| **nav2_smac_planner** | `libnav2_smac_planner.so`, `libnav2_smac_planner_2d.so`, `libnav2_smac_planner_lattice.so` | Eigen3, OMPL | ✅ |
| **nav2_constrained_smoother** | `libnav2_constrained_smoother.so` | Ceres Solver | ✅ |
| **nav2_mppi_controller** | `libmppi_controller.so`, `libmppi_critics.so` | xtensor, xsimd | ✅ |

#### ローカリゼーション・ウェイポイント（フェーズ 4）

| パッケージ | 実行バイナリ | 共有ライブラリ (.so) | 外部依存 | 状態 |
|:---|:---|:---|:---|:---|
| **nav2_amcl** | `amcl` | `libamcl_core.so`, `libpf_lib.so`, `libsensors_lib.so`, `libmotions_lib.so`, `libmap_lib.so` | — | ✅ |
| **nav2_waypoint_follower** | `waypoint_follower` | `libwaypoint_follower_core.so`, `libwait_at_waypoint.so`, `libphoto_at_waypoint.so`, `libinput_at_waypoint.so` | OpenCV | ✅ |

#### Behavior Tree（フェーズ 4）

| パッケージ | 共有ライブラリ (.so) | 外部依存 | 状態 |
|:---|:---|:---|:---|
| **nav2_behavior_tree** | `libnav2_behavior_tree.so` + **44個のBTノードプラグイン** `.so` | BehaviorTree.CPP v3 | ✅ (パッチ適用) |

BTノードプラグイン一覧（全44個）:
`libnav2_assisted_teleop_action_bt_node.so`, `libnav2_back_up_action_bt_node.so`, `libnav2_clear_costmap_service_bt_node.so`, `libnav2_compute_path_through_poses_action_bt_node.so`, `libnav2_compute_path_to_pose_action_bt_node.so`, `libnav2_follow_path_action_bt_node.so`, `libnav2_navigate_to_pose_action_bt_node.so`, `libnav2_spin_action_bt_node.so`, `libnav2_wait_action_bt_node.so`, 他35個

#### ナビゲーター・最上流（フェーズ 5）

| パッケージ | 生成物 | 状態 |
|:---|:---|:---|
| **nav2_bt_navigator** | `bt_navigator` (実行バイナリ), `libbt_navigator_core.so` | ✅ |
| **nav2_simple_commander** | `example_nav_to_pose`, `example_nav_through_poses`, `example_waypoint_follower` (Pythonバイナリ) | ✅ |
| **nav2_bringup** | filegroup (launch/params/maps/rviz/worlds/urdf) | ✅ |

### 5.3 移行対象外パッケージ

| パッケージ | 理由 |
|:---|:---|
| **nav2_rviz_plugins** | Qt5 MOC/UIC ビルドが Bazel 上で極めて困難 |
| **nav2_system_tests** | ROS 2 ノード間通信のサンドボックス上テストは別途設計が必要 |
| **nav2_common** | CMake ヘルパーのみであり、Bazel 移行不要 |

---

## 6. 発生した問題と解決策

### 6.1 `.h` / `.hpp` ヘッダーインクルード不整合

- **現象**: `nav_msgs/msg/path.h` が Bazel ビルドで見つからない
- **原因**: colcon では C言語用(`.h`)とC++用(`.hpp`)のメッセージヘッダーが同一パスに配置されるが、Bazel (`rules_ros2`) では `c_ros2_interface_library` と `cpp_ros2_interface_library` に分離されている
- **解決**: C++コードで `.hpp` を使うようパッチで修正

### 6.2 `new_local_repository` にパッチ機能がない

- **現象**: Bazel 7 の `new_local_repository` は `patches` 属性を持たない
- **解決**: `patched_local_repository.bzl` にカスタムリポジトリルールを実装。ソースをコピーしてから `patch` コマンドでパッチを適用し、元ソースを汚染しない

### 6.3 BUILD ファイルでの for ループ不可

- **現象**: `nav2_behavior_tree` の 44個のBTノードプラグインを宣言する際、BUILD ファイル内で `for` ループが使えない
- **解決**: `nav2_behavior_tree_rules.bzl` にヘルパーマクロ `declare_bt_nodes()` を作成し、`.bzl` ファイル内でリスト内包表記を使用

### 6.4 `c_nav2_msgs` ターゲット不足

- **現象**: `behavior_tree_status_change.h` のインクルード時に C インターフェースが見つからない
- **解決**: `BUILD.bazel` に `c_ros2_interface_library` を使った `c_nav2_msgs` ターゲットを追加

---

## 7. 今後の課題・展望

| 項目 | 内容 |
|:---|:---|
| **ランタイム検証** | ビルド成功は確認済みだが、実際にROS 2ノードとして起動・通信できるかの動作検証は未実施 |
| **pluginlib 動的ロード** | サーバーノード（planner_server 等）がプラグインを `pluginlib` で動的ロードする際のパス解決は、Bazel の `runfiles` 機構に依存しており、追加設定が必要になる可能性がある |
| **Dockerfile 更新** | 追加の apt パッケージ（Eigen3, Ceres, xtensor 等）を Dockerfile に反映する必要がある |
| **パッチの最小化** | 現在パッチは1件のみだが、Nav2 のバージョンアップ時にパッチの保守が必要 |
| **Bzlmod 移行** | 現在は WORKSPACE 形式だが、将来的に Bazel の Bzlmod (MODULE.bazel) 形式への移行も検討可能 |
| **テスト** | 単体テスト・統合テストの Bazel への移行は未着手 |
