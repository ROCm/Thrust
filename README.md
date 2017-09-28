# Thrust
HIP back-end for Thrust (alpha release).

### Introduction
Thrust is a parallel algorithm library. This library has been ported to HIP/ROCm platform. This repository contains the HIP port of Thrust. The HIP ported library works on both HIP/CUDA and HIP/ROCm platforms.


### Pre-requisites

### Hardware
Visit the following link for ROCm hardware requirements:
https://github.com/RadeonOpenCompute/ROCm/blob/master/README.md#supported-cpus


### Installation

AMD ROCm Installation

$ wget -qO - http://repo.radeon.com/rocm/apt/debian/rocm.gpg.key | sudo apt-key add -

$ sudo sh -c 'echo deb [arch=amd64] http://repo.radeon.com/rocm/apt/debian/ xenial main > /etc/apt/sources.list.d/rocm.list'

$ sudo apt-get update

$ sudo apt-get install rocm-dev

### Thrust

$ git clone  https://github.com/ROCmSoftwarePlatform/Thrust.git

$ cd Thrust

### Executable generation

$ export HIP_PLATFORM=hcc (For HCC Platform )

$ export HIP_PLATFORM=nvcc ( For NVCC Platform)				

$ cd examples									

Change the extension of the application file from .cu to .cpp

$ cp sum.cu sum.cpp

To recursively change the extension of all the applications in the Thrust/examples run the  cu_to_cpp.sh script

 $ ./cu_to_cpp.sh

For NVCC or HCC platform, build application using hipcc compiler for example:  

$ /opt/rocm/bin/hipcc sum.cpp  -I../ -o sum.out 							

To recursively generate executables to all the applications in Thrust/examples,run script_compile_testing_hcc.sh script

$ ./script_compile_testing_hcc.sh


### Unit Test												
 Run the following commands to generate executables for test cases in Thrust/testing.	

 Single file

$ cp device_ptr.cu device_ptr.cpp

$ /opt/rocm/bin/hipcc device_ptr.cpp testframework.cpp -I. -I../ -o device_ptr.cpp.out									

 Multiple files(recursively)

$ ./cu_to_cpp.sh

$ ./script_compile_testing_hcc.sh												

### Known Issues:
A linker error is being faced while trying to generate executables for test cases in Thrust/testing/backend/cuda,thereby allowing to generate only object files. The compile only option “-c” alone works while compiling test cases in backend/cuda.					


### Thrust API Functionality:

S.NO  |  Thrust API                      |  HIP/CUDA   |  HIP/ROCm
------|----------------------------------|-------------|-------------
1     |  thrust::device_ptr              |  Supported  |  Supported
2     |  thrust::counting_iterator       |  Supported  |  In-progress
3     |  thrust::copy                    |  Supported  |  In-progress
4     |  thrust::stable_sort_by_key      |  Supported  |  In-progress
5     |  thrust::sequence                |  Supported  |  In-progress
6     |  thrust:sort_by_key              |  Supported  |  In-progress
7     |  thrust::inner_product           |  Supported  |  In-progress
8     |  thrust::plus<int>               |  Supported  |  Supported
9     |  thrust::not_equal_to<real>      |  Supported  |  In-progress
10    |  thrust::reduce_by_key           |  Supported  |  In-progress
11    |  thrust::constant_iterator<int>  |  Supported  |  In-progress
12    |  thrust::exclusive_scan          |  Supported  |  In-progress
13    |  thrust::inclusive_scan          |  Supported  |  In-progress
14    |  thrust::distance                |  Supported  |  Supported
15    |  thrust::transform               |  Supported  |  In-progress
16    |  thrust::max_element             |  Supported  |  In-progress
17    |  thrust::find_if                 |  Supported  |  In-progress
18    |  thrust::find                    |  Supported  |  In-progress
19    |  thrust::copy_if                 |  Supported  |  In-progress
20    |  thrust::tabulate                |  Supported  |  In-progress
21    |  thrust::identity<real>          |  Supported  |  In-progress
22    |  thrust::make_pair               |  Supported  |  In-progress
23    |  thrust::pair                    |  Supported  |  Supported
24    |  thrust::inclusive_scan_by_key   |  Supported  |  In-progress
25    |  thrust::make_reverse_iterator   |  Supported  |  In-progress
26    |  thrust::equal_to<long>          |  Supported  |  In-progress
27    |  thrust::maximum<long>           |  Supported  |  In-progress
28    |  thrust::transform_reduce        |  Supported  |  In-progress
29    |  thrust::make_zip_iterator       |  Supported  |  In-progress
30    |  thrust::make_tuple              |  Supported  |  In-progress
31    |  thrust::get<>                   |  Supported  |  In-progress
32    |  thrust::transform_iterator      |  Supported  |  Supported
33    |  thrust::permutation_iterator    |  Supported  |  In-progress
34    |  thrust::fill                    |  Supported  |  In-progress
35    |  thrust::iterator_difference     |  Supported  |  In-progress
36    |  thrust::device_vector           |  Supported  |  Supported
37    |  thrust::unary_function          |  Supported  |  In-progress


