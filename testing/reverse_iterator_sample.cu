#include <unittest/unittest.h>
#include <thrust/iterator/reverse_iterator.h>
#include <thrust/sequence.h>
#include <thrust/scan.h>
template <typename T>
struct TestReverseIteratorExclusiveScan
{
  void operator()(const size_t n)
  {
    thrust::host_vector<T> h_data = unittest::random_samples<T>(n);

    thrust::device_vector<T> d_data = h_data;

    thrust::host_vector<T>   h_result(n);
    thrust::device_vector<T> d_result(n);

    thrust::exclusive_scan(thrust::make_reverse_iterator(h_data.end()),
                           thrust::make_reverse_iterator(h_data.begin()),
                           h_result.begin());

    thrust::exclusive_scan(thrust::make_reverse_iterator(d_data.end()),
                           thrust::make_reverse_iterator(d_data.begin()),
                           d_result.begin());
    if(n >=65)
    { 
     std::cout<<"Vector Size is :"<<n <<std::endl;
      for(int i=0;i<n;i++)
      {
             int hostValue = h_result[i];
             int deviceValue = d_result[i]; 
           std::cout<<i<<"->"<<hostValue<<","<<deviceValue<<"   ";
      }
        std::cout<<std::endl;
    }


    ASSERT_EQUAL_QUIET(h_result, d_result);
  }
};
VariableUnitTest<TestReverseIteratorExclusiveScan, IntegralTypes> TestReverseIteratorExclusiveScanInstance;

                                                                                                
