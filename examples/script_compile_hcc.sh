for i in `find $pwd -name '*.cpp'` ; do echo $i ; /opt/rocm/bin/hipcc $i -I../ -I../thrust/system/cuda/detail/cub-hip -g -o $i.out >& $i.txt ; 
done
