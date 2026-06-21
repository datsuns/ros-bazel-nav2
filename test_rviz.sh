#!/bin/bash
export AMENT_PREFIX_PATH=/tmp/my_ament:$AMENT_PREFIX_PATH
mkdir -p /tmp/my_ament/share/ament_index/resource_index/packages
touch /tmp/my_ament/share/ament_index/resource_index/packages/rviz_common
touch /tmp/my_ament/share/ament_index/resource_index/packages/rviz_default_plugins
touch /tmp/my_ament/share/ament_index/resource_index/packages/rviz_rendering

rm -rf /tmp/my_ament/share/rviz_common
ln -snf $(pwd)/bazel-map_server/external/rviz/rviz_common /tmp/my_ament/share/rviz_common
rm -rf /tmp/my_ament/share/rviz_default_plugins
ln -snf $(pwd)/bazel-map_server/external/rviz/rviz_default_plugins /tmp/my_ament/share/rviz_default_plugins

rm -rf /tmp/my_ament/share/rviz_rendering
mkdir -p /tmp/my_ament/share/rviz_rendering
cp -r bazel-map_server/external/rviz/rviz_rendering/ogre_media /tmp/my_ament/share/rviz_rendering/
cat << 'INNER_EOF' > /tmp/my_ament/share/rviz_rendering/ogre_media/plugins.cfg
PluginFolder=/usr/lib/x86_64-linux-gnu/OGRE
Plugin=RenderSystem_GL
INNER_EOF

xvfb-run -a -s "-screen 0 1280x720x24" bash -c "export AMENT_PREFIX_PATH=/tmp/my_ament:\$AMENT_PREFIX_PATH; bazel run @rviz//:rviz2 & sleep 12 ; import -window root /home/ros/.gemini/antigravity-ide/brain/0543c500-95b3-408c-8206-9db1dfee0695/artifacts/rviz2_gui.png ; pkill -f rviz2"
