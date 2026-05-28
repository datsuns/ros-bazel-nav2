#include "my_subscriber.hpp"
#include <iostream>

MySubscriber::MySubscriber()
: Node("my_subscriber")
{
  // map_io.hpp で定義された LoadParameters / MapMode を利用して
  // ヘッダーのエクスポート/インポートおよび動作検証を行う
  nav2_map_server::LoadParameters params;
  params.image_file_name = "test_map.pgm";
  params.resolution = 0.05;
  params.free_thresh = 0.196;
  params.occupied_thresh = 0.65;
  params.mode = nav2_map_server::MapMode::Trinary;
  params.negate = false;

  std::cout << "[MySubscriber] MapMode checked: " << static_cast<int>(params.mode) << std::endl;
  std::cout << "[MySubscriber] Resolution checked: " << params.resolution << std::endl;

  // ラムダ式による安全なコールバック設定
  subscription_ = this->create_subscription<std_msgs::msg::String>(
    "topic", 10,
    [this](const std_msgs::msg::String::SharedPtr msg) {
      this->topic_callback(msg);
    });
}

void MySubscriber::topic_callback(const std_msgs::msg::String::SharedPtr msg)
{
  RCLCPP_INFO(this->get_logger(), "Received message: '%s'", msg->data.c_str());
}

int main(int argc, char * argv[])
{
  rclcpp::init(argc, argv);
  auto node = std::make_shared<MySubscriber>();
  std::cout << "[MySubscriber] Node initialized successfully." << std::endl;
  rclcpp::spin(node);
  rclcpp::shutdown();
  return 0;
}
