module plut.chartype;

import plut.colorindex;

struct CharType {
    ColorIndex foreground = ColorIndex.LightGray;
    ColorIndex background = ColorIndex.Black;
    wchar data = ' ';
};

version(Windows) {
    import core.sys.windows.windows;
    import std.utf;
    import std.conv;
    
    CHAR_INFO toCharInfo(const(CharType) c) {
        CHAR_INFO result;

        result.Attributes = (c.foreground | (c.background << 4)).to!WORD;
        result.UnicodeChar = c.data;
        
        return result;
    }
}