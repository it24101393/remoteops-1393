ip a
sudo shutdown now
ssh-keygen
ssh-copy-id chamasha@10.21.8.224
ssh chamasha@10.21.8.224
ping 10.21.8.224
ip a
sudo dnf install openssh-server -y
sudo systemctl start sshd
sudo systemctl enable sshd
sudo systemctl status sshd
nano client.c
gcc client.c -o client
./client
nano client.c
./client
nano client.c
gcc client.c -o client
./client
nano server.c
gcc server.c -o server
./server
nano server.c
gcc server.c -o server
./server
mkdir network_lab8
cd network_lab8
nano server.py
import socket
# Client configuration
HOST = '127.0.0.1'
PORT = 7000
BUFFER = 4096
# Create TCP socket
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# Connect to server
client.connect((HOST, PORT))
# Open video file in binary read mode (Oyata folder eke message.mp4 kiyala video file ekak thiyenna oni)
file = open("message.mp4", "rb")
# Send video data
while True:;     data = file.read(BUFFER)
    if not data:;         break;     client.sendall(data)
file.close() client.close()
nano client.py
ip a
mkdir network_lab8
cd network_lab8
nano server.py
wget -O message.mp4 https://www.w3schools.com/html/mov_bbb.mp4
nano client.py
python client.py
wget -O message.mp4 https://www.w3schools.com/html/mov_bbb.mp4
ls -lh message.mp4
python client.py
mkdir network_lab8
cd network_lab8
nano server.py
python server.py
nano server.py
python server.py
nano server.c
nano client.c
gcc server.c -o server
./client
./client
nano client.c
gcc client.c -o client
nano client.c
gcc client.c -o client
./client
nano server.c
gcc server.c -o server -lpthread
nano server.c
gcc server.c -o server -lpthread
./server
chat_server.c
nano chat_server.c
gcc chat_server.c -o chat_server -lpthread
nano chat_server.c
gcc chat_server.c -o chat_server -lpthread
nano chat_server.c
gcc chat_server.c -o chat_server -lpthread
./chat_server
nano chat_server.c
gcc chat_server.c -o chat_server -lpthread
nano chat_server
gcc chat_server.c -o chat_server -pthread
ip a
sudo dnf update -y
nano chat_server.c
gcc chat_server.c -o chat_server -lpthread
nano chat_server.c
gcc chat_server.c -o chat_server -lpthread
nano chat_server.c
gcc chat_server.c -o chat_server -lpthread
rm chat_server.c
nano chat_server.c
gcc chat_server.c -o chat_server -lpthread
./chat_server
rm chat_server.c
nano chat_server.c
gcc chat_server.c -o chat_server -lpthread
./chat_server
nano chat_server.c
gcc chat_server.c -o chat_server -lpthread
./chat_server
nano chat_server.c
rm chat_server.c
python3 -c '
code = """#include 
#include 
#include 
#include 
#include 
#include 

#define MAX_CLIENTS 10
#define PORT 12345

int client_sockets[MAX_CLIENTS];
pthread_mutex_t clients_mutex = PTHREAD_MUTEX_INITIALIZER;

void add_client(int socket) {
    pthread_mutex_lock(&clients_mutex);
    for(int i = 0; i < MAX_CLIENTS; i++) {
        if(client_sockets[i] == 0) {
            client_sockets[i] = socket;
            break;
        }
    }
    pthread_mutex_unlock(&clients_mutex);
}

void remove_client(int socket) {
    pthread_mutex_lock(&clients_mutex);
    for(int i = 0; i < MAX_CLIENTS; i++) {
        if(client_sockets[i] == socket) {
            client_sockets[i] = 0;
            break;
        }
    }
    pthread_mutex_unlock(&clients_mutex);
}

void broadcast_message(char *message, int sender_socket) {
    pthread_mutex_lock(&clients_mutex);
    for(int i = 0; i < MAX_CLIENTS; i++) {
        if(client_sockets[i] != 0 && client_sockets[i] != sender_socket) {
            send(client_sockets[i], message, strlen(message), 0);
        }
    }
    pthread_mutex_unlock(&clients_mutex);
}

void *handle_client(void *arg) {
    int sock = *((int *)arg);
    free(arg);
    char buffer[1024];
    int bytes_read;

    printf("\\nA client joined the chat!\\n");

    while((bytes_read = recv(sock, buffer, sizeof(buffer) - 1, 0)) > 0) {
        buffer[bytes_read] = 0;
        printf("Client says: %s", buffer);
        broadcast_message(buffer, sock);
    }

    printf("\\nA client left the chat!\\n");
    remove_client(sock);
    close(sock);
    return NULL;
}

int main() {
    int server_fd, new_socket;
    struct sockaddr_in address;
    socklen_t addrlen = sizeof(address);

    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    bind(server_fd, (struct sockaddr *)&address, sizeof(address));
    listen(server_fd, 5);

    printf("Concurrent Chat Server Running on port %d...\\n", PORT);

    while(1) {
        new_socket = accept(server_fd, (struct sockaddr *)&address, &addrlen);
        add_client(new_socket);

        int *pclient = malloc(sizeof(int));
        *pclient = new_socket;

        pthread_t tid;
        pthread_create(&tid, NULL, handle_client, pclient);
        pthread_detach(tid);
    }
    return 0;
}
"""
with open("chat_server.c", "w") as f:
    f.write(code)
