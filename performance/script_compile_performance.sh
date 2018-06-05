#!/bin/bash
for i in `find $pwd -name '*.test'` ;do python build/perftest.py ;
done

for i in `find $pwd -name '*.cu'` ;do /opt/rocm/bin/hipify-perl --inplace $i
done
rm -rf *.prehip

for f in *.cu; do
cp -- "$f" "${f%.cu}.cpp"
done

cp -r ../testing/unittest .


for i in `find $pwd -name '*.cpp'` ;do echo $i ;/opt/rocm/bin/hipcc $i -I. -I../  -o $i.out >& $i.txt ;
done

for file in *.cpp.out; do mv "${file}" "${file/%cpp.out/out}"; done


