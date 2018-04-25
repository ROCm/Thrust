for i in `find $pwd -name '*.out'` ; do echo $i ; ./$i ; 
done
