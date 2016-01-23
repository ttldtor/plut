module plut.window;

import az.core.az;

import plut.size;
import plut.pos;
import plut.sizepolicy;
import plut.handler;
import plut.commonevent;
import plut.keyboardevent;
import plut.mouseevent;
import plut.sizeevent;
import plut.posevent;
import plut.sizepolicyevent;
import plut.colorindex;
import plut.chartype;

class Window: Az {
    alias ZOrderChangeEvent = ValueChangeEvent!(typeof(zOrder_));

    private {
        CharType[][] buffer_;

        Pos pos_;
        int zOrder_;
        Size size_;

        SizePolicy sizePolicy_;

        auto keyboardEventsHandler_ = new SharedHandler!(Window /+ sender +/, KeyboardEvent /+ event +/);
        auto mouseEventsHandler_ = new SharedHandler!(Window /+ sender +/, MouseEvent /+ event +/);
        auto posEventsHandler_ = new SharedHandler!(Window /+ sender +/, PosEvent /+ event +/);
        auto zOrderChangesHandler_ = new SharedHandler!(Window /+ sender +/, ZOrderChangeEvent /+ event +/);
        auto sizeEventsHandler_ = new SharedHandler!(Window /+ sender +/, SizeEvent /+ event +/);
        auto sizePolicyEventsHandler_ = new SharedHandler!(Window /+ sender +/, SizePolicyEvent /+ event +/);
    }

    public {
        this(Az parent = null) {
            super(parent);
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
                sizeEventsHandler_(this, SizeEvent(this, size_, newSize));

                return size_ = newSize;
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
        }
    }
};