#!/bin/bash
cd /home/ros/.cache/bazel/_bazel_ros/88f66cb3e13d8072d62e258e40b5e172/execroot/map_server_workspace/bazel-out/k8-fastbuild/bin/external/rviz/rviz2.runfiles/map_server_workspace && \
  exec env \
    -u JAVA_RUNFILES \
    -u RUNFILES_DIR \
    -u RUNFILES_MANIFEST_FILE \
    -u RUNFILES_MANIFEST_ONLY \
    -u TEST_SRCDIR \
    BUILD_WORKING_DIRECTORY=/workspaces/map_server \
    BUILD_WORKSPACE_DIRECTORY=/workspaces/map_server \
  /home/ros/.cache/bazel/_bazel_ros/88f66cb3e13d8072d62e258e40b5e172/execroot/map_server_workspace/bazel-out/k8-fastbuild/bin/external/rviz/rviz2 "$@"