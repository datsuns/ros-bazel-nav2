FROM althack/ros2:humble-dev

# Install dependencies for nav2_map_server and bazel
USER root
RUN apt-get update && apt-get install -y \
    libgraphicsmagick++1-dev \
    libyaml-cpp-dev \
    curl \
    git \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install bazelisk (acts as bazel)
RUN npm install -g @bazel/bazelisk

# Set up user settings (user in althack/ros2 is usually "ros" or "ubuntu", but we can run as the default user)
USER ros
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
