module plut.console;

import az.core.az;
import az.core.handler;

import plut.colorindex;
import plut.sizeevent;
import plut.size;
import plut.mouseevent;
import plut.mousestate;
import plut.keyboardevent;
import plut.keyboardstate;
import plut.chartype;
import plut.pos;
import plut.window;

import std.conv;

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
        
        Size currentSize_;
        Pos currentPosInBuffer_;
        

        void calculateCurrentSize() {
            import std.math;

            CONSOLE_SCREEN_BUFFER_INFO bufferInfo;

            GetConsoleScreenBufferInfo(stdOut_, &bufferInfo);

            auto size = bufferInfo.dwMaximumWindowSize;
            auto s = bufferInfo.srWindow;

            currentPosInBuffer_ = Pos(bufferInfo.dwCursorPosition.X.to!int, bufferInfo.dwCursorPosition.Y.to!int);

            //currentSize_.width = size.X.to!int;
            //currentSize_.height = size.Y.to!int;
            currentSize_.width = abs(s.Right.to!int - s.Left.to!int + 1);
            currentSize_.height = abs(s.Bottom.to!int - s.Top.to!int + 1);
        }

    public:
        
        this() {
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

            calculateCurrentSize();
        }
        
        void run(Console console) {
            import plut.plut;
            
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
                            case KEY_EVENT:
                                console.keyboardEventsHandler()(console, KeyboardEvent(console, KeyboardState(), KeyboardState()));
                                break;
                                
                            case MOUSE_EVENT:
                                console.mouseEventsHandler()(console, MouseEvent(console, MouseState(), MouseState()));
                                break;
                                
                            case WINDOW_BUFFER_SIZE_EVENT:
                                auto oldSize = currentSize_;

                                calculateCurrentSize();                                 
                                console.sizeEventsHandler()(console, SizeEvent(console, oldSize, currentSize_));

                                break;
                                
                            case FOCUS_EVENT: break;
                            case MENU_EVENT: break;
                            default: break;
                        }
                    }
                    
                    auto oldSize = currentSize_;
                    calculateCurrentSize();
                    console.sizeEventsHandler()(console, SizeEvent(console, oldSize, currentSize_));
                    drawBuffer(Pos(0, 0), Plut.mainWindow.buffer, Plut.mainWindow.size);
                }
                
                Thread.sleep(50.msecs);
                Thread.yield();
            }
            
        }
        
        void drawBuffer(Pos pos, CharType[] buffer, Size s) {
            if (buffer is null || currentSize_.width == 0 || currentSize_.height == 0 || s.width == 0 || s.height == 0) {
                return;
            }

            CHAR_INFO[] nativeBuffer = new CHAR_INFO[](s.height * s.width);
            
            for (int j = 0; j < s.height; j++) {
                for (int i = 0; i < s.width; i++) {
                    nativeBuffer[j * s.width + i] = buffer[j * s.width + i].toCharInfo;
                }
            }
            
            auto rect = SMALL_RECT(0, 0,
                    (s.width - 1).to!SHORT, (s.height - 1).to!SHORT);
            auto size = COORD(s.width.to!SHORT, s.height.to!SHORT);
            
            //TODO: use temporary buffer
            WriteConsoleOutputW(stdOut_, nativeBuffer.ptr, size, COORD(0, 0), &rect);
        }

        @property {
            auto currentSize() {
                if (currentSize_.width == 0 || currentSize_.height == 0) {
                    calculateCurrentSize();
                }

                return currentSize_;
            }
        }
    }
}


class Console: Az {
    
private:
    ConsoleImpl impl_;
    
    ColorIndex defaultForegroundColor_;
    ColorIndex defaultBackgroundColor_;
    
    auto keyboardEventsHandler_ = new Handler!(Az /+ sender +/, KeyboardEvent /+ event +/);
    auto mouseEventsHandler_ = new Handler!(Az /+ sender +/, MouseEvent /+ event +/);
    auto sizeEventsHandler_ = new Handler!(Az /+ sender +/, SizeEvent /+ event +/);
    
public:

    this() {
        impl_ = new ConsoleImpl();
    }

    @property {
        auto size() {
            return impl_.currentSize;
        }

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

    void run() {
        impl_.run(this);
    }
};