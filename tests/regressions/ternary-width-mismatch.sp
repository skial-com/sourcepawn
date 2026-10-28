// Regression test for alliedmodders/sourcepawn#1199. A ternary whose left arm
// was widened to match the right (int -> int64, float/int -> double) kept the
// left arm's type as its result type, so the bytecode failed validation.

native void printnum(int x);
native void printnum64(int64 x);
native void printdouble(double x);
native int dynamic_native(int arg);

public void main() {
    bool t = dynamic_native(1) == 1;
    bool f = !t;
    int i = 3;
    int8 s = -5;
    float fl = 2.5;
    int64 w = 0x100000000;
    double d = 1.5;

    printnum64(t ? i : w);
    printnum64(f ? i : w);
    int64 q = t ? i : w;
    printnum64(q);
    printnum(view_as<int>(f ? i : w));
    printnum64(t ? s : w);
    printdouble(t ? fl : d);
    printdouble(f ? fl : d);
    printdouble(t ? i : d);
    printdouble(f ? i : d);
}
