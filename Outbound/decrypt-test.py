from base64 import b64decode
from Crypto.Cipher import DES3

des_key = b'rcmail-!24ByteDESkey*Str'  # must be 24 bytes
encrypted = b64decode('L7Rv00A8TuwJAr67kITxxcSgnIk25Am/')

iv = encrypted[:8]
ciphertext = encrypted[8:]

cipher = DES3.new(des_key, DES3.MODE_CBC, iv)
plaintext = cipher.decrypt(ciphertext)

# Strip PKCS#7 padding
pad_len = plaintext[-1]
print(plaintext[:-pad_len].decode())

