#!/bin/bash
# Sets up AMENT_PREFIX_PATH for Rviz2 Bazel build and runs it.
WORKSPACE_DIR=$(pwd)
AMENT_DIR="/tmp/rviz2_ament_index"

rm -rf "$AMENT_DIR"
mkdir -p "$AMENT_DIR/share/ament_index/resource_index/packages"
touch "$AMENT_DIR/share/ament_index/resource_index/packages/rviz_common"
touch "$AMENT_DIR/share/ament_index/resource_index/packages/rviz_default_plugins"
touch "$AMENT_DIR/share/ament_index/resource_index/packages/rviz_rendering"

# Setup Pluginlib definitions
mkdir -p "$AMENT_DIR/share/ament_index/resource_index/rviz_common__pluginlib__plugin"
echo "share/rviz_default_plugins/plugins_description.xml" > "$AMENT_DIR/share/ament_index/resource_index/rviz_common__pluginlib__plugin/rviz_default_plugins"

BAZEL_OUT_BASE=$(bazel info output_base)
RVIZ_SRC_DIR="$BAZEL_OUT_BASE/external/rviz"

# Setup rviz_common resources (icons, default.rviz, package.xml)
mkdir -p "$AMENT_DIR/share/rviz_common"
cp -r "$RVIZ_SRC_DIR/rviz_common/icons" "$AMENT_DIR/share/rviz_common/"
cp -f "$RVIZ_SRC_DIR/rviz_common/default.rviz" "$AMENT_DIR/share/rviz_common/"
ln -sf "$RVIZ_SRC_DIR/rviz_common/package.xml" "$AMENT_DIR/share/rviz_common/"

# Setup plugins_description.xml and package.xml
mkdir -p "$AMENT_DIR/share/rviz_default_plugins"
ln -sf "$RVIZ_SRC_DIR/rviz_default_plugins/plugins_description.xml" "$AMENT_DIR/share/rviz_default_plugins/"
ln -sf "$RVIZ_SRC_DIR/rviz_default_plugins/package.xml" "$AMENT_DIR/share/rviz_default_plugins/"

# Setup ogre_media and plugins.cfg
mkdir -p "$AMENT_DIR/share/rviz_rendering"
cp -r "$RVIZ_SRC_DIR/rviz_rendering/ogre_media" "$AMENT_DIR/share/rviz_rendering/"
cat << 'INNER_EOF' > "$AMENT_DIR/share/rviz_rendering/ogre_media/plugins.cfg"
PluginFolder=/usr/lib/x86_64-linux-gnu/OGRE
Plugin=RenderSystem_GL
INNER_EOF

export AMENT_PREFIX_PATH="$AMENT_DIR:$AMENT_PREFIX_PATH"

echo "Starting Rviz2 via Bazel..."
exec bazel run @rviz//:rviz2 -- "$@"
