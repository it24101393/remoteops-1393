import socket
import os

HOST = '0.0.0.0'
PORT = 7000
BUFFER = 4096

# Create TCP socket
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind((HOST, PORT))
server.listen(5)

print("Video Server running on port", PORT)
print("Server PID:", os.getpid())

while True:
    # Accept client connection
    conn, addr = server.accept()
    print(f"Connection received from {addr}")
    
    # Fork a new process for each client
    pid = os.fork()
    
    if pid == 0:
        # Child process handles the client
        server.close()  # Close server socket in child
        print(f"Child process handling client\nChild PID: {os.getpid()} Parent PID: {os.getppid()}")
        
        # Create unique file for each client's video
        file = open(f"received_video_{os.getpid()}.mp4", "wb")
        chunk_count = 0
        total_bytes = 0
        
        while True:
            data = conn.recv(BUFFER)
            if not data:
                break
            chunk_count += 1
            bytes_received = len(data)
            total_bytes += bytes_received
            print(f"Chunk {chunk_count} received: {bytes_received} bytes")
            file.write(data)
            
        print(f"Total bytes received: {total_bytes}")
        file.close()
        conn.close()
        os._exit(0)  # Exit child process
    else:
        # Parent process closes connection and waits for next client
        conn.close()
