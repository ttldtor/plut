module plut.window;

import std.conv;

import az.core.az;
import az.core.handler;

import plut.size;
import plut.pos;
import plut.sizepolicy;
import plut.commonevent;
import plut.keyboardevent;
import plut.mouseevent;
import plut.sizeevent;
import plut.posevent;
import plut.sizepolicyevent;
import plut.colorindex;
import plut.chartype;
import plut.console;

class Window: Az {
    alias ZOrderChangeEvent = ValueChangeEvent!(typeof(zOrder_));

private:

    CharType[] buffer_;

    Pos pos_;
    int zOrder_;
    Size size_;

    SizePolicy sizePolicy_;

    auto keyboardEventsHandler_ = new Handler!(Window /+ sender +/, KeyboardEvent /+ event +/);
    auto mouseEventsHandler_ = new Handler!(Window /+ sender +/, MouseEvent /+ event +/);
    auto posEventsHandler_ = new Handler!(Window /+ sender +/, PosEvent /+ event +/);
    auto zOrderChangesHandler_ = new Handler!(Window /+ sender +/, ZOrderChangeEvent /+ event +/);
    auto sizeEventsHandler_ = new Handler!(Window /+ sender +/, SizeEvent /+ event +/);
    auto sizePolicyEventsHandler_ = new Handler!(Window /+ sender +/, SizePolicyEvent /+ event +/);

public:

    this(Size size, int zOrder, Az parent = null) {
        super(parent);

        size_ = size;
        zOrder_ = zOrder;
        buffer_ = new CharType[] (size_.height * size_.width);

        auto w = cast(Window)parent;

        if (parent is null) {
            import plut.plut;

            Plut.console.keyboardEventsHandler += delegate (Az a, KeyboardEvent e) {
                keyboardEventsHandler_(this, e);
            };

            Plut.console.mouseEventsHandler += delegate (Az a, MouseEvent e) {
                mouseEventsHandler_(this, e);
            };

            Plut.console.sizeEventsHandler += delegate (Az a, SizeEvent e) {
                this.size = e.newValue;
            };
        } else {
            w.keyboardEventsHandler += delegate (Window s, KeyboardEvent e) {
                keyboardEventsHandler_(s, e);
            };

            w.mouseEventsHandler += delegate (Window s, MouseEvent e) {
                mouseEventsHandler_(s, e);
            };

            w.sizeEventsHandler += delegate (Window s, SizeEvent e) {
                this.size = e.newValue;
            };
        }

        fill();
    }

    void fill() {
        for (int j = 0; j < size_.height; ++j) {
            for (int i = 0; i < size_.width; ++i) {
                buffer_[j * size_.width + i] = CharType(ColorIndex.Black, ColorIndex.Red, ('А' + j).to!wchar);
            }
        }
    }

    void repaint() {
        fill();
    }

    @property {
        Pos pos(Pos newPos) {
            posEventsHandler_(this, PosEvent(this, pos_, newPos));

            return pos_ = newPos;
        }

        Pos pos() {
            return pos_;
        }

        int zOrder(int newZOrder) {
            zOrderChangesHandler_(this, ZOrderChangeEvent(this, zOrder_, newZOrder));

            return zOrder_ = newZOrder;
        }

        int zOrder() {
            return zOrder_;
        }

        Size size(Size newSize) {
            auto oldSize = size_;

            size_ = newSize;
            buffer_.length = newSize.height * newSize.width;

            repaint();
            sizeEventsHandler_(this, SizeEvent(this, oldSize, newSize));

            return size_;
        }

        Size size() {
            return size_;
        }

        SizePolicy sizePolicy(SizePolicy newSizePolicy) {
            sizePolicyEventsHandler_(this, SizePolicyEvent(this, sizePolicy_, newSizePolicy));

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

        auto posEventsHandler() {
            return posEventsHandler_;
        }

        auto zOrderChangesHandler() {
            return zOrderChangesHandler_;
        }

        auto sizePolicyEventsHandler() {
            return sizePolicyEventsHandler_;
        }
        
        auto buffer() {
            return buffer_;
        }
    }
};