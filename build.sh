#!/usr/bin/env sh
# Simple script to just contain the cmake build options

cmake -S . -B build \
  -DROCKSDB_BUILD_SHARED=ON \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DCMAKE_BUILD_TYPE=Debug \
  -DWITH_EXAMPLES=ON
cmake --build build --parallel 4 --config Debug --target ${1:-simple_example_traced}