print("Setup completed successfully!")
'
gcc chat_server.c -o chat_server -lpthread
./chat_server
cat << 'EOF' > chat_server.c
#include 
#include 
#include 
#include 
#include 
#include 

#define MAX_CLIENTS 10
#define PORT 12345

int client_sockets[MAX_CLIENTS];
pthread_mutex_t clients_mutex = PTHREAD_MUTEX_INITIALIZER;

void add_client(int socket) {
    pthread_mutex_lock(&clients_mutex);
    for(int i = 0; i < MAX_CLIENTS; i++) {
        if(client_sockets[i] == 0) {
            client_sockets[i] = socket;
            break;
        }
    }
    pthread_mutex_unlock(&clients_mutex);
}

void remove_client(int socket) {
    pthread_mutex_lock(&clients_mutex);
    for(int i = 0; i < MAX_CLIENTS; i++) {
        if(client_sockets[i] == socket) {
            client_sockets[i] = 0;
            break;
        }
    }
    pthread_mutex_unlock(&clients_mutex);
}

void broadcast_message(char *message, int sender_socket) {
    pthread_mutex_lock(&clients_mutex);
    for(int i = 0; i < MAX_CLIENTS; i++) {
        if(client_sockets[i] != 0 && client_sockets[i] != sender_socket) {
            send(client_sockets[i], message, strlen(message), 0);
        }
    }
    pthread_mutex_unlock(&clients_mutex);
}

void *handle_client(void *arg) {
    int sock = *((int *)arg);
    free(arg);
    char buffer[1024];
    int bytes_read;

    printf("\nA client joined the chat!\n");

    while((bytes_read = recv(sock, buffer, sizeof(buffer) - 1, 0)) > 0) {
        buffer[bytes_read] = '\0';
        printf("Client says: %s", buffer);
        broadcast_message(buffer, sock);
    }

    printf("\nA client left the chat!\n");
    remove_client(sock);
    close(sock);
    return NULL;
}

int main() {
    int server_fd, new_socket;
    struct sockaddr_in address;
    socklen_t addrlen = sizeof(address);

    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    bind(server_fd, (struct sockaddr *)&address, sizeof(address));
    listen(server_fd, 5);

    printf("Concurrent Chat Server Running on port %d...\n", PORT);

    while(1) {
        new_socket = accept(server_fd, (struct sockaddr *)&address, &addrlen);
        add_client(new_socket);

        int *pclient = malloc(sizeof(int));
        *pclient = new_socket;

        pthread_t tid;
        pthread_create(&tid, NULL, handle_client, pclient);
        pthread_detach(tid);
    }
    return 0;
}
EOF

