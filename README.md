# rnnoise-wasm

[rnnoise](https://people.xiph.org/~jm/demo/rnnoise/) noise suppression library as a WASM module.

This repository contains the necessary utilities to build the library using a Docker build environment with Emscripten.

## Build

### Prerequisites

- node - tested version v10.16.3
- npm  - tested version v6.9.0
- docker - tested version 19.03.1

### Building the module

Building is straightforward, run:
```
npm run build
```
The repository already has a pre-compiled version under the **dist** folder, running the above command will replace it with the newly compiled binaries and glue wasm .js file respectively.

In order to facilitate the build with docker the following prebuilt image is used [trzeci/emscripten/](https://hub.docker.com/r/trzeci/emscripten/) however, it is slightly altered by installing autotools components necessary for building rnnoise.

In summary the build process consists of two steps:

1. `build:dockerfile` - pulls in [trzeci/emscripten/](https://hub.docker.com/r/trzeci/emscripten/) which is then altered and saved. Any suqsequent build is going to check if the images was already installed and use that, so if one wants to make changes to the Dockerfile be sure to first delete the build image from your local docker repo.
2. `build:emscripten` - mounts the repo to the docker image from step one and runs build.sh on it. The bash script contains all the steps necessary for building rnnoise as a wasm module.

## Usage

Following a build two files are generated under **dist**, the actual webassembly binary `rnnoise.wasm` and the generated emscriten .js file named `index.js` which contains glue code and the necessary libc runtime javascript bindings.

The repo is structured so it can be used as a npm dependency, with the entry point in dist/index.js, be mindful as using index.js
automatically implies that rnnoise.wasm needs to be present as well, thus for a normal npm build system one must explicitly copy rnnoise.wasm to the project structure.

