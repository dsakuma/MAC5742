#!/bin/bash

echo "CALL CONTENTION"
echo "---------------"

T=( 2 20 200 2000 )
N=( 10 1000 100000 10000000 )

for t in "${T[@]}"
do
  for n in "${N[@]}"
  do
     printf "\nRunning for T=$t and N=$n\n"
     output=$(./contention.sh $n $t)

     read N_IFS <<< $(echo "$output" | awk '/Number of ifs:[[:space:]]/ { print $4 }')
     read TIME_IFS <<< $(echo "$output" | awk '/[[:space:]]Average of[[:space:]]/ { print $5 }')

     # echo "${N_IFS}"
     echo "${TIME_IFS}"
  done
done

# declare -a arr=(1 2 3)

# arr=$(echo $N_IFS | tr " " "\n")
#
# for i in $arr
# do
#   printf "Running for i=$i\n"
# done
