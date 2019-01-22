#!/bin/bash

echo $PWD

cd $PWD/examples
./cu_to_cpp.sh
./script_compile_hcc.sh

cd ..
cd testing
./cu_to_cpp.sh


cd backend/cuda
cp ../../cu_to_cpp.sh .
./cu_to_cpp.sh

cd ../../
./script_compile_testing_hcc.sh

cd ../performance
./script_compile_performance.sh

cd ..
./script_run_hcc.sh


