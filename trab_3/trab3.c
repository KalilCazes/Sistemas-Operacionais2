#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>

void signal_handler(int sig)
{
    FILE *log_file = fopen("log.txt", "a");
    fprintf(log_file, "\nFIM DOS LOGS");
    fprintf(log_file, "%s", "\n====================================");
    fclose(log_file);
    exit(0);
}

int main(int argc, char *const argv[])
{

    (void)signal(SIGTERM, signal_handler);

    int n = atol(argv[1]);

    FILE *log_file;

    log_file = fopen("log.txt", "w");

    fprintf(log_file, "%s", "\nPID\t\t\tPPID\t\t\tNome do Programa");
    fprintf(log_file, "%s", "\n====================================");

    fclose(log_file);

    while (1)
    {
        sleep(n);

        log_file = fopen("log.txt", "a");

        FILE *get_zombie;
        char zombie_buffer[1000];
        get_zombie = popen("/bin/ps aux | awk '{ print $8 \" \" $2 }' | grep -w Z", "r");
        while (fgets(zombie_buffer, 100, get_zombie) != NULL)
        {
            char *zombie_pid = strtok(zombie_buffer, " ");
            zombie_pid = strtok(NULL, " ");
            zombie_pid = strtok(zombie_pid, "\n");

            FILE *get_zombie_parent;
            char parent_pid_buffer[1035];

            char parent_pid_command[80];
            strcpy(parent_pid_command, "/bin/ps -o ppid= -p ");
            strcat(parent_pid_command, zombie_pid);

            get_zombie_parent = popen(parent_pid_command, "r");
            while (fgets(parent_pid_buffer, 100, get_zombie_parent) != NULL)
            {
                char *parent_pid = strtok(parent_pid_buffer, "\n");

                FILE *get_zombie_parent_name;
                char parent_name_buffer[1024];

                char parent_name_command[80];
                strcpy(parent_name_command, "ps -p ");
                strcat(parent_name_command, parent_pid);
                strcat(parent_name_command, " -o comm=");

                get_zombie_parent_name = popen(parent_name_command, "r");
                while (fgets(parent_name_buffer, 100, get_zombie_parent_name) != NULL)
                {
                    char *parent_name = strtok(parent_name_buffer, "\n");
                    fprintf(log_file, "\n%s\t\t%s\t\t\t%s", zombie_pid, parent_pid, parent_name);
                }
                pclose(get_zombie_parent_name);
            }
            pclose(get_zombie_parent);
        }
        pclose(get_zombie);

        fprintf(log_file, "%s", "\n====================================");
        fclose(log_file);
    }

    return 0;
}