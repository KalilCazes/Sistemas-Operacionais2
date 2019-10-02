#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *const argv[])
{

    int n = atol(argv[1]);

    FILE *log_file;

    log_file = fopen("log.txt", "w");

    fprintf(log_file, "%s", "\nPID\t\tPPID\t\tNome do Programa");
    fprintf(log_file, "%s", "\n====================================");

    fclose(log_file);

    while (1)
    {
        sleep(n);

        printf("\n\nJust Do It!\n");

        log_file = fopen("log.txt", "a");

        FILE *command_file;
        char buffer[1035];
        command_file = popen("/bin/ps aux | awk '{ print $8 \" \" $2 }' | grep -w Z", "r");
        while (fgets(buffer, 100, command_file) != NULL)
        {
            char *ptr = strtok(buffer, " ");
            ptr = strtok(NULL, " ");
            ptr = strtok(ptr, "\n");

            FILE *second_command_file;
            char second_buffer[1035];

            char command_str[80];
            strcpy(command_str, "/bin/ps -o ppid= -p ");
            strcat(command_str, ptr);

            second_command_file = popen(command_str, "r");
            while (fgets(second_buffer, 100, second_command_file) != NULL)
            {
                char *second_ptr = strtok(second_buffer, "\n");
                fprintf(log_file, "\n%s\t\t%s\t\t\tVem Nimim", ptr, second_ptr);
                printf("Filho: %s, Pai: %s", ptr, second_buffer);
            }
            pclose(second_command_file);
        }
        pclose(command_file);

        fprintf(log_file, "%s", "\n====================================");
        fclose(log_file);
    }

    return 0;
}