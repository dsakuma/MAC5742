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
  run_main
  number_of_lines=$(echo "$output" | wc -l)
  number_of_tests=$((${number_of_lines} / $OUTPUT_LINES_PER_TEST))
  echo "Parsing main.c output..."
  for test_number in `seq 1 $number_of_tests`
  do
    parse_test_output
    store_results
  done
  generate_statistics
  print_statistics
  echo "---------------------"
}

#count top outlier
#ar=(10 30 44 44 69 12 11)
#IFS=$'\n'
#echo "${ar[*]}" | sort -nr | head -n1


compile_project

run_program 5 300000

run_program 5 3000000

run_program 10 300000

run_program 10 3000000
