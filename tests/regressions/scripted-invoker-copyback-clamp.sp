#include <shell>

// A native that pushes an array or string with copyback and claims a larger size
// than the callback's sized parameter (e.g. a byte count instead of 3 cells) used
// to get the whole claimed size copied back from the parameter's flat storage, so
// everything past it was overwritten with unrelated VM memory. Only the part that
// was copied in may be copied back.

native int call_with_copyback_array(Function callback, int out[3]);
native int call_with_copyback_string(Function callback, char out[8]);

void sized_array(int v[3]) {
    v[0] *= 10;
    v[1] *= 10;
    v[2] *= 10;
}

void unsized_array(int[] v) {
    v[0] *= 10;
    v[1] *= 10;
    v[2] *= 10;
}

void sized_string(char s[8]) {
    s[0] = 'h';
    s[1] = 'e';
    s[2] = 'l';
    s[3] = 'l';
    s[4] = 'o';
    s[5] = 0;
}

public void main() {
    int out[3];

    printnum(call_with_copyback_array(sized_array, out));
    printnums(out[0], out[1], out[2]);

    printnum(call_with_copyback_array(unsized_array, out));
    printnums(out[0], out[1], out[2]);

    char str[8];
    printnum(call_with_copyback_string(sized_string, str));
    print(str);
    print("\n");
}
