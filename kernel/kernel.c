// kernel/kernel.c
void kernel_main() {
    const char *str = "Welcome to BlueOS!";
    char *vidptr = (char*)0xb8000;  // Video memory begins here.
    unsigned int i = 0;
    unsigned int j = 0;

    while (j < 80 * 25 * 2) {
        vidptr[j] = ' ';    // Blank character
        vidptr[j+1] = 0x07; // Attribute-byte: light grey on black screen
        j = j + 2;
    }

    j = 0;

    while (str[j] != '\0') {
        vidptr[i] = str[j];
        vidptr[i+1] = 0x07; // Attribute-byte: light grey on black screen
        ++j;
        i = i + 2;
    }

    return;
}
