#include <epicsExit.h>
#include <iocsh.h>

int main(int argc, char *argv[])
{
    if (argc != 2)
        return 2;
    const int status = iocsh(argv[1]);
    if (status == 0)
        iocsh(nullptr);
    epicsExit(status == 0 ? 0 : 1);
    return status == 0 ? 0 : 1;
}
