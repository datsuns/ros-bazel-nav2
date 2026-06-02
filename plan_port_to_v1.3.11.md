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
