module plut.pos;

struct CommonPos(N) {
    N x, y;
};

alias Pos = CommonPos!int;