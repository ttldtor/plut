module plut.window;

struct CharType {};
struct AttributeType {};

struct Window {
    int currentX;
    int currentY;
    int maxX;
    int maxY;
    int beginX;
    int beginY;
    int fllags;
    AttributeType attributes;
    AttributeType background;
    bool clear;
    bool leaveIt;
    bool scroll;
    bool noDelay;
    bool immediateUpdate;
    bool synchronizeAncestors;
    bool useKeypad;
    CharType[]* line;
    CharType* firstChanged;
    CharType* lastChanged;
    int topOfScrollingRegion;
    int bottomOfScrollingRegion;
    int delayForGetch; // delay in ms for getch()
    int relativeX, relativeY; // coords relative to parent (0, 0)
    Window* parent;
};