/opt/rocm/llvm/bin/clang++ -x assembler -target amdgcn--amdhsa --offload-arch=gfx942 ./bmm_asm.s -o bmm_asm.co
hipcc batched_gemm_asm.cpp -o ./batched_gemm_asm