FROM trzeci/emscripten:sdk-tag-1.38.30-64bit

RUN apt-get update && \
    apt-get install -y libtool && \
    apt-get install -y autotools-dev && \
    apt-get install -y autoconf && \
    apt-get install -y automake