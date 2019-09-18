#!/bin/bash

set -e

export OPTIMIZE="-Os"
export LDFLAGS=${OPTIMIZE}
export CFLAGS=${OPTIMIZE}
export CXXFLAGS=${OPTIMIZE}

ENTRY_POINT="rnnoise.js"

echo "============================================="
echo "Compiling wasm bindings"
echo "============================================="
(
  cd rnnoise

  # Clean possible autotools clutter that might affect the configurations step
  git clean -f -d
  ./autogen.sh

  # For some reason setting the CFLAGS export doesn't apply optimization to all compilation steps
  # so we need to explicitly pass it to configure.
  emconfigure ./configure CFLAGS=${OPTIMIZE}
  emmake make clean
  emmake make V=1

  # Compile librnnoise generated LLVM bytecode to wasm
  emcc \
    ${OPTIMIZE} \
    -s STRICT=1 \
    -s ALLOW_MEMORY_GROWTH=1 \
    -s MALLOC=emmalloc \
    -s MODULARIZE=1 \
    -s EXPORT_ES6=1 \
    -s EXPORTED_FUNCTIONS="['_rnnoise_process_frame', '_rnnoise_init', '_rnnoise_destroy', '_rnnoise_create', '_malloc', '_free']" \
    .libs/librnnoise.so \
    -o ./$ENTRY_POINT

  # Create output folder
  rm -rf ../dist
  mkdir -p ../dist

  # Move artifacts
  mv $ENTRY_POINT ../dist/index.js
  mv rnnoise.wasm ../dist/

  # Clean cluttter
  git clean -f -d
)
echo "============================================="
echo "Compiling wasm bindings done"
echo "============================================="