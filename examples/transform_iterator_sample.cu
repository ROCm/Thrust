#include <thrust/iterator/transform_iterator.h>
#include <thrust/iterator/counting_iterator.h>
#include <thrust/device_vector.h>
#include <thrust/reduce.h>
#include <thrust/functional.h>
#include <iostream>
#include <iterator>
#include <string>

// this functor clamps a value to the range [lo, hi]
template <typename T>
struct clamp : public thrust::unary_function<T,T>
{
    T lo, hi;

    __host__ __device__
    clamp(T _lo, T _hi) : lo(_lo), hi(_hi) {}

    __host__ __device__
    T operator()(T x)
    {
        if (x < lo)
            return lo;
        else if (x < hi)
            return x;
        else
            return hi;
    }
};

template <typename T>
struct simple_negate : public thrust::unary_function<T,T>
{
    __host__ __device__
    T operator()(T x)
    {
        return -x;
    }
};

template <typename Iterator>
void print_range(const std::string& name, Iterator first, Iterator last)
{
    typedef typename std::iterator_traits<Iterator>::value_type T;

    std::cout << name << ": ";
    thrust::copy(first, last, std::ostream_iterator<T>(std::cout, " "));  
    std::cout << "\n";
}


int main(void)
{
    // clamp values to the range [1, 5]
    int lo = 1;
    int hi = 5;

    // define some types
    typedef thrust::device_vector<int> Vector;
    typedef Vector::iterator           VectorIterator;

    // initialize values
    Vector values(8);

    values[0] =  2;
    values[1] =  5;
    values[2] =  7;
    values[3] =  1;
    values[4] =  6;
    values[5] =  0;
    values[6] =  3;
    values[7] =  8;
    
    print_range("values         ", values.begin(), values.end());

    // define some more types
    typedef thrust::transform_iterator<clamp<int>, VectorIterator> ClampedVectorIterator;

    // create a transform_iterator that applies clamp() to the values array
    ClampedVectorIterator cv_begin = thrust::make_transform_iterator(values.begin(), clamp<int>(lo, hi));
    ClampedVectorIterator cv_end   = cv_begin + values.size();
    
    ////
    // compute the sum of the clamped sequence with reduce()
      std::cout << "sum of clamped values : " << thrust::reduce(cv_begin, cv_end) << "\n";  //On applying thrust::reduce function the result obtained is correct

       // now [clamped_begin, clamped_end) defines a sequence of clamped values
      print_range("clamped values ", cv_begin, cv_end);    //Here the compiler throws no device code error

    return 0;
}

