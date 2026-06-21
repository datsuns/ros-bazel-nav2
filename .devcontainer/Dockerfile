FROM althack/ros2:humble-dev

# Install dependencies for nav2_map_server and bazel
USER root
RUN apt-get update && apt-get install -y \
    libgraphicsmagick++1-dev \
    libyaml-cpp-dev \
    libompl-dev \
    curl \
    git \
    nodejs \
    npm \
    qtbase5-dev \
    libqt5svg5-dev \
    libqt5opengl5-dev \
    libogre-1.12-dev \
    libassimp-dev \
    libtinyxml2-dev \
    liburdfdom-dev \
    liburdfdom-headers-dev \
    libcurl4-openssl-dev \
    qt5-qmake \
    qtbase5-dev-tools \
    libignition-math6-dev \
    && rm -rf /var/lib/apt/lists/*

# Install bazelisk (acts as bazel)
RUN npm install -g @bazel/bazelisk

# Set up user settings (user in althack/ros2 is usually "ros" or "ubuntu", but we can run as the default user)
USER ros
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
