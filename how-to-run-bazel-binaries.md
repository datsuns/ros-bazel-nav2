# Bazel ビルド済みバイナリの実行ガイド

本ドキュメントでは、Bazel でビルドされた ROS 2 バイナリの起動方法について説明します。
Bazel を使用する場合、`source install/setup.bash` を実行しなくても、`bazel run` を通じて依存関係が解決された状態で実行可能です。

## 1. 基本的な実行形式

Bazel ターゲットを実行し、引数を渡す際の基本形式は以下の通りです。
```bash
bazel run <target_name> -- <arguments_for_binary>
```
`--` 以降の引数が、Bazel 自体ではなく実行されるバイナリに直接渡されます。

---

## 2. 主要バイナリの起動コマンド

### 2.1 Map Server (地図配信)
`map_server` はマップ設定ファイルをパラメータとして指定する必要があります。

**コマンド例:**
```bash
bazel run @nav2_map_server//:map_server -- --ros-args -p yaml_filename:=src/navigation2/nav2_bringup/maps/turtlebot3_world.yaml
```

**ライフサイクルの管理:**
`map_server` はライフサイクルノードです。起動後、別のターミナルからアクティブ化してください。
```bash
ros2 lifecycle set /map_server configure
ros2 lifecycle set /map_server activate
```

### 2.2 AMCL (自己位置推定)
**コマンド例:**
```bash
bazel run @nav2_amcl//:amcl
```

### 2.3 Map Saver CLI (地図保存)
配信されている地図をファイルとして保存します。

**コマンド例:**
```bash
bazel run @nav2_map_server//:map_saver_cli -- -f my_map_name
```

---

## 3. その他の便利なコマンド

### 全てのターゲットをビルド
実行前に全ての実行ファイルやライブラリをビルドする場合に使用します。
```bash
bazel build //... @nav2_amcl//... @nav2_costmap_2d//... @nav2_map_server//...
```

### 依存関係のクリーンアップ
ビルドエラーが発生した場合や、環境をリセットしたい場合に使用します。
```bash
bazel clean --expunge
```

## 4. 補足: なぜ `source setup.bash` が不要なのか
Bazel はビルド時に `runfiles` と呼ばれるディレクトリツリーを生成します。ここには実行に必要な全ての共有ライブラリ（`.so`）へのシンボリックリンクが含まれており、`bazel run` は実行時にこれらのパスを自動的にライブラリサーチパスに含めます。そのため、ROS 2 の標準的な環境変数設定なしで、自己完結的に動作します。
