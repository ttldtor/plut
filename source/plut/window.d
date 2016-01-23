module plut.window;

import az.core.az;

import plut.size;
import plut.pos;
import plut.sizepolicy;
import plut.handler;
import plut.keyboardevent;
import plut.mouseevent;
import plut.sizeevent;
import plut.colorindex;
import plut.chartype;

class Window: Az {
    private {
        CharType[][] buffer_;

        Pos pos_;
        int zOrder_;
        Size size_;

        SizePolicy sizePolicy_;

        auto keyboardEventsHandler_ = new SharedHandler!(Window /+ sender +/, KeyboardEvent /+ event +/);
        auto mouseEventsHandler_ = new SharedHandler!(Window /+ sender +/, MouseEvent /+ event +/);
        auto sizeEventsHandler_ = new SharedHandler!(Window /+ sender +/, SizeEvent /+ event +/);
    }

    public {
        this(Az parent = null) {
            super(parent);
        }

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

            auto keyboardEventsHandler() {
                return keyboardEventsHandler_;
            }

            auto mouseEventsHandler() {
                return mouseEventsHandler_;
            }

            auto sizeEventsHandler() {
                return sizeEventsHandler_;
            }
        }
    }
};