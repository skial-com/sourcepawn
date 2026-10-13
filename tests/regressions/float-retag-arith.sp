#include <shell>

// Retagging a non-float value as float (Float:x, view_as<float>(x)) used to emit
// no instruction, so the v2 VM still typed the value as int32/any and lowered the
// arithmetic or comparison around it as integer math: `w *= Float:f()` gave 0.0,
// `w += Float:f()` gave garbage and `w > Float:f()` compared bit patterns. The
// compiler now emits bitcast.f32 / bitcast.i32 for these retags, and also for an
// untagged `any` operand that the operator treats as float (`w *= GetArrayCell()`).

enum Tag { Tag_Zero };

any AnyOne() { return 1.0; }
int IntTwo() { return view_as<int>(2.0); }
Tag TagHalf() { return view_as<Tag>(0.5); }
float FloatThree() { return 3.0; }

public void main() {
    float w;

    // any -> float
    w = 1.5; w *= Float:AnyOne();           printfloat(w);
    w = 1.5; w = w * view_as<float>(AnyOne()); printfloat(w);
    w = 1.5; w += Float:AnyOne();           printfloat(w);
    w = 1.5; w -= view_as<float>(AnyOne()); printfloat(w);
    w = 1.5; w /= Float:AnyOne();           printfloat(w);
    printnum(2.0 > Float:AnyOne());
    printnum(Float:AnyOne() < 0.5);

    // int -> float
    w = 1.5; w *= view_as<float>(IntTwo()); printfloat(w);
    printfloat(-view_as<float>(IntTwo()));

    // enum -> float
    w = 3.0; w *= view_as<float>(TagHalf()); printfloat(w);

    // array element retag
    int cells[2];
    cells[0] = view_as<int>(4.0);
    w = 0.5; w *= view_as<float>(cells[0]); printfloat(w);

    // float -> int keeps the raw bits, and integer math applies
    int bits = view_as<int>(FloatThree());
    printnum(bits == 0x40400000);
    printnum(view_as<int>(FloatThree()) + 1 == 0x40400001);

    // constants
    printfloat(view_as<float>(0x3F800000) * 2.0);

    // untagged any as a float operand
    w = 1.5; w *= AnyOne();                 printfloat(w);
    w = 1.5; w += AnyOne();                 printfloat(w);
    w = 1.5; w = w - AnyOne();              printfloat(w);
    printnum(2.0 > AnyOne());
    printnum(0.5 < AnyOne() <= 2.0);
    printnum(1.0 < AnyOne() < 2.0);
    any anys[2];
    anys[1] = 1.5;
    w = 2.0; w *= anys[1];                  printfloat(w);

    // any on the left of a float compound assignment
    any a = 1.5;
    a *= 2.0;                               printfloat(a);
    a -= 0.5;                               printfloat(a);

    // lvalue retags
    cells[1] = view_as<int>(2.0);
    Float:cells[1] *= 2.0;                  printfloat(view_as<float>(cells[1]));
    view_as<float>(cells[1]) += 1.0;        printfloat(view_as<float>(cells[1]));
}
