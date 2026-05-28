#pragma once

#include <rclcpp/rclcpp.hpp>
#include <std_msgs/msg/string.hpp>

// nav2_map_server の map_io.hpp ヘッダーをインクルード
// このヘッダーがエクスポートされ、Bazel依存関係経由でインポートできるかを検証
#include "nav2_map_server/map_io.hpp"

class MySubscriber : public rclcpp::Node
{
public:
  MySubscriber();

private:
  void topic_callback(const std_msgs::msg::String::SharedPtr msg);
  rclcpp::Subscription<std_msgs::msg::String>::SharedPtr subscription_;
};
