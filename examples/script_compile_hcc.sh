for i in `find $pwd -name '*.cu'` ; do echo $i ;  sudo hipcc $i -I. -I../ -Wno-deprecated-gpu-targets -o $i.out >& $i.txt ; 
done
