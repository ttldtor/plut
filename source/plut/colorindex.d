module plut.colorindex;

version(Windows) {
    private enum BackgroundMask = 0xF0;
    private enum ForegroundMask = 0x0F;

    enum ColorIndex: ushort {
        Black     = 0,
        Blue      = 1,
        Green     = 2,
        Cyan      = 3,
        Red       = 4,
        Magenta   = 5,
        Yellow    = 6,
        LightGray = 7,

        Gray         = 8,
        LightBlue    = 9,
        LightGreen   = 10,
        LightCyan    = 11,
        LightRed     = 12,
        LightMagenta = 13,
        LightYellow  = 14,
        White        = 15,

        Bright       = 8,

        Default      = 256
    };

    ColorIndex light(ColorIndex c) {
        if (c != ColorIndex.Default) {
            return cast(ColorIndex)(c ^ ColorIndex.Bright);
        }

        return c;
    }

} else version(Posix) {
    enum ColorIndex: ushort {};
}

