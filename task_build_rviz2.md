# Rviz2 (ROS 2 Jazzy) ビルド作業のまとめ

現在の作業進捗と今後の対応方針について、次回作業をスムーズに再開できるよう整理した内容です。

## 1. 実施した内容 (Completed Work)

1. **Rviz2のビルド設定 (`rules_ros2`)**
   - `WORKSPACE` に `rviz2` リポジトリ（`jazzy` ブランチ）を追加。
   - `3rdparty/bazel/rviz2.BUILD` を作成・修正し、Bazelでのビルドルールを整備。

2. **不足する依存関係（外部パッケージ・ライブラリ）の解決**
   - `libcurl`, `eigen`, `image_transport`, `laser_geometry`, `map_msgs` 等のパッケージ・ライブラリ依存を順次解決。
   - **`interactive_markers` の対応**: 依存パッケージとして追加し、階層ズレや Jazzy->Humble 間の QoS パラメータ非互換によるコンパイルエラーを解消するパッチ (`interactive_markers_qos.patch`) を適用。
   - **`point_cloud_transport` の対応**: Jazzyブランチは提供されていなかったため、`humble` ブランチを採用。また不足していた `@ros2_rclcpp//:rclcpp_components` の依存を追加。

3. **コードや依存ライブラリのバージョン不整合のパッチ対応**
   - `rviz_image_encodings.patch`: 画像フォーマット（YUV関連）の不足定義を補うパッチを作成・適用。
   - **Ignition Math / Gz Math への対応**: 
     - Jazzy の Rviz2 コードは `gz-math7` (`<gz/math/...>`) を要求するが、現在のコンテナ環境 (Ubuntu 22.04 Jammy) は `ignition-math6` しか持たない。
     - これを解決するため、Rviz2内のインクルードパスや名前空間を `ignition::math` にダウングレードするパッチ (`rviz_gz_math.patch`) を作成し、`WORKSPACE` に適用した。
     - 併せて `system_sdk.bzl` に `ignition_math` (`-lignition-math6`) の定義を追加した。

## 2. 採用したプラン (Current Plan)

- **ターゲットバージョン**: ユーザーの要望に基づき、可能な限り **ROS 2 JazzyのRviz2** ソースコードをビルド対象とする。
- **環境ギャップの吸収**: 現在の Devcontainer 環境（Ubuntu 22.04）との間で発生するライブラリのバージョン不一致は、
  - 互換性のある別ブランチ（Humble等）の利用
  - `#include` や名前空間の差異を埋めるパッチファイル (`.patch`) の適用
  - システムインストール済みライブラリ (`system_sdk.bzl`) の活用
  によって個別撃破で解決する。

## 3. 見えている課題 (Current Issues & Observations)

1. **`ignition-math6` パッケージの不足**
   - `system_sdk.bzl` に `ignition_math` を追加し、`rviz2.BUILD` にも `deps` として登録されていたが、コンテナ環境内に実体 (`libignition-math6-dev`) がインストールされておらず `<ignition/math/Inertial.hh>` が見つからないエラーが発生した。`apt-get` でインストールすることで解決した。
2. **OSバージョン起因の未知のエラー**
   - Ubuntu 22.04 (Jammy) において Ubuntu 24.04 (Noble) 向けのコードをコンパイルしているため、これ以降も Qt のマイナーバージョン差異やC++標準ライブラリ起因のエラーが発生する可能性が残っている。
3. **他のプラグインの依存解決**
   - 現在全体の90%付近までコンパイルが進んでいるが、残り10%の各種プラグインでさらに未定義の ROS 2 メッセージパッケージなどが要求される可能性が高い。

## 4. 今後のTODO (Next Steps / TODOs)

- [x] `3rdparty/bazel/rviz2.BUILD` の `rviz_default_plugins` ターゲットの `deps` に `@system_libs//:ignition_math` を追加する。（既に追加済みだった）
- [x] コンテナ環境に `libignition-math6-dev` をインストールしてヘッダ不足エラーを解消する。
- [x] 再度 `bazel build @rviz//:rviz2` を実行する。（ビルド成功）
- [x] 新たなコンパイルエラーが出た場合は、依存関係の追加やパッチ作成を繰り返し、コンパイルを完了させる。
- [x] コンパイル通過後、リンクエラー（Undefined reference 等）が発生しないか確認する。
- [ ] ビルド成功後、Rviz2 バイナリを起動してGUIが描画され、基本的な描画プラグインが動作するかどうか検証する。
