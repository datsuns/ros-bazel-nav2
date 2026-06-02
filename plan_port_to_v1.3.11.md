# Navigation2 v1.3.11 移行および Bazel ビルド修正プラン

本ドキュメントは、Navigation2 の参照を `humble` ブランチから `1.3.11` タグに変更したソースコードにおいて、Bazel ビルドが通るようにするための移行プランです。
ビルド中のコンパイルエラー原因の分析、具体的な対応方針、および検証手順をまとめています。

---

## 1. 検出された課題と原因分析

`1.3.11` ソースコードでの初回のビルド確認において、`nav2_util` パッケージのビルド中に以下のコンパイルエラーが発生しました。

```
external/nav2_util/include/nav2_util/service_client.hpp:49:15: error: cannot convert 'rclcpp::SystemDefaultsQoS' to 'const rmw_qos_profile_t&' {aka 'const rmw_qos_profile_s&'}
   49 |       rclcpp::SystemDefaultsQoS(),
```

### 原因分析
* **API の定義差異 (Bazel化自体の影響)**:
  * 最新の ROS 2 Humble システム（apt等で提供されるもの）では、`create_client` のオーバーロードに C++ の QoS ラッパークラス（`const rclcpp::QoS &`）を直接受け取るシグネチャが追加されているため、`rclcpp::SystemDefaultsQoS()` をそのまま渡せます。
  * 一方、Bazel化のために使用している外部の `rules_ros2` ルールセットがビルド・提供している `rclcpp` ライブラリは、QoS 引数として古いC言語の生構造体（`const rmw_qos_profile_t &`）のみを受け取る定義になっているため、暗黙の型変換に失敗しコンパイルエラーが発生しています。

---

## 2. 解決方針と具体的変更内容

Navigation2 内のソースコードを直接改変しない（non-invasiveな開発）というプロジェクトの基本方針を維持するため、パッチを適用して解決します。

### A. パッチファイルの新規作成
* **パッチファイル**: `patches/nav2_util_qos_fix.patch` [NEW]
* **内容**:
  `nav2_util/include/nav2_util/service_client.hpp` の 49行目を以下のように書き換え、明示的に `rmw_qos_profile_t` 構造体を取得して渡すようにします。
  ```diff
  -      rclcpp::SystemDefaultsQoS(),
  +      rclcpp::SystemDefaultsQoS().get_rmw_qos_profile(),
  ```

### B. Bazel 構成ファイルの更新
* **`WORKSPACE`** の修正:
  `nav2_util` のインポート定義を `new_local_repository` から `patched_local_repository` に変更し、上記のパッチを適用するように構成します。
  ```python
  patched_local_repository(
      name = "nav2_util",
      path = "src/navigation2/nav2_util",
      build_file = "//3rdparty/bazel:nav2_util.BUILD",
      patches = ["//patches:nav2_util_qos_fix.patch"],
      patch_strip = 2,
  )
  ```
* **`patches/BUILD.bazel`** の修正:
  新しく追加したパッチファイルを `filegroup` の `srcs` に追加し、WORKSPACEから参照できるようにします。

---

## 3. 依存関係に基づくビルド順序と移行ステップ

以前の `glob` キャッシュの不整合トラブル（作業ツリーが一時的に空になったことで空のヘッダーがキャッシュされた問題）を考慮し、**必ずキャッシュをクリアしてから、下位パッケージより順番にビルド検証を行います。**

### ビルド順序
1. **`nav2_msgs`** (メッセージ・アクション定義) - 依存関係の最下層。
2. **`nav2_util`** (共通ユーティリティ) - 上記のパッチ適用後にビルド。
3. **`nav2_voxel_grid`** (ボクセルグリッド定義)
4. **`nav2_costmap_2d`** (コストマップ) - `nav2_msgs`, `nav2_util`, `nav2_voxel_grid` に依存。
5. **`nav2_core`** (共通プラグインインターフェース)
6. **各種プラグイン・プランナー・コントローラー群** (順次確認)
   * DWBコントローラ系 (`nav_2d_msgs`, `nav_2d_utils`, `costmap_queue`, `dwb_msgs`, `dwb_core`, `dwb_critics`, `dwb_plugins`)
   * プランナー系 (`nav2_planner`, `nav2_navfn_planner`, `nav2_smac_planner`)
   * コントローラ系 (`nav2_controller`, `nav2_regulated_pure_pursuit_controller`, `nav2_rotation_shim_controller`, `nav2_mppi_controller`)
   * AMCL、ウェイポイントフォロワー、スムーサー (`nav2_amcl`, `nav2_waypoint_follower`, `nav2_smoother`, `nav2_constrained_smoother`)
   * BTナビゲータ関連 (`nav2_behavior_tree`, `nav2_bt_navigator`)
