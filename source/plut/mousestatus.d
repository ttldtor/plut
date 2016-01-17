module plut.mousestatus;

struct MouseSatus {
    int x, y; // absolute (column, row) 0 based, measured in characters
    short button[3]; // state of each button
    int changes; // flags indicating what has changed with the mouse
};
