module plut.console;

import az.core.az;
import az.core.handler;

import plut.colorindex;
import plut.sizeevent;
import plut.mouseevent;
import plut.keyboardevent;
import plut.chartype;
import plut.pos;

class PlutConsoleException: Exception {
    public @safe pure nothrow this(string message, string file = __FILE__, size_t line = __LINE__, Throwable next = null) {
        super(message, file, line, next);
    }
}

version(Windows) {
    import core.sys.windows.windows;
    import core.thread;
    
    class ConsoleImpl {
        private:
        
        enum inputBufferSize = 512;
        
        HANDLE stdOut_;
        HANDLE stdIn_;
        DWORD oldConsoleMode_;
        
        public:
        
        this(Console parent) {
            stdOut_ = GetStdHandle(STD_OUTPUT_HANDLE);
            stdIn_ = GetStdHandle(STD_INPUT_HANDLE);
            
            if (stdOut_ == INVALID_HANDLE_VALUE) {
                throw new PlutConsoleException("Invalid STD_OUT handle");
            }
            
            if (stdIn_ == INVALID_HANDLE_VALUE) {
                throw new PlutConsoleException("Invalid STD_IN handle");
            }
            
            if (!GetConsoleMode(stdIn_, &oldConsoleMode_)) {
                throw new PlutConsoleException("Can't get console mode");
            }
            
            DWORD newConsoleMode = ENABLE_WINDOW_INPUT | ENABLE_MOUSE_INPUT;
            
            scope(failure) {
                SetConsoleMode(stdIn_, oldConsoleMode_);
            }
            
            if (!SetConsoleMode(stdIn_, newConsoleMode)) {
                throw new PlutConsoleException("Can't set console mode");
            } 
        }
        
        void run() {
            
            INPUT_RECORD[inputBufferSize] inputBuffer;
            DWORD numberOfEvents = 0;
            DWORD numberOfEventsRead = 0;
            
            
            while (true) {
                GetNumberOfConsoleInputEvents(stdIn_, &numberOfEvents);
                
                if (numberOfEvents > 0) {
                    ReadConsoleInputA(stdIn_, inputBuffer.ptr, inputBufferSize, &numberOfEventsRead);
                    
                    for (DWORD i = 0; i < numberOfEventsRead; i++) {
                        INPUT_RECORD record = inputBuffer[i];
                        
                        switch (record.EventType) {
                            case KEY_EVENT: break;
                            case MOUSE_EVENT: break;
                            case WINDOW_BUFFER_SIZE_EVENT: break;
                            case FOCUS_EVENT: break;
                            case MENU_EVENT: break;
                            default: break;
                        }
                    }
                }
                
                Thread.yield();
            }
            
        }
    }
}


class Console: Az {
    
private:
    ConsoleImpl impl_;
    
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
    
    void drawBuffer(Pos pos, CharType[][] buffer) {
        
    }
};