module plut.size;

import std.format;

struct CommonSize(N) {
    N width, height;
};

alias Size = CommonSize!int;

string toString(Size s) {
    return format("(%s x %s)", s.width, s.height);
}