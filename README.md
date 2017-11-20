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

### Directory Structure
```
├── doc
├── examples
│   ├── cpp_integration
│   ├── cuda
│   └── include
├── performance
│   └── build
├── site_scons
│   └── site_tools
├── testing
│   ├── backend
│   │   ├── cuda
│   │   └── omp
│   ├── trivial_tests
│   └── unittest
└── thrust
    ├── detail
    │   ├── allocator
    │   ├── complex
    │   ├── config
    │   ├── dispatch
    │   ├── functional
    │   │   └── operators
    │   ├── mpl
    │   ├── range
    │   ├── type_traits
    │   │   ├── algorithm
    │   │   └── iterator
    │   └── util
    ├── iterator
    │   └── detail
    ├── random
    │   └── detail
    └── system
        ├── cpp
        │   └── detail
        ├── cuda
        │   ├── detail
        │   │   ├── block
        │   │   ├── bulk
        │   │   │   ├── algorithm
        │   │   │   │   └── detail
        │   │   │   ├── detail
        │   │   │   │   └── cuda_launcher
        │   │   │   └── iterator
        │   │   ├── cub
        │   │   │   ├── block
        │   │   │   │   └── specializations
        │   │   │   ├── block_range
        │   │   │   │   └── specializations
        │   │   │   ├── block_sweep
        │   │   │   │   └── specializations
        │   │   │   ├── device
        │   │   │   │   └── dispatch
        │   │   │   ├── grid
        │   │   │   ├── host
        │   │   │   ├── iterator
        │   │   │   ├── thread
        │   │   │   └── warp
        │   │   │       └── specializations
        │   │   └── detail
        │   └── experimental
        ├── detail
        │   ├── adl
        │   ├── generic
        │   │   └── scalar
        │   ├── internal
        │   └── sequential
        ├── omp
        │   └── detail
        └── tbb
            └── detail
```

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

### Known Issues
A linker error is being faced while trying to generate executables for test cases in Thrust/testing/backend/cuda,thereby allowing to generate only object files. The compile only option “-c” alone works while compiling test cases in backend/cuda.					

### Dependency
 There exists a dependency on hipified version of cub to generate executables.
 The hipified cub is available as cub-hip in <https://github.com/ROCmSoftwarePlatform/cub-hip/tree/hip_port_1.7.3>
   
 Credentials may be required to clone cub-hip.
 The hipified cub should be placed according to the directory structure mentioned above.

### Thrust API Functionality

Serial No.  |  Thrust API                     |  HIP/CUDA   |  HIP/ROCm
------------|---------------------------------|-------------|-------------
1           |  thrust::device_ptr             |  Supported  |  **Supported**
2           |  thrust::make_zip_iterator      |  Supported  |  **Supported**
3           |  thrust::copy                   |  Supported  |  **Supported**
4           |  thrust::stable_sort_by_key     |  Supported  |  **Supported**
5           |  thrust::sequence               |  Supported  |  **Supported**
6           |  thrust::inner_product          |  Supported  |  **Supported**
7           |  thrust::plus                   |  Supported  |  **Supported**
8           |  thrust::distance               |  Supported  |  **Supported**
9           |  thrust::transform              |  Supported  |  **Supported**
10          |  thrust::inclusive_scan_by_key  |  Supported  |  **Supported**
11          |  thrust::exclusive_scan         |  Supported  |  **Supported**
12          |  thrust::inclusive_scan         |  Supported  |  **Supported**
13          |  thrust::iterator_difference    |  Supported  |  **Supported**
14          |  thrust::device_vector          |  Supported  |  **Supported**
15          |  thrust::unary_function         |  Supported  |  **Supported**
16          |  thrust::get<>                  |  Supported  |  **Supported**
17          |  thrust::transform_iterator     |  Supported  |  **Supported**
18          |  thrust::permutation_iterator   |  Supported  |  **Supported**
19          |  thrust::make_tuple             |  Supported  |  **Supported**
20          |  thrust::identity               |  Supported  |  **Supported**
21          |  thrust::fill                   |  Supported  |  **Supported**
22          |  thrust::transform_reduce       |  Supported  |  **Supported**
23          |  thrust::counting_iterator      |  Supported  |  **Supported**
24          |  thrust::maximum                |  Supported  |  **Supported**
25          |  thrust::not_equal_to           |  Supported  |  In-progress
26          |  thrust::reduce_by_key          |  Supported  |  In-progress
27          |  thrust::constant_iterator      |  Supported  |  In-progress
28          |  thrust::max_element            |  Supported  |  In-progress
29          |  thrust::find_if                |  Supported  |  In-progress
30          |  thrust::find                   |  Supported  |  In-progress
31          |  thrust::copy_if                |  Supported  |  In-progress
32          |  thrust::tabulate               |  Supported  |  In-progress
33          |  thrust::make_pair              |  Supported  |  In-progress
34          |  thrust::pair                   |  Supported  |  In-progress
35          |  thrust::make_reverse_iterator  |  Supported  |  In-progress
36          |  thrust::equal_to               |  Supported  |  In-progress
37          |  thrust:sort_by_key             |  Supported  |  In-progress

