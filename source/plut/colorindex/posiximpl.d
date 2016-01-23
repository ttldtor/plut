module plut.colorindex.posiximpl;

version(Posix) {
    enum ColorIndex: ushort {
        Black     = 30,
        Blue      = 31,
        Green     = 32,
        Cyan      = 33,
        Red       = 34,
        Magenta   = 35,
        Yellow    = 36,
        LightGray = 37,

        Gray         = 94,
        LightBlue    = 95,
        LightGreen   = 96,
        LightCyan    = 97,
        LightRed     = 98,
        LightMagenta = 99,
        LightYellow  = 100,
        White        = 101,

        Bright       = 64,

        Default      = 256
    };
}

