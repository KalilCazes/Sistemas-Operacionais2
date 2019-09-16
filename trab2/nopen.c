#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>

int isopen(int fd)
{
    int nwrite;

    //printf("\nTesting FD = %d", fd);

    nwrite = write(fd, "ola", 3);
    if (nwrite == -1)
    {
        int err = errno;
        //printf("\nErro = %d", err);
        return 0;
    }
    else
    {
        return 1;
    }
}

int main(void)
{
    int nopen, fd;

    int opened_file;
    opened_file = open("teste", O_RDWR);
    //printf("File Opened = %d", opened_file);

    for (nopen = fd = 0; fd < getdtablesize(); fd++)
    {
        if (isopen(fd))
            nopen++;
    }
    printf("\nExistem % d descritores abertos\n", nopen);
    return (0);
}