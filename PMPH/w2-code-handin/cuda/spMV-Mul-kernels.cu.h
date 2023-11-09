#ifndef SP_MV_MUL_KERS
#define SP_MV_MUL_KERS

/* __global__ void task3Kernel(float* d_in, float *d_out, int N) { */
/*     const unsigned int lid = threadIdx.x; // local id inside a block */
/*     const unsigned int gid = blockIdx.x*blockDim.x + lid; // global id */
/*     if (gid < N) { */
/*         float val = d_in[gid]; */
/*         val = val/(val-2.3); */
/*         d_out[gid] = val*val*val; // do computation */
/*     } */
/* } */

__global__ void
replicate0(int tot_size, char* flags_d) {
    // ... fill in your implementation here ...
    const unsigned int gid = blockIdx.x*blockDim.x+threadIdx.x;
    if (gid < tot_size) {
        flags_d[gid] = 0;
    }
}

__global__ void
mkFlags(int mat_rows, int* mat_shp_sc_d, char* flags_d) {
    // ... fill in your implementation here ...
    const unsigned int gid = blockIdx.x*blockDim.x+threadIdx.x;
    if (gid < mat_rows) {
        flags_d[mat_shp_sc_d[gid]] = 1;
    }
}

__global__ void 
mult_pairs(int* mat_inds, float* mat_vals, float* vct, int tot_size, float* tmp_pairs) {
    // ... fill in your implementation here ...
    const unsigned int gid = blockIdx.x*blockDim.x+threadIdx.x;
    if (gid < tot_size) {
        tmp_pairs[gid] = mat_vals[gid] * vct[mat_inds[gid]];
    }
}

__global__ void
select_last_in_sgm(int mat_rows, int* mat_shp_sc_d, float* tmp_scan, float* res_vct_d) {
    // ... fill in your implementation here ...
    const unsigned int gid = blockIdx.x*blockDim.x+threadIdx.x;
    if (gid < mat_rows) {
        res_vct_d[gid] = tmp_scan[mat_shp_sc_d[gid]-1];//-1 since we want the end of the prev arr and not the start of this arr.
    }
}

#endif
