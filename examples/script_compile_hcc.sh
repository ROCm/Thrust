for i in `find $pwd -name '*.cu'` ; do echo $i ;  hipcc $i -I../ -o $i.out >& $i.txt ; 
done
