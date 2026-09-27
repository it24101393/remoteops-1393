#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <pthread.h>
int client_counter = 1;
void *handle_client(void *arg) {
 int sock = ((int *)arg)[0];
 int client_id = ((int *)arg)[1];
 char buffer[1024];
 printf("\nClient %d connected\n", client_id);
 printf("Processing Client %d...\n", client_id);
 sleep(5);
 int read_size = recv(sock, buffer, 1024, 0);
 buffer[read_size] = '\0';
 printf("Client %d says: %s\n", client_id, buffer);
 printf("Client %d done\n", client_id);
 close(sock);
 free(arg);
 return NULL;
}
int main() {
 int server_fd, *data;
 struct sockaddr_in server, client;
 socklen_t c = sizeof(struct sockaddr_in);
 server_fd = socket(AF_INET, SOCK_STREAM, 0); 
server.sin_family = AF_INET;
 server.sin_addr.s_addr = INADDR_ANY;
 server.sin_port = htons(12345);
 bind(server_fd, (struct sockaddr *)&server, sizeof(server));
 listen(server_fd, 5);
 printf("Multithreaded Server Running...\n");
 while (1) {
 int new_socket = accept(server_fd, (struct sockaddr *)&client, &c);
 data = malloc(sizeof(int) * 2);
 data[0] = new_socket;
 data[1] = client_counter++;
 pthread_t tid;
 pthread_create(&tid, NULL, handle_client, (void *)data);
 pthread_detach(tid);
 }
 return 0;
}
