module plut.beep;

version(Windows) {
    import core.sys.windows.windows;

    void beep() {
        MessageBeep(0xFFFFFFFF);
    }
}