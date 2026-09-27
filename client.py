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
while True:
    data = file.read(BUFFER)
    if not data:
        break
    client.sendall(data)

file.close()
client.close()
print("Video sent successfully")
