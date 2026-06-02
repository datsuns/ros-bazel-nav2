load(
    "@com_github_mvukov_rules_ros2//ros2:cc_defs.bzl",
    "ros2_cpp_library",
)
load(
    "@map_server_workspace//3rdparty/bazel:nav2_behavior_tree_rules.bzl",
    "declare_bt_nodes",
)

COMMON_DEPS = [
    "@ros2_rclcpp//:rclcpp",
    "@ros2_rclcpp//:rclcpp_action",
    "@ros2_rclcpp//:rclcpp_lifecycle",
    "@ros2_common_interfaces//:cpp_geometry_msgs",
    "@ros2_common_interfaces//:c_geometry_msgs",
    "@ros2_common_interfaces//:cpp_sensor_msgs",
    "@nav2_msgs//:cpp_nav2_msgs",
    "@nav2_msgs//:c_nav2_msgs",
    "@ros2_common_interfaces//:cpp_nav_msgs",
    "@behaviortree_cpp//:behaviortree_cpp",
    "@ros2_geometry2//:tf2",
    "@ros2_geometry2//:tf2_ros",
    "@ros2_geometry2//:cpp_tf2_geometry_msgs",
    "@ros2_common_interfaces//:cpp_std_msgs",
    "@ros2_common_interfaces//:cpp_std_srvs",
    "@nav2_util//:nav2_util",
]

# Core engine library
ros2_cpp_library(
    name = "nav2_behavior_tree",
    srcs = [
        "src/behavior_tree_engine.cpp",
    ],
    hdrs = glob(["include/nav2_behavior_tree/**/*.hpp"]) + [":plugins_list_hpp"],
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = COMMON_DEPS,
)

genrule(
    name = "plugins_list_hpp",
    outs = ["include/nav2_behavior_tree/plugins_list.hpp"],
    cmd = "printf '// Automatically generated\\nnamespace nav2::details {\\n  const char* BT_BUILTIN_PLUGINS = \"nav2_compute_path_to_pose_action_bt_node;nav2_compute_path_through_poses_action_bt_node;nav2_controller_cancel_bt_node;nav2_wait_cancel_bt_node;nav2_spin_cancel_bt_node;nav2_back_up_cancel_bt_node;nav2_assisted_teleop_cancel_bt_node;nav2_drive_on_heading_cancel_bt_node;nav2_smooth_path_action_bt_node;nav2_follow_path_action_bt_node;nav2_back_up_action_bt_node;nav2_drive_on_heading_bt_node;nav2_spin_action_bt_node;nav2_wait_action_bt_node;nav2_assisted_teleop_action_bt_node;nav2_clear_costmap_service_bt_node;nav2_reinitialize_global_localization_service_bt_node;nav2_truncate_path_action_bt_node;nav2_truncate_path_local_action_bt_node;nav2_navigate_to_pose_action_bt_node;nav2_navigate_through_poses_action_bt_node;nav2_remove_passed_goals_action_bt_node;nav2_get_pose_from_path_action_bt_node;nav2_planner_selector_bt_node;nav2_controller_selector_bt_node;nav2_smoother_selector_bt_node;nav2_goal_checker_selector_bt_node;nav2_progress_checker_selector_bt_node;nav2_compute_and_track_route_bt_node;nav2_compute_route_bt_node;nav2_is_stuck_condition_bt_node;nav2_transform_available_condition_bt_node;nav2_goal_reached_condition_bt_node;nav2_globally_updated_goal_condition_bt_node;nav2_goal_updated_condition_bt_node;nav2_is_path_valid_condition_bt_node;nav2_time_expired_condition_bt_node;nav2_path_expiring_timer_condition;nav2_distance_traveled_condition_bt_node;nav2_initial_pose_received_condition_bt_node;nav2_is_battery_charging_condition_bt_node;nav2_is_battery_low_condition_bt_node;nav2_rate_controller_bt_node;nav2_distance_controller_bt_node;nav2_speed_controller_bt_node;nav2_goal_updater_node_bt_node;nav2_path_longer_on_approach_bt_node;nav2_single_trigger_bt_node;nav2_goal_updated_controller_bt_node;nav2_recovery_node_bt_node;nav2_pipeline_sequence_bt_node;nav2_round_robin_node_bt_node\";\\n}\\n' > $@",
)


# Declare all BT node plugins using the helper macro
declare_bt_nodes(COMMON_DEPS)

