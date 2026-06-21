# ビルド依存関係方針変更の移行プラン (ROS 2非依存化)

本プロジェクトではこれまで「可能な限りすべての依存関係をソースからビルドする」という方針をとっていましたが、「ROS 2への依存（`/opt/ros`）のみ排除できればよい」という新しい方針へ移行するためのプランを以下にまとめます。

## 1. 方針変更の意味と影響

新しい方針「`/opt/ros` への依存のみ排除する」とは、以下のルールを意味します。
1. **ROSエコシステムのパッケージ**: `apt` 経由でインストールすると `/opt/ros/humble` に配置されてしまうため、**引き続きソースからビルド（`WORKSPACE` で定義）する必要があります。**
2. **ROS非依存のサードパーティライブラリ**: 標準のUbuntuシステムパッケージ（`/usr/lib` や `/usr/include` に配置されるもの）が存在する場合は、**ソースビルドを辞めてシステムパッケージ（`apt`）を利用できます。**

## 2. 移行によりソースビルドを省略できる依存関係

今回の方針変更によって、新たに `WORKSPACE` から削除（ソースビルドを省略）できるのは以下の1つのみとなります。

*   **OMPL (Open Motion Planning Library)**
    *   **理由**: ROSに依存しない純粋なC++ライブラリであり、Ubuntu 22.04の標準パッケージ（`/usr` にインストールされる `libompl-dev`）として提供されているため。

### なぜ他は省略できないのか？（補足）
*   **既にシステムパッケージを利用しているもの** (`Eigen3`, `OpenCV`, `Ceres Solver`, `yaml-cpp` など): 過去の設計時点で既に `system_sdk.bzl` を通じてUbuntu標準のパッケージを参照しており、元々ソースビルドしていません。
*   **ROSへの依存が発生してしまうもの** (`angles`, `map_msgs`, `bond_core`, `cv_bridge` など): `apt` でインストール可能ですがすべて `ros-humble-*` となり、`/opt/ros/humble/` に配置されROS 2本体へ依存してしまうため、引き続きソースからのビルドが必要です。
*   **Ubuntu標準パッケージが存在しないもの** (`BehaviorTree.CPP`): Ubuntu 22.04の標準リポジトリに存在せず、`apt` で入れるには `ros-humble-behaviortree-cpp-v3` を使うしかなく `/opt/ros` への依存を生むため、引き続きソースからビルドする必要があります。

## 3. 具体的な変更手順 (OMPLのシステムパッケージへの切り替え)

### 3.1. Dockerfile の修正
システムパッケージをコンテナにインストールします。
- **対象ファイル**: `.devcontainer/Dockerfile`
- **変更内容**: `apt-get install` のリストに `libompl-dev` を追加。

### 3.2. system_sdk.bzl の修正
BazelがシステムのOMPLを参照できるように設定を追加します。
- **対象ファイル**: `system_sdk.bzl`
- **変更内容**: 
  - `/usr/include/ompl-1.5` へのシンボリックリンク追加。
  - `cc_library(name = "ompl")` ターゲットの追加。

### 3.3. WORKSPACE の修正
ソースからのOMPLビルド設定を削除します。
- **対象ファイル**: `WORKSPACE`
- **変更内容**: `ompl` の `http_archive` 定義を削除。

### 3.4. OMPLのBUILDファイルの削除
- **対象ファイル**: `3rdparty/bazel/ompl.BUILD`
- **変更内容**: ファイルごと削除。

### 3.5. 依存先パッケージのBUILDファイルの修正
Nav2の各パッケージから、新しいOMPLターゲットを参照するように変更します。
- **対象ファイル**: `3rdparty/bazel/nav2_smac_planner.BUILD` 等 (OMPLに依存しているもの)
- **変更内容**: 依存関係（`deps`）を `@ompl//:ompl` から `@system_libs//:ompl` に書き換え。
