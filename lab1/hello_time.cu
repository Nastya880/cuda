#include <iostream>
#include <cuda_runtime.h>
#include <chrono>

constexpr const size_t N = 1024 * 1024;

__global__ void kernel(float* data)
{
}

void run_hello_world(dim3 grid_dim, dim3 block_dim)
{
    float* a;
    float* dev = nullptr;

    a = (float*)malloc(N * sizeof(float));
    cudaMalloc((void**)&dev, N * sizeof(float));

    auto start = std::chrono::high_resolution_clock::now();
    kernel<<<grid_dim, block_dim>>> (dev);
    auto end = std::chrono::high_resolution_clock::now();
    std::cout << std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count() << "ns\n";

    cudaMemcpy(a, dev, N * sizeof(float), cudaMemcpyDeviceToHost);
    cudaFree(dev);
    free(a);
}

int main(int argc, char* argv[])
{

    int deviceCount;

    std::cout << "Base GPU execution time: ";
    run_hello_world({(N/512),1}, {512, 1});

//    start = std::chrono::high_resolution_clock::now();
    std::cout << "Full GPU execution time: ";
    run_hello_world({(N/prop.maxThreadsDim[0]),1}, {(uint32_t)prop.maxThreadsDim[0], 1});
//    end = std::chrono::high_resolution_clock::now();
//    std::cout << "Full GPU execution time: " << std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count() << "ms\n";

    return 0;
}
