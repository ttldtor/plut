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
        }
        
        void run(Console console) {
            
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
                                WINDOW_BUFFER_SIZE_RECORD sizeRecord = record.WindowBufferSizeEvent;
                                Size oldSize = currentSize_;
                                currentSize_ = Size(sizeRecord.dwSize.X, sizeRecord.dwSize.Y); 
                                console.sizeEventsHandler()(console, SizeEvent(console, oldSize, currentSize_));

                                break;
                                
                            case FOCUS_EVENT: break;
                            case MENU_EVENT: break;
                            default: break;
                        }
                    }
                    
                    drawBuffer(Pos(0, 0), console.mainWindow.buffer);
                }
                
                Thread.yield();
            }
            
        }
        
        void drawBuffer(Pos pos, CharType[][] buffer) {
            CHAR_INFO[][] nativeBuffer = new CHAR_INFO[][](currentSize_.height, currentSize_.width);
            
            for (int j = 0; j < currentSize_.height; j++) {
                for (int i = 0; i < currentSize_.width; i++) {
                    nativeBuffer[j][i] = buffer[j][i].toCharInfo;
                }
            }
            
            auto rect = SMALL_RECT(0, 0, (currentSize_.width - 1).to!SHORT, (currentSize_.height - 1).to!SHORT);
            auto size = COORD((currentSize_.width - 1).to!SHORT, (currentSize_.height - 1).to!SHORT);
            
            //TODO: use temporary buffer
            WriteConsoleOutputW(stdOut_, nativeBuffer[0].ptr, size, COORD(0, 0), &rect);

        }
    }
}


class Console: Az {
    
private:
    ConsoleImpl impl_;
    Window mainWindow_;
    
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
        
        Window mainWindow() {
            return mainWindow_;
        }
    }
    
    void drawBuffer(Pos pos, CharType[][] buffer) {
        
    }
    
    void addMainWindow(Window w) {
        mainWindow_ = w;
    }
    
    void run() {
        impl_.run(this);
    }
};