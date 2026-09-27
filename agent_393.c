#include <string.h>
#include <malloc>
#include <strlen>
#include <close>
#include <size_t>
#include <listen>
#include <struct sockaddr_in>
#include <inet_pton>

// ඔබේ ලියාපදිංචි අංකයට අදාළ Macros මෙතැනින් එකතු කරන්න:
#define PORT 9410
#define REG_NUMBER "IT24101393"
#define SID "3931"
#define AUTH_TOKEN "OPS-1393"
#define LOG_FILE "remoteops_IT24101393.log"
#define STORAGE_PATH "./agentfiles/IT24101393/"
void handle_client(int client_sock) {
    char buffer[1024];
    int valread;

    // 1. Authentication පරීක්ෂා කිරීම
    memset(buffer, 0, sizeof(buffer));
    valread = read(client_sock, buffer, sizeof(buffer) - 1);
    if (valread > 0) {
        // අන්තයේ ඇති newline ඉවත් කිරීම
        buffer[strcspn(buffer, "\r\n")] = 0;
        
        if (strcmp(buffer, "AUTH " AUTH_TOKEN) == 0) {
            char response[128];
            snprintf(response, sizeof(response), "OK AUTHENTICATED SID:%s\n", SID);
            write(client_sock, response, strlen(response));
            printf("Client authenticated successfully!\n");
        } else {
            char *err_msg = "ERR INVALID AUTH\n";
            write(client_sock, err_msg, strlen(err_msg));
            printf("Authentication failed for client.\n");
            close(client_sock);
            return;
        }
    }

    // 2. විධාන (Commands) ලැබෙන තුරු සවන් දීම ලූප් එකක් හරහා සිදු කිරීම
    while (1) {
        memset(buffer, 0, sizeof(buffer));
        valread = read(client_sock, buffer, sizeof(buffer) - 1);
        if (valread <= 0) break; // සම්බන්ධතාව බිඳී ගියහොත්

        buffer[strcspn(buffer, "\r\n")] = 0;
        printf("Received command: %s\n", buffer);

        if (strcmp(buffer, "SYSINFO") == 0) {
            char *sys_info = "CPU: 2 Cores | RAM: 4GB | Uptime: 2 hours\n";
            write(client_sock, sys_info, strlen(sys_info));
        } 
        else if (strcmp(buffer, "QUIT") == 0) {
            char *bye = "BYE\n";
            write(client_sock, bye, strlen(bye));
            break;
        } 
        else {
            char *unknown = "ERR UNKNOWN COMMAND\n";
            write(client_sock, unknown, strlen(unknown));
        }
    }

    close(client_sock);
}

int main() {
    int server_fd, new_socket;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);

    // Socket නිර්මාණය කිරීම
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("Socket failed");
        exit(EXIT_FAILURE);
    }

    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &opt, sizeof(opt))) {
        perror("setsockopt failed");
        exit(EXIT_FAILURE);
    }

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("Bind failed");
        exit(EXIT_FAILURE);
    }

    if (listen(server_fd, 5) < 0) {
        perror("Listen failed");
        exit(EXIT_FAILURE);
    }

    printf("Agent (IT24101393) started. Listening on port %d...\n", PORT);

    while(1) {
        if ((new_socket = accept(server_fd, (struct sockaddr *)&address, (socklen_t*)&addrlen)) < 0) {
            perror("Accept failed");
            continue;
        }

        printf("New controller connected!\n");

        // බහු සම්බන්ධතා (Multiple clients) සඳහා fork() භාවිත කිරීම
        if (fork() == 0) {
            close(server_fd); // Child process එකට සර්වර් සෝකට් එක අවශ්‍ය නැත
            handle_client(new_socket);
            exit(0);
        }
        
        close(new_socket); // Parent process එක new_socket එක වසා දමයි
    }

    return 0;
}
