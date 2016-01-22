module plut.window;

import plut.size;
import plut.pos;
import plut.sizepolicy;
import plut.handler;
import plut.keyboardevent;
import plut.mouseevent;
import plut.sizeevent;
import plut.colorindex;
import plut.chartype;

class Window {
    CharType[][] buffer_;
    
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
            Pos pos(Pos newPos) {
                return pos_ = newPos;
            }

            Pos pos() {
                return pos_;
            }

            int zOrder(int newZOrder) {
                return zOrder_ = newZOrder;
            }

            int zOrder() {
                return zOrder_;
            }
        }
    }
};