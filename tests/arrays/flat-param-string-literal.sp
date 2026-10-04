#include <shell>

void Show(char buf[8]) {
    print(buf);
    print("\n");
}

void Fill(char buf[8] = "") {
    print(buf);
    print(" -> ");
    for (int i = 0; i < 7; i++)
        buf[i] = 'a' + i;
    print(buf);
    print("\n");
}

void Later() {
    print("");
    print("later\n");
}

public void main() {
    Show("hello");
    Show("");
    Fill();
    Fill();
    Fill("xy");
    Later();
}
