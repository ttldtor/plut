module plut.chartype;

import plut.colorindex;

struct CommonCharType(C) {
    ColorIndex foreground;
    ColorIndex background;
    C data;
};

alias CharType = CommonCharType!char;
alias WideCharType = CommonCharType!wchar;
alias DoubleWideCharType = CommonCharType!dchar;

version(Windows) {
    import core.sys.windows.windows;
    import std.utf;
    
    CHAR_INFO toCharInfo(C)(const(C) c) if(is(C : CharType) || is(C : WideCharType) || is(C : DoubleWideCharType)) {
        CHAR_INFO result;
        
        result.Attributes = c.foreground | c.background;
        result.UnicodeChar = ("" ~ c.data).toUTF16()[0];
        
        return result;
    }
}