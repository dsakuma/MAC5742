OUTPUT_LINES_PER_TEST=8

parse_test_output()
{
  end="$((${test_number} * $OUTPUT_LINES_PER_TEST))"
  start="$((${end} - $OUTPUT_LINES_PER_TEST + 1))"
  test_output=$(echo "$output" | sed -n ${start},${end}p)
}

store_results()
{
  algorithm=$(echo "$test_output" | awk '/Algorithm:[[:space:]]/ { print $2 }')
  elapsed_time=$(echo "$test_output" | awk '/Elapsed/ { print $5 }')
  avg_access=$(echo "$test_output" | awk '/Average/ { print $4 }')
  std_deviation_access=$(echo "$test_output" | awk '/Standard/ { print $5 }')
  if [ "$algorithm" = "bakery," ]; then
    bakery_sum_elapsed_time=$((${bakery_sum_elapsed_time} + ${elapsed_time}))
    bakery_sum_std_deviation_access=$(echo "${bakery_sum_std_deviation_access} + ${std_deviation_access}" | bc)
  else
    gate_sum_elapsed_time=$((${gate_sum_elapsed_time} + ${elapsed_time}))
    gate_sum_std_deviation_access=$(echo "${gate_sum_std_deviation_access} + ${std_deviation_access}" | bc)
  fi
}

count_outliers()
{
  parsed_access=$(echo "$test_output" | awk '/^[0-9]/ {print substr($0, 1, length($0)-2)}')
  IFS=', ' read -a access_count <<< $parsed_access
  max=${access_count[0]}
  min=${access_count[0]}
  for i in "${access_count[@]}"
  do
      # Update max if applicable
      if [[ "$i" -gt "$max" ]]; then
          max="$i"
      fi

      # Update min if applicable
      if [[ "$i" -lt "$min" ]]; then
          min="$i"
      fi
  done
  two_std_deviation=$(echo "${std_deviation_access} * 3" | bc)
  top_limit=$(echo "${avg_access} + ${two_std_deviation}" | bc)
  bottom_limit=$(echo "${avg_access} - ${two_std_deviation}" | bc)

  if [ "$algorithm" = "bakery," ]; then
    if [ $(echo "${max} > ${top_limit}" | bc) -eq 1 ]; then
      #echo $max
      #echo $top_limit
      bakery_top_outlier_counter=$((${bakery_top_outlier_counter} + 1))
    fi
    if [ $(echo "${min} < ${bottom_limit}" | bc) -eq 1 ]; then
      bakery_bottom_outlier_counter=$((${bakery_bottom_outlier_counter} + 1))
    fi
  else
    if [ $(echo "${max} > ${top_limit}" | bc) -eq 1 ]; then
      gate_top_outlier_counter=$((${gate_top_outlier_counter} + 1))
    fi
    if [ $(echo "${min} < ${bottom_limit}" | bc) -eq 1 ]; then
      gate_bottom_outlier_counter=$((${gate_bottom_outlier_counter} + 1))
    fi
  fi

  #echo "Max is: $max"
  #echo "Min is: $min"
}

generate_statistics()
{
  echo "Generating statistics..."
  number_of_tests_per_algorith=$((${number_of_tests} / 2))

  mean_bakery_sum_elapsed_time=$((${bakery_sum_elapsed_time} / ${number_of_tests_per_algorith}))
  mean_bakery_sum_std_deviation_access=$(echo "scale=2; ${bakery_sum_std_deviation_access} / ${number_of_tests_per_algorith}" | bc)
  mean_gate_sum_elapsed_time=$((${gate_sum_elapsed_time} / ${number_of_tests_per_algorith}))
  mean_gate_sum_std_deviation_access=$(echo "scale=2; ${gate_sum_std_deviation_access} / ${number_of_tests_per_algorith}" | bc)
}

print_statistics()
{
  echo "\nResults:"
  echo "Bakery - Mean Elapsed Time: $mean_bakery_sum_elapsed_time"
  echo "Bakery - Mean Standard Deviation Access: $mean_bakery_sum_std_deviation_access"
  echo "Gate - Mean Elapsed Time: $mean_gate_sum_elapsed_time"
  echo "Gate - Mean Standard Deviation Access: $mean_gate_sum_std_deviation_access"

  echo "Bakery - Top Outlier Count: $bakery_top_outlier_counter"
  echo "Bakery - Bottom Outlier Count: $bakery_bottom_outlier_counter"

  echo "Gate - Top Outlier Count: $gate_top_outlier_counter"
  echo "Gate - Bottom Outlier Count: $gate_bottom_outlier_counter"
}

compile_project()
{
  # Ensure the project is compiled
  echo ""
  echo "Compiling project..."
  make
}

run_main()
{
  echo "Running main.c..."
  output=$(./main ${NUM_THREADS} ${TOTAL_TIME})
}

run_program()
{
  # Run program for a specific number of threads and time consuming cpu
  echo "---------------------"
  echo "RUN PROGRAM (n_thread=$1, total_time=$2)"
  NUM_THREADS=$1
  TOTAL_TIME=$2
  bakery_sum_elapsed_time=0
  bakery_sum_std_deviation_access=0
  gate_sum_elapsed_time=0
  gate_sum_std_deviation_access=0
  bakery_top_outlier_counter=0
  bakery_bottom_outlier_counter=0
  gate_top_outlier_counter=0
  gate_bottom_outlier_counter=0
  run_main
  number_of_lines=$(echo "$output" | wc -l)
  number_of_tests=$((${number_of_lines} / $OUTPUT_LINES_PER_TEST))
  echo "Parsing main.c output..."
  for test_number in `seq 1 $number_of_tests`
  do
    parse_test_output
    store_results
    count_outliers
  done
  generate_statistics
  print_statistics
  echo "---------------------"
}

compile_project

run_program 5 300000

run_program 5 3000000

run_program 10 300000

run_program 10 3000000