gcc chat_server.c -o chat_server -lpthread
./chat_server
python3 -c '
lines = [
    "#include ",
    "#include ",
    "#include ",
    "#include ",
    "#include ",
    "#include ",
    "",
    "#define MAX_CLIENTS 10",
    "#define PORT 12345",
    "",
    "int client_sockets[MAX_CLIENTS];",
    "pthread_mutex_t clients_mutex = PTHREAD_MUTEX_INITIALIZER;",
    "",
    "void add_client(int socket) {",
    "    pthread_mutex_lock(&clients_mutex);",
    "    for(int i = 0; i < MAX_CLIENTS; i++) {",
    "        if(client_sockets[i] == 0) {",
    "            client_sockets[i] = socket;",
    "            break;",
    "        }",
    "    }",
    "    pthread_mutex_unlock(&clients_mutex);",
    "}",
    "",
    "void remove_client(int socket) {",
    "    pthread_mutex_lock(&clients_mutex);",
    "    for(int i = 0; i < MAX_CLIENTS; i++) {",
    "        if(client_sockets[i] == socket) {",
    "            client_sockets[i] = 0;",
    "            break;",
    "        }",
    "    }",
    "    pthread_mutex_unlock(&clients_mutex);",
    "}",
    "",
    "void broadcast_message(char *message, int sender_socket) {",
    "    pthread_mutex_lock(&clients_mutex);",
    "    for(int i = 0; i < MAX_CLIENTS; i++) {",
    "        if(client_sockets[i] != 0 && client_sockets[i] != sender_socket) {",
    "            send(client_sockets[i], message, strlen(message), 0);",
    "        }",
    "    }",
    "    pthread_mutex_unlock(&clients_mutex);",
    "}",
    "",
    "void *handle_client(void *arg) {",
    "    int sock = *((int *)arg);",
    "    free(arg);",
    "    char buffer[1024];",
    "    int bytes_read;",
    "    printf(\"\\nA client joined the chat!\\n\");",
    "    while((bytes_read = recv(sock, buffer, sizeof(buffer) - 1, 0)) > 0) {",
    "        buffer[bytes_read] = 0;",
    "        printf(\"Client says: %s\", buffer);",
    "        broadcast_message(buffer, sock);",
    "    }",
    "    printf(\"\\nA client left the chat!\\n\");",
    "    remove_client(sock);",
    "    close(sock);",
    "    return NULL;",
    "}",
    "",
    "int main() {",
    "    int server_fd, new_socket;",
    "    struct sockaddr_in address;",
    "    socklen_t addrlen = sizeof(address);",
    "    server_fd = socket(AF_INET, SOCK_STREAM, 0);",
    "    address.sin_family = AF_INET;",
    "    address.sin_addr.s_addr = INADDR_ANY;",
    "    address.sin_port = htons(PORT);",
    "    bind(server_fd, (struct sockaddr *)&address, sizeof(address));",
    "    listen(server_fd, 5);",
    "    printf(\"Concurrent Chat Server Running on port %d...\\n\", PORT);",
    "    while(1) {",
    "        new_socket = accept(server_fd, (struct sockaddr *)&address, &addrlen);",
    "        add_client(new_socket);",
    "        int *pclient = malloc(sizeof(int));",
    "        *pclient = new_socket;",
    "        pthread_t tid;",
    "        pthread_create(&tid, NULL, handle_client, pclient);",
    "        pthread_detach(tid);",
    "    }",
    "    return 0;",
    "}"
]
with open("chat_server.c", "w") as f:
    f.write("\n".join(lines) + "\n")
print("DONE")
'
gcc chat_server.c -o chat_server -lpthread
./chat_server 
nano agent_1393.c
gcc agent_1393.c -o agent_1393
nano agent_1393.c
gcc agent_1393.c -o agent_1393
nano agent_1393.c
gcc agent_1393.c -o agent_1393
nano agent_1393.c
gcc agent_1393.c -o agent_1393
nano agent_1393.c
gcc agent_1393.c -o agent_1393
nano agent_1393.c
gcc agent_1393.c -o agent_1393
nano agent_1393.c
gcc agent_1393.c -o agent_1393
nano agent_1393.c
gcc agent_1393.c -o agent_1393
nano agent_1393.c
gcc agent_1393.c -o agent_1393
nano agent_1393.c
gcc agent_1393.c -o agent_1393
nano agent_1393.c
gcc agent_1393.c -o agent_1393
nano agent_1393.c
gcc agent_1393.c -o agent_1393
./agent_1393
nano agent_1393.c
gcc agent_1393.c -o agent_1393
./agent_1393
gcc agent_1393.c -o agent_1393
./agent_1393
client_1393.c
nc localhost 9410
nano client_1393.c
gcc client_1393.c -o client_1393
nano client_1393.c
gcc client_1393.c -o client_1393
./client_1393
client_1393
./client_1393
nano client_1393.c
gcc agent_1393.c -o agent_1393
./agent_1393
gcc client_1393.c -o client_1393
./client_1393
gcc client_1393.c -o client_1393
./client_1393
nano controller_393.c
nc localhost 9410
nano client_1393.c
gcc client_1393.c -o client_1393
./client_1393
agent_1393.c
nano agent_1393.c
gcc agent_1393.c -o agent_1393
./agent_1393
nano agent_1393.c
