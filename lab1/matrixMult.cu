%%writefile matrixMult.cu
#include "cuda_runtime.h"
#include <stdio.h>
#include <stdlib.h>

#define BLOCK_SIZE 16

__global__ void matrixMult(int *A, int *B, int *C, int N) 
{
    int i0 = N * (blockDim.y * blockIdx.y +  threadIdx.y);
    int j0 = blockDim.x * blockIdx.x + threadIdx.x;
    int sum = 0;

    for (int k = 0; k < N; k++)
    sum += A[i0 + k] * B[k * N + j0]; //смещение для записываемого элемента

    int ind = N * (blockDim.y * blockIdx.y + threadIdx.y) + blockDim.x * blockIdx.x + threadIdx.x;
    C[ind] = sum;
}

int main()
{
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // количество строк и столбцов матрицы
    int N = 100;
    
    size_t ABCsize = N * N * sizeof(int);
    
    int *h_A = (int *)malloc(ABCsize);
    int *h_B = (int *)malloc(ABCsize);
    int *h_C = (int *)malloc(ABCsize);
 
    //заполнение матриц
    for (int i = 0; i < N * N; ++i)
    {
        h_A[i] = rand() % (int)RAND_MAX;
    }

    for (int i = 0; i < N * N; ++i)
    {
        h_B[i] = rand()%(int)RAND_MAX;
    }
    
    int *d_A = NULL;
    cudaMalloc((void **)&d_A, Asize);
    
    int *d_B = NULL;
    cudaMalloc((void **)&d_B, Bsize);
    
    int * d_C = NULL;
    cudaMalloc((void **)&d_C, Csize);
    cudaMemcpy(d_A, h_A, ABCsize, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, ABCsize, cudaMemcpyHostToDevice);
 
    dim3 threadsPerBlock = dim3(BLOCK_SIZE, BLOCK_SIZE);
    dim3 blocksPerGrid = dim3(N / BLOCK_SIZE, N /  BLOCK_SIZE);
    cudaEventRecord(start, 0);
    
    matrixMult<<<blocksPerGrid, threadsPerBlock>>>(d_A, d_B, d_C, N);
    
    cudaEventRecord(stop, 0);
    cudaEventSynchronize(stop);

    float KernelTime;
    cudaEventElapsedTime(&KernelTime, start, stop);
    printf("KernelTime: %.2f milliseconds\n", KernelTime);
    
    cudaMemcpy(h_C, d_C, Csize, cudaMemcpyDeviceToHost);
    
    printf("MULTIPLICATE\n");
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            int sum = 0;
                for (int k = 0; k < N; k++) 
                    sum += h_A[i * N + k] * h_B[k * N + j];
        }
    }
    printf("END\n");
    
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
    free(h_A);
    free(h_B);
    free(h_C);

    cudaEventDestroy(start);
    cudaEventDestroy(stop);

    return 0;
}
