module plut.window;

import plut.size;
import plut.pos;
import plut.sizepolicy;
import plut.handler;
import plut.keyboardevent;
import plut.mouseevent;
import plut.sizeevent;
import plut.colorindex;

class Window {
    char[][] buffer;
    
    Pos pos;
    Size size;

    Pos innerPos;
    ColorIndex foregroundColor;
    ColorIndex backgroundColor;

    SizePolicy policy;
    
    Window parent;

    auto onKeyboardEvent = new SharedHandler!(Window /+ sender +/, KeyboardEvent /+ event +/);
    auto onMouseEvent = new SharedHandler!(Window /+ sender +/, MouseEvent /+ event +/);
    auto onSizeEvent = new SharedHandler!(Window /+ sender +/, SizeEvent /+ event +/);
};