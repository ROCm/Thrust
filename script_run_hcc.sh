#!/bin/bash

for i in `find $1 -name '*.out'`;
do echo $i ; ./$i >& $i.txt;
done

