module plut.handler;

import std.conv;

class Handler(Ts...) {
    alias Delegate = void delegate(Ts);
    alias Delegates = Delegate[ptrdiff_t];
    
    Delegates delegates_;
    
    void opCall(Ts args) {
        foreach (_, d; delegates_) {
            d(args);
        }
    }
    
    void opCall(Ts args) shared {
        synchronized (this) {
            foreach (_, d; delegates_) {
                d(args);
            }
        }
    }
    
    void opOpAssign(string op, Dg)(Dg d) {
        static if (op == "+") {
            if ((cast(ptrdiff_t)d.funcptr in delegates_) is null) {
                delegates_[cast(ptrdiff_t)d.funcptr] = d;
            }
        } else static if (op == "-") {
            if ((cast(ptrdiff_t)d.funcptr in delegates_) !is null) {
                delegates_.remove(cast(ptrdiff_t)d.funcptr);
            }
        } else {
            static assert(0, "Handler " ~ op ~ "= " ~ Dg.stringof ~ " is not supported");
        }
    }
    
    void opOpAssign(string op, Dg)(Dg d) shared {
        synchronized (this) {
            static if (op == "+") {
                if ((cast(ptrdiff_t)d.funcptr in delegates_) is null) {
                    delegates_[cast(ptrdiff_t)d.funcptr] = d;
                }
            } else static if (op == "-") {
                if ((cast(ptrdiff_t)d.funcptr in delegates_) !is null) {
                    delegates_.remove(cast(ptrdiff_t)d.funcptr);
                }
            } else {
                static assert(0, "Handler " ~ op ~ "= " ~ Dg.stringof ~ " is not supported");
            }
        }
    }
    
    void clear() {
        Delegates d;
        
        delegates_ = d;
    }
    
    void clear() shared {
        synchronized (this) {
            shared(Delegates) d;
            
            delegates_ = d;
        }
    }
}

alias SharedHandler = shared Handler;

unittest {
    auto h = new Handler!(int, int, int)();
    bool handled = false;

    h += delegate (int x, int y, int z) {
        handled = true;
        return;
    };

    h(2, 3, 4);
    assert(handled);
    h.clear();

    handled = false;
    h(5, 7, 21);
    assert(!handled);
}


