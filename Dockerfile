FROM ubuntu:20.04

# 日本設定
ENV TZ Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV LANG ja_JP.UTF-8

# パッケージインストール
RUN apt update -yqq && \
    apt install -y --no-install-recommends \
    build-essential curl ca-certificates \
    file git locales sudo && \
    locale-gen ja_JP.UTF-8 && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*



FROM python:2.7.18

WORKDIR /usr/src/app

COPY . .


RUN apt update


RUN apt-get -q -y install git curl
# RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git > /dev/null 
# RUN echo yes | mecab-ipadic-neologd/bin/install-mecab-ipadic-neologd -n > /dev/null 2>&1
# 

#setup tesseract-ocr
RUN apt-get -y install tesseract-ocr tesseract-ocr-jpn libtesseract-dev libleptonica-dev tesseract-ocr-script-jpan tesseract-ocr-script-jpan-vert 

# RUN pip install -r requirements.txt
RUN pip install setuptools_scm
RUN pip install psutil
RUN pip install torch>=0.3
