for i in `find $pwd -name '*.cpp'` ; do echo $i ;/opt/rocm/bin/hipcc $i testframework.cpp -I. -I../  -o $i.out >& $i.txt ; 
done

for file in *.cpp.out; do mv "${file}" "${file/%cpp.out/out}"; done
