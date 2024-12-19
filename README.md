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
Currently the prebuilt files `rnnoise.wasm` along with the `index.js` are genererated using the old rnnoise release 0.1 while the sync version is generated using 0.2. This is done to keep compatibility with usage in jitsi meet, namely the old async version is used for noise detection while the new sync model is used for actual noise suppression within the context of an `AudioWorklet`. This will change in the future when jitsi meet noise detection will have updated heuristics using the new model.
However, following a build all files in the dist files will be replaced with versions using the new model (both sync and async). 
Files replaced include the actual webassembly binary `rnnoise.wasm` and the generated emscriten.js file named `rnnoise.js` which contains glue code and the necessary libc runtime javascript bindings, as well as the `rnnoise-sync.js` file which is the sync loading version that has the binary wasm module inlined as a base64 string, this is useful for contexts that only allow synchronous loading of resources, like an `AudioWorklet`.

The repo is structured so it can be used as a npm dependency, with the entry point in dist/index.js, be mindful as using index.js
automatically implies that rnnoise.wasm needs to be present as well, thus for a normal npm build system one must explicitly copy rnnoise.wasm to the project structure.

