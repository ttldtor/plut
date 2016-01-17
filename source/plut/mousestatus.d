module plut.mousestatus;

struct MouseSatus {
    int x, y; // absolute (column, row) 0 based, measured in characters
    short[3] button; // state of each button
    int changes; // flags indicating what has changed with the mouse
};
