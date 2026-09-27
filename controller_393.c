#include 
#include 
#include 
#include 
#include 
#include 
#include 
#include 

// ඔබේ ලියාපදිංචි අංකයට අදාළ Macros මෙතැනින් එකතු කරන්න:
#define PORT 9410
#define REG_NUMBER "IT24101393"
#define SID "3931"
#define AUTH_TOKEN "OPS-1393"
#define LOG_FILE "remoteops_IT24101393.log"
#define STORAGE_PATH "./agentfiles/IT24101393/"
int main() {
    int sock = 0;
    struct sockaddr_in serv_addr;
    char buffer[1024] = {0};
    char message[256];

    // 1. Socket නිර්මාණය කිරීම
    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        printf("\n Socket creation error \n");
        return -1;
    }

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);

    // Localhost වෙත සම්බන්ධ වීම (අවශ්‍ය නම් වෙනත් IP එකක් දිය හැක)
    if(inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr)<=0) {
        printf("\nInvalid address/ Address not supported \n");
        return -1;
    }

    // 2. සර්වර් එකට සම්බන්ධ වීම (Connect)
    if (connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        printf("\nConnection Failed \n");
        return -1;
    }
    printf("Connected to Agent!\n");

    // 3. ස්වයංක්‍රීයව Authentication යැවීම
    snprintf(message, sizeof(message), "AUTH %s\n", AUTH_TOKEN);
    send(sock, message, strlen(message), 0);

    memset(buffer, 0, sizeof(buffer));
    read(sock, buffer, 1024);
    printf("Server Response: %s", buffer);

    // 4. SYSINFO විධානය යැවීම පරීක්ෂා කිරීම
    snprintf(message, sizeof(message), "SYSINFO\n");
    send(sock, message, strlen(message), 0);

    memset(buffer, 0, sizeof(buffer));
    read(sock, buffer, 1024);
    printf("Server Response: %s", buffer);

    // 5. QUIT යැවීම
    snprintf(message, sizeof(message), "QUIT\n");
    send(sock, message, strlen(message), 0);

    close(sock);
    return 0;
}
