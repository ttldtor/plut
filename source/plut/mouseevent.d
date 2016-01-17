module plut.mouseevent;

struct MouseEvent {
    short id; // unused, always 0;
    int x, y, z; // x, y same as MouseStatus; z unused
    ulong buttonsState; // equivalent to changes + button[], but in the same format as used for mousemask()
};