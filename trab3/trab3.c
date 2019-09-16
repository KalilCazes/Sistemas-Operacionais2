#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>

int walk_dir(const char *path, void (*func)(const char *))
{
    DIR *dirp;
    struct dirent *dp;
    char *p, *full_path;

    int len;

    /* abre o diretório */
    if ((dirp = opendir(path)) == NULL)
    {
        return (-1);
    }
    len = strlen(path);

    /* aloca uma área na qual, garantidamente, o caminho caberá */
    if ((full_path = malloc(len + MAXNAMLEN + 2)) == NULL)
    {
        closedir(dirp);
        return (-1);
    }

    /* copia o prefixo e acrescenta a ‘/’ ao final */
    memcpy(full_path, path, len);
    p = full_path + len;
    *p++ = '/';

    /* deixa “p” no lugar certo! */
    while ((dp = readdir(dirp)) != NULL)
    {

        /* ignora as entradas “.” e “..” */
        if (strcmp(dp->d_name, ".") == 0 || strcmp(dp->d_name, "..") == 0)
        {
            continue;
        }

        strcpy(p, dp->d_name); /* “full_path” armazena o caminho */
        (*func)(full_path);
    }

    free(full_path);
    closedir(dirp);
    return (0);
}

void func_r(const char *full_path)
{
    printf("\nr - %s", full_path);
}

void func_d(const char *full_path)
{
    printf("\nd - %s", full_path);
}

void func_l(const char *full_path)
{
    printf("\nl - %s", full_path);
}

void func_b(const char *full_path)
{
    printf("\nb - %s", full_path);
}

void func_c(const char *full_path)
{
    printf("\nc - %s", full_path);
}

int main(int argc, char *const argv[])
{
    int opt;

    const *path;
    if (argc < 3)
    {
        path = ".";
    }
    else
    {
        path = argv[2];
    }

    opt = getopt(argc, argv, "rdlbc");

    switch (opt)
    {
    case 'r':
        func_r(path);
        break;
    case 'd':
        func_d(path);
        break;
    case 'l':
        func_l(path);
        break;
    case 'b':
        func_b(path);
        break;
    case 'c':
        func_c(path);
        break;

    default:
        func_r(path);
        break;
    }

    //walk_dir("/home/flavio342/Desktop/ufrj/so2/trab3", test);
    return 0;
}