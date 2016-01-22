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
    char[][] buffer_;
    
    Pos pos_;
    int zOrder_;
    Size size_;

    Pos innerPos_;
    ColorIndex foregroundColor_;
    ColorIndex backgroundColor_;

    SizePolicy policy_;
    
    Window parent_;

    auto onKeyboardEvent = new SharedHandler!(Window /+ sender +/, KeyboardEvent /+ event +/);
    auto onMouseEvent = new SharedHandler!(Window /+ sender +/, MouseEvent /+ event +/);
    auto onSizeEvent = new SharedHandler!(Window /+ sender +/, SizeEvent /+ event +/);

    public {
        @property {
            ref Pos pos(Pos newPos) {
                pos_ = newPos;
                
                return pos_;
            }

            ref Pos pos() {
                return pos_;
            }
        }
    }
};