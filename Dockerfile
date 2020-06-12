FROM trzeci/emscripten:1.39.17-upstream

RUN apt-get update && \
    apt-get install -y libtool autotools-dev autoconf automake

