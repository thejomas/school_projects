#!/usr/bin/env bash
# Find de 3 filer - compiler dem med opencl - kør dem og tag avg
# print avg - compiler med c - kør og tag avg - print avg - print improvement

files=("lssp-zeros" "lssp-same" "lssp-sorted")
for file in "${files[@]}"; do
    openclAvg=0
    cAvg=0
    echo "Compiling with opencl $file"
    futhark opencl "$file.fut"
    echo "Output from opencl benchmarks of $file";#take avg?
    futhark dataset --i32-bounds=-10:10 -b -g [10000000]i32 | ./$file -t /dev/stdout -r 10 | awk '{sum+=$1; print $1} END{print "Avg: " ((sum-$1) / (NR-1))}'
    echo "Compiling with c $file"
    futhark c "$file.fut"
    echo "Output from c benchmarks of $file";#take avg?
    futhark dataset --i32-bounds=-10:10 -b -g [10000000]i32 | ./$file -t /dev/stdout -r 10 | awk '{sum+=$1; print $1} END{print "Avg: " ((sum-$1) / (NR-1))}'
    #awk '{print "The improvement: " (cAvg/openclAvg)}'
done
# inp | awk '{sum+=$1}'
