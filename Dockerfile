# Use the official ROCm image as a parent image
FROM rocm/dev-ubuntu-22.04:5.3

# Set the working directory in the container
WORKDIR /app

# Install Python and pip
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    build-essential \
    wget \
    unzip \
    git \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/* 

# Upgrade setuptools
RUN --mount=type=cache,target=/root/.cache/pip pip3 install --upgrade setuptools

# Install setuptools and wheel
RUN --mount=type=cache,target=/root/.cache/pip pip3 install setuptools wheel

# Download and unzip the audio-webui
RUN wget https://github.com/gitmylo/audio-webui/releases/download/Installers/audio-webui.zip
RUN unzip audio-webui.zip

# Install dependencies from the install script
RUN --mount=type=cache,target=/root/.cache/pip bash /app/install_linux_macos.sh

# Set the working directory for the app
WORKDIR /app/audio-webui

# Copy necessary files
COPY ./.env /app
COPY ./run.sh /app

# If you have additional installation steps, uncomment and modify as needed
# RUN --mount=type=cache,target=/root/.cache/pip bash /app/install.sh
# RUN --mount=type=cache,target=/root/.cache/pip pip3 install tensorboardX
