OUTPUT_LINES_PER_TEST=8

parse_test_output()
{
  end="$((${test_number} * $OUTPUT_LINES_PER_TEST))"
  start="$((${end} - $OUTPUT_LINES_PER_TEST + 1))"
  test_output=$(echo "$output" | sed -n ${start},${end}p)
  echo "$test_output"
}

#count_bottom_outlier()
#count_top_outlier()

store_results()
{
  algorithm=$(echo "$test_output" | awk '/Algorithm:[[:space:]]/ { print $2 }')
  elapsed_time=$(echo "$test_output" | awk '/Elapsed/ { print $5 }')
  # avg_access=$(echo "$test_output" | awk '/Average/ { print $4 }')
  std_deviation_access=$(echo "$test_output" | awk '/Standard/ { print $5 }')
  echo "$algorithm"
  echo "$elapsed_time"
  #echo "$avg_access"
  echo "$std_deviation_access"
  if [ "$algorithm" = "bakery," ]; then
    bakery_sum_elapsed_time=$((${bakery_sum_elapsed_time} + ${elapsed_time}))
    bakery_sum_std_deviation_access=$(echo "${bakery_sum_std_deviation_access} + ${std_deviation_access}" | bc)
  else
    gate_sum_elapsed_time=$((${gate_sum_elapsed_time} + ${elapsed_time}))
    gate_sum_std_deviation_access=$(echo "${gate_sum_std_deviation_access} + ${std_deviation_access}" | bc)
  fi
}

print_statistics()
{
  echo ""
  echo "PRINT STATISTICS"
  echo "================"

  number_of_tests_per_algorith=$((${number_of_tests} / 2))

  mean_bakery_sum_elapsed_time=$((${bakery_sum_elapsed_time} / ${number_of_tests_per_algorith}))
  mean_bakery_sum_std_deviation_access=$(echo "scale=2; ${bakery_sum_std_deviation_access} / ${number_of_tests_per_algorith}" | bc)
  mean_gate_sum_elapsed_time=$((${gate_sum_elapsed_time} / ${number_of_tests_per_algorith}))
  mean_gate_sum_std_deviation_access=$(echo "scale=2; ${gate_sum_std_deviation_access} / ${number_of_tests_per_algorith}" | bc)

  echo "Bakery - Mean Elapsed Time: $mean_bakery_sum_elapsed_time"
  echo "Bakery - Mean Standard Deviation Access: $mean_bakery_sum_std_deviation_access"
  echo "Gate - Mean Elapsed Time: $mean_gate_sum_elapsed_time"
  echo "Gate - Mean Standard Deviation Access: $mean_gate_sum_std_deviation_access"

}

generate_statistics()
{
  # Collect data to generate a histogram for a specific number of threads and size of
  # vetor for a specif number of rounds
  echo ""
  echo "GENERATE HISTOGRAM DATA"
  echo "======================="
  NUM_THREADS=$1
  TOTAL_TIME=$2
  bakery_sum_elapsed_time=0
  bakery_sum_std_deviation_access=0
  gate_sum_elapsed_time=0
  gate_sum_std_deviation_access=0
  output=$(./main ${NUM_THREADS} ${TOTAL_TIME})
  number_of_lines=$(echo "$output" | wc -l)
  number_of_tests=$((${number_of_lines} / $OUTPUT_LINES_PER_TEST))
  for test_number in `seq 1 $number_of_tests`
  do
      parse_test_output
      store_results
  done
  print_statistics
}

generate_statistics 10 100000
