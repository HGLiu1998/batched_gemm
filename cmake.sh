cmake                                                                                             \
-D CMAKE_PREFIX_PATH=/opt/rocm/                                                                   \
-D CMAKE_CXX_COMPILER=/opt/rocm/bin/hipcc                                          \
-D CMAKE_CXX_FLAGS="-ftemplate-backtrace-limit=0  -fPIE  -Wno-gnu-line-marker -fbracket-depth=512" \
-D CMAKE_BUILD_TYPE=Release                                                                       \
-D BUILD_DEV=ON                                                                                   \
-D GPU_TARGETS=gfx942                                                              \
-D CMAKE_VERBOSE_MAKEFILE:BOOL=ON                                                                 \
-D USE_BITINT_EXTENSION_INT4=OFF    