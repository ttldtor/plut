module plut.zorder;

import az.core.handler;

import plut.commonevent;

alias ZOrderType = double;
alias ZOrderChangeEvent = ValueChangeEvent!ZOrderType;
alias ZOrderChangeEventHandler(S) = Handler!(S /+ sender +/, ZOrderChangeEvent /+ event +/);

interface HasZOrder(S) {
    @property ZOrderType zOrder(ZOrderType newZOrder);
    @property ZOrderType zOrder();
    @property ZOrderChangeEventHandler!S zOrderChangesHandler();
}

mixin template HasZOrderMixin(S) {
    private ZOrderType zOrder_;
    private auto zOrderChangesHandler_ = new ZOrderChangeEventHandler!S;

    public:
    @property {
        ZOrderType zOrder(ZOrderType newZOrder) {
            zOrderChangesHandler_(this, ZOrderChangeEvent(this, zOrder_, newZOrder));
            return zOrder_ = newZOrder;
        }

        ZOrderType zOrder() {
            return zOrder_;
        }

        ZOrderChangeEventHandler!S zOrderChangesHandler() {
            return zOrderChangesHandler_;
        }
    }
}
