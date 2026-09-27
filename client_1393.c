o
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 9410

int main() {
    int sock = 0;
    struct sockaddr_in serv_addr;
    char *token = "OPS-1393";
    char buffer[1024] = {0};

    // 1. Socket එක නිර්මාණය කිරීම
    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) {
        printf("\n Socket creation error \n");
        return -1;
    }

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);

    // 2. Server IP එකට (Localhost) සම්බන්ධ වීම
    if (inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr) <= 0) {
        printf("\nInvalid address/ Address not supported \n");
        return -1;
    }

    if (connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        printf("\nConnection Failed \n");
        return -1;
    }

    // 3. Server එකට Token එක යැවීම
    send(sock, token, strlen(token), 0);
    printf("Token එක Server එකට යවන ලදී: %s\n", token);

    // 4. Server එකෙන් එන පිළිතුර (Response) කියවා ගැනීම
    read(sock, buffer, 1024);
    printf("Server එකෙන් ලැබුණු පිළිතුර: %s\n", buffer);
// SYSINFO ඉල්ලීම සර්වර් එකට යැවීම
    char *sys_cmd = "SYSINFO\n";
    send(sock, sys_cmd, strlen(sys_cmd), 0);

    // සර්වර් එකෙන් එන SYSINFO පිළිතුර ලබා ගැනීම
    char sys_buffer[1024] = {0};
    read(sock, sys_buffer, 1024);
    printf("Server SYSINFO Response: %s\n", sys_buffer);
    // 5. Connection එක වසා දැමීම
    close(sock);
    return 0;
}
