#!/bin/bash

index_of_best()
{
  # Logic to select the index with the best time
  current_best=0
  for i in "${!TIME_IFS[@]}"; do
    if [ $(echo "${TIME_IFS[$i]} < ${TIME_IFS[$current_best]}" | bc) -eq 1 ]; then
      current_best=$i
    fi
  done
  echo $current_best
}

index_of_worst()
{
  # Logic to select the index with the worst time
  current_worst=0
  for i in "${!TIME_IFS[@]}"; do
    if [ $(echo "${TIME_IFS[$i]} > ${TIME_IFS[$current_worst]}" | bc) -eq 1 ]; then
      current_worst=$i
    fi
  done
  echo $current_worst
}

print_time_ifs()
{
  # Print the array with if times
  echo ""
  echo "PRINT TIME IFS"
  echo "--------------"
  for i in `seq 0 9`
  do
    printf "$i - ${TIME_IFS[i]}\n"
  done
}

print_histogram_data()
{
  # Print the histogram data
  echo ""
  echo "BEST HISTOGRAM DATA"
  echo "-------------------"
  for i in `seq 0 9`
  do
    printf "$i - ${BESTHIST[i]}\n"
  done

  echo ""
  echo "WORST HISTOGRAM DATA"
  echo "-------------------"
  for i in `seq 0 9`
  do
    printf "$i - ${WORSTHIST[i]}\n"
  done
}

generate_histogram()
{
  # Collect data to generate a histogram for a specific number of threads and size of
  # vetor for a specif number of rounds
  echo ""
  echo "GENERATE HISTOGRAM DATA"
  echo "-----------------------"
  BESTHIST=( 0 0 0 0 0 0 0 0 0 0 )
  WORSTHIST=( 0 0 0 0 0 0 0 0 0 0 )
  SIZE_VECTOR=$1
  NUM_THREADS=$2
  NUM_ROUNDS=$3
  counter=0
  for round in `seq 1 $NUM_ROUNDS`
  do
      printf "Running for N=$SIZE_VECTOR snd T=$NUM_THREADS. Round: $round\n"
      output=$(./contention.sh $SIZE_VECTOR $NUM_THREADS)
      read -a TIME_IFS <<< $(echo "$output" | awk '/[[:space:]]Average of[[:space:]]/ { print $5 }')

      idx_best=$(index_of_best)
      idx_worst=$(index_of_worst)

      BESTHIST[$idx_best]=$((${BESTHIST[$idx_best]}+1))
      WORSTHIST[$idx_worst]=$((${WORSTHIST[$idx_worst]}+1))
  done
}


# Test 1
generate_histogram 1000000 1000 1000
print_histogram_data

# Test 2
generate_histogram 1000000 500 1000
print_histogram_data

# Test 3
generate_histogram 10000 1000 1000
print_histogram_data

# Test 4
generate_histogram 10000 500 1000
print_histogram_data
