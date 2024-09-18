FROM ubuntu:20.04

# Set timezone
ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install dependencies and ROS Noetic
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    tzdata \
    dirmngr \
    gnupg2 \
    lsb-release \
    curl \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Setup ROS Noetic repository
RUN curl -sSL 'http://packages.ros.org/ros.key' | apt-key add - && \
    sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros-latest.list'

# Install ROS Noetic and RViz
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-noetic-desktop-full \
    ros-noetic-rviz \
    && rm -rf /var/lib/apt/lists/* \
    ros-noetic-tf \
    graphviz
    
# Setup environment
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV ROS_DISTRO=noetic

# Source ROS setup.bash
RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc

# Setup entrypoint
COPY ./ros_entrypoint.sh /
RUN chmod +x /ros_entrypoint.sh
ENTRYPOINT ["/ros_entrypoint.sh"]

WORKDIR /workspace
CMD ["bash"]
