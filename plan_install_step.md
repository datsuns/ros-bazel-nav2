# 既存環境への Bazel 成果物段階的移行プラン

本ドキュメントでは、既に `colcon` でビルドされた Navigation2 動作環境において、特定のコンポーネントを Bazel でビルドした成果物に段階的に置き換えていく手順を定義します。

## 1. 移行の基本方針
一気に全ての環境を Bazel に切り替えるのではなく、依存関係の少ない末端のツールから順に置き換え、最終的に主要なノードを Bazel バイナリで動作させることを目指します。

*   **検証の単位**: バイナリ単位で差し替えを行う。
*   **環境の共存**: 既存の `setup.bash` (ROS 2 環境) を利用しつつ、バイナリのパス指定のみを Bazel 版へ向ける。

---

## 2. 移行フェーズ

### ステージ 1: 単体ツールの差し替え (独立実行)
他のノードや launch ファイルに依存せず、単発で実行される CLI ツールから置き換えます。

*   **対象**: `map_saver_cli`, `map_saver_server`
*   **目的**: Bazel ビルド版バイナリが、既存の共有ライブラリ環境下で正しくロードされ動作するかを確認する。
*   **実行例**:
    ```bash
    # 既存の map_server が動いている状態で実行
    ./bazel-bin/external/nav2_map_server/map_saver_cli -f my_map
    ```

### ステージ 2: Launch ファイル内ノードの個別差し替え
既存の Python Launch ファイルを書き換え、特定のノードのみ Bazel ビルド済みの実行ファイルを使用するように変更します。

*   **対象**: `map_server`, `amcl`
*   **方法**: `Node` クラスの `executable` 引数に Bazel のバイナリパスをフルパスで指定する。
*   **目的**: ノード間通信（トピック/サービス/アクション）に Bazel 版バイナリが混ざっても正常に機能するかを確認する。

### ステージ 3: ライブラリ・プラグインの差し替え
`Pluginlib` を通じてロードされる共有ライブラリや、基盤となるライブラリを置き換えます。

*   **対象**: `nav2_costmap_2d` の各レイヤープラグイン、`nav2_util`
*   **課題**: `LD_LIBRARY_PATH` の調整や、プラグイン定義 XML のパス解決が必要。

---

## 3. バイナリパス対応表

jovial_taussig コンテナ内でのパス対応は以下の通りです。

| パッケージ名 | バイナリ / ライブラリ | Bazel ビルドパス (相対) |
| :--- | :--- | :--- |
| **nav2_map_server** | `map_server` | `bazel-bin/external/nav2_map_server/map_server` |
| | `map_saver_cli` | `bazel-bin/external/nav2_map_server/map_saver_cli` |
| | `libmap_io.so` | `bazel-bin/external/nav2_map_server/libmap_io.so` |
| **nav2_amcl** | `amcl` | `bazel-bin/external/nav2_amcl/amcl` |
| **nav2_util** | `libnav2_util.so` | `bazel-bin/external/nav2_util/libnav2_util.so` |
| **nav2_costmap_2d** | `nav2_costmap_2d` | `bazel-bin/external/nav2_costmap_2d/nav2_costmap_2d` |

---

## 4. 検証時のチェックリスト
1.  [ ] `ldd <binary>` を実行し、Bazel 版バイナリが意図したライブラリをロードしているか？
2.  [ ] `ros2 node info` 等で、Bazel 版ノードが正しく ROS グラフに参加できているか？
3.  [ ] ライフサイクルノードのアクティブ化（Configure/Activate）が正常に行えるか？
