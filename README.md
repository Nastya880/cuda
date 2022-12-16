# CUDA labs
CUDA works in Google Colab

## Запуск и выполнение (инструкция  https://medium.com/@iphoenix179/running-cuda-c-c-in-jupyter-or-how-to-run-nvcc-in-google-colab-663d33f53772)

1. Открыть a Colab notebook: https://colab.research.google.com/
2. Создать новый Python3 notebook
3. Сменить среду выполнения на аппаратный ускоритель GPU
4. Выполнить 

```
!apt update -qq;
!wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb;
!dpkg -i cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb;
!apt-key add /var/cuda-repo-8-0-local-ga2/7fa2af80.pub;
!apt-get update -qq;
!apt-get install cuda gcc-5 g++-5 -y -qq;
!ln -s /usr/bin/gcc-5 /usr/local/cuda/bin/gcc;
!ln -s /usr/bin/g++-5 /usr/local/cuda/bin/g++;
!apt install cuda-8.0;
```
5. Пртотверить установку nvcc
```
!/usr/local/cuda/bin/nvcc --version
```
Должен быть такой ответ:
```
nvcc: NVIDIA (R) Cuda compiler driver Copyright (c) 2005-2016 NVIDIA Corporation Built on Tue_Jan_10_13:22:03_CST_2017 Cuda compilation tools, release 8.0, V8.0.61
```

6. Установить расширение
```
!pip install git+git://github.com/andreinechaev/nvcc4jupyter.git
```

7. Загрузить установленное расширение
```
%load_ext nvcc_plugin
```

### Готово! Для сообщение интерпретатору об использовании cuda в программе писать %%cu

Запускать можно так
``` 
%%writefile test.cu
#include <stdlib.h>
#include <stdio.h>
...
```

```
!nvcc test.cu -o test -Wno-deprecated-gpu-targets
!nvprof ./test
```
