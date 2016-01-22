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
    private {
        CharType[][] buffer_;

        Pos pos_;
        int zOrder_;
        Size size_;

        SizePolicy sizePolicy_;

        Window parent_;
        Window[] children_;

        auto keyboardEventsHandler = new SharedHandler!(Window /+ sender +/, KeyboardEvent /+ event +/);
        auto mouseEventsHandler = new SharedHandler!(Window /+ sender +/, MouseEvent /+ event +/);
        auto sizeEventsHandler = new SharedHandler!(Window /+ sender +/, SizeEvent /+ event +/);
    }

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

            Size size(Size newSize) {
                return size_ = newSize;
            }

            Size size() {
                return size_;
            }

            SizePolicy sizePolicy(SizePolicy newSizePolicy) {
                return sizePolicy_ = newSizePolicy;
            }

            SizePolicy sizePolicy() {
                return sizePolicy_;
            }
        }
    }
};