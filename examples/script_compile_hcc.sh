for i in `find $pwd -name '*.cu'` ; do echo $i ; /opt/rocm/bin/hipcc $i -I../ -c -o $i.out >& $i.txt ; 
done
