import base64

def decrypt_password(encrypted_password, key):
    # Convert from Base64
    encrypted_bytes = base64.b64decode(encrypted_password)
    key_bytes = key.encode('ascii')
    decrypted_bytes = bytearray()
    
    # Perform the XOR operations
    for i in range(len(encrypted_bytes)):
        key_byte = key_bytes[i % len(key_bytes)]
        decrypted_byte = (encrypted_bytes[i] ^ key_byte) ^ 0xDF
        decrypted_bytes.append(decrypted_byte)
    
    # Return as string
    return decrypted_bytes.decode('ascii')

# Your encrypted password and key
enc_password = "0Nv32PTwgYjzg9/8j5TbmvPd3e7WhtWWyuPsyO76/Y+U193E"
key = "armando"

# Decrypt and print
password = decrypt_password(enc_password, key)
print("Decrypted password:", password)
