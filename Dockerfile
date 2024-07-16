FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV PYENV_ROOT="/root/.pyenv"
ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}"
ENV PYTHON_VERSION=3.11.9
ENV PYGPT_REPOSITORY=https://github.com/szczyglis-dev/py-gpt.git
ENV PYGPT_VERSION=v2.2.19
ENV APP_DIR=/app
ENV QTWEBENGINE_CHROMIUM_FLAGS="--no-sandbox"


# Set working directory
WORKDIR $APP_DIR

# Install the necessary system dependencies
RUN apt-get update && apt-get install -y \
    alsa-utils build-essential curl gcc git gstreamer1.0-gl gstreaqmer1.0-libav gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly libasound2-data libasound2-plugins \
    libbz2-dev libffi-dev libgl1-mesa-dev liblzma-dev libncurses5-dev libncursesw5-dev libqt5gui5 libqt5x11extras5 \
    libreadline-dev libsqlite3-dev libssl-dev libwayland-cursor0 libxcb-cursor0 libxcb-icccm4 libxcb-render0-dev \
    libxcb-shape0-dev libxcb-util1 libxcb-xfixes0-dev libxcb1-dev libxkbcommon-x11-0 libxkbfile1 llvm make mesa-utils \
    pipewire portaudio19-dev pulseaudio python3-opencv tk-dev wget xserver-xorg-video-amdgpu xz-utils zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

#libasound2 libegl1-mesa

#RUN ldd /usr/lib/x86_64-linux-gnu/qt5/plugins/platforms/libqxcb.so

RUN curl https://pyenv.run | bash
RUN pyenv install $PYGPT_VERSION \
    && pyenv global $PYGPT_VERSION

#COPY requirements.txt .
RUN git clone  $APP_DIR
RUN git checkout $PYGPT_VERSION
RUN python3 -m venv venv
RUN pip install -r requirements.txt

# Expose port (replace PORT with actual port if necessary, 8000 is a placeholder)
EXPOSE 8000

# Run pip install and start the app
CMD ["python3", "run.py"]