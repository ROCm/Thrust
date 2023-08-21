/*
 *  Copyright 2008-2013 NVIDIA Corporation
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

#include <hip/hip_runtime.h>
#include <iostream>
#include <stdexcept>
#include <thrust/detail/swap.h>
#include <thrust/system/cuda/detail/bulk/detail/config.hpp>
#include <thrust/system/cuda/detail/bulk/detail/guarded_cuda_runtime_api.hpp>
#include <thrust/system/cuda/detail/bulk/detail/terminate.hpp>
#include <thrust/system/cuda/detail/bulk/detail/throw_on_error.hpp>
#include <utility>

BULK_NAMESPACE_PREFIX
namespace bulk
{
    namespace detail
    {

        struct future_core_access;

    } // end detail

    template <typename T>
    class future;

    template <>
    class future<void>
    {
    public:
        __host__ __device__ ~future()
        {
            if(valid())
            {
#if __BULK_HAS_CUDART__
                // swallow errors
                hipError_t e = hipEventDestroy(m_event);

#if __BULK_HAS_PRINTF__
                if(e)
                {
                    printf("CUDA error after hipEventDestroy in future dtor: %s",
                           hipGetErrorString(e));
                } // end if
#endif // __BULK_HAS_PRINTF__

                if(m_owns_stream)
                {
                    e = hipStreamDestroy(m_stream);

#if __BULK_HAS_PRINTF__
                    if(e)
                    {
                        printf("CUDA error after hipStreamDestroy in future dtor: %s",
                               hipGetErrorString(e));
                    } // end if
#endif // __BULK_HAS_PRINTF__
                } // end if
#endif
            } // end if
        } // end ~future()

        __host__ __device__ void wait() const
        {
            // XXX should probably check for valid() here

#if __BULK_HAS_CUDART__

//#ifndef __CUDA_ARCH__
#if __HIP_DEVICE_COMPILE__ == 0
            // XXX need to capture the error as an exception and then throw it in .get()
            bulk::detail::throw_on_error(hipEventSynchronize(m_event),
                                         "hipEventSynchronize in future::wait");
#else
            // XXX need to capture the error as an exception and then throw it in .get()
            bulk::detail::throw_on_error(hipDeviceSynchronize(),
                                         "hipDeviceSynchronize in future::wait");
#endif // __CUDA_ARCH__

#else
            // XXX should terminate with a message
            bulk::detail::terminate();
#endif // __BULK_HAS_CUDART__
        } // end wait()

        __host__ __device__ bool valid() const
        {
            return m_event != 0;
        } // end valid()

        __host__ __device__ future()
            : m_stream(0)
            , m_event(0)
            , m_owns_stream(false)
        {
        }

        // simulate a move
        // XXX need to add rval_ref or something
        __host__ __device__ future(const future& other)
            : m_stream(0)
            , m_event(0)
            , m_owns_stream(false)
        {
            thrust::swap(m_stream, const_cast<future&>(other).m_stream);
            thrust::swap(m_event, const_cast<future&>(other).m_event);
            thrust::swap(m_owns_stream, const_cast<future&>(other).m_owns_stream);
        } // end future()

        // simulate a move
        // XXX need to add rval_ref or something
        __host__ __device__ future& operator=(const future& other)
        {
            thrust::swap(m_stream, const_cast<future&>(other).m_stream);
            thrust::swap(m_event, const_cast<future&>(other).m_event);
            thrust::swap(m_owns_stream, const_cast<future&>(other).m_owns_stream);
            return *this;
        } // end operator=()

    private:
        friend struct detail::future_core_access;

        __host__ __device__ future(hipStream_t s, bool owns_stream)
            : m_stream(s)
            , m_owns_stream(owns_stream)
        {
#if __BULK_HAS_CUDART__
            bulk::detail::throw_on_error(hipEventCreateWithFlags(&m_event, create_flags),
                                         "hipEventCreateWithFlags in future ctor");
            bulk::detail::throw_on_error(hipEventRecord(m_event, m_stream),
                                         "hipEventRecord in future ctor");
#endif
        } // end future()

        // XXX this combination makes the constructor expensive
        //static const int create_flags = hipEventDisableTiming | cudaEventBlockingSync;
        static const int create_flags = hipEventDisableTiming;

        hipStream_t m_stream;
        hipEvent_t  m_event;
        bool        m_owns_stream;
    }; // end future<void>

    namespace detail
    {

        struct future_core_access
        {
            __host__ __device__ inline static future<void> create(hipStream_t s, bool owns_stream)
            {
                return future<void>(s, owns_stream);
            } // end create_in_stream()

            __host__ __device__ inline static hipEvent_t event(const future<void>& f)
            {
                return f.m_event;
            } // end event()
        }; // end future_core_access

    } // end detail

} // end namespace bulk
BULK_NAMESPACE_SUFFIX
