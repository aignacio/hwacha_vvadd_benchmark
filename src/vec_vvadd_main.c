// See LICENSE for license details.

//**************************************************************************
// Vector VVADD benchmark for Hwacha v4
//--------------------------------------------------------------------------
//

#include "util.h"
#include "vec-util.h"
#include "vec_vvadd.h"

//--------------------------------------------------------------------------
// Input/Reference Data

#include "dataset1.h"

extern  int iteracoes,
            proc_by_iter[MAX_ITER_LOG];

//--------------------------------------------------------------------------
// Main
void vvadd( int n, float a[], float b[], float c[] )
{
  int i;
  for ( i = 0; i < n; i++ )
    c[i] = a[i] + b[i];
}

void print_vector_info(){
  int processed_elements = 0;
  const offset_print = 5;

  printf("\n\tVector CPU operation ([iteration]=elements processed): ");
  printf("\n");
  for(char i = 0; i < iteracoes/offset_print; i++){
    for(char j = 0; j < offset_print; j++){
      printf("\t[%d] = %d", i*offset_print+j, proc_by_iter[i*offset_print+j]);
      processed_elements += proc_by_iter[i*offset_print+j];
    }
    printf("\n");
  }
  printf("\n\tIterations: %d", iteracoes);
  printf("\n\tNumber of processed elements: %d \n", processed_elements);
}

int main( int argc, char* argv[] )
{
  float result[DATA_SIZE];

  // Clear counters
  for(char i = 0; i < MAX_ITER_LOG; i++)
    proc_by_iter[i] = 0;
  
  printf("\n\tVector add benchmark using HWACHA\n");
  // setStats(1);
  // vvadd( DATA_SIZE, input_data_X, input_data_Y, result );
  // setStats(0);

  setStats(1);
  vec_vvadd_asm(DATA_SIZE, result, input_data_X, input_data_Y);
  setStats(0);

  print_vector_info();
  
  printf("\n\n");

  return verifyFloat(DATA_SIZE, result, verify_data);
}
