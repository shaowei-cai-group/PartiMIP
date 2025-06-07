/*=====================================================================================

    Filename:     main.cpp

    Description:
        Version:  1.0

    Author:       Peng Lin, linpeng@ios.ac.cn

    Organization: Shaowei Cai Group,
                  Institute of Software,
                  Chinese Academy of Sciences,
                  Beijing, China.

=====================================================================================*/
#include "../Scheduler/Scheduler.h"

std::chrono::steady_clock::time_point timeStart = std::chrono::steady_clock::now();

int main(int argc, char **argv)
{
    INIT_ARGS

    // __global_paras.print_change();
    // RecreateDirectory(OPT(logPath));
    Scheduler scheduler;
    scheduler.Optimize();
    return 0;
}