7. **統合パッケージ**
   * `nav2_lifecycle_manager`, `nav2_velocity_smoother`, `nav2_collision_monitor`, `nav2_simple_commander`, `nav2_bringup`

---

## 4. 検証計画 (Verification Plan)

### A. 事前準備 (キャッシュクリア)
古い不整合なキャッシュを確実に排除するため、以下のコマンドで Bazel キャッシュを完全にクリアします。
```bash
bazel clean --expunge
```

### B. 個別パッケージのビルド検証
依存関係の順番に従って、以下の主要ターゲットを個別ビルドし、コンパイルエラーが発生しないことを確認します。
```bash
# 1. メッセージビルド
bazel build @nav2_msgs//...

# 2. パッチ適用後のユーティリティビルド
bazel build @nav2_util//...

# 3. コストマップビルド
bazel build @nav2_costmap_2d//...
```

### C. 全体のビルド検証
最終的に、ワークスペース内のすべての対象パッケージ（Rvizプラグインやシステムテスト等を除く）が正常にビルドできることを検証します。
```bash
bazel build //...
```

---

## 5. ROS2バージョン互換性に関する考察

### 5.1 ビルド環境のバージョン構成

本プロジェクトのビルド環境は以下のバージョン構成となっている。

| コンポーネント | バージョン / 相当ディストリビューション | 備考 |
|---|---|---|
| devcontainer OS | Ubuntu 22.04 (Jammy) | |
| システムインストール ROS2 | Humble (`/opt/ros/humble`) | apt 経由、**Bazelビルドでは直接使用されない** |
| rules_ros2 | コミット `5308eab` | Bazel用 ROS2 ビルドルールセット |
| rules_ros2 が提供する geometry2 | `0.25.15` (Humble 相当) | rules_ros2 が WORKSPACE に固定 |
| Navigation2 ソースコード | `1.3.11` | **Iron 向けリリース** |

> **重要**: Bazelビルドでは `/opt/ros/humble` のシステムパッケージは直接使用されない。
> tf2_ros 等は `rules_ros2` が取得・ビルドする geometry2 `0.25.15` が使われる。

### 5.2 バージョン不一致によるコンパイルエラーの構造

Navigation2 `1.3.11` は **ROS2 Iron** をターゲットとして開発されたリリースである。
Iron の geometry2 (`0.26.x`) では `tf2_ros::TransformListener::subscription_callback` が `virtual` として公開されており、サブクラスからのオーバーライドが正当なAPIとして設計されていた。

一方、本ビルド環境で使われる geometry2 は Humble 相当の `0.25.15` であり、このバージョンでは同メソッドが `private` として宣言されているためオーバーライードが不可能でありコンパイルエラーが発生する。

```
Navigation2 1.3.11 (Iron 向け)
    ↓ geometry2 0.26.x (Iron) の API を前提
    ↓ subscription_callback は virtual（オーバーライド可能）

rules_ros2 が提供する geometry2 0.25.15 (Humble 相当)
    ↓ subscription_callback は private（オーバーライド不可）

→ コンパイルエラー（バージョン不一致）
```

### 5.3 `tf2_ros::subscription_callback` のアクセス修飾子の変遷

| geometry2 バージョン | ROS2 ディストリビューション | `subscription_callback` のアクセス |
|---|---|---|
| `0.25.x` | **Humble** | `private`（オーバーライド不可） |
| `0.26.x` | **Iron** | `virtual`（オーバーライド可能） |
| `0.35.x` | Jazzy | `virtual` |

