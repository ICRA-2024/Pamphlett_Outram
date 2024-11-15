FROM osrf/ros:noetic-desktop-full

ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    libeigen3-dev \
    libboost-all-dev \
    git \
    python3-pip \
    python3-catkin-tools \
    libgoogle-glog-dev \
    libgflags-dev \
    libatlas-base-dev \
    libsuitesparse-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Ceres-Solver
RUN git clone -b 2.1.0 https://ceres-solver.googlesource.com/ceres-solver /tmp/ceres-solver && \
    mkdir -p /tmp/ceres-solver/build && cd /tmp/ceres-solver/build && \
    cmake .. -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF && \
    make -j$(nproc) && make install && \
    rm -rf /tmp/ceres-solver
    
# Create a catkin workspace
RUN mkdir -p /catkin_ws/src
WORKDIR /catkin_ws/src

# Clone the required repositories
RUN git clone https://github.com/ICRA-2024/Pamphlett_Outram.git

# Build the Outram package
WORKDIR /catkin_ws/src/Pamphlett_Outram
SHELL ["/bin/bash", "-c"]
RUN mkdir -p build && cd build && \
    source /opt/ros/noetic/setup.bash && \
    cmake .. && \
    mv pmc-src/ /catkin_ws/build/
    
WORKDIR /catkin_ws

# Build the workspace
RUN source /opt/ros/noetic/setup.bash && \
    catkin build outram

# Source the workspace in the container's bash environment
RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc && \
    echo "source /catkin_ws/devel/setup.bash" >> /root/.bashrc

# Set the default command to bash
CMD ["bash"]
