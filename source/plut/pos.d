module plut.pos;

import plut.commonevent;
import az.core.az;
import az.core.handler;

struct CommonPos(N) {
    N x, y;
};

alias Pos = CommonPos!int;
alias PosEvent = CommonEvent!(Az, Pos);
alias PosEventHandler(S) = Handler!(S /+ sender +/, PosEvent /+ event +/);

interface HasPos(S) {
    @property Pos pos(Pos newPos);
    @property Pos pos();
    @property PosEventHandler!S posEventHandler();
}

mixin template HasPosMixin(S) {
    private Pos pos_;
    private auto posEventHandler_ = new PosEventHandler!S;

    public:
    @property {
        Pos pos(Pos newPos) {
            posEventHandler_(this, PosEvent(this, pos_, newPos));

            return pos_ = newPos;
        }

        Pos pos() {
            return pos_;
        }

        PosEventHandler!S posEventHandler() {
            return posEventHandler_;
        }
    }
}