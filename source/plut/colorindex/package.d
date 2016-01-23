module plut.colorindex;

version(Windows) {
    public import plut.colorindex.windowsimpl;
} else version(Posix) {
    public import plut.colorindex.posiximpl;
}

ColorIndex lighter(ColorIndex c) {
    if (c < ColorIndex.Gray) {
        return cast(ColorIndex)(c ^ ColorIndex.Bright);
    } else if (c == ColorIndex.Gray) {
        return ColorIndex.LightGray;
    }

    return c;
}

ColorIndex darker(ColorIndex c) {
    if (c == ColorIndex.LightGray) {
        return ColorIndex.Gray;
    } else if (c >= ColorIndex.Gray && c < ColorIndex.Default) {
        return cast(ColorIndex)(c ^ ColorIndex.Bright);
    }

    return c;
}


unittest {
    assert(ColorIndex.Black.lighter.lighter.lighter == ColorIndex.White);
    assert(ColorIndex.Red.lighter.darker == ColorIndex.Red);
}
