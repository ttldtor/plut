module plut.console;

import az.core.az;
import az.core.handler;

import plut.colorindex;
import plut.sizeevent;
import plut.mouseevent;
import plut.keyboardevent;

class Console: Az {
    
private:
    
    ColorIndex defaultForegroundColor_;
    ColorIndex defaultBackgroundColor_;
    
    auto keyboardEventsHandler_ = new SharedHandler!(Az /+ sender +/, KeyboardEvent /+ event +/);
    auto mouseEventsHandler_ = new SharedHandler!(Az /+ sender +/, MouseEvent /+ event +/);
    auto sizeEventsHandler_ = new SharedHandler!(Az /+ sender +/, SizeEvent /+ event +/);
    
public:

    @property {
        ColorIndex defaultForegroundColor() {
            return defaultForegroundColor_;
        }
        
        ColorIndex defaultBackgroundColor() {
            return defaultBackgroundColor_;
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
};