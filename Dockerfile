
# FROM python:2.7.16
# # 日本設定
# ENV TZ Asia/Tokyo
# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# ENV LANG ja_JP.UTF-8

# # パッケージインストール
# RUN apt update -yqq && \
#     apt install -y --no-install-recommends \
#     build-essential curl ca-certificates \
#     file git locales sudo && \
#     locale-gen ja_JP.UTF-8 && \
#     apt clean && \
#     rm -rf /var/lib/apt/lists/*


FROM nvidia/cuda:11.0-devel-ubuntu20.04

ENV TZ Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV LANG ja_JP.UTF-8

# apt-get update や apt-get upgrade の前に
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub

ENV PYTHON_VERSION 2.7.16
ENV HOME /root
ENV PYTHON_ROOT $HOME/local/python-$PYTHON_VERSION
ENV PATH $PYTHON_ROOT/bin:$PATH
ENV PYENV_ROOT $HOME/.pyenv
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
    git \
    make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    && git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT \
    && $PYENV_ROOT/plugins/python-build/install.sh \
    && /usr/local/bin/python-build -v $PYTHON_VERSION $PYTHON_ROOT \
    && rm -rf $PYENV_ROOT


WORKDIR /usr/src/app

COPY . .


RUN apt-get -q -y install git curl
# RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git > /dev/null 
# RUN echo yes | mecab-ipadic-neologd/bin/install-mecab-ipadic-neologd -n > /dev/null 2>&1
# 

#setup tesseract-ocr
RUN apt-get -y install tesseract-ocr tesseract-ocr-jpn libtesseract-dev libleptonica-dev tesseract-ocr-script-jpan tesseract-ocr-script-jpan-vert 

# RUN pip install -r requirements.txt
RUN pip install setuptools_scm
RUN pip install psutil
RUN pip install future
RUN pip install numpy --upgrade
# RUN pip install torchvision torchaudio
RUN pip install https://download.pytorch.org/whl/cpu/torch-0.3.1-cp27-cp27mu-linux_x86_64.whl
# RUN pip install torch==1.11.0+cu102 torchvision==0.12.0+cu102 torchaudio==0.11.0 --extra-index-url https://download.pytorch.org/whl/cu102

