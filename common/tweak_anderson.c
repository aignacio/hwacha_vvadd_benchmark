#include "util.h"
#include "vec-util.h"

int iteracoes = 0,
    tmp = 0,
    proc_by_iter[MAX_ITER_LOG];

void check_stats_ctrl_th(void){
    // We cannot use printf if we don't backup the argument registers
    // so let's comment it!
    // Also we should take care to avoid using a0-a3 registers because they
    // are used by the vector control thread.a

    asm ("addi %0, t0, 0" \
            : "=r" (proc_by_iter[iteracoes]) : );
    asm ("addi %0, %1, 1" \
            : "=r" (iteracoes) : "r" (iteracoes));
}