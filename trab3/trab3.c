#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>

struct stat path_stat;

int count = 0;

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
    stat(full_path, &path_stat);
    if (S_ISREG(path_stat.st_mode))
    {
        count++;
        printf("%s\n", full_path);
    }
}

void func_d(const char *full_path)
{
    stat(full_path, &path_stat);
    if (S_ISDIR(path_stat.st_mode))
    {
        count++;
        printf("%s\n", full_path);
    }
}

void func_l(const char *full_path)
{
    lstat(full_path, &path_stat);
    if (S_ISLNK(path_stat.st_mode))
    {
        count++;
        printf("%s\n", full_path);
    }
}

void func_b(const char *full_path)
{
    stat(full_path, &path_stat);
    if (S_ISBLK(path_stat.st_mode))
    {
        count++;
        printf("%s\n", full_path);
    }
}

void func_c(const char *full_path)
{
    stat(full_path, &path_stat);
    if (S_ISCHR(path_stat.st_mode))
    {
        count++;
        printf("%s\n", full_path);
    }
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
        walk_dir(path, func_r);
        break;
    case 'd':
        walk_dir(path, func_d);
        break;
    case 'l':
        walk_dir(path, func_l);
        break;
    case 'b':
        walk_dir(path, func_b);
        break;
    case 'c':
        walk_dir(path, func_c);
        break;

    default:
        walk_dir(path, func_r);
        break;
    }

    printf("\nTotal INODES = %d\n", count);

    return 0;
}