Navigation2 `1.3.11` は Iron (`0.26.x`) を前提として `subscription_callback` をオーバーライドする設計を取っており、Humble 環境でそのままビルドしようとするとコンパイルエラーになる。

### 5.4 rules_ros2 の Jazzy 対応状況

`rules_ros2` の README には以下の記述がある（2025年7月時点）：

> *ROS 2 packages are by default locked to versions from `release-humble-20250721`*

**rules_ros2 は現時点で Humble に明示的にロックされており、Jazzy の公式サポートはない。**

Jazzy 対応には以下のような大規模な作業が必要となるため、当面は現実的ではない：

- 全パッケージの `BUILD` ファイルの刷新
- rclcpp、geometry2 等のAPI変更への追従
- Python/型生成まわりの変更対応

### 5.5 現行方針の結論

| 選択肢 | 評価 |
|---|---|
| Humble 固定を維持し、不一致をパッチで個別対処 | ✅ **現実的・採用中** |
| rules_ros2 を Iron 対応コミットへ更新 | ⚠️ 非公式・不安定。devcontainer も Iron に変更が必要 |
| rules_ros2 を Jazzy 対応へ更新 | ❌ 公式未サポート。大規模作業が必要 |

**Navigation2 `1.3.11` (Iron 向け) を Humble 環境でビルドする本プロジェクトでは、APIの非互換は Bazelパッチによる個別 Workaround で対処する方針とする。**
これは技術的負債ではなく、ビルドシステムの制約を明示的に認識した上での合理的な設計判断である。

---

## 6. ビルド生成物の過不足確認とROSノード一覧

### 6.1 CMakeビルド vs Bazelビルド — バイナリ比較表

Navigation2 1.3.11 を colcon/CMake でビルドした場合に生成されるバイナリと、現在のBazelビルドで定義されているターゲットを比較する。

| CMake生成バイナリ | パッケージ | Bazelターゲット | 状態 |
|---|---|---|---|
| `amcl` | nav2_amcl | `@nav2_amcl//:amcl` | ✅ 対応あり |
| `bt_navigator` | nav2_bt_navigator | `@nav2_bt_navigator//:bt_navigator` | ✅ 対応あり |
| `collision_monitor` | nav2_collision_monitor | `@nav2_collision_monitor//:collision_monitor` | ✅ 対応あり |
| `collision_detector` | nav2_collision_monitor | ―（未定義） | ⚠️ **Bazel未対応** |
| `controller_server` | nav2_controller | `@nav2_controller//:controller_server` | ✅ 対応あり |
| `nav2_costmap_2d` | nav2_costmap_2d | `@nav2_costmap_2d//:nav2_costmap_2d` | ✅ 対応あり |
| `nav2_costmap_2d_markers` | nav2_costmap_2d | `@nav2_costmap_2d//:nav2_costmap_2d_markers` | ✅ 対応あり |
| `nav2_costmap_2d_cloud` | nav2_costmap_2d | `@nav2_costmap_2d//:nav2_costmap_2d_cloud` | ✅ 対応あり |
| `lifecycle_manager` | nav2_lifecycle_manager | `@nav2_lifecycle_manager//:lifecycle_manager` | ✅ 対応あり |
| `map_server` | nav2_map_server | `@nav2_map_server//:map_server` | ✅ 対応あり |
| `map_saver_cli` | nav2_map_server | `@nav2_map_server//:map_saver_cli` | ✅ 対応あり |
| `map_saver_server` | nav2_map_server | `@nav2_map_server//:map_saver_server` | ✅ 対応あり |
| `costmap_filter_info_server` | nav2_map_server | `@nav2_map_server//:costmap_filter_info_server` | ✅ 対応あり |
| `planner_server` | nav2_planner | `@nav2_planner//:planner_server` | ✅ 対応あり |
| `smoother_server` | nav2_smoother | `@nav2_smoother//:smoother_server` | ✅ 対応あり |
| `lifecycle_bringup` | nav2_util | `@nav2_util//:lifecycle_bringup` | ✅ 対応あり |
| `base_footprint_publisher` | nav2_util | `@nav2_util//:base_footprint_publisher` | ✅ 対応あり（パッチ適用）|
| `velocity_smoother` | nav2_velocity_smoother | `@nav2_velocity_smoother//:velocity_smoother` | ✅ 対応あり |
| `waypoint_follower` | nav2_waypoint_follower | `@nav2_waypoint_follower//:waypoint_follower` | ✅ 対応あり |
| `generate_nav2_tree_nodes_xml` | nav2_behavior_tree | ―（未定義） | ⚠️ **Bazel未対応** |

