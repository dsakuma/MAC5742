#!/bin/bash

call_contention()
{
  echo ""
  echo "CALL CONTENTION"
  echo "---------------"
  # Call contention with different numbers of Ts and Ns
  T=( 1700 1800 1900 2000 )
  N=( 10 )

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
}

index_of_best()
{
  echo 0
}

index_of_worst()
{
  echo 9
}

print_histogram_data()
{
  echo ""
  echo "BEST HISTOGRAM DATA"
  echo "-------------------"
  for i in `seq 0 9`
  do
    printf "$i - ${BESTHIST[i]}\n"
  done

  echo ""
  echo "BEST HISTOGRAM DATA"
  echo "-------------------"
  for i in `seq 0 9`
  do
    printf "$i - ${WORSTHIST[i]}\n"
  done
}

generate_histogram()
{
  echo ""
  echo "GENERATE HISTOGRAM DATA"
  echo "-----------------------"
  # Collect data to generate a histogram for a specific number of T and N
  BESTHIST=( 0 0 0 0 0 0 0 0 0 0 )
  WORSTHIST=( 0 0 0 0 0 0 0 0 0 0 )
  T=2
  N=10
  counter=0
  N_ROUNDS=2
  for i in `seq 1 $N_ROUNDS`
  do
      printf "Running for T=$T and N=$N. Round: $i\n"
      output=$(./contention.sh $N $T)
      read TIME_IFS <<< $(echo "$output" | awk '/[[:space:]]Average of[[:space:]]/ { print $5 }')
      idx_best=$(index_of_best)
      idx_worst=$(index_of_worst)
      BESTHIST[$idx_best]=$((${BESTHIST[$idx_best]}+1))
      WORSTHIST[$idx_worst]=$((${WORSTHIST[$idx_worst]}+1))
  done
}

# call_contention
generate_histogram
print_histogram_data
