#include <stdio.h>
#include <chrono>

__global__ void hello_kernel(void)
{
  printf("Hello, world from the device!\n");
}

int main(void)
{
  /*unsigned int timer;
  cutCreateTimer(&timer);
  curStartTimer(timer);*/

  printf("Hello, world from the host!\n");

  // инициализируем события
  cudaEvent_t start, stop;
  float elapsedTime;

  // создаем события
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  // запись события
  cudaEventRecord(start, 0);
  cudaEventRecord(stop,0);

  hello_kernel<<<1,1>>>(); 
 
  cudaEventSynchronize(stop);
  cudaEventElapsedTime(&elapsedTime, start, stop);

  // вывод информации 
  printf("Time spent executing by the GPU: %.7f  millseconds\n", elapsedTime);

  // уничтожение события 
  cudaEventDestroy(start);
  cudaEventDestroy(stop);

  return 0;
}