### 6.2 Bazel未対応バイナリの詳細

#### `collision_detector`（nav2_collision_monitor）

- **役割**: 障害物の検出のみを行い、ロボットを停止させない（通知のみ）。`collision_monitor`（検出＋停止）の軽量版。
- **対応方針**: 必要な場合は `nav2_collision_monitor.BUILD` に `ros2_cpp_binary` ターゲットとして追加する。
- **優先度**: 低（`collision_monitor` で代替可能なユースケースが多い）

#### `generate_nav2_tree_nodes_xml`（nav2_behavior_tree）

- **役割**: BTプラグインから `nav2_tree_nodes.xml` を自動生成するビルド時ツール（ランタイムで使用するものではなく、XMLファイルを事前生成するコマンドラインツール）。
- **対応方針**: ランタイム実行には不要。必要であれば `@nav2_behavior_tree//:generate_nav2_tree_nodes_xml` として追加可能だが、`plugins_list.hpp` の `genrule` で代替している。
- **優先度**: 低（Bazelビルドの `genrule` で同等機能を実現済み）

### 6.3 起動するROSノード一覧

各バイナリが起動するROSノード名（`rclcpp::Node::get_name()` で返される名前）を示す。

| バイナリ名 | ROSノード名 | 主な役割 |
|---|---|---|
| `amcl` | `amcl` | 自己位置推定（Adaptive MCL） |
| `bt_navigator` | `bt_navigator` | ビヘイビアツリーによるナビゲーション制御 |
| `collision_monitor` | `collision_monitor` | 障害物検出・緊急停止 |
| `controller_server` | `controller_server` | パス追従コントローラ（DWB等のプラグイン管理） |
| `nav2_costmap_2d` | `local_costmap` / `global_costmap` | コストマップノード本体 |
| `nav2_costmap_2d_markers` | （スタンドアロンツール） | コストマップをMarkerとして可視化 |
| `nav2_costmap_2d_cloud` | （スタンドアロンツール） | コストマップをPointCloudとして可視化 |
| `lifecycle_manager` | `lifecycle_manager` | Nav2ノード群のライフサイクル管理 |
| `map_server` | `map_server` | 静的地図の配信（`/map` トピック） |
| `map_saver_cli` | （CLIツール） | 地図をファイルに保存するコマンドラインツール |
| `map_saver_server` | `map_saver_server` | 地図保存サービスサーバ |
| `costmap_filter_info_server` | `costmap_filter_info_server` | コストマップフィルタ情報の配信 |
| `planner_server` | `planner_server` | グローバルパスプランナー（NavFn / SMAC等のプラグイン管理） |
| `smoother_server` | `smoother_server` | パス平滑化サーバ |
| `lifecycle_bringup` | （CLIツール） | Nav2ノードのライフサイクル状態を手動遷移させるツール |
| `base_footprint_publisher` | `base_footprint_publisher` | `base_link` → `base_footprint` のTFを発行（Z/Roll/Pitch除去） |
| `velocity_smoother` | `velocity_smoother` | 速度指令の平滑化・加速度制限 |
| `waypoint_follower` | `waypoint_follower` | ウェイポイント追従 |

### 6.4 まとめ

- **対応済み**: 19バイナリ中 **17バイナリ** がBazelターゲットとして定義・ビルド可能
- **未対応**: `collision_detector`、`generate_nav2_tree_nodes_xml` の2つ
  - いずれも**ランタイム運用上の優先度が低い**（`collision_monitor` で代替可 / ビルド時ツール）
  - 必要に応じて対応するBazel BUILDターゲットを追加することで解決可能

