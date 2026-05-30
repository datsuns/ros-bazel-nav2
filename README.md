# ROS 2 Navigation2 Bazel Build Project

本プロジェクトは、ROS 2 Humble の Navigation2 (Nav2) パッケージ群を Bazel ビルドシステムへ移行し、高速かつ再現性の高いビルド環境を構築することを目的としています。

## ドキュメント一覧

ルートディレクトリにある各 Markdown ファイルの内容と役割の要約です。

| ファイル名 | 内容の要約 |
| :--- | :--- |
| **[README.md](README.md)** | **本ファイル**。プロジェクトのドキュメントインデックス。 |
| **[how-to-run-bazel-binaries.md](how-to-run-bazel-binaries.md)** | **実行ガイド**。Bazel でビルドされた `map_server` や `amcl` などのバイナリの起動方法。 |
| **[imple_phase1_report.md](imple_phase1_report.md)** | **移行実施レポート**。フェーズ1（主要パッケージの移行）の構成方針、ビルドコマンド、colcon との比較。 |
| **[plan_port_to_non_ros.md](plan_port_to_non_ros.md)** | **脱 /opt/ros 計画**。`/opt/ros` への依存を削減し、ソースビルドへ移行するための計画とステータス。 |
| **[walkthrough.md](walkthrough.md)** | **技術解説**。Bazel 移行のステップ、ビルド生成物の詳細比較、新規コンポーネント追加手順。 |
| **[plan_port_all.md](plan_port_all.md)** | **全パッケージ移行ロードマップ**。Nav2 全体のパッケージを Bazel 化するための難易度評価と計画。 |
| **[implementation_plan.md](implementation_plan.md)** | **初期作業方針**。Bzlmod から WORKSPACE 形式への切り替えなど、初期の移行戦略。 |

## 主な Bazel 構成のポイント
*   **非侵襲的構成**: `src/navigation2` 以下のソースコードは一切変更せず、`3rdparty/bazel/` に置いた外部 BUILD ファイルで管理しています。
*   **自己完結型**: `/opt/ros` への依存を最小限に抑え、主要パッケージをソースからビルド可能です。
*   **ゼロコピー**: インストールディレクトリへのコピーを行わず、サンドボックス内での直接参照により効率的なビルドを実現しています。
