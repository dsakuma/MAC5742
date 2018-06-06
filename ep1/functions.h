void print_matrix(double** matrix, long long int n_rows, long long int n_cols);
void write_matrix(double** matrix, long long int n_rows, long long int n_cols, char filename[]);
double ** allocate_memory_matrix(long long int n_rows, long long int n_cols);
double ** allocate_memory_and_fill_matrix(char filename[]);
long long int get_n_rows_or_cols(char filename[], char type[]);
