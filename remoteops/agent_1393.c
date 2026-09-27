#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define PORT 9410

int main() {
    int server_fd, client_sock;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);
    char buffer[1024] = {0};

    // 1. Socket එක සෑදීම
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }

    // 2. Port එක Reuse කිරීමට සකස් කිරීම
    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &opt, sizeof(opt))) {
        perror("setsockopt");
        exit(EXIT_FAILURE);
    }

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    // 3. Bind කිරීම
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address))<0) {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }

    // 4. Listen කිරීම
    if (listen(server_fd, 3) < 0) {
        perror("listen");
        exit(EXIT_FAILURE);
    }

    printf("RemoteOps Agent (Port %d) started. Waiting for connections...\n", PORT);

    // 5. Client කනෙක්ට් වීම Accept කිරීම
    if ((client_sock = accept(server_fd, (struct sockaddr *)&address, (socklen_t*)&addrlen)) < 0) {
        perror("accept");
        exit(EXIT_FAILURE);
    }

    // Token එක කියවීම
    read(client_sock, buffer, 1024);
    printf("Received: %s\n", buffer);

    if (strstr(buffer, "OPS-1393") != NULL) {
        char *response = "OK AUTHENTICATED SID:3931\n";
        write(client_sock, response, strlen(response));
    }

    // SYSINFO විධානය කියවීම
    memset(buffer, 0, sizeof(buffer));
    read(client_sock, buffer, 1024);

    if (strncmp(buffer, "SYSINFO", 7) == 0) {
        int cpu_load = 12;      
        int mem_used_mb = 340;  
        long uptime_sec = 4500; 

        char sys_response[256];
        snprintf(sys_response, sizeof(sys_response), "OK SYSINFO %d %d %ld SID:3931\n", cpu_load, mem_used_mb, uptime_sec);
        write(client_sock, sys_response, strlen(sys_response));
    }

    close(client_sock);
    close(server_fd);
    return 0;
}
