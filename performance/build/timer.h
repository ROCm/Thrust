/*
 *  Copyright 2008-2009 NVIDIA Corporation
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#pragma once

// A simple timer class

#ifdef __HIPCC__

// use CUDA's high-resolution timers when possible
#include <hip/hip_runtime_api.h>
#include <string>
#include <thrust/system/cuda/error.h>
#include <thrust/system_error.h>

void cuda_safe_call(hipError_t error, const std::string& message = "")
{
    if(error)
        throw thrust::system_error(error, thrust::cuda_category(), message);
}

struct timer
{
    hipEvent_t start;
    hipEvent_t end;

    timer(void)
    {
        cuda_safe_call(hipEventCreate(&start));
        cuda_safe_call(hipEventCreate(&end));
        restart();
    }

    ~timer(void)
    {
        cuda_safe_call(hipEventDestroy(start));
        cuda_safe_call(hipEventDestroy(end));
    }

    void restart(void)
    {
        cuda_safe_call(hipEventRecord(start, 0));
    }

    double elapsed(void)
    {
        cuda_safe_call(hipEventRecord(end, 0));
        cuda_safe_call(hipEventSynchronize(end));

        float ms_elapsed;
        cuda_safe_call(hipEventElapsedTime(&ms_elapsed, start, end));
        return ms_elapsed / 1e3;
    }

    double epsilon(void)
    {
        return 0.5e-6;
    }
};

#elif defined(__linux__)

#include <sys/time.h>

struct timer
{
    timeval start;
    timeval end;

    timer(void)
    {
        restart();
    }

    ~timer(void) {}

    void restart(void)
    {
        gettimeofday(&start, NULL);
    }

    double elapsed(void)
    {
        gettimeofday(&end, NULL);

        return static_cast<double>(end.tv_sec - start.tv_sec)
               + 1e-6 * static_cast<double>((int)end.tv_usec - (int)start.tv_usec);
    }

    double epsilon(void)
    {
        return 0.5e-6;
    }
};

#else

// fallback to clock()
#include <ctime>

struct timer
{
    clock_t start;
    clock_t end;

    timer(void)
    {
        restart();
    }

    ~timer(void) {}

    void restart(void)
    {
        start = clock();
    }

    double elapsed(void)
    {
        end = clock();

        return static_cast<double>(end - start) / static_cast<double>(CLOCKS_PER_SEC);
    }

    double epsilon(void)
    {
        return 1.0 / static_cast<double>(CLOCKS_PER_SEC);
    }
};

#endif
