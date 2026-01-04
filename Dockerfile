# 1. Use the official NVIDIA CUDA image as the base
# This image already contains the CUDA Toolkit (nvcc) and libraries
# We use the "devel" version to get compilers (nvcc) needed for things like flash-attn
FROM nvidia/cuda:12.4.1-devel-ubuntu22.04

# 2. Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH=/usr/local/cuda/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# 3. Install basic utilities and Python 3.10 (Standard for Ubuntu 22.04)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    curl \
    wget \
    vim \
    python3 \
    python3-pip \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# 4. Install Miniforge
# We download the latest script and install it to /opt/conda
RUN wget --quiet https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -O ~/miniforge.sh && \
    /bin/bash ~/miniforge.sh -b -p /opt/conda && \
    rm ~/miniforge.sh && \
    # Initialize conda for shell interaction
    /opt/conda/bin/conda init bash

# 5. Install PyTorch ecosystem
# We use the 'base' environment. Miniforge defaults to conda-forge, but
# we explicitly add '-c pytorch -c nvidia' as requested to get the official binaries.
RUN /opt/conda/bin/mamba install -n base \
    python=3.10 \
    pytorch \
    torchvision \
    torchaudio \
    pytorch-cuda=12.4 \
    -c pytorch \
    -c nvidia \
    -y && \
    /opt/conda/bin/mamba clean -afy

# 6. Install OpenVLA (Clone -> Install -> Keep for now)
# We keep the source temporarily because LIBERO installation needs libero_requirements.txt
# FIXED SECTION: Use absolute paths (/opt/conda/bin/...)
RUN cd /tmp && \
    git clone https://github.com/openvla/openvla.git && \
    cd openvla && \
    /opt/conda/bin/pip install -e . --no-build-isolation && \
    cd /


# 7. LIBERO
# Fix numpy version conflict before installing LIBERO
RUN echo "Installing Libero Requirements..." && \
    cd /tmp && \
    # First install numpy compatible with TensorFlow
    /opt/conda/bin/pip install "numpy>=1.23.5,<2.0.0" && \
    # Install libero_requirements.txt from openvla repo first
    /opt/conda/bin/pip install -r /tmp/openvla/experiments/robot/libero/libero_requirements.txt && \
    # Now clone and install LIBERO
    git clone https://github.com/Lifelong-Robot-Learning/LIBERO.git && \
    cd LIBERO && \
    /opt/conda/bin/pip install -e . --no-build-isolation && \
    # Verify Libero installation
    /opt/conda/bin/python -c "import libero; print('Libero installed successfully')" && \
    cd /


# 8. BridgeData V2 (WidowX Envs)
RUN echo "Installing BridgeData V2 Requirements..." && \
    cd /tmp && \
    git clone https://github.com/rail-berkeley/bridge_data_robot.git && \
    # Note: setup.py is inside the 'widowx_envs' subdirectory
    cd bridge_data_robot/widowx_envs && \
    /opt/conda/bin/pip install -e . --no-build-isolation && \
    echo "Installing EdgeML..." && \
    git clone https://github.com/youliangtan/edgeml.git && \
    cd edgeml && \
    /opt/conda/bin/pip install -e . --no-build-isolation && \
    cd / 

# 9. CRITICAL FIX: Manually add Source Roots to PYTHONPATH
# This fixes the "ModuleNotFoundError" when you are not inside the directories.
# We map the exact locations where we cloned the repos.
ENV PYTHONPATH="/tmp/LIBERO:/tmp/openvla:/tmp/bridge_data_robot/widowx_envs:/tmp/edgeml"

# 10. Final fix (ensure compatible version)
RUN /opt/conda/bin/pip install "numpy>=1.23.5,<2.0.0" && \
    /opt/conda/bin/pip install flash-attn --no-build-isolation

# Default command
# (Optional) Create a working directory
# WORKDIR /app
CMD ["/bin/bash"]