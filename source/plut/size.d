module plut.size;

struct CommonSize(N) {
    N width, height;
};

alias Size = CommonSize!